From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 0/7] introduce cpu.headroom knob to cpu controller
Date: Wed, 10 Apr 2019 19:43:35 +0000
Message-ID: <A2E9A149-9EAA-478D-A096-1D4D4BA442B3@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
 <20190410115907.GE19434@e105550-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9nmGSS5VRXZzKeOCMgnLGJ1C0FfBs4PrZ2TdJWWWPf0=;
 b=fCxI14puBAjvgB0tXHbj8UGkk5tI7uI8JfPImHeublgHDbjaVouC2rpVjqKGdUinjG4N
 RXhGtnz+uRotCESGPQqs4ecsp7LQPR955BqYoPzVTG+lvuMyZeMrkWjDVx4dboi6w454
 wq/0wURsdvtLuyqaYX7jcjDtwC32iHakS9M= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nmGSS5VRXZzKeOCMgnLGJ1C0FfBs4PrZ2TdJWWWPf0=;
 b=gGNSFudSYaVoO2LlINJIlN4Sx1nSAceMYqz8/ngv6W546beHDsuw0QVQJhY+dDAQZbXmQ8FJBp0zukhHv2+T5hBK/7Gx5oNhg4RAjVhBTxugrgVWHVRZYhkuZ7bN4yQw9IE0V0IudCGKEFndELc1hZ+PmsPe3i8f9ScpNEr4FVg=
In-Reply-To: <20190410115907.GE19434@e105550-lin.cambridge.arm.com>
Content-Language: en-US
Content-ID: <98126E7250EA9C438F4B34D1597C1A20@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>, "tglx@linutronix.de" <tglx@linutronix.de>, Kernel Team <Kernel-team@fb.com>

Hi Morten,

> On Apr 10, 2019, at 4:59 AM, Morten Rasmussen <morten.rasmussen@arm.com> =
wrote:
>=20
> Hi,
>=20
> On Mon, Apr 08, 2019 at 02:45:32PM -0700, Song Liu wrote:
>> Servers running latency sensitive workload usually aren't fully loaded f=
or=20
>> various reasons including disaster readiness. The machines running our=20
>> interactive workloads (referred as main workload) have a lot of spare CP=
U=20
>> cycles that we would like to use for optimistic side jobs like video=20
>> encoding. However, our experiments show that the side workload has stron=
g
>> impact on the latency of main workload:
>>=20
>>  side-job   main-load-level   main-avg-latency
>>     none          1.0              1.00
>>     none          1.1              1.10
>>     none          1.2              1.10=20
>>     none          1.3              1.10
>>     none          1.4              1.15
>>     none          1.5              1.24
>>     none          1.6              1.74
>>=20
>>     ffmpeg        1.0              1.82
>>     ffmpeg        1.1              2.74
>>=20
>> Note: both the main-load-level and the main-avg-latency numbers are
>> _normalized_.
>=20
> Could you reveal what level of utilization those main-load-level numbers
> correspond to? I'm trying to understand why the latency seems to
> increase rapidly once you hit 1.5. Is that the point where the system
> hits 100% utilization?

The load level above is measured as requests-per-second.=20

When there is no side workload, the system has about 45% busy CPU with=20
load level of 1.0; and about 75% busy CPU at load level of 1.5.=20

The saturation starts before the system hitting 100% utilization. This is
true for many different resources: ALUs in SMT systems, cache lines,=20
memory bandwidths, etc.=20

>=20
>> In these experiments, ffmpeg is put in a cgroup with cpu.weight of 1=20
>> (lowest priority). However, it consumes all idle CPU cycles in the=20
>> system and causes high latency for the main workload. Further experiment=
s
>> and analysis (more details below) shows that, for the main workload to m=
eet
>> its latency targets, it is necessary to limit the CPU usage of the side
>> workload so that there are some _idle_ CPU. There are various reasons
>> behind the need of idle CPU time. First, shared CPU resouce saturation=20
>> starts to happen way before time-measured utilization reaches 100%.=20
>> Secondly, scheduling latency starts to impact the main workload as CPU=20
>> reaches full utilization.=20
>>=20
>> Currently, the cpu controller provides two mechanisms to protect the mai=
n=20
>> workload: cpu.weight and cpu.max. However, neither of them is sufficient=
=20
>> in these use cases. As shown in the experiments above, side workload wit=
h=20
>> cpu.weight of 1 (lowest priority) would still consume all idle CPU and a=
dd=20
>> unacceptable latency to the main workload. cpu.max can throttle the CPU=
=20
>> usage of the side workload and preserve some idle CPU. However, cpu.max=
=20
>> cannot react to changes in load levels. For example, when the main=20
>> workload uses 40% of CPU, cpu.max of 30% for the side workload would yie=
ld=20
>> good latencies for the main workload. However, when the workload=20
>> experiences higher load levels and uses more CPU, the same setting (cpu.=
max=20
>> of 30%) would cause the interactive workload to miss its latency target.=
=20
>>=20
>> These experiments demonstrated the need for a mechanism to effectively=20
>> throttle CPU usage of the side workload and preserve idle CPU cycles.=20
>> The mechanism should be able to adjust the level of throttling based on
>> the load level of the main workload.=20
>>=20
>> This patchset introduces a new knob for cpu controller: cpu.headroom.=20
>> cgroup of the main workload uses cpu.headroom to ensure side workload to=
=20
>> use limited CPU cycles. For example, if a main workload has a cpu.headro=
om=20
>> of 30%. The side workload will be throttled to give 30% overall idle CPU=
.=20
>> If the main workload uses more than 70% of CPU, the side workload will o=
nly=20
>> run with configurable minimal cycles. This configurable minimal cycles i=
s
>> referred as "tolerance" of the main workload.
>=20
> IIUC, you are proposing to basically apply dynamic bandwidth throttling t=
o
> side-jobs to preserve a specific headroom of idle cycles.

This is accurate. The effect is similar to cpu.max, but more dynamic.=20

>=20
> The bit that isn't clear to me, is _why_ adding idle cycles helps your
> workload. I'm not convinced that adding headroom gives any latency
> improvements beyond watering down the impact of your side jobs. AFAIK,

We think the latency improvements actually come from watering down the=20
impact of side jobs. It is not just statistically improving average=20
latency numbers, but also reduces resource contention caused by the side
workload. I don't know whether it is from reducing contention of ALUs,=20
memory bandwidth, CPU caches, or something else, but we saw reduced=20
latencies when headroom is used.=20

> the throttling mechanism effectively removes the throttled tasks from
> the schedule according to a specific duty cycle. When the side job is
> not throttled the main workload is experiencing the same latency issues
> as before, but by dynamically tuning the side job throttling you can
> achieve a better average latency. Am I missing something?
>=20
> Have you looked at your distribution of main job latency and tried to
> compare with when throttling is active/not active?

cfs_bandwidth adjusts allowed runtime for each task_group each period=20
(configurable, 100ms by default). cpu.headroom logic applies gentle=20
throttling, so that the side workload gets some runtime in every period.=20
Therefore, if we look at time window equal to or bigger than 100ms, we
don't really see "throttling active time" vs. "throttling inactive time".=20

>=20
> I'm wondering if the headroom solution is really the right solution for
> your use-case or if what you are really after is something which is
> lower priority than just setting the weight to 1. Something that

The experiments show that, cpu.weight does proper work for priority: the=20
main workload gets priority to use the CPU; while the side workload only=20
fill the idle CPU. However, this is not sufficient, as the side workload=20
creates big enough contention to impact the main workload.=20

> (nearly) always gets pre-empted by your main job (SCHED_BATCH and
> SCHED_IDLE might not be enough). If your main job consist
> of lots of relatively short wake-ups things like the min_granularity
> could have significant latency impact.

cpu.headroom gives benefits in addition to optimizations in pre-empt
side. By maintaining some idle time, fewer pre-empt actions are=20
necessary, thus the main workload will get better latency.=20

Thanks,
Song

>=20
> Morten

