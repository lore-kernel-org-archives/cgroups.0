From: brookxu <brookxu.cn@gmail.com>
Subject: [RFC PATCH v2 00/11] bfq: introduce bfq.ioprio for cgroup
Date: Fri, 12 Mar 2021 19:08:34 +0800
Message-ID: <cover.1615517202.git.brookxu@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bTPvw3IUJ9WwR588wMJx9zIhcLtpvhfNVx1XrrnOYxE=;
        b=uacnWCwaZE8woNMCG/63jKiql0GCb1RAWsGNNANEjFev7+Ce4FH89lrOAGQse/v+fC
         oHyQhOY1K7MQdt2kUCazgGEXV3WdpE2ZajjsBUVe+l6FO7P4iwKhynOjLbiOJXhjlF16
         f1w30m6CMa5oAL8nyRkUKFQ6S/ckj+DmNqrrMtk9pf24QZbUpHwxOnitWcPgSPQ06Ukj
         yJhiRxntJPYJ74hXKv0e/JoxciQZAsyjO0gWSOKG3tnOrjLP2FUdEu6ZuGtuhL0TuSRf
         O/evwCTxwbx1uYb1F0XrAWluvR23otNH/xC+AC0PyZYxzOYOp/qUHG3gplj/FJGFvhzE
         s8YQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

Tasks in the production environment can be roughly divided into
three categories: emergency tasks, ordinary tasks and offline
tasks. Emergency tasks need to be scheduled in real time, such
as system agents. Offline tasks do not need to guarantee QoS,
but can improve system resource utilization during system idle
periods, such as background tasks. The above requirements need
to achieve IO preemption. At present, we can use weights to
simulate IO preemption, but since weights are more of a shared
concept, they cannot be simulated well. For example, the weights
of emergency tasks and ordinary tasks cannot be determined well,
offline tasks (with the same weight) actually occupy different
resources on disks with different performance, and the tail
latency caused by offline tasks cannot be well controlled. Using
ioprio's concept of preemption, we can solve the above problems
very well. Since ioprio will eventually be converted to weight,
using ioprio alone can also achieve weight isolation within the
same class. But we can still use bfq.weight to control resource,
achieving better IO Qos control.

However, currently the class of bfq_group is always be class, and
the ioprio class of the task can only be reflected in a single
cgroup. We cannot guarantee that real-time tasks in a cgroup are
scheduled in time. Therefore, we introduce bfq.ioprio, which
allows us to configure ioprio class for cgroup. In this way, we
can ensure that the real-time tasks of a cgroup can be scheduled
in time. Similarly, the processing of offline task groups can
also be simpler.

The bfq.ioprio interface now is available for cgroup v1 and cgroup
v2. Users can configure the ioprio for cgroup through this interface,
as shown below:

echo "1 2"> blkio.bfq.ioprio

The above two values respectively represent the values of ioprio
class and ioprio for cgroup. The ioprio of tasks within the cgroup
is uniformly equal to the ioprio of the cgroup. If the ioprio of
the cgroup is disabled, the ioprio of the task remains the same,
usually from io_context.

When testing, using fio and fio_generate_plots we can clearly see
that the IO delay of the task satisfies RT> BE> IDLE. When RT is
running, BE and IDLE are guaranteed minimum bandwidth. When used
with bfq.weight, we can also isolate the resource within the same
class.

The test process is as follows:
# prepare data disk
mount /dev/sdb /data1

# create cgroup v1 hierarchy
cd /sys/fs/cgroup/blkio
mkdir rt be idle
echo "1 0" > rt/blkio.bfq.ioprio
echo "2 0" > be/blkio.bfq.ioprio
echo "3 0" > idle/blkio.bfq.ioprio

# run fio test
fio fio.ini

# generate svg graph
fio_generate_plots res

The contents of fio.ini are as follows:
[global]
ioengine=libaio
group_reporting=1
log_avg_msec=500
direct=1
time_based=1
iodepth=16
size=100M
rw=write
bs=1M
[rt]
name=rt
write_bw_log=rt
write_lat_log=rt
write_iops_log=rt
filename=/data1/rt.bin
cgroup=rt
runtime=30s
nice=-10
[be]
name=be
new_group
write_bw_log=be
write_lat_log=be
write_iops_log=be
filename=/data1/be.bin
cgroup=be
runtime=60s
[idle]
name=idle
new_group
write_bw_log=idle
write_lat_log=idle
write_iops_log=idle
filename=/data1/idle.bin
cgroup=idle
runtime=90s

V2:
1. Optmise bfq_select_next_class().
2. Introduce bfq_group [] to track the number of groups for each CLASS.
3. Optimse IO injection, EMQ and Idle mechanism for CLASS_RT.

Chunguang Xu (11):
  bfq: introduce bfq_entity_to_bfqg helper method
  bfq: limit the IO depth of idle_class to 1
  bfq: keep the minimun bandwidth for be_class
  bfq: expire other class if CLASS_RT is waiting
  bfq: optimse IO injection for CLASS_RT
  bfq: disallow idle if CLASS_RT waiting for service
  bfq: disallow merge CLASS_RT with other class
  bfq: introduce bfq.ioprio for cgroup
  bfq: convert the type of bfq_group.bfqd to bfq_data*
  bfq: remove unnecessary initialization logic
  bfq: optimize the calculation of bfq_weight_to_ioprio()

 block/bfq-cgroup.c  |  99 +++++++++++++++++++++++++++++++----
 block/bfq-iosched.c |  47 ++++++++++++++---
 block/bfq-iosched.h |  28 ++++++++--
 block/bfq-wf2q.c    | 124 +++++++++++++++++++++++++++++++++-----------
 4 files changed, 244 insertions(+), 54 deletions(-)

-- 
2.30.0

