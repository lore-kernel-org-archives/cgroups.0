Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0B43D6689
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 09:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788167163; cv=none; b=gSjS4+JiqcagXY1EVs4K6peQhyVdBVO/DpVntiT4lh49w7mlMlBGecYTiY/SNkI39yS20QQBbH1FsLxnG6ENm7h04gF/5T8vPYSC0FpJz9xfz0VmKDvpO9WsoYMle13+BywcTfrLYN/C/YjmfSJNyxixgIKUVlqnRSsHQCgeqhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788167163; c=relaxed/simple;
	bh=FYe75tnPMNS9B6/HxVt6jwjQcEDYhMOo2R39ea0SjzI=;
	h=Message-ID:Date:MIME-Version:To:CC:From:Subject:Content-Type; b=o4UGo2CBGRB317MHiaumSBhSOJUwLSn2n9mZugFrv1WpST/hBznp0qAWhDBvvUF1MadNJm14D6yV671+ykQFd3l8C+qfPRGXLlRLaa4d0/+/aTSbSULH+H3B8tGewTdCnDnWhIjfWWJuIEMrjxKRJH4qy8hNpA4d13FHbQut+IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=heuTWfkY; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="heuTWfkY"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Toyj5pGJSeNH+PJmAutt4gIspKBpasG8nr4GiUIjl0Q=;
	b=heuTWfkY+JhrBIPTCwtlpmAmgsdnp/cOn3k+X+ENPmPM8rmIIuIkS4vhzdXVBgJ2Wsmq5bg4g
	o4HfRhGcedHGeL5p4TEnya2evu0CIAxjj7F7sTj+mMpnVLEocGJc1lUBUXFdxAPb9qPYM4lB60A
	jIB5oSF7GBA37AfFOkT0oRw=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hYN9D3TTdz1cyQ2;
	Mon, 31 Aug 2026 16:54:56 +0800 (CST)
Received: from dggpemf100017.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 8BDEB40578;
	Mon, 31 Aug 2026 17:05:44 +0800 (CST)
Received: from [10.67.111.186] (10.67.111.186) by
 dggpemf100017.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 31 Aug 2026 17:05:43 +0800
Message-ID: <0a897510-8d80-2d8a-5b7b-800aea5f1d23@huawei.com>
Date: Mon, 31 Aug 2026 17:05:42 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
To: Waiman Long <longman@redhat.com>, <ridong.chen@linux.dev>, Tejun Heo
	<tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
CC: <jifa@huawei.com>, Hui Tang <tanghui20@huawei.com>,
	<cgroups@vger.kernel.org>
From: Zhang Qiao <zhangqiao22@huawei.com>
Subject: [BUG] cgroup/cpuset: Concurrent WARN_ON_ONCE triggers during remote
 partition stress-test
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100017.china.huawei.com (7.185.36.74)

Hi,

While stress-testing cpuset partitions under KASAN (kernel 7.2-rc1,
dc59e4fea9d83 "Linux 7.2-rc1"), four distinct WARN_ON_ONCE() in
kernel/cgroup/cpuset.c fire within a ~1s window. They all concern the
remote partition / effective-cpumask invariants and are triggered by
concurrent CPU hotplug, cpuset.cpus/cpuset.cpus.exclusive/
cpuset.cpus.partition writes, task migration and (un)partitioning of
nested subgroups.

Environment
-----------
- Kernel : Linux 7.2-rc1, generic KASAN enabled, x86_64, PREEMPT
- server   : Intel Xeon Platinum 8380 @ 2.30GHz, 2 NUMA nodes, 160 CPUs
- Cmdline: ... cgroup_disable=files apparmor=0 	systemd.unified_cgroup_hierarchy=1

Reproduction
------------
A pure-shell self-contained script (attached below) runs several concurrent
"disturbance" loops. The issue is extremely easy to reproduce; the script
consistently triggers the WARNs within seconds of execution.

  - CPU hotplug toggle of a helper pool (CPU online/offline)
  - random writes to cpuset.cpus / cpuset.cpus.exclusive
    (single CPU, empty, or range)
  - random root <-> member switching of cpuset.cpus.partition
  - migrating burner tasks between subgroups via cgroup.procs
  - creating and removing nested sub-partitions under S0-S3

Run as:  bash fn_warn_repro_008_shell.sh

The parent cgroup TEST_CGROOT is set as "member" and four children
S0-S3 as remote partition roots, giving the invariant checks above a
reason to run concurrently.

Observed
--------
Four WARN_ON_ONCE fire (trimmed traces below; register dumps omitted). No KASAN
use-after-free or list corruption was observed on this run.

1) kernel/cgroup/cpuset.c:867  generate_sched_domains+0x489/0x900, CPU#155:
bash/9129
   WARN_ON_ONCE(1) when two partition-root cpusets overlap.

---------------[ cut here ]---------------
WARNING: kernel/cgroup/cpuset.c:867 at generate_sched_domains+0x489/0x900,
CPU#155: bash/9129
CPU: 155 UID: 0 PID: 9129 Comm: bash Kdump: loaded Tainted: G S        7.2.0+
#11 PREEMPTLAZY
Tainted: [S]=CPU_OUT_OF_SPEC
RIP: 0010:generate_sched_domains+0x489/0x900
Call Trace:
 <TASK>
  ? update_cpumask+0x617/0x7c0
  rebuild_sched_domains_locked+0x8c/0x1c0
  ? __pfx_rebuild_sched_domains_locked+0x10/0x10
  ? kasan_save_track+0x10/0x30
  ? cpuset_write_resmask+0x1fc/0x880
  ? kfree+0x162/0x440
  cpuset_update_sd_hk_unlock+0xc7/0xf0
  cpuset_write_resmask+0x201/0x880
  cgroup_file_write+0x1b4/0x600
  kernfs_fop_write_iter+0x31c/0x500
  vfs_write+0x58c/0xca0
  ksys_write+0xef/0x1c0
  do_syscall_64+0xaf/0x550
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>
---[ end trace 0000000000000000 ]---

2) kernel/cgroup/cpuset.c:1599  remote_cpus_update+0x6d5/0x990, CPU#150: bash/9125
   WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus)).

---------------[ cut here ]---------------
WARNING: kernel/cgroup/cpuset.c:1599 at remote_cpus_update+0x6d5/0x990, CPU#150:
bash/9125
CPU: 150 UID: 0 PID: 9125 Comm: bash Kdump: loaded Tainted: G S      W
7.2.0+ #11 PREEMPTLAZY
Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
RIP: 0010:remote_cpus_update+0x6d5/0x990
Call Trace:
 <TASK>
  ? partition_cpus_change.part.0+0x249/0x470
  update_exclusive_cpumask+0x438/0x810
  ? __pfx_update_exclusive_cpumask+0x10/0x10
  cpuset_write_resmask+0x33b/0x880
  cgroup_file_write+0x1b4/0x600
  kernfs_fop_write_iter+0x31c/0x500
  vfs_write+0x58c/0xca0
  ksys_write+0xef/0x1c0
  do_syscall_64+0xaf/0x550
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>
---[ end trace 0000000000000000 ]---

3) kernel/cgroup/cpuset.c:1513  remote_partition_enable+0x3ac/0x4b0, CPU#149:
bash/9124
   WARN_ON_ONCE(cpumask_intersects(tmp->new_cpus, subpartitions_cpus)).

---------------[ cut here ]---------------
WARNING: kernel/cgroup/cpuset.c:1513 at remote_partition_enable+0x3ac/0x4b0,
CPU#149: bash/9124
CPU: 149 UID: 0 PID: 9124 Comm: bash Kdump: loaded Tainted: G S      W
7.2.0+ #11 PREEMPTLAZY
Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
RIP: 0010:remote_partition_enable+0x3ac/0x4b0
Call Trace:
 <TASK>
  update_prstate+0x998/0xb60
  ? __pfx_update_prstate+0x10/0x10
  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
  cpuset_partition_write+0xcb/0x120
  cgroup_file_write+0x1b4/0x600
  kernfs_fop_write_iter+0x31c/0x500
  vfs_write+0x58c/0xca0
  ksys_write+0xef/0x1c0
  do_syscall_64+0xaf/0x550
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>
---[ end trace 0000000000000000 ]---

4) kernel/cgroup/cpuset.c:2050  compute_partition_effective_cpumask+0x710/0x900,
CPU#44: bash/9124
   WARN_ON_ONCE(is_remote_partition(child)) — remote partition underneath
   another partition root.

---------------[ cut here ]---------------
WARNING: kernel/cgroup/cpuset.c:2050 at
compute_partition_effective_cpumask+0x710/0x900, CPU#44: bash/9124
CPU: 44 UID: 0 PID: 9124 Comm: bash Kdump: loaded Tainted: G S      W
7.2.0+ #11 PREEMPTLAZY
Tainted: [S]=CPU_OUT_OF_SPEC, [W]=WARN
RIP: 0010:compute_partition_effective_cpumask+0x710/0x900
Call Trace:
 <TASK>
  update_cpumasks_hier+0x9df/0x1200
  ? remote_partition_enable+0x353/0x4b0
  update_prstate+0x8ff/0xb60
  ? __pfx_update_prstate+0x10/0x10
  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
  cpuset_partition_write+0xcb/0x120
  cgroup_file_write+0x1b4/0x600
  kernfs_fop_write_iter+0x31c/0x500
  vfs_write+0x58c/0xca0
  ksys_write+0xef/0x1c0
  do_syscall_64+0xaf/0x550
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>
---[ end trace 0000000000000000 ]---

The line numbers above map to the exact 7.2-rc1 source

These WARNs suggest the remote-partition / subpartitions_cpus bookkeeping
can become momentarily inconsistent when partition *, exclusive and
cpuset.cpus writes race with CPU hotplug and parallel subgroup
(un)partitioning. I haven't pinpointed the exact race or prepared a patch yet.
Please let me know if you need full dmesg logs, specific ftrace outputs, or if I
should test any debugging patches.

Thanks,
Zhang Qiao

======================================================================
Reproduction script (fn_warn_repro_008_shell.sh)
======================================================================

#!/bin/bash
#
# Copyright (c) Huawei Technologies Co., Ltd. 2026-2026. All rights reserved.
# Author: jifa@huawei.com
# Create: 2026/08/31
# TestCase Description: FN-WARN-REPRO-008 (PURE SHELL) — reproduce
slab-use-after-free under KASAN
#
#   This is a pure-shell, self-contained single-file version of
fn_warn_repro_008.sh.
#   It has no dependency on:
#     - common_base.sh / sched_common.sh / common.sh
#     - the cpu_sim binary (replaced by a bash `while` busy-loop sub-shell)
#     - base64 / xz decoding (the script no longer embeds any binary)
#
#   The key to triggering the cpuset_mutex race is not CPU utilization itself,
#   but the cgroup.procs write. So a simple bash busy-loop sub-process is enough
#   to create task-migration pressure.
#
# Goals:
#   1. KASAN: slab-use-after-free in remote_partition_check /
remote_partition_enable
#   2. cpuset.c:1753 (remote_partition_disable operating on a corrupted list)
#   3. lib/list_debug.c:29 / 35 (list_add operating on a corrupted list)
#   4. soft lockup / NULL deref / Oops / panic (as a side-effect of the race)
#
# Verification: look for KASAN / list_debug / cpuset.c:1753 / NULL deref / soft
lockup in dmesg
#
# Usage:
#   bash fn_warn_repro_008_shell.sh [duration_sec]
#   default duration=60s
#
# Exit codes:
#   0  = completed (inspect the log output to determine whether it reproduced)
#   1+ = environment error

set -u

# =============================================================================
# Global configuration
# =============================================================================
STANDALONE_DIR="$(cd "$(dirname "$0")" && pwd)"
CASE_NAME="${0/.sh/}"
LOG_FILE="${CASE_NAME}.log"
REPRO_FILE="${CASE_NAME}.repro"
: > "${LOG_FILE}"
: > "${REPRO_FILE}"

DURATION="${1:-${ST_LONG_DURATION:-60}}"
export DURATION
MAX_TASKS=2

HELPER_CPU_POOL=""
ROOT_CG="/sys/fs/cgroup"
TEST_CGROOT=""

declare -a task_pid task_cg_idx task_alive
task_count=0

ALL_CGS=()
SUB_PATHS=()

# =============================================================================
# Logging
# =============================================================================
function logger_info()  { printf "\033[0;37m[INFO] %s\033[0m\n"  "$*"; }
function logger_error() { printf "\033[0;31m[ERROR] %s\033[0m\n" "$*"; }
function logger_setup() { printf "\033[0;34m[SETUP] %s\033[0m\n" "$*"; }
function logger_pass()  { printf "\033[0;32m[PASS] %s\033[0m\n"  "$*"; }
function logger_failed(){ printf "\033[0;31m[FAILED] %s\033[0m\n" "$*"; }

ret=0

# =============================================================================
# 1. cgroup / environment helpers (self-contained implementation,
#    equivalent to common.sh / sched_common.sh)
# =============================================================================
function is_cgroup_v2() {
    [ -f /sys/fs/cgroup/cgroup.controllers ] && echo true || echo false
}

function set_subtree_control_repeat() {
    local cg="$1" val="$2"
    echo "${val}" > "${cg}/cgroup.subtree_control" 2>/dev/null
}

# CPU pool (avoid the system's main CPUs 0-1; use 2-5 on a 6-CPU machine)
function helper_init_cpu_pool() {
    local nr_cpus
    nr_cpus=$(lscpu 2>/dev/null | awk '/^CPU\(s\):/ {gsub(/[^0-9]/,"",$2); print
$2; exit}')
    if [[ -n "$nr_cpus" && "$nr_cpus" -lt 8 ]]; then
        if [[ "$nr_cpus" -ge 4 ]]; then
            HELPER_CPU_POOL=$(seq 2 $((nr_cpus - 1)) | tr '\n' ' ')
        fi
    fi
    [[ -z "$HELPER_CPU_POOL" ]] && HELPER_CPU_POOL="4 5 6 7"
    export HELPER_CPU_POOL
}

function helper_pick_cpus() {
    local n=${1:-1}
    [[ -z "$HELPER_CPU_POOL" ]] && helper_init_cpu_pool
    local pool=($HELPER_CPU_POOL)
    [[ ${#pool[@]} -lt $n ]] && return 1
    echo "${pool[@]:0:n}"
}

# Create an isolated CGROOT and set it as the partition root
function helper_setup_cgroot() {
    local suffix=${1:-$$}
    TEST_CGROOT="${ROOT_CG}/test_cpuset_partition_${suffix}"
    if [[ -d "$TEST_CGROOT" ]]; then
        helper_cleanup_cgroot "$TEST_CGROOT"
    fi
    set_subtree_control_repeat "$ROOT_CG" "+cpuset"
    mkdir -p "$TEST_CGROOT"
    set_subtree_control_repeat "$TEST_CGROOT" "+cpuset"
    [[ -z "$HELPER_CPU_POOL" ]] && helper_init_cpu_pool
    if [[ -n "$HELPER_CPU_POOL" ]]; then
        echo 0 > "$TEST_CGROOT/cpuset.mems" 2>/dev/null
        echo "$HELPER_CPU_POOL" > "$TEST_CGROOT/cpuset.cpus" 2>/dev/null
        echo "root" > "$TEST_CGROOT/cpuset.cpus.partition" 2>/dev/null
        echo "$HELPER_CPU_POOL" > "$TEST_CGROOT/cpuset.cpus.exclusive" 2>/dev/null
    fi
    export TEST_CGROOT
}

# Enable +cpuset top-down one level at a time so child cgroups can write cpuset.cpus
function helper_mkdir_cg() {
    local cg
    for cg in "$@"; do
        mkdir -p "$cg"
        local chain=()
        local p="$cg"
        while [[ -n "$p" && "$p" != "/" ]]; do
            [[ "$p" == "$ROOT_CG" ]] && break
            chain=("$p" "${chain[@]}")
            p=$(dirname "$p")
        done
        local d
        for d in "${chain[@]}"; do
            [[ -f "$d/cgroup.subtree_control" ]] && \
                set_subtree_control_repeat "$d" "+cpuset" 2>/dev/null
        done
    done
}

function helper_cleanup_partition() {
    local cg="$1"
    [[ -z "$cg" || ! -d "$cg" ]] && return 0
    echo "member" > "$cg/cpuset.cpus.partition" 2>/dev/null
    echo "" > "$cg/cpuset.cpus" 2>/dev/null
    echo "" > "$cg/cpuset.cpus.exclusive" 2>/dev/null
}

function helper_cleanup_cgroot() {
    local cgroot="$1"
    [[ -z "$cgroot" || ! -d "$cgroot" ]] && return 0
    if [[ -f "$cgroot/cgroup.procs" ]]; then
        while read -r pid; do
            [[ -n "$pid" && "$pid" -gt 100 ]] && echo "$pid" >
/sys/fs/cgroup/cgroup.procs 2>/dev/null
        done < "$cgroot/cgroup.procs"
    fi
    find "$cgroot" -depth -type d 2>/dev/null | while read -r d; do
        helper_cleanup_partition "$d"
        rmdir "$d" 2>/dev/null
    done
}

# Kill the burner child processes started by this script (isolated via process
group to avoid killing unrelated processes)
function cleanup_all_tasks() {
    local p
    for p in "${task_pid[@]:-}"; do
        [[ -n "$p" ]] && kill -9 "$p" 2>/dev/null
    done
    # Fallback: kill all bash burners started by this script (tagged via env var
BURNER_PARENT=<ppid>)
    pkill -9 -f "BURNER_PARENT=$$" 2>/dev/null
}

# Recover all CPUs to online by enumerating sysfs (cannot use nproc — it only
counts online CPUs)
function recover_hotplug_cpus() {
    local cpu_sysfs="/sys/devices/system/cpu"
    local cpu_dir
    for cpu_dir in ${cpu_sysfs}/cpu[0-9]*; do
        [[ -d "$cpu_dir" ]] || continue
        local n=${cpu_dir##*cpu}
        [[ "$n" == "0" ]] && continue
        local f="${cpu_dir}/online"
        if [[ -f "$f" ]]; then
            local s
            s=$(cat "$f" 2>/dev/null)
            if [[ "$s" == "0" ]]; then
                echo 1 > "$f" 2>/dev/null
                [[ $? -eq 0 ]] && logger_info "Recovered cpu${n} online=1" ||
logger_error "Failed to recover cpu${n}"
            fi
        fi
    done
}

function helper_full_cleanup() {
    cleanup_all_tasks
    recover_hotplug_cpus
    [[ -n "$TEST_CGROOT" ]] && helper_cleanup_cgroot "$TEST_CGROOT"
}

# =============================================================================
# 2. CPU burner — a pure-bash sub-process, replacing cpu_sim
#    Uses a `while true; do :; done` busy-loop to consume CPU, tagged with
#    BURNER_PARENT=<ppid> on the command line so cleanup can pkill -f it
#    precisely without killing other bash processes
# =============================================================================
function start_burner() {
    # $1 = runtime in seconds (self-terminates after that to avoid leaking)
    local secs=${1:-$((DURATION + 30))}
    BURNER_PARENT=$$ bash -c "
        trap 'exit 0' TERM
        end=\$((SECONDS + ${secs}))
        while [[ \$SECONDS -lt \$end ]]; do
            :
        done
    " &
    echo $!
}

# =============================================================================
# 3. Disturbance functions (ported directly from the original fn_warn_repro_008.sh)
# =============================================================================
function disturb_hotplug() {
    local pool=($HELPER_CPU_POOL)
    local end=$((SECONDS + DURATION))
    while [[ $SECONDS -lt $end ]]; do
        local c="${pool[$((RANDOM % ${#pool[@]}))]}"
        echo 0 > "/sys/devices/system/cpu/cpu$c/online" 2>/dev/null
        sleep 0.02
        echo 1 > "/sys/devices/system/cpu/cpu$c/online" 2>/dev/null
        sleep 0.03
        if (( RANDOM % 2 == 0 )); then
            for c2 in "${pool[@]}"; do
                echo 0 > "/sys/devices/system/cpu/cpu$c2/online" 2>/dev/null
            done
            sleep 0.05
            for c2 in "${pool[@]}"; do
                echo 1 > "/sys/devices/system/cpu/cpu$c2/online" 2>/dev/null
            done
            sleep 0.08
        fi
    done
}

function disturb_partition_switch() {
    local end=$((SECONDS + DURATION))
    while [[ $SECONDS -lt $end ]]; do
        local n=${#ALL_CGS[@]}
        [[ $n -eq 0 ]] && { sleep 0.1; continue; }
        local idx=$((RANDOM % n))
        local cg="${ALL_CGS[idx]}"
        [[ ! -d "$cg" ]] && { sleep 0.02; continue; }
        local pr="root"
        (( RANDOM % 2 == 0 )) && pr="member"
        echo "$pr" > "$cg/cpuset.cpus.partition" 2>/dev/null
        sleep 0.02
    done
}

function disturb_exclusive_write() {
    local pool=($HELPER_CPU_POOL)
    local end=$((SECONDS + DURATION))
    while [[ $SECONDS -lt $end ]]; do
        local n=${#ALL_CGS[@]}
        [[ $n -eq 0 ]] && { sleep 0.1; continue; }
        local idx=$((RANDOM % n))
        local cg="${ALL_CGS[idx]}"
        [[ ! -d "$cg" ]] && { sleep 0.02; continue; }
        local r=$((RANDOM % 3))
        case $r in
            0)
                local c="${pool[$((RANDOM % ${#pool[@]}))]}"
                echo "$c" > "$cg/cpuset.cpus.exclusive" 2>/dev/null
                ;;
            1)
                echo "" > "$cg/cpuset.cpus.exclusive" 2>/dev/null
                ;;
            2)
                local c1="${pool[$((RANDOM % ${#pool[@]}))]}"
                local c2="${pool[$((RANDOM % ${#pool[@]}))]}"
                [[ "$c1" -gt "$c2" ]] && { local t=$c1; c1=$c2; c2=$t; }
                echo "$c1-$c2" > "$cg/cpuset.cpus.exclusive" 2>/dev/null
                ;;
        esac
        sleep 0.02
    done
}

function disturb_cpus_write() {
    local pool=($HELPER_CPU_POOL)
    local end=$((SECONDS + DURATION))
    while [[ $SECONDS -lt $end ]]; do
        local n=${#ALL_CGS[@]}
        [[ $n -eq 0 ]] && { sleep 0.1; continue; }
        local idx=$((RANDOM % n))
        local cg="${ALL_CGS[idx]}"
        [[ ! -d "$cg" ]] && { sleep 0.02; continue; }
        local r=$((RANDOM % 2))
        case $r in
            0)
                local c="${pool[$((RANDOM % ${#pool[@]}))]}"
                echo "$c" > "$cg/cpuset.cpus" 2>/dev/null
                ;;
            1)
                echo "" > "$cg/cpuset.cpus" 2>/dev/null
                ;;
        esac
        sleep 0.02
    done
}

# Task-migration disturbance: use a bash burner instead of cpu_sim
function disturb_task_migrate() {
    local i
    for ((i = 0; i < MAX_TASKS; i++)); do
        local pid
        pid=$(start_burner $((DURATION + 30)))
        task_pid[task_count]=$pid
        task_cg_idx[task_count]=0
        task_alive[task_count]=1
        ((task_count++))
        sleep 0.1
    done
    for ((i = 0; i < task_count; i++)); do
        [[ ${#ALL_CGS[@]} -gt 0 ]] && echo "${task_pid[i]}" >
"${ALL_CGS[0]}/cgroup.procs" 2>/dev/null
    done

    local end=$((SECONDS + DURATION))
    while [[ $SECONDS -lt $end ]]; do
        local alive=()
        for ((i = 0; i < task_count; i++)); do
            [[ "${task_alive[i]}" == "1" ]] && alive+=($i)
        done
        [[ ${#alive[@]} -eq 0 ]] && break
        local ti=${alive[$((RANDOM % ${#alive[@]}))]}
        local n=${#ALL_CGS[@]}
        [[ $n -eq 0 ]] && { sleep 0.2; continue; }
        local idx=$((RANDOM % n))
        local cg="${ALL_CGS[idx]}"
        [[ ! -d "$cg" ]] && { sleep 0.05; continue; }
        echo "${task_pid[ti]}" > "$cg/cgroup.procs" 2>/dev/null
        task_cg_idx[ti]=$idx
        sleep 0.1
    done

    for ((i = 0; i < task_count; i++)); do
        [[ "${task_alive[i]}" == "1" ]] && kill -9 "${task_pid[i]}" 2>/dev/null
    done
}

function disturb_grandson_ops() {
    local pool=($HELPER_CPU_POOL)
    local end=$((SECONDS + DURATION))
    local sons=("${SUB_PATHS[@]}")
    while [[ $SECONDS -lt $end ]]; do
        local k
        for ((k = 0; k < 5; k++)); do
            [[ ${#ALL_CGS[@]} -ge 80 ]] && break
            [[ ${#sons[@]} -eq 0 ]] && break
            local sidx=$((RANDOM % ${#sons[@]}))
            local parent="${sons[sidx]}"
            [[ ! -d "$parent" ]] && continue
            local suffix=$((RANDOM % 100000))
            local new="${parent}/L1_${suffix}"
            [[ -d "$new" ]] && continue
            helper_mkdir_cg "$new" 2>/dev/null
            if [[ -d "$new" ]]; then
                echo 0 > "$new/cpuset.mems" 2>/dev/null
                local c="${pool[$((RANDOM % ${#pool[@]}))]}"
                echo "$c" > "$new/cpuset.cpus" 2>/dev/null
                echo "$c" > "$new/cpuset.cpus.exclusive" 2>/dev/null
                echo "root" > "$new/cpuset.cpus.partition" 2>/dev/null
                ALL_CGS+=("$new")
            fi
        done

        local rmdone=0
        local i
        for ((i = 4; i < ${#ALL_CGS[@]} && rmdone < 3; i++)); do
            if [[ "${ALL_CGS[i]}" == *"/L1_"* ]]; then
                local cg="${ALL_CGS[i]}"
                rmdir "$cg" 2>/dev/null
                unset 'ALL_CGS[i]'
                ((rmdone++))
            fi
        done
        ALL_CGS=("${ALL_CGS[@]}")
        sleep 0.01
    done
}

# =============================================================================
# 4. setup / do_test / cleanup
# =============================================================================
function setup() {
    [[ "$(is_cgroup_v2)" != "true" ]] && { logger_error "need cgroup v2";
((ret+=1)); exit 1; }
    ROOT_CG=/sys/fs/cgroup
    helper_init_cpu_pool
    helper_setup_cgroot
}

function do_test() {
    local pool
    pool=$(helper_pick_cpus 4)
    [[ -z "$pool" || $(echo "$pool" | wc -w) -lt 4 ]] && { logger_error "need ≥4
CPUs in pool, skip"; ((ret+=1)); return; }
    local pool_arr=($pool)
    logger_info "pool=${pool[*]} duration=${DURATION}s"

    local dmesg_lines_before
    dmesg_lines_before=$(dmesg 2>/dev/null | wc -l)

    # TEST_CGROOT as member + 4 remote-partition subgroups S0-S3
    echo "member" > "$TEST_CGROOT/cpuset.cpus.partition" 2>/dev/null
    sleep 0.2
    echo "$pool" > "$TEST_CGROOT/cpuset.cpus" 2>/dev/null
    echo "$pool" > "$TEST_CGROOT/cpuset.cpus.exclusive" 2>/dev/null
    sleep 0.3

    local i
    for ((i = 0; i < 4; i++)); do
        local cg="${TEST_CGROOT}/S${i}"
        local c="${pool_arr[i % 4]}"
        helper_mkdir_cg "$cg"
        echo 0 > "$cg/cpuset.mems" 2>/dev/null
        echo "$c" > "$cg/cpuset.cpus" 2>/dev/null
        echo "$c" > "$cg/cpuset.cpus.exclusive" 2>/dev/null
        echo "root" > "$cg/cpuset.cpus.partition" 2>/dev/null
        SUB_PATHS+=("$cg")
        ALL_CGS+=("$cg")
        sleep 0.03
    done
    logger_info "created ${#SUB_PATHS[@]} remote partition subgroups
(parent=member)"

    # 8 concurrent disturbances: hotplug + partition_switch + 3x exclusive_write
+ cpus_write + task_migrate + grandson_ops
    disturb_hotplug           & local p1=$!
    disturb_partition_switch  & local p2=$!
    disturb_exclusive_write   & local p3=$!
    disturb_exclusive_write   & local p4=$!
    disturb_exclusive_write   & local p5=$!
    disturb_cpus_write        & local p6=$!
    disturb_task_migrate     & local p7=$!
    disturb_grandson_ops     & local p8=$!

    # Check dmesg every 2s; stop as soon as an issue is hit
    local warned=0
    local check_end=$((SECONDS + DURATION))
    while [[ $SECONDS -lt $check_end ]]; do
        sleep 2
        local new_warnings
        new_warnings=$(dmesg 2>/dev/null | tail -n +$((dmesg_lines_before + 1)) | \
            grep -cE
"WARNING.*cpuset|WARNING.*list_debug|KASAN|cpuset.c:(1753|1793|2195)|list_add_valid_or_report|list_del
corruption|soft lockup|general protection fault|Unable to handl
e|oops|BUG:|panic|segfault|slab-use-after-free|use-after-free")
        if [[ $new_warnings -gt 0 ]]; then
            warned=1
            logger_info "issue detected in dmesg — stopping disturbances early"
            break
        fi
    done

    kill -9 $p1 $p2 $p3 $p4 $p5 $p6 $p7 $p8 2>/dev/null
    pkill -9 -f "BASH_BURNER_${$}" 2>/dev/null
    cleanup_all_tasks
    sleep 1

    # Force-clean any leftovers in TEST_CGROOT
    if [[ -n "$TEST_CGROOT" && -d "$TEST_CGROOT" ]]; then
        if [[ -f "$TEST_CGROOT/cgroup.procs" ]]; then
            while read -r p; do
                [[ -n "$p" && "$p" -gt 100 ]] && echo "$p" >
/sys/fs/cgroup/cgroup.procs 2>/dev/null
            done < "$TEST_CGROOT/cgroup.procs"
        fi
        find "$TEST_CGROOT" -depth -mindepth 1 -type d 2>/dev/null | while read
-r d; do
            echo "member" > "$d/cpuset.cpus.partition" 2>/dev/null
            echo "" > "$d/cpuset.cpus" 2>/dev/null
            echo "" > "$d/cpuset.cpus.exclusive" 2>/dev/null
            rmdir "$d" 2>/dev/null
        done
        echo "member" > "$TEST_CGROOT/cpuset.cpus.partition" 2>/dev/null
        echo "" > "$TEST_CGROOT/cpuset.cpus" 2>/dev/null
        echo "" > "$TEST_CGROOT/cpuset.cpus.exclusive" 2>/dev/null
    fi

    # Extract all trace segments + other dmesg anomalies
    local dmesg_full dmesg_inc
    dmesg_full=$(dmesg 2>/dev/null)
    dmesg_inc=$(echo "$dmesg_full" | tail -n +$((dmesg_lines_before + 1)))

    local trace_count=0
    local current_trace=""
    local in_trace=0
    local line
    while IFS= read -r line; do
        if [[ "$line" == *"------------[ cut here ]------------"* ]]; then
            in_trace=1
            current_trace="$line"$'\n'
        elif [[ "$in_trace" == "1" ]]; then
            current_trace+="$line"$'\n'
            if [[ "$line" == *"---[ end trace "* ]]; then
                in_trace=0
                ((trace_count++))
                echo "=== Reproduced Issue #${trace_count} ===" >> "${REPRO_FILE}"
                echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')" >> "${REPRO_FILE}"
                local warn_line
                warn_line=$(echo "$current_trace" | grep -E
"WARNING:.*cpuset\.c:|WARNING:.*list_debug" | head -1)
                [[ -n "$warn_line" ]] && echo "Warning: ${warn_line}" >>
"${REPRO_FILE}"
                local kasan_line
                kasan_line=$(echo "$current_trace" | grep -iE
"KASAN|slab-use-after-free|use-after-free" | head -1)
                [[ -n "$kasan_line" ]] && echo "KASAN: ${kasan_line}" >>
"${REPRO_FILE}"
                local oops_line
                oops_line=$(echo "$current_trace" | grep -iE "general protection
fault|Unable to handle|oops|BUG:|panic|segfault|NULL pointer" | head -1)
                [[ -n "$oops_line" ]] && echo "Oops: ${oops_line}" >>
"${REPRO_FILE}"
                echo "--- Full Trace ---" >> "${REPRO_FILE}"
                echo "$current_trace" >> "${REPRO_FILE}"
                echo "" >> "${REPRO_FILE}"
                current_trace=""
            fi
        fi
    done <<< "$dmesg_inc"

    local other_issues
    other_issues=$(echo "$dmesg_inc" | grep -iE "soft lockup|list_del
corruption|list_add_valid_or_report|KASAN|slab-use-after-free|use-after-free|BUG:|oops:|panic|Unable
to handle|genera
l protection fault|segfault|NULL pointer|kernel page fault" | grep -v "WARNING:"
| head -30)
    if [[ -n "$other_issues" ]]; then
        echo "=== Other Kernel Issues ===" >> "${REPRO_FILE}"
        echo "$other_issues" >> "${REPRO_FILE}"
        echo "" >> "${REPRO_FILE}"
    fi

    if [[ $trace_count -gt 0 || -n "$other_issues" ]]; then
        logger_info "==== REPRODUCED ${trace_count} traces + other issues ===="
        logger_info "Detailed traces saved to: ${REPRO_FILE}"
        awk '
            /^=== Reproduced Issue #/ { if (cur) print cur; cur=$0 }
            /^Warning: / { cur = cur "  | " $0 }
            /^KASAN: / { cur = cur "  | " $0 }
            /^Oops: / { cur = cur "  | " $0 }
            END { if (cur) print cur }
        ' "${REPRO_FILE}" | while IFS= read -r summary; do
            logger_info "$summary"
        done
        logger_pass "reproduced ${trace_count} traces (see ${REPRO_FILE})"
        if echo "$dmesg_inc" | grep -qE
"KASAN|slab-use-after-free|use-after-free"; then
            logger_pass "KASAN UAF detected! (target of fn_warn_repro_008)"
        fi
        if echo "$dmesg_inc" | grep -qE "BUG:|oops:|panic|Unable to
handle|general protection fault|segfault"; then
            logger_info "kernel panic/oops detected (see ${REPRO_FILE})"
        fi
    else
        logger_info "no issues this run (probabilistic) — try more iterations"
    fi

    if echo "$dmesg_inc" | grep -qE "KASAN|slab-use-after-free|use-after-free"; then
        logger_pass "KASAN UAF reproduced!"
    fi
    if echo "$dmesg_inc" | grep -qE "BUG:|oops:|panic|Unable to handle|general
protection fault|segfault|kernel page fault"; then
        logger_info "kernel panic/crash detected (details in ${REPRO_FILE})"
    fi

    [ $trace_count -gt 0 ] && logger_pass "PASS: reproduced kernel issues!" ||
logger_info "INFO: no issue reproduced this iteration (run again to increase
chance)"
}

function cleanup() {
    helper_full_cleanup
}

# =============================================================================
# main
# =============================================================================
logger_setup "Starting ${CASE_NAME} (pure-shell, duration=${DURATION}s)"

setup
do_test
cleanup
exit ${ret}

