From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 0/7] introduce cpu.headroom knob to cpu controller
Date: Mon, 22 Apr 2019 23:22:21 +0000
Message-ID: <E97E73F4-CE8C-4CD7-B6B6-5F63A4E881B1@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
 <20190410115907.GE19434@e105550-lin.cambridge.arm.com>
 <A2E9A149-9EAA-478D-A096-1D4D4BA442B3@fb.com>
 <CAKfTPtAFB3gSZYJN1BcjU_XoY=Pfu2xtea+2MEw7FkVc3mwTSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2CeFzKtjISHNTJ/GhmGMb7VMMUY0rdl1YKbLZO0t+Js=;
 b=N2YJNoreyA6Oe3YUYV1tuIU3K2H0yI/ohY5XC6g8Q9EpjDZo5Aa6vxuW/KwFk7YDfzya
 y02+4LBAy2DxzAXuPX137osMp5J7LH1zoT6wBYRrcIz8SCQK2pXEgVKK+8/ooyqxeoNj
 7kCnF+Sz8SX7QgJUamJbrZjYDtmVqqTlehw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CeFzKtjISHNTJ/GhmGMb7VMMUY0rdl1YKbLZO0t+Js=;
 b=ZPWylkRRKeVTgSHE3O7VXrrM3wecNHiYgYNXTO4rPiB80DDI/vsG6ayK/5c9LUvhSUI2aHb+GMZ0gsg5o0vuMFIYLRJ6Zyg65EbGw5m6E8rCJg2gnovPzdWYeMDi5NzL/QX2/9gfE0vS5RWwPEEddncmzKpHBj7QyzVaLunWwFw=
In-Reply-To: <CAKfTPtAFB3gSZYJN1BcjU_XoY=Pfu2xtea+2MEw7FkVc3mwTSA@mail.gmail.com>
Content-Language: en-US
Content-ID: <EF24496EEDBE124C9CEFF658E8571CDA@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>, Kernel Team <Kernel-team@fb.com>

Hi Vincent,

> On Apr 17, 2019, at 5:56 AM, Vincent Guittot <vincent.guittot@linaro.org>=
 wrote:
>=20
> On Wed, 10 Apr 2019 at 21:43, Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Hi Morten,
>>=20
>>> On Apr 10, 2019, at 4:59 AM, Morten Rasmussen <morten.rasmussen@arm.com=
> wrote:
>>>=20
>=20
>>>=20
>>> The bit that isn't clear to me, is _why_ adding idle cycles helps your
>>> workload. I'm not convinced that adding headroom gives any latency
>>> improvements beyond watering down the impact of your side jobs. AFAIK,
>>=20
>> We think the latency improvements actually come from watering down the
>> impact of side jobs. It is not just statistically improving average
>> latency numbers, but also reduces resource contention caused by the side
>> workload. I don't know whether it is from reducing contention of ALUs,
>> memory bandwidth, CPU caches, or something else, but we saw reduced
>> latencies when headroom is used.
>>=20
>>> the throttling mechanism effectively removes the throttled tasks from
>>> the schedule according to a specific duty cycle. When the side job is
>>> not throttled the main workload is experiencing the same latency issues
>>> as before, but by dynamically tuning the side job throttling you can
>>> achieve a better average latency. Am I missing something?
>>>=20
>>> Have you looked at your distribution of main job latency and tried to
>>> compare with when throttling is active/not active?
>>=20
>> cfs_bandwidth adjusts allowed runtime for each task_group each period
>> (configurable, 100ms by default). cpu.headroom logic applies gentle
>> throttling, so that the side workload gets some runtime in every period.
>> Therefore, if we look at time window equal to or bigger than 100ms, we
>> don't really see "throttling active time" vs. "throttling inactive time"=
.
>>=20
>>>=20
>>> I'm wondering if the headroom solution is really the right solution for
>>> your use-case or if what you are really after is something which is
>>> lower priority than just setting the weight to 1. Something that
>>=20
>> The experiments show that, cpu.weight does proper work for priority: the
>> main workload gets priority to use the CPU; while the side workload only
>> fill the idle CPU. However, this is not sufficient, as the side workload
>> creates big enough contention to impact the main workload.
>>=20
>>> (nearly) always gets pre-empted by your main job (SCHED_BATCH and
>>> SCHED_IDLE might not be enough). If your main job consist
>>> of lots of relatively short wake-ups things like the min_granularity
>>> could have significant latency impact.
>>=20
>> cpu.headroom gives benefits in addition to optimizations in pre-empt
>> side. By maintaining some idle time, fewer pre-empt actions are
>> necessary, thus the main workload will get better latency.
>=20
> I agree with Morten's proposal, SCHED_IDLE should help your latency
> problem because side job will be directly preempted unlike normal cfs
> task even lowest priority.
> In addition to min_granularity, sched_period also has an impact on the
> time that a task has to wait before preempting the running task. Also,
> some sched_feature like GENTLE_FAIR_SLEEPERS can also impact the
> latency of a task.
>=20
> It would be nice to know if the latency problem comes from contention
> on cache resources or if it's mainly because you main load waits
> before running on a CPU
>=20
> Regards,
> Vincent

Thanks for these suggestions. Here are some more tests to show the impact=20
of scheduler knobs and cpu.headroom.

side-load | cpu.headroom | side/cpu.weight | min_gran | cpu-idle | main/lat=
ency
---------------------------------------------------------------------------=
-----
  none    |      0       |     n/a         |    1 ms  |  45.20%  |   1.00
 ffmpeg   |      0       |      1          |   10 ms  |   3.38%  |   1.46
 ffmpeg   |      0       |   SCHED_IDLE    |    1 ms  |   5.69%  |   1.42
 ffmpeg   |    20%       |   SCHED_IDLE    |    1 ms  |  19.00%  |   1.13
 ffmpeg   |    30%       |   SCHED_IDLE    |    1 ms  |  27.60%  |   1.08

In all these cases, the main workload is loaded with same level of=20
traffic (request per second). Main workload latency numbers are normalized=
=20
based on the baseline (first row).=20

For the baseline, the main workload runs without any side workload, the=20
system has about 45.20% idle CPU.=20

The next two rows compare the impact of scheduling knobs cpu.weight and=20
sched_min_granularity. With cpu.weight of 1 and min_granularity of 10ms,=20
we see a latency of 1.46; with SCHED_IDLE and min_granularity of 1ms, we=20
see a latency of 1.42. So SCHED_IDLE and min_granularity help protecting=20
the main workload. However, it is not sufficient, as the latency overhead=20
is high (>40%).=20

The last two rows show the benefit of cpu.headroom. With 20% headroom,=20
the latency is 1.13; while with 30% headroom, the latency is 1.08.=20

We can also see a clear correlation between latency and global idle CPU:=20
more idle CPU yields better lower latency.=20

Over all, these results show that cpu.headroom provides effective=20
mechanism to control the latency impact of side workloads. Other knobs=20
could also help the latency, but they are not as effective and flexible=20
as cpu.headroom.=20

Does this analysis address your concern?=20

Thanks,
Song

>=20
>>=20
>> Thanks,
>> Song
>>=20
>>>=20
>>> Morten
>>=20

