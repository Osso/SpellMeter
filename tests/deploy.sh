#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
deploy_script=${DEPLOY_SCRIPT:-$project_dir/deploy.sh}
test_root=$(mktemp -d "${TMPDIR:-/tmp}/spellmeter-deploy-test.XXXXXX")
fake_bin=$test_root/bin
log_dir=$test_root/log
mkdir -p "$fake_bin" "$log_dir/ssh" "$log_dir/scp"

cleanup() {
    rm -rf "$test_root"
}
trap cleanup EXIT HUP INT TERM

write_noop_command() {
    command_name=$1
    cat > "$fake_bin/$command_name" <<'EOF'
#!/bin/sh
set -eu
exit 0
EOF
    chmod 755 "$fake_bin/$command_name"
}

write_capture_command() {
    command_name=$1
    cat > "$fake_bin/$command_name" <<'EOF'
#!/bin/sh
set -eu
log_dir=${SPELLMETER_DEPLOY_TEST_LOG:?}/$(basename "$0")
printf '%s\n' "$#" > "$log_dir/argv-count"
argument_index=1
for argument do
    printf '%s\n' "$argument" > "$log_dir/argv-$argument_index"
    argument_index=$((argument_index + 1))
done
cat > "$log_dir/stdin"
EOF
    chmod 755 "$fake_bin/$command_name"
}

write_noop_command rm
write_noop_command mkdir
write_noop_command cp
write_capture_command ssh
write_capture_command scp

fail() {
    printf 'FAIL: %s\n' "$1" >&2
    exit 1
}

assert_file() {
    [ -f "$1" ] || fail "missing capture: $1"
}

assert_equals() {
    expected=$1
    actual=$2
    [ "$actual" = "$expected" ] || fail "expected '$expected', got '$actual'"
}

assert_argument() {
    command_name=$1
    argument_index=$2
    expected=$3
    file="$log_dir/$command_name/argv-$argument_index"
    assert_file "$file"
    actual=$(cat "$file")
    assert_equals "$expected" "$actual"
}

output_file=$log_dir/output
set +e
PATH="$fake_bin:$PATH" \
SPELLMETER_DEPLOY_TEST_LOG="$log_dir" \
    sh "$deploy_script" > "$output_file" 2>&1
deploy_status=$?
set -e

if [ ! -f "$log_dir/ssh/argv-count" ]; then
    fail "launcher did not call remote deployment (exit $deploy_status): $(cat "$output_file")"
fi
[ "$deploy_status" -eq 0 ] || fail "launcher exited $deploy_status after remote deployment"

assert_file "$log_dir/ssh/argv-count"
assert_file "$log_dir/ssh/stdin"
assert_equals 6 "$(cat "$log_dir/ssh/argv-count")"
assert_argument ssh 1 alessio-desktop
assert_argument ssh 2 powershell.exe
assert_argument ssh 3 -NoProfile
assert_argument ssh 4 -NonInteractive
assert_argument ssh 5 -Command
assert_argument ssh 6 -

ssh_script=$(cat "$log_dir/ssh/stdin")
case "$ssh_script" in
    *'$ErrorActionPreference = "Stop"'*) ;;
    *) fail 'SSH script does not fail fast' ;;
esac
case "$ssh_script" in
    *'C:\World of Warcraft\_retail_\Interface\AddOns\SpellMeter'*) ;;
    *) fail 'SSH script does not target the active Retail addon directory' ;;
esac
case "$ssh_script" in
    *'Remove-Item'*) ;;
    *) fail 'SSH script does not remove the existing addon directory' ;;
esac
case "$ssh_script" in
    *'New-Item'*) ;;
    *) fail 'SSH script does not recreate the addon directory' ;;
esac

assert_file "$log_dir/scp/argv-count"
assert_file "$log_dir/scp/stdin"
assert_equals 5 "$(cat "$log_dir/scp/argv-count")"
assert_argument scp 1 "$project_dir/SpellMeter.toc"
assert_argument scp 2 "$project_dir/SpellMeter.lua"
assert_argument scp 3 "$project_dir/SpellMeterModel.lua"
assert_argument scp 4 "$project_dir/SpellMeterRows.lua"
assert_argument scp 5 'alessio-desktop:C:/World of Warcraft/_retail_/Interface/AddOns/SpellMeter/'

output=$(cat "$output_file")
case "$output" in
    *'alessio-desktop:C:/World of Warcraft/_retail_/Interface/AddOns/SpellMeter/'*) ;;
    *) fail 'launcher did not print the installed remote destination' ;;
esac

printf 'PASS deploy launcher remote contract\n'
