From: brookxu <brookxu.cn@gmail.com>
Subject: [RFC PATCH 0/8] bfq: introduce bfq.ioprio for cgroup
Date: Mon,  8 Mar 2021 20:00:13 +0800
Message-ID: <cover.1615203034.git.brookxu@tencent.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=R/mts98GlDutHhgzA1LEz4Tkn30xrY5SkbMfoTtOKwI=;
        b=ozGqeSDtM+WQItumTUxas1Vds2nU8frKxEEIEHXOZmKh2lsgNKNvcdDze/Rfa0Lvqg
         lcEnFEpSimHAr/Uab85hbMNFHxN4E1tVh3dxrKtETgesboEsGooNUJtxjoA4aFwLGzSN
         LBo4ehifa1YPEjj/Gl+VqND0LaAd8ck52aiD398nNHCdWuXpIJ5k7ecyBEUiODz2wE41
         wIAo3JtEI63O+1eebruaN2UGgYaVKDkenND/FWVEeksFQwVGAeQEcnpHDj07poMrzF4H
         EooZQ+45nn17MLGGI3NeLKLfS+PRppswwud1ePUQKH5BMaH+tiIi71tC/NMyCIZ+eYsG
         4Iyg==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

Tasks in the production environment can be roughly divided into
three categories: emergency tasks, ordinary tasks and offline
tasks. Emergency tasks need to be scheduled in real time, and the
amount of data for such tasks is usually not very large, such as
system agents. Offline tasks do not need to guarantee QoS, but
can improve system resource utilization during system idle
periods, such as various background tasks. The above requirements
need to achieve IO preemption. At present, we can use weights to
simulate IO preemption, but since weights are more of a shared
concept, they cannot be simulated well. For example, the weights
of emergency tasks and ordinary tasks cannot be determined well,
offline tasks (with the same weight) actually occupy different
resources on disks with different performance, and the tail delay
caused by offline tasks cannot be well controlled. Using ioprio's
concept of preemption, we can solve the above problems very well.
Second, we can still use weights to control resource isolation of
the same priority, thereby achieving better IO Qos control.

However, currently implemented by bfq, the class of bfq_group is
always be class, and the ioprio class of the task can only be
reflected in a single cgroup. We cannot guarantee that real-time
tasks in a cgroup are scheduled in time. To this end, we
introduced cgroup ioprio. In this way, we can ensure that the
real-time tasks of a cgroup can be scheduled in time. Similarly,
the processing of offline task groups can also be simpler.

To this end, we have introduced the bfq.ioprio interface for
cgroup v1 and cgroup v2. Users can configure the priority
through this interface, as shown below:

echo "1 2"> blkio.bfq.weight

The above two values respectively represent the values of ioprio
class and ioprio for cgroup. The ioprio of tasks within the cgroup
is uniformly equal to the ioprio of the cgroup. If the ioprio of
the cgroup is disabled, the ioprio of the task remains the same,
usually from io_context.

When testing, using fio and fio_generate_plots we can clearly see
that the IO delay of the task satisfies RT> BE> IDLE. When RT is
running, BE and IDLE are guaranteed minimum bandwidth. When used
with bfq.weight, we can also isolate the weight within the same
class.

The last three patches are irrelevant to the cgroup ioprio,
they are brought together here for the convenience of patch
management.

Chunguang Xu (8):
  bfq: introduce bfq_entity_to_bfqg helper method
  bfq: limit the IO depth of idle_class to 1
  bfq: keep the minimun bandwidth for be_class
  bfq: expire bfqq if a higher priority class is waiting
  bfq: introduce bfq.ioprio for cgroup
  bfq: convert the type of bfq_group.bfqd to bfq_data*
  bfq: remove unnecessary initialization logic
  bfq: optimize the calculation of bfq_weight_to_ioprio()

 block/bfq-cgroup.c  |  99 +++++++++++++++++++++++++++++++++++++-----
 block/bfq-iosched.c |  32 +++++++++++++-
 block/bfq-iosched.h |  20 ++++++---
 block/bfq-wf2q.c    | 103 +++++++++++++++++++++++++++++++-------------
 4 files changed, 207 insertions(+), 47 deletions(-)

-- 
2.30.0

