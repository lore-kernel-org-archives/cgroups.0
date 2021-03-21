From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [RFC PATCH v2 00/11] bfq: introduce bfq.ioprio for cgroup
Date: Sun, 21 Mar 2021 12:04:53 +0100
Message-ID: <F64D5CC8-E650-4AE6-8452-7FA0C1976271@linaro.org>
References: <cover.1615517202.git.brookxu@tencent.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8pbSHoOc4fdbEmSmiSG1Rc1zJ6Vo+wX1h1aVlPgdpxQ=;
        b=TFrOc3y6fE6WVMQzcw5ZSat+UP1VZf4xVGkAH9McSR/CRL8zo/CbAx1Phy681QQ3xZ
         IX0JgOzzYmM1oAvOawijWUnf0NW4iVNcZtcBtOCQfIsIFCpOfNomPF6RB7VDT9zLHrBq
         EMd7qkmVGhEXIK0vTetvTuuVv8TI6cYtiMQo7TxDBlE8hfEeC7JZu+HMu/2ChVsf7D90
         nl7grNbHuz5JPSDXrjFrztfwIYB/+51dNzl4tqczsrjvnzs8fpKRNJYpG5z1kZY7x6Ue
         cBv4KoTgqFrXI9dGb1vNrvdV2HiuPCSL9nCpdyyHkAJ/Cjmv5GUHyDW1Q3XuKh7HKc7d
         yZYA==
In-Reply-To: <cover.1615517202.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: brookxu <brookxu.cn@gmail.com>
Cc: axboe@kernel.dk, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org



> Il giorno 12 mar 2021, alle ore 12:08, brookxu <brookxu.cn@gmail.com> =
ha scritto:
>=20
> From: Chunguang Xu <brookxu@tencent.com>
>=20

Hi Chunguang,

> Tasks in the production environment can be roughly divided into
> three categories: emergency tasks, ordinary tasks and offline
> tasks. Emergency tasks need to be scheduled in real time, such
> as system agents. Offline tasks do not need to guarantee QoS,
> but can improve system resource utilization during system idle
> periods, such as background tasks. The above requirements need
> to achieve IO preemption. At present, we can use weights to
> simulate IO preemption, but since weights are more of a shared
> concept, they cannot be simulated well. For example, the weights
> of emergency tasks and ordinary tasks cannot be determined well,
> offline tasks (with the same weight) actually occupy different
> resources on disks with different performance, and the tail
> latency caused by offline tasks cannot be well controlled. Using
> ioprio's concept of preemption, we can solve the above problems
> very well. Since ioprio will eventually be converted to weight,
> using ioprio alone can also achieve weight isolation within the
> same class. But we can still use bfq.weight to control resource,
> achieving better IO Qos control.
>=20
> However, currently the class of bfq_group is always be class, and
> the ioprio class of the task can only be reflected in a single
> cgroup. We cannot guarantee that real-time tasks in a cgroup are
> scheduled in time. Therefore, we introduce bfq.ioprio, which
> allows us to configure ioprio class for cgroup. In this way, we
> can ensure that the real-time tasks of a cgroup can be scheduled
> in time. Similarly, the processing of offline task groups can
> also be simpler.
>=20

I find this contribution very interesting.  Anyway, given the
relevance of such a contribution, I'd like to hear from relevant
people (Jens, Tejun, ...?), before revising individual patches.

Yet I already have a general question.  How does this mechanism comply
with per-process ioprios and ioprio classes?  For example, what
happens if a process belongs to BE-class group according to your
mechanism, but to a RT class according to its ioprio?  Does the
pre-group class dominate the per-process class?  Is all clean and
predictable?

> The bfq.ioprio interface now is available for cgroup v1 and cgroup
> v2. Users can configure the ioprio for cgroup through this interface,
> as shown below:
>=20
> echo "1 2"> blkio.bfq.ioprio

Wouldn't it be nicer to have acronyms for classes (RT, BE, IDLE),
instead of numbers?

Thank you very much for this improvement proposal,
Paolo

>=20
> The above two values respectively represent the values of ioprio
> class and ioprio for cgroup. The ioprio of tasks within the cgroup
> is uniformly equal to the ioprio of the cgroup. If the ioprio of
> the cgroup is disabled, the ioprio of the task remains the same,
> usually from io_context.
>=20
> When testing, using fio and fio_generate_plots we can clearly see
> that the IO delay of the task satisfies RT> BE> IDLE. When RT is
> running, BE and IDLE are guaranteed minimum bandwidth. When used
> with bfq.weight, we can also isolate the resource within the same
> class.
>=20
> The test process is as follows:
> # prepare data disk
> mount /dev/sdb /data1
>=20
> # create cgroup v1 hierarchy
> cd /sys/fs/cgroup/blkio
> mkdir rt be idle
> echo "1 0" > rt/blkio.bfq.ioprio
> echo "2 0" > be/blkio.bfq.ioprio
> echo "3 0" > idle/blkio.bfq.ioprio
>=20
> # run fio test
> fio fio.ini
>=20
> # generate svg graph
> fio_generate_plots res
>=20
> The contents of fio.ini are as follows:
> [global]
> ioengine=3Dlibaio
> group_reporting=3D1
> log_avg_msec=3D500
> direct=3D1
> time_based=3D1
> iodepth=3D16
> size=3D100M
> rw=3Dwrite
> bs=3D1M
> [rt]
> name=3Drt
> write_bw_log=3Drt
> write_lat_log=3Drt
> write_iops_log=3Drt
> filename=3D/data1/rt.bin
> cgroup=3Drt
> runtime=3D30s
> nice=3D-10
> [be]
> name=3Dbe
> new_group
> write_bw_log=3Dbe
> write_lat_log=3Dbe
> write_iops_log=3Dbe
> filename=3D/data1/be.bin
> cgroup=3Dbe
> runtime=3D60s
> [idle]
> name=3Didle
> new_group
> write_bw_log=3Didle
> write_lat_log=3Didle
> write_iops_log=3Didle
> filename=3D/data1/idle.bin
> cgroup=3Didle
> runtime=3D90s
>=20
> V2:
> 1. Optmise bfq_select_next_class().
> 2. Introduce bfq_group [] to track the number of groups for each =
CLASS.
> 3. Optimse IO injection, EMQ and Idle mechanism for CLASS_RT.
>=20
> Chunguang Xu (11):
>  bfq: introduce bfq_entity_to_bfqg helper method
>  bfq: limit the IO depth of idle_class to 1
>  bfq: keep the minimun bandwidth for be_class
>  bfq: expire other class if CLASS_RT is waiting
>  bfq: optimse IO injection for CLASS_RT
>  bfq: disallow idle if CLASS_RT waiting for service
>  bfq: disallow merge CLASS_RT with other class
>  bfq: introduce bfq.ioprio for cgroup
>  bfq: convert the type of bfq_group.bfqd to bfq_data*
>  bfq: remove unnecessary initialization logic
>  bfq: optimize the calculation of bfq_weight_to_ioprio()
>=20
> block/bfq-cgroup.c  |  99 +++++++++++++++++++++++++++++++----
> block/bfq-iosched.c |  47 ++++++++++++++---
> block/bfq-iosched.h |  28 ++++++++--
> block/bfq-wf2q.c    | 124 +++++++++++++++++++++++++++++++++-----------
> 4 files changed, 244 insertions(+), 54 deletions(-)
>=20
> --=20
> 2.30.0
>=20

