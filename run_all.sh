#!/usr/bin/env bash
# Compile and simulate every lab testbench with Icarus Verilog.
#
#   bash run_all.sh         run everything, print a summary
#   bash run_all.sh -v      also print each simulation's output
#   bash run_all.sh 05      run only labs whose folder starts with 05
#
# A test fails if it does not compile, does not finish within 30 s,
# prints a line starting with FAIL, or (for self-checking testbenches)
# never prints PASS. Waveforms (.vcd) are written to build/<test>/.

set -u
cd "$(dirname "$0")"

VERBOSE=0
FILTER=""
for arg in "$@"; do
    case "$arg" in
        -v) VERBOSE=1 ;;
        *)  FILTER="$arg" ;;
    esac
done

command -v iverilog >/dev/null || { echo "iverilog not found (sudo apt install iverilog)"; exit 2; }

# name | lab folder | design file(s) | testbench | self-checking (1) or smoke test (0)
TESTS=(
  "basic_gates      |01-basic-logic-gates          |basic_gates.v            |tb_basic_gates.v           |1"
  "nand_universal   |01-basic-logic-gates          |nand_universal.v         |tb_nand_universal.v        |1"
  "nor_universal    |01-basic-logic-gates          |nor_universal.v          |tb_nor_universal.v         |1"
  "adder            |03-adder-subtractor           |adder.v                  |tb_adder.v                 |1"
  "subtractor       |03-adder-subtractor           |subtractor.v             |tb_subtractor.v            |1"
  "mux_boolean      |04-mux-boolean-function       |mux_boolean.v            |tb_mux_boolean.v           |1"
  "alu              |05-alu                        |alu.v                    |tb_alu.v                   |1"
  "decoder_3to8     |06-decoder-3to8               |decoder_3to8.v           |tb_decoder_3to8.v          |1"
  "decoder_4to16    |07-decoder-4to16              |decoder_4to16.v          |tb_decoder_4to16.v         |1"
  "priority_encoder |08-priority-encoder-4to2      |priority_encoder_4to2.v  |tb_priority_encoder_4to2.v |1"
  "demux_sweep      |09-demux-1to8                 |demux_1to8.v             |tb_demux_1to8_sweep.v      |1"
  "demux_random     |09-demux-1to8                 |demux_1to8.v             |tb_demux_1to8_random.v     |1"
  "d_flip_flop      |10-d-flip-flop                |d_flip_flop.v            |tb_d_flip_flop.v           |0"
  "jk_ms_ff         |11-jk-master-slave-flip-flop  |jk_ms_ff.v               |tb_jk_ms_ff.v              |1"
  "t_ff_sync        |12-t-flip-flop                |t_ff_sync_preset_clear.v |tb_t_ff.v                  |0"
  "t_ff_async       |12-t-flip-flop                |t_ff_async_preset_clear.v|tb_t_ff.v                  |0"
  "async_counter    |13-async-up-counter-4bit      |async_counter_4bit.v     |tb_async_counter_4bit.v    |1"
)

trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; echo "${s%"${s##*[![:space:]]}"}"; }

pass=0; fail=0; failed=()
for t in "${TESTS[@]}"; do
    IFS='|' read -r name lab design tb selfcheck <<< "$t"
    name=$(trim "$name"); lab=$(trim "$lab"); design=$(trim "$design"); tb=$(trim "$tb"); selfcheck=$(trim "$selfcheck")
    [[ -n "$FILTER" && "$lab" != "$FILTER"* ]] && continue

    out="build/$name"; mkdir -p "$out"
    src="$lab/verilog"
    status="ok"
    if ! iverilog -g2012 -o "$out/sim.vvp" "$src/$design" "$src/$tb" > "$out/compile.log" 2>&1; then
        status="compile error"; log="$out/compile.log"
    else
        log="$out/sim.log"
        ( cd "$out" && timeout 30 vvp -n sim.vvp ) > "$log" 2>&1
        rc=$?
        if   [[ $rc -eq 124 ]];                                  then status="timeout"
        elif [[ $rc -ne 0 ]];                                    then status="exit code $rc"
        elif grep -q '^FAIL' "$log";                             then status="check failed"
        elif [[ "$selfcheck" == 1 ]] && ! grep -q '^PASS' "$log"; then status="no PASS line"
        fi
    fi

    if [[ "$status" == ok ]]; then
        pass=$((pass + 1))
        result=$(grep -m1 '^PASS' "$log" 2>/dev/null || echo "ran (smoke test)")
        printf '  PASS  %-17s %s\n' "$name" "$result"
    else
        fail=$((fail + 1)); failed+=("$name")
        printf '  FAIL  %-17s %s  (see %s)\n' "$name" "$status" "$log"
    fi
    [[ $VERBOSE == 1 ]] && sed 's/^/        | /' "$log"
done

echo
echo "$pass passed, $fail failed"
[[ $fail -eq 0 ]] || { echo "Failed: ${failed[*]}"; exit 1; }
