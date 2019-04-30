From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 0/7] introduce cpu.headroom knob to cpu controller
Date: Tue, 30 Apr 2019 16:54:18 +0000
Message-ID: <19AF6556-A2A2-435B-9358-CD22CF7BFD9F@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
 <20190410115907.GE19434@e105550-lin.cambridge.arm.com>
 <A2E9A149-9EAA-478D-A096-1D4D4BA442B3@fb.com>
 <CAKfTPtAFB3gSZYJN1BcjU_XoY=Pfu2xtea+2MEw7FkVc3mwTSA@mail.gmail.com>
 <E97E73F4-CE8C-4CD7-B6B6-5F63A4E881B1@fb.com>
 <F0A127DD-F9B6-4FBE-B9AD-8E8B00A7D676@fb.com>
 <CAKfTPtA_ouYCes9LnYn0quAKm273mi3vP-++GTBtYcQn07xc6Q@mail.gmail.com>
 <A62E5068-4A1E-44E3-99BB-02E98229C1E2@fb.com>
 <CAKfTPtAG3v=37wyLjzkNNK_6HdoMK6WO7AMYfa+G24rq2iyAfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ga/EWKOAn9UDB4/9v+JepbeJg373fEqSyzJw4liRsvE=;
 b=J/7lNJ2MO3QohbtmP58ifNjlYxGhac1sL5Qv6kjNPdsSRqsxPLuC/zWpflFo7RfaDV/C
 +avwcZOraofpifkwIPmvxuvtYmZqkwhfJCwj2PnKOmStwjuy/xDC6+NSd/lptRSvAFOh
 p79jbqnfMgOa52UIVxc95dhmotdni6sOAQU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ga/EWKOAn9UDB4/9v+JepbeJg373fEqSyzJw4liRsvE=;
 b=KOVM2txMvQR230Okmd0uOBavvnacL3V91C5snYPoXu3pqeRweHszbCnetT6wo2tj0SZPgLgkeSSccg+FQbh2HDnxC9JKP3rE+WrT/Mp4KmEYUXWrlChLH9JVyzAnl5Eh7QcDZsgGniMq2Q0u/eBEOWbjn9/zwfbcAjBveNKqPqs=
In-Reply-To: <CAKfTPtAG3v=37wyLjzkNNK_6HdoMK6WO7AMYfa+G24rq2iyAfg@mail.gmail.com>
Content-Language: en-US
Content-ID: <D44450EECA858B4782EE638B5EF2A540@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>, Kernel Team <Kernel-team@fb.com>, viresh kumar <viresh.kumar@linaro.org>



> On Apr 30, 2019, at 12:20 PM, Vincent Guittot <vincent.guittot@linaro.org=
> wrote:
>=20
> Hi Song,
>=20
> On Tue, 30 Apr 2019 at 08:11, Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Apr 29, 2019, at 8:24 AM, Vincent Guittot <vincent.guittot@linaro.or=
g> wrote:
>>>=20
>>> Hi Song,
>>>=20
>>> On Sun, 28 Apr 2019 at 21:47, Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>> Hi Morten and Vincent,
>>>>=20
>>>>> On Apr 22, 2019, at 6:22 PM, Song Liu <songliubraving@fb.com> wrote:
>>>>>=20
>>>>> Hi Vincent,
>>>>>=20
>>>>>> On Apr 17, 2019, at 5:56 AM, Vincent Guittot <vincent.guittot@linaro=
.org> wrote:
>>>>>>=20
>>>>>> On Wed, 10 Apr 2019 at 21:43, Song Liu <songliubraving@fb.com> wrote=
:
>>>>>>>=20
>>>>>>> Hi Morten,
>>>>>>>=20
>>>>>>>> On Apr 10, 2019, at 4:59 AM, Morten Rasmussen <morten.rasmussen@ar=
m.com> wrote:
>>>>>>>>=20
>>>>>>=20
>>>>>>>>=20
>>>>>>>> The bit that isn't clear to me, is _why_ adding idle cycles helps =
your
>>>>>>>> workload. I'm not convinced that adding headroom gives any latency
>>>>>>>> improvements beyond watering down the impact of your side jobs. AF=
AIK,
>>>>>>>=20
>>>>>>> We think the latency improvements actually come from watering down =
the
>>>>>>> impact of side jobs. It is not just statistically improving average
>>>>>>> latency numbers, but also reduces resource contention caused by the=
 side
>>>>>>> workload. I don't know whether it is from reducing contention of AL=
Us,
>>>>>>> memory bandwidth, CPU caches, or something else, but we saw reduced
>>>>>>> latencies when headroom is used.
>>>>>>>=20
>>>>>>>> the throttling mechanism effectively removes the throttled tasks f=
rom
>>>>>>>> the schedule according to a specific duty cycle. When the side job=
 is
>>>>>>>> not throttled the main workload is experiencing the same latency i=
ssues
>>>>>>>> as before, but by dynamically tuning the side job throttling you c=
an
>>>>>>>> achieve a better average latency. Am I missing something?
>>>>>>>>=20
>>>>>>>> Have you looked at your distribution of main job latency and tried=
 to
>>>>>>>> compare with when throttling is active/not active?
>>>>>>>=20
>>>>>>> cfs_bandwidth adjusts allowed runtime for each task_group each peri=
od
>>>>>>> (configurable, 100ms by default). cpu.headroom logic applies gentle
>>>>>>> throttling, so that the side workload gets some runtime in every pe=
riod.
>>>>>>> Therefore, if we look at time window equal to or bigger than 100ms,=
 we
>>>>>>> don't really see "throttling active time" vs. "throttling inactive =
time".
>>>>>>>=20
>>>>>>>>=20
>>>>>>>> I'm wondering if the headroom solution is really the right solutio=
n for
>>>>>>>> your use-case or if what you are really after is something which i=
s
>>>>>>>> lower priority than just setting the weight to 1. Something that
>>>>>>>=20
>>>>>>> The experiments show that, cpu.weight does proper work for priority=
: the
>>>>>>> main workload gets priority to use the CPU; while the side workload=
 only
>>>>>>> fill the idle CPU. However, this is not sufficient, as the side wor=
kload
>>>>>>> creates big enough contention to impact the main workload.
>>>>>>>=20
>>>>>>>> (nearly) always gets pre-empted by your main job (SCHED_BATCH and
>>>>>>>> SCHED_IDLE might not be enough). If your main job consist
>>>>>>>> of lots of relatively short wake-ups things like the min_granulari=
ty
>>>>>>>> could have significant latency impact.
>>>>>>>=20
>>>>>>> cpu.headroom gives benefits in addition to optimizations in pre-emp=
t
>>>>>>> side. By maintaining some idle time, fewer pre-empt actions are
>>>>>>> necessary, thus the main workload will get better latency.
>>>>>>=20
>>>>>> I agree with Morten's proposal, SCHED_IDLE should help your latency
>>>>>> problem because side job will be directly preempted unlike normal cf=
s
>>>>>> task even lowest priority.
>>>>>> In addition to min_granularity, sched_period also has an impact on t=
he
>>>>>> time that a task has to wait before preempting the running task. Als=
o,
>>>>>> some sched_feature like GENTLE_FAIR_SLEEPERS can also impact the
>>>>>> latency of a task.
>>>>>>=20
>>>>>> It would be nice to know if the latency problem comes from contentio=
n
>>>>>> on cache resources or if it's mainly because you main load waits
>>>>>> before running on a CPU
>>>>>>=20
>>>>>> Regards,
>>>>>> Vincent
>>>>>=20
>>>>> Thanks for these suggestions. Here are some more tests to show the im=
pact
>>>>> of scheduler knobs and cpu.headroom.
>>>>>=20
>>>>> side-load | cpu.headroom | side/cpu.weight | min_gran | cpu-idle | ma=
in/latency
>>>>> ---------------------------------------------------------------------=
-----------
>>>>> none    |      0       |     n/a         |    1 ms  |  45.20%  |   1.=
00
>>>>> ffmpeg   |      0       |      1          |   10 ms  |   3.38%  |   1=
.46
>>>>> ffmpeg   |      0       |   SCHED_IDLE    |    1 ms  |   5.69%  |   1=
.42
>>>>> ffmpeg   |    20%       |   SCHED_IDLE    |    1 ms  |  19.00%  |   1=
.13
>>>>> ffmpeg   |    30%       |   SCHED_IDLE    |    1 ms  |  27.60%  |   1=
.08
>>>>>=20
>>>>> In all these cases, the main workload is loaded with same level of
>>>>> traffic (request per second). Main workload latency numbers are norma=
lized
>>>>> based on the baseline (first row).
>>>>>=20
>>>>> For the baseline, the main workload runs without any side workload, t=
he
>>>>> system has about 45.20% idle CPU.
>>>>>=20
>>>>> The next two rows compare the impact of scheduling knobs cpu.weight a=
nd
>>>>> sched_min_granularity. With cpu.weight of 1 and min_granularity of 10=
ms,
>>>>> we see a latency of 1.46; with SCHED_IDLE and min_granularity of 1ms,=
 we
>>>>> see a latency of 1.42. So SCHED_IDLE and min_granularity help protect=
ing
>>>>> the main workload. However, it is not sufficient, as the latency over=
head
>>>>> is high (>40%).
>>>>>=20
>>>>> The last two rows show the benefit of cpu.headroom. With 20% headroom=
,
>>>>> the latency is 1.13; while with 30% headroom, the latency is 1.08.
>>>>>=20
>>>>> We can also see a clear correlation between latency and global idle C=
PU:
>>>>> more idle CPU yields better lower latency.
>>>>>=20
>>>>> Over all, these results show that cpu.headroom provides effective
>>>>> mechanism to control the latency impact of side workloads. Other knob=
s
>>>>> could also help the latency, but they are not as effective and flexib=
le
>>>>> as cpu.headroom.
>>>>>=20
>>>>> Does this analysis address your concern?
>>>=20
>>> So, you results show that sched_idle class doesn't provide the
>>> intended behavior because it still delay the scheduling of sched_other
>>> tasks. In fact, the wakeup path of the scheduler doesn't make any
>>> difference between a cpu running a sched_other and a cpu running a
>>> sched_idle when looking for the idlest cpu and it can create some
>>> contentions between sched_other tasks whereas a cpu runs sched_idle
>>> task.
>>=20
>> I don't think scheduling delay is the only (or dominating) factor of
>> extra latency. Here are some data to show it.
>>=20
>> I measured IPC (instructions per cycle) of the main workload under
>> different scenarios:
>>=20
>> side-load | cpu.headroom | side/cpu.weight  | IPC
>> ----------------------------------------------------
>> none     |     0%       |       N/A        | 0.66
>> ffmpeg   |     0%       |    SCHED_IDLE    | 0.53
>> ffmpeg   |    20%       |    SCHED_IDLE    | 0.58
>> ffmpeg   |    30%       |    SCHED_IDLE    | 0.62
>>=20
>> These data show that the side workload has a negative impact on the
>> main workload's IPC. And cpu.headroom could help reduce this impact.
>>=20
>> Therefore, while optimizations in the wakeup path should help the
>> latency; cpu.headroom would add _significant_ benefit on top of that.
>=20
> It seems normal that side workload has a negative impact on IPC
> because of resources sharing but your previous results showed a 42%
> regression of latency with sched_idle which is can't be only linked to
> resources access contention

Agreed. I think both scheduling latency and resource contention=20
contribute noticeable latency overhead to the main workload. The=20
scheduler optimization by Viresh would help reduce the scheduling
latency, but it won't help the resource contention. Hopefully, with=20
optimizations in the scheduler, we can meet the latency target with=20
smaller cpu.headroom. However, I don't think scheduler optimizations=20
will eliminate the need of cpu.headroom, as the resource contention
always exists, and the impact could be significant.=20

Do you have further concerns with this patchset?

Thanks,
Song=20


>>=20
>> Does this assessment make sense?
>>=20
>>=20
>>> Viresh (cced to this email) is working on improving such behavior at
>>> wake up and has sent an patch related to the subject:
>>> https://lkml.org/lkml/2019/4/25/251
>>> I'm curious if this would improve the results.
>>=20
>> I could try it with our workload next week (I am at LSF/MM this
>> week). Also, please keep in mind that this test sometimes takes
>> multiple days to setup and run.
>=20
> Yes. I understand. That would be good to have a simpler setup to
> reproduce the behavior of your setup in order to do preliminary tests
> and analyse the behavior
>=20
>>=20
>> Thanks,
>> Song
>>=20
>>>=20
>>> Regards,
>>> Vincent
>>>=20
>>>>>=20
>>>>> Thanks,
>>>>> Song
>>>>>=20
>>>>=20
>>>> Could you please share your comments and suggestions on this work? Did
>>>> the results address your questions/concerns?
>>>>=20
>>>> Thanks again,
>>>> Song
>>>>=20
>>>>>>=20
>>>>>>>=20
>>>>>>> Thanks,
>>>>>>> Song
>>>>>>>=20
>>>>>>>>=20
>>>>>>>> Morten

