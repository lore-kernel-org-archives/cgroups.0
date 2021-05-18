From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: [PATCH 0/3] sched/fair: Fix load decay issues related to throttling
Date: Tue, 18 May 2021 14:51:59 +0200
Message-ID: <20210518125202.78658-1-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QWNAW7pOe42b2/HBFIs7w7csNMJPX/6XPOTUoBjwouU=;
        b=QDilPCD/cVptq4KmogSHUQ5GMusPqfS56a4HkXUVkSEl8SQByMJhXjjN4VJECdaOG3
         /9q8YAaCVNcXxf+1oJAYyc2jtHBjhktP5p8lhXlB6qQIZRQ4joYmg0S0co1HnQ9GmNtQ
         YxfksByEM3IjeNGhw/HPubiN+tfy7eXzDQz1uqmVf9dmYrNyuMmrmEKGSIy5fqzBqu22
         fe1KuI5NRhs+0bWgs001L18V8ODzbXUQ2WgpqukbGLm3PMfi08jkBMbysLdNMsWbVdIh
         gfIAKOPFhZHMeWQXswDlRuZLwnTKVCN5RyaW8uBa0aA+3Ma5xzWz51pFLl/Anx0cYy43
         m6cg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>

Here is a follow up with some fairness fixes related to throttling, PELT and
load decay in general.

It is related to the discussion in:

https://lore.kernel.org/lkml/20210425080902.11854-1-odin-RObV4cXtwVA@public.gmane.org and
https://lkml.kernel.org/r/20210501141950.23622-2-odin-RObV4cXtwVA@public.gmane.org

Tested on v5.13-rc2 (since that contain the fix from above^).

The patch descriptions should make sense in its own, and I have attached some
simple reproduction scripts at the end of this mail. I also appended a patch
fixing some ascii art that I have been looking at several times without
understanding, when it turns out it breaks if tabs is not 8 spaces. I can
submit that as a separate patch if necessary.

Also, I have no idea what to call the "insert_on_unthrottle" var, so feel
free to come with suggestions.


There are probably "better" and more reliable ways to reproduce this, but
these works for me "most of the time", and gives an ok context imo. Throttling
is not deterministic, so keep that in mind. I have been testing with
CONFIG_HZ=250, so if you use =1000 (or anything else), you might get other
results/harder to reproduce.

Reprod script for "Add tg_load_contrib cfs_rq decay checking":
--- bash start
CGROUP=/sys/fs/cgroup/slice

function run_sandbox {
  local CG="$1"
  local LCPU="$2"
  local SHARES="$3"
  local CMD="$4"

  local PIPE="$(mktemp -u)"
  mkfifo "$PIPE"
  sh -c "read < $PIPE ; exec $CMD" &
  local TASK="$!"
  mkdir -p "$CG/sub"
  tee "$CG"/cgroup.subtree_control <<< "+cpuset +cpu" 
  tee "$CG"/sub/cgroup.procs <<< "$TASK"
  tee "$CG"/sub/cpuset.cpus <<< "$LCPU"
  tee "$CG"/sub/cpu.weight <<< "$SHARES"
  tee "$CG"/cpu.max <<< "10000 100000"

  sleep .1
  tee "$PIPE" <<< sandox_done
  rm "$PIPE"
}

mkdir -p "$CGROUP"
tee "$CGROUP"/cgroup.subtree_control <<< "+cpuset +cpu" 

run_sandbox "$CGROUP/cg-1" "0" 100 "stress --cpu 1"
run_sandbox "$CGROUP/cg-2" "3" 100 "stress --cpu 1"
sleep 1.02
tee "$CGROUP"/cg-1/sub/cpuset.cpus <<< "1"
sleep 1.05
tee "$CGROUP"/cg-1/sub/cpuset.cpus <<< "2"
sleep 1.07
tee "$CGROUP"/cg-1/sub/cpuset.cpus <<< "3"

sleep 2

tee "$CGROUP"/cg-1/cpu.max <<< "max"
tee "$CGROUP"/cg-2/cpu.max <<< "max"

read
killall stress
sleep .2
rmdir /sys/fs/cgroup/slice/{cg-{1,2}{/sub,},}

# Often gives:
# cat /sys/kernel/debug/sched/debug | grep ":/slice" -A 28 | egrep "(:/slice)|tg_load_avg"                                                                                                           odin@4670k
# 
# cfs_rq[3]:/slice/cg-2/sub
#   .tg_load_avg_contrib           : 1024
#   .tg_load_avg                   : 1024
# cfs_rq[3]:/slice/cg-1/sub
#   .tg_load_avg_contrib           : 1023
#   .tg_load_avg                   : 1023
# cfs_rq[3]:/slice/cg-1
#   .tg_load_avg_contrib           : 1040
#   .tg_load_avg                   : 2062
# cfs_rq[3]:/slice/cg-2
#   .tg_load_avg_contrib           : 1013
#   .tg_load_avg                   : 1013
# cfs_rq[3]:/slice
#   .tg_load_avg_contrib           : 1540
#   .tg_load_avg                   : 1540
--- bash end


Reprod for "sched/fair: Correctly insert cfs_rqs to list on unthrottle":
--- bash start
CGROUP=/sys/fs/cgroup/slice
TMP_CG=/sys/fs/cgroup/tmp
OLD_CG=/sys/fs/cgroup"$(cat /proc/self/cgroup | cut -c4-)"
function run_sandbox {
  local CG="$1"
  local LCPU="$2"
  local SHARES="$3"
  local CMD="$4"

  local PIPE="$(mktemp -u)"
  mkfifo "$PIPE"
  sh -c "read < $PIPE ; exec $CMD" &
  local TASK="$!"
  mkdir -p "$CG/sub"
  tee "$CG"/cgroup.subtree_control <<< "+cpuset +cpu" 
  tee "$CG"/sub/cpuset.cpus <<< "$LCPU"
  tee "$CG"/sub/cgroup.procs <<< "$TASK"
  tee "$CG"/sub/cpu.weight <<< "$SHARES"

  sleep .01
  tee "$PIPE" <<< sandox_done
  rm "$PIPE"
}

mkdir -p "$CGROUP"
mkdir -p "$TMP_CG"
tee "$CGROUP"/cgroup.subtree_control <<< "+cpuset +cpu" 

echo $$ | tee "$TMP_CG"/cgroup.procs
tee "$TMP_CG"/cpuset.cpus <<< "0"
sleep .1

tee "$CGROUP"/cpu.max <<< "1000 4000"

run_sandbox "$CGROUP/cg-0" "0" 10000 "stress --cpu 1"
run_sandbox "$CGROUP/cg-3" "3" 1 "stress --cpu 1"

sleep 2
tee "$CGROUP"/cg-0/sub/cpuset.cpus <<< "3"

tee "$CGROUP"/cpu.max <<< "max"

read
killall stress
sleep .2
echo $$ | tee "$OLD_CG"/cgroup.procs
rmdir "$TMP_CG" /sys/fs/cgroup/slice/{cg-{0,3}{/sub,},}

# Often gives:
# cat /sys/kernel/debug/sched/debug | grep ":/slice" -A 28 | egrep "(:/slice)|tg_load_avg"                                                                                                           odin@4670k
#
# cfs_rq[3]:/slice/cg-3/sub
#   .tg_load_avg_contrib           : 1039
#   .tg_load_avg                   : 2036
# cfs_rq[3]:/slice/cg-0/sub
#   .tg_load_avg_contrib           : 1023
#   .tg_load_avg                   : 1023
# cfs_rq[3]:/slice/cg-0
#   .tg_load_avg_contrib           : 102225
#   .tg_load_avg                   : 102225
# cfs_rq[3]:/slice/cg-3
#   .tg_load_avg_contrib           : 4
#   .tg_load_avg                   : 1001
# cfs_rq[3]:/slice
#   .tg_load_avg_contrib           : 1038
#   .tg_load_avg                   : 1038
--- bash end

Thanks
Odin

Odin Ugedal (3):
  sched/fair: Add tg_load_contrib cfs_rq decay checking
  sched/fair: Correctly insert cfs_rq's to list on unthrottle
  sched/fair: Fix ascii art by relpacing tabs

 kernel/sched/fair.c  | 22 +++++++++++++---------
 kernel/sched/sched.h |  1 +
 2 files changed, 14 insertions(+), 9 deletions(-)

-- 
2.31.1

