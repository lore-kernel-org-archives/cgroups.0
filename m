From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 0/7] introduce cpu.headroom knob to cpu controller
Date: Mon, 15 Apr 2019 16:48:49 +0000
Message-ID: <2A377F4D-8A84-4D90-9C59-48B865EB34D1@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=TEHzZEZdrC/d6Tz1Tbgw+1V5dE4hw4LpftnJuRBmkIk=;
 b=lKiG0NU7AuW8j5d9CbQnIdh6q/xCFGANTsZBbtH4YLENqLbbay2H21q86xfSdv0H5298
 OopqPUMmfBMgE+Y5rX+NQDliMb8fp8/uLIjG4e0WEu1i+wUXjJJaB7G6PVgxQPb0PzJe
 OfLxCRLy8U5pIQynvnx/ZuoY3tSR0TfKDgU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEHzZEZdrC/d6Tz1Tbgw+1V5dE4hw4LpftnJuRBmkIk=;
 b=iaQh6zZTAg6UtBTRAjBuRwznQrkN+Omt+83Y9bzYViZezciqaoQdNMVqt+Xw1SQW+okUsrQylXbtEddKB+y1p/Y2jNzsmUoZkrz9ZMwL3Yj0eu/3K1VrrDDTnTnE3q7w2pm3VPH06OoSVfRE+8wcn+VRgyY/hnjSyXEvTLJnU4Q=
In-Reply-To: <20190408214539.2705660-1-songliubraving@fb.com>
Content-Language: en-US
Content-ID: <DA114A4AFB606A44AAE4F9B2F011544F@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Morten Rasmussen <morten.rasmussen@arm.com>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Peter,

> On Apr 8, 2019, at 2:45 PM, Song Liu <songliubraving@fb.com> wrote:
>=20
> Servers running latency sensitive workload usually aren't fully loaded fo=
r=20
> various reasons including disaster readiness. The machines running our=20
> interactive workloads (referred as main workload) have a lot of spare CPU=
=20
> cycles that we would like to use for optimistic side jobs like video=20
> encoding. However, our experiments show that the side workload has strong
> impact on the latency of main workload:
>=20
>  side-job   main-load-level   main-avg-latency
>     none          1.0              1.00
>     none          1.1              1.10
>     none          1.2              1.10=20
>     none          1.3              1.10
>     none          1.4              1.15
>     none          1.5              1.24
>     none          1.6              1.74
>=20
>     ffmpeg        1.0              1.82
>     ffmpeg        1.1              2.74
>=20
> Note: both the main-load-level and the main-avg-latency numbers are
> _normalized_.
>=20
> In these experiments, ffmpeg is put in a cgroup with cpu.weight of 1=20
> (lowest priority). However, it consumes all idle CPU cycles in the=20
> system and causes high latency for the main workload. Further experiments
> and analysis (more details below) shows that, for the main workload to me=
et
> its latency targets, it is necessary to limit the CPU usage of the side
> workload so that there are some _idle_ CPU. There are various reasons
> behind the need of idle CPU time. First, shared CPU resouce saturation=20
> starts to happen way before time-measured utilization reaches 100%.=20
> Secondly, scheduling latency starts to impact the main workload as CPU=20
> reaches full utilization.=20
>=20
> Currently, the cpu controller provides two mechanisms to protect the main=
=20
> workload: cpu.weight and cpu.max. However, neither of them is sufficient=
=20
> in these use cases. As shown in the experiments above, side workload with=
=20
> cpu.weight of 1 (lowest priority) would still consume all idle CPU and ad=
d=20
> unacceptable latency to the main workload. cpu.max can throttle the CPU=20
> usage of the side workload and preserve some idle CPU. However, cpu.max=20
> cannot react to changes in load levels. For example, when the main=20
> workload uses 40% of CPU, cpu.max of 30% for the side workload would yiel=
d=20
> good latencies for the main workload. However, when the workload=20
> experiences higher load levels and uses more CPU, the same setting (cpu.m=
ax=20
> of 30%) would cause the interactive workload to miss its latency target.=
=20
>=20
> These experiments demonstrated the need for a mechanism to effectively=20
> throttle CPU usage of the side workload and preserve idle CPU cycles.=20
> The mechanism should be able to adjust the level of throttling based on
> the load level of the main workload.=20
>=20
> This patchset introduces a new knob for cpu controller: cpu.headroom.=20
> cgroup of the main workload uses cpu.headroom to ensure side workload to=
=20
> use limited CPU cycles. For example, if a main workload has a cpu.headroo=
m=20
> of 30%. The side workload will be throttled to give 30% overall idle CPU.=
=20
> If the main workload uses more than 70% of CPU, the side workload will on=
ly=20
> run with configurable minimal cycles. This configurable minimal cycles is
> referred as "tolerance" of the main workload.=20
>=20
> The following is a detailed example:
>=20
> main/cpu.headroom    main-cpu-load    low-pri-cpu-cycle   idle-cpu
>      30%                 30%                40%              30%
>      30%                 40%                30%              30%
>      30%                 50%                20%              30%
>      30%                 60%                10%              30%
>      30%                 70%                minimal          ~30%
>      30%                 80%                minimal          ~20%
>=20
> In the example, we use a constant cpu.headroom setting of 30%. As main jo=
b
> experiences different level of load, the cpu controller adjusts CPU cycle=
s
> used by the low-pri jobs.
>=20
> We experiemented with a web server as the main workload and ffmpeg as the=
=20
> side workload. The following table compares latency impact on the main=20
> workload under different cpu.headroom settings and load levels. In all=20
> tests, the side workload cgroup is configured with cpu.weight of 1. When=
=20
> throttled, the side workload can only run 1ms per 100ms period.
>=20
>                               average-latency
> main-load-level   w/o-side    w/-side-      w/-side-       w/-side-
>                            no-headroom   30%-headroom   20%-headroom
>     1.0            1.00       1.82          1.26           1.14          =
           =20
>     1.1            1.10       2.74          1.26           1.32          =
           =20
>     1.2            1.10                     1.29           1.38          =
           =20
>     1.3            1.10                     1.32           1.49          =
           =20
>     1.4            1.15                     1.29           1.85          =
           =20
>     1.5            1.24                     1.32                         =
      =20
>     1.6            1.74                     1.50                         =
    =20
>=20
> Each row of the table shows a normalized load level and average latencies=
=20
> for 4 scenarios: w/o side workload, w/ side workload but no headroom; w/=
=20
> side workload and 30% headroom; with side workload and 20% headroom.=20
>=20
>=20
> When there is no side workload, average latency of main job falls in the=
=20
> 0.7x range, except the very high load scenarios. When there is side=20
> workload but no headroom, latency of the main job goes very high at=20
> moderate load levels. With 30% headroom, the average latency falls in the=
=20
> 0.8x range. With 20% headroom, the average latency falls in the 0.9x to=20
> 1.x range. We didn't finish tests in some cases with high load, because=20
> the latency is too high.=20
>=20
> This experiment demonstrated cpu.headroom is an effective and efficient
> knob to control the latency of the main job.
>=20
> Thanks!

Could you please kindly share your feedback and comments on this work?

Thanks and Regards,
Song

> Song Liu (7):
>  sched: refactor tg_set_cfs_bandwidth()
>  cgroup: introduce hook css_has_tasks_changed
>  cgroup: introduce cgroup_parse_percentage
>  sched, cgroup: add entry cpu.headroom
>  sched/fair: global idleness counter for cpu.headroom
>  sched/fair: throttle task runtime based on cpu.headroom
>  Documentation: cgroup-v2: add information for cpu.headroom
>=20
> Documentation/admin-guide/cgroup-v2.rst |  18 +
> fs/proc/stat.c                          |   4 +-
> include/linux/cgroup-defs.h             |   2 +
> include/linux/cgroup.h                  |   1 +
> include/linux/kernel_stat.h             |   2 +
> kernel/cgroup/cgroup.c                  |  51 +++
> kernel/sched/core.c                     | 425 ++++++++++++++++++++++--
> kernel/sched/fair.c                     | 143 +++++++-
> kernel/sched/sched.h                    |  30 ++
> 9 files changed, 634 insertions(+), 42 deletions(-)
>=20
> --=20
> 2.17.1
>=20

