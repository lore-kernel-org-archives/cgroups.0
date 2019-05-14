From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 0/7] introduce cpu.headroom knob to cpu controller
Date: Tue, 14 May 2019 20:58:31 +0000
Message-ID: <0C1325C9-DE18-42C6-854D-64433ABD6FC3@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
 <20190410115907.GE19434@e105550-lin.cambridge.arm.com>
 <A2E9A149-9EAA-478D-A096-1D4D4BA442B3@fb.com>
 <CAKfTPtAFB3gSZYJN1BcjU_XoY=Pfu2xtea+2MEw7FkVc3mwTSA@mail.gmail.com>
 <E97E73F4-CE8C-4CD7-B6B6-5F63A4E881B1@fb.com>
 <F0A127DD-F9B6-4FBE-B9AD-8E8B00A7D676@fb.com>
 <CAKfTPtA_ouYCes9LnYn0quAKm273mi3vP-++GTBtYcQn07xc6Q@mail.gmail.com>
 <A62E5068-4A1E-44E3-99BB-02E98229C1E2@fb.com>
 <CAKfTPtAG3v=37wyLjzkNNK_6HdoMK6WO7AMYfa+G24rq2iyAfg@mail.gmail.com>
 <19AF6556-A2A2-435B-9358-CD22CF7BFD9F@fb.com>
 <2E7A1CDA-0384-474E-9011-5B209A1A58DF@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vGfxxx7ynQxiHzJwgifK140qhBCPYAw4G3XpHKPfuTU=;
 b=gmfws8zX0OboxV6w+zsUQdMFVnthlKoHoYpsXXvwFRcOAbPDBheLCR2bt+LkApe1FIE/
 c9sAYAuxXbKsElzQQ5/AwaCBNhjb9PZvBwnkCy5zu74Z+tDq7/ATlVXB/CdY0ls0BXZw
 19nyQ9S/NvRQMSGt4ACWyF7LFx/RNZ+UahE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGfxxx7ynQxiHzJwgifK140qhBCPYAw4G3XpHKPfuTU=;
 b=X8MepOHB3lgUXq+mSwr0tJmfKc/kt0a4xeuMLjqN/R8LmlgpeaVfAk3WXbgdRlQ4CPrCQDto9NHKwQmtHU8F33zgyAd1gVcMo3TF8IElKwlLPPST52UnDLZnDOJUvaYm9lb1h6iYPHTtWKkGiH0aFY1CjoB6G5gxx5voSRJrau0=
In-Reply-To: <2E7A1CDA-0384-474E-9011-5B209A1A58DF@fb.com>
Content-Language: en-US
Content-ID: <F99F34678C1BC34EA4410EB9C4CE875C@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>, Kernel Team <Kernel-team@fb.com>, viresh kumar <viresh.kumar@linaro.org>

Hi Vincent,

> On May 10, 2019, at 11:22 AM, Song Liu <songliubraving@fb.com> wrote:
>=20
>=20
>=20
>> On Apr 30, 2019, at 9:54 AM, Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Apr 30, 2019, at 12:20 PM, Vincent Guittot <vincent.guittot@linaro.o=
rg> wrote:
>>>=20
>>> Hi Song,
>>>=20
>>> On Tue, 30 Apr 2019 at 08:11, Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Apr 29, 2019, at 8:24 AM, Vincent Guittot <vincent.guittot@linaro.=
org> wrote:
>>>>>=20
>>>>> Hi Song,
>>>>>=20
>>>>> On Sun, 28 Apr 2019 at 21:47, Song Liu <songliubraving@fb.com> wrote:
>>>>>>=20
>>>>>> Hi Morten and Vincent,
>>>>>>=20
>>>>>>> On Apr 22, 2019, at 6:22 PM, Song Liu <songliubraving@fb.com> wrote=
:
>>>>>>>=20
>>>>>>> Hi Vincent,
>>>>>>>=20
>>>>>>>> On Apr 17, 2019, at 5:56 AM, Vincent Guittot <vincent.guittot@lina=
ro.org> wrote:
>>>>>>>>=20
>>>>>>>> On Wed, 10 Apr 2019 at 21:43, Song Liu <songliubraving@fb.com> wro=
te:
>>>>>>>>>=20
>>>>>>>>> Hi Morten,
>>>>>>>>>=20
>>>>>>>>>> On Apr 10, 2019, at 4:59 AM, Morten Rasmussen <morten.rasmussen@=
arm.com> wrote:
>>>>>>>>>>=20
>>>>>>>>=20
>>>>>>>>>>=20
>>>>>>>>>> The bit that isn't clear to me, is _why_ adding idle cycles help=
s your
>>>>>>>>>> workload. I'm not convinced that adding headroom gives any laten=
cy
>>>>>>>>>> improvements beyond watering down the impact of your side jobs. =
AFAIK,
>>>>>>>>>=20
>>>>>>>>> We think the latency improvements actually come from watering dow=
n the
>>>>>>>>> impact of side jobs. It is not just statistically improving avera=
ge
>>>>>>>>> latency numbers, but also reduces resource contention caused by t=
he side
>>>>>>>>> workload. I don't know whether it is from reducing contention of =
ALUs,
>>>>>>>>> memory bandwidth, CPU caches, or something else, but we saw reduc=
ed
>>>>>>>>> latencies when headroom is used.
>>>>>>>>>=20
>>>>>>>>>> the throttling mechanism effectively removes the throttled tasks=
 from
>>>>>>>>>> the schedule according to a specific duty cycle. When the side j=
ob is
>>>>>>>>>> not throttled the main workload is experiencing the same latency=
 issues
>>>>>>>>>> as before, but by dynamically tuning the side job throttling you=
 can
>>>>>>>>>> achieve a better average latency. Am I missing something?
>>>>>>>>>>=20
>>>>>>>>>> Have you looked at your distribution of main job latency and tri=
ed to
>>>>>>>>>> compare with when throttling is active/not active?
>>>>>>>>>=20
>>>>>>>>> cfs_bandwidth adjusts allowed runtime for each task_group each pe=
riod
>>>>>>>>> (configurable, 100ms by default). cpu.headroom logic applies gent=
le
>>>>>>>>> throttling, so that the side workload gets some runtime in every =
period.
>>>>>>>>> Therefore, if we look at time window equal to or bigger than 100m=
s, we
>>>>>>>>> don't really see "throttling active time" vs. "throttling inactiv=
e time".
>>>>>>>>>=20
>>>>>>>>>>=20
>>>>>>>>>> I'm wondering if the headroom solution is really the right solut=
ion for
>>>>>>>>>> your use-case or if what you are really after is something which=
 is
>>>>>>>>>> lower priority than just setting the weight to 1. Something that
>>>>>>>>>=20
>>>>>>>>> The experiments show that, cpu.weight does proper work for priori=
ty: the
>>>>>>>>> main workload gets priority to use the CPU; while the side worklo=
ad only
>>>>>>>>> fill the idle CPU. However, this is not sufficient, as the side w=
orkload
>>>>>>>>> creates big enough contention to impact the main workload.
>>>>>>>>>=20
>>>>>>>>>> (nearly) always gets pre-empted by your main job (SCHED_BATCH an=
d
>>>>>>>>>> SCHED_IDLE might not be enough). If your main job consist
>>>>>>>>>> of lots of relatively short wake-ups things like the min_granula=
rity
>>>>>>>>>> could have significant latency impact.
>>>>>>>>>=20
>>>>>>>>> cpu.headroom gives benefits in addition to optimizations in pre-e=
mpt
>>>>>>>>> side. By maintaining some idle time, fewer pre-empt actions are
>>>>>>>>> necessary, thus the main workload will get better latency.
>>>>>>>>=20
>>>>>>>> I agree with Morten's proposal, SCHED_IDLE should help your latenc=
y
>>>>>>>> problem because side job will be directly preempted unlike normal =
cfs
>>>>>>>> task even lowest priority.
>>>>>>>> In addition to min_granularity, sched_period also has an impact on=
 the
>>>>>>>> time that a task has to wait before preempting the running task. A=
lso,
>>>>>>>> some sched_feature like GENTLE_FAIR_SLEEPERS can also impact the
>>>>>>>> latency of a task.
>>>>>>>>=20
>>>>>>>> It would be nice to know if the latency problem comes from content=
ion
>>>>>>>> on cache resources or if it's mainly because you main load waits
>>>>>>>> before running on a CPU
>>>>>>>>=20
>>>>>>>> Regards,
>>>>>>>> Vincent
>>>>>>>=20
>>>>>>> Thanks for these suggestions. Here are some more tests to show the =
impact
>>>>>>> of scheduler knobs and cpu.headroom.
>>>>>>>=20
>>>>>>> side-load | cpu.headroom | side/cpu.weight | min_gran | cpu-idle | =
main/latency
>>>>>>> -------------------------------------------------------------------=
-------------
>>>>>>> none    |      0       |     n/a         |    1 ms  |  45.20%  |   =
1.00
>>>>>>> ffmpeg   |      0       |      1          |   10 ms  |   3.38%  |  =
 1.46
>>>>>>> ffmpeg   |      0       |   SCHED_IDLE    |    1 ms  |   5.69%  |  =
 1.42
>>>>>>> ffmpeg   |    20%       |   SCHED_IDLE    |    1 ms  |  19.00%  |  =
 1.13
>>>>>>> ffmpeg   |    30%       |   SCHED_IDLE    |    1 ms  |  27.60%  |  =
 1.08
>>>>>>>=20
>>>>>>> In all these cases, the main workload is loaded with same level of
>>>>>>> traffic (request per second). Main workload latency numbers are nor=
malized
>>>>>>> based on the baseline (first row).
>>>>>>>=20
>>>>>>> For the baseline, the main workload runs without any side workload,=
 the
>>>>>>> system has about 45.20% idle CPU.
>>>>>>>=20
>>>>>>> The next two rows compare the impact of scheduling knobs cpu.weight=
 and
>>>>>>> sched_min_granularity. With cpu.weight of 1 and min_granularity of =
10ms,
>>>>>>> we see a latency of 1.46; with SCHED_IDLE and min_granularity of 1m=
s, we
>>>>>>> see a latency of 1.42. So SCHED_IDLE and min_granularity help prote=
cting
>>>>>>> the main workload. However, it is not sufficient, as the latency ov=
erhead
>>>>>>> is high (>40%).
>>>>>>>=20
>>>>>>> The last two rows show the benefit of cpu.headroom. With 20% headro=
om,
>>>>>>> the latency is 1.13; while with 30% headroom, the latency is 1.08.
>>>>>>>=20
>>>>>>> We can also see a clear correlation between latency and global idle=
 CPU:
>>>>>>> more idle CPU yields better lower latency.
>>>>>>>=20
>>>>>>> Over all, these results show that cpu.headroom provides effective
>>>>>>> mechanism to control the latency impact of side workloads. Other kn=
obs
>>>>>>> could also help the latency, but they are not as effective and flex=
ible
>>>>>>> as cpu.headroom.
>>>>>>>=20
>>>>>>> Does this analysis address your concern?
>>>>>=20
>>>>> So, you results show that sched_idle class doesn't provide the
>>>>> intended behavior because it still delay the scheduling of sched_othe=
r
>>>>> tasks. In fact, the wakeup path of the scheduler doesn't make any
>>>>> difference between a cpu running a sched_other and a cpu running a
>>>>> sched_idle when looking for the idlest cpu and it can create some
>>>>> contentions between sched_other tasks whereas a cpu runs sched_idle
>>>>> task.
>>>>=20
>>>> I don't think scheduling delay is the only (or dominating) factor of
>>>> extra latency. Here are some data to show it.
>>>>=20
>>>> I measured IPC (instructions per cycle) of the main workload under
>>>> different scenarios:
>>>>=20
>>>> side-load | cpu.headroom | side/cpu.weight  | IPC
>>>> ----------------------------------------------------
>>>> none     |     0%       |       N/A        | 0.66
>>>> ffmpeg   |     0%       |    SCHED_IDLE    | 0.53
>>>> ffmpeg   |    20%       |    SCHED_IDLE    | 0.58
>>>> ffmpeg   |    30%       |    SCHED_IDLE    | 0.62
>>>>=20
>>>> These data show that the side workload has a negative impact on the
>>>> main workload's IPC. And cpu.headroom could help reduce this impact.
>>>>=20
>>>> Therefore, while optimizations in the wakeup path should help the
>>>> latency; cpu.headroom would add _significant_ benefit on top of that.
>>>=20
>>> It seems normal that side workload has a negative impact on IPC
>>> because of resources sharing but your previous results showed a 42%
>>> regression of latency with sched_idle which is can't be only linked to
>>> resources access contention
>>=20
>> Agreed. I think both scheduling latency and resource contention=20
>> contribute noticeable latency overhead to the main workload. The=20
>> scheduler optimization by Viresh would help reduce the scheduling
>> latency, but it won't help the resource contention. Hopefully, with=20
>> optimizations in the scheduler, we can meet the latency target with=20
>> smaller cpu.headroom. However, I don't think scheduler optimizations=20
>> will eliminate the need of cpu.headroom, as the resource contention
>> always exists, and the impact could be significant.=20
>>=20
>> Do you have further concerns with this patchset?
>>=20
>> Thanks,
>> Song=20
>=20
> Here are some more results with both Viresh's patch and the cpu.headroom
> set. In these tests, the side job runs with SCHED_IDLE, so we get benefit
> of Viresh's patch.=20
>=20
> We collected another metric here, average "cpu time" used by the requests=
.
> We also presented "wall time" and "wall - cpu" time. "wall time" is the=20
> same as "latency" in previous results. Basically, "wall time" includes cp=
u=20
> time, scheduling latency, and time spent waiting for data (from data base=
,=20
> memcache, etc.). We don't have good data that separates scheduling latenc=
y
> and time spent waiting for data, so we present "wall - cpu" time, which i=
s=20
> the sum of the two. Time spent waiting for data should not change in thes=
e=20
> tests, so changes in "wall - cpu" mostly comes from scheduling latency.=20
> All the latency numbers are normalized based on the "wall time" of the=20
> first row.=20
>=20
> side job | cpu.headroom |  cpu-idle | wall time | cpu time | wall - cpu
> ------------------------------------------------------------------------
> none    |     n/a      |    42.4%  |   1.00    |   0.31   |   0.69
> ffmpeg   |       0      |    10.8%  |   1.17    |   0.38   |   0.79
> ffmpeg   |     25%      |    22.8%  |   1.08    |   0.35   |   0.73
>=20
> From these results, we can see that Viresh's patch reduces the latency
> overhead of the side job, from 42% (in previous results) to 17%. And=20
> a 25% cpu.headroom further reduces the latency overhead to 8%.=20
> cpu.headroom reduces time spent in "cpu time" and "wall - cpu" time,=20
> which means cpu.headroom yields better IPC and lower scheduling latency.
>=20
> I think these data demonstrate that=20
>=20
>  1. Viresh's work is helpful in reducing scheduling latency introduced=20
>     by SCHED_IDLE side jobs.=20
>  2. cpu.headroom work provides mechanism to further reduce scheduling
>     latency on top of Viresh's work.=20
>=20
> Therefore, the combination of the two work would give us mechanisms to=20
> control the latency overhead of side workloads.=20
>=20
> @Vincent, do these data and analysis make sense from your point of view?

Do you have further questions/concerns with this set?=20

As the data shown, scheduling latency is not the only resource of high
latency here. In fact, with hyper threading and other shared system=20
resources (cache, memory, etc.), side workload would always negatively
impact the latency of the main workload. It is impossible to eliminate
these impacts with scheduler optimizations. On the other hand,=20
cpu.headroom provides mechanism to limit such impact.=20

Optimization and protection are two sides of the problem. While we=20
spend a lot of time optimizing the workload (so Viresh's work is really
interesting for us), cpu.headroom works on the protection side. There=20
are multiple reasons behind the high latencies. cpu.headroom provides=20
universal protection against all these.=20

With the protection of cpu.headroom, we can actually do optimizations=20
more efficiently, as we can safely start with a high headroom, and=20
then try to lower it.

Please let me know your thoughts on this.=20

Thanks,
Song



