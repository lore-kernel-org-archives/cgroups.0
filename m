From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 0/7] introduce cpu.headroom knob to cpu controller
Date: Wed, 15 May 2019 15:42:29 +0000
Message-ID: <61F85297-8A31-42A7-AF99-324AF8AFCE18@fb.com>
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
 <0C1325C9-DE18-42C6-854D-64433ABD6FC3@fb.com>
 <CAKfTPtDxhjh0LsjgTwKhMMtFqhyDW6qtU-=9K1p-fCR6YLjxCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=TlXDeJMRdkJ4Uwpc3adOfyTNz5a5KP+loB1W2f/SP/c=;
 b=UKx7ZdNiXg29iWe/+yAgOdoof9JSwauqu9rl8MbC7ROA8svkFEFOXqUp2oiaOf1thnqq
 RIr8rABWBovO1lIF1mR4FtXxN4li+v8CjybQ5TOjrxLVZlcmVayhi3VH7OZ/ZM+rBc3G
 YAacjPWwvB3/a+JRqPmYX+3YHv6s24VUoSE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlXDeJMRdkJ4Uwpc3adOfyTNz5a5KP+loB1W2f/SP/c=;
 b=Jd/UihbZNrhJhyLxazMRFz9MfvuWkFwHzoOWziMR08UdXc7DxOFnxUUyuB+O2nC2jfuhmoEJUgBRzbmjFgF6blZZ1npq1aRqMBqrogp/8Ik947Unx8HL/v+XZMbfsDCLigNfhnjXdhI191/45mB2nIAg2mQB7WhCgZvckQbGZ/E=
In-Reply-To: <CAKfTPtDxhjh0LsjgTwKhMMtFqhyDW6qtU-=9K1p-fCR6YLjxCQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <AA6E44C6D36A944B83165EFB7A3F5407@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>, Kernel Team <Kernel-team@fb.com>, viresh kumar <viresh.kumar@linaro.org>

Hi Vincent,

> On May 15, 2019, at 3:18 AM, Vincent Guittot <vincent.guittot@linaro.org>=
 wrote:
>=20
> Hi Song,
>=20
> On Tue, 14 May 2019 at 22:58, Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Hi Vincent,
>>=20
>=20
> [snip]
>=20
>>>=20
>>> Here are some more results with both Viresh's patch and the cpu.headroo=
m
>>> set. In these tests, the side job runs with SCHED_IDLE, so we get benef=
it
>>> of Viresh's patch.
>>>=20
>>> We collected another metric here, average "cpu time" used by the reques=
ts.
>>> We also presented "wall time" and "wall - cpu" time. "wall time" is the
>>> same as "latency" in previous results. Basically, "wall time" includes =
cpu
>>> time, scheduling latency, and time spent waiting for data (from data ba=
se,
>>> memcache, etc.). We don't have good data that separates scheduling late=
ncy
>>> and time spent waiting for data, so we present "wall - cpu" time, which=
 is
>>> the sum of the two. Time spent waiting for data should not change in th=
ese
>>> tests, so changes in "wall - cpu" mostly comes from scheduling latency.
>>> All the latency numbers are normalized based on the "wall time" of the
>>> first row.
>>>=20
>>> side job | cpu.headroom |  cpu-idle | wall time | cpu time | wall - cpu
>>> -----------------------------------------------------------------------=
-
>>> none    |     n/a      |    42.4%  |   1.00    |   0.31   |   0.69
>>> ffmpeg   |       0      |    10.8%  |   1.17    |   0.38   |   0.79
>>> ffmpeg   |     25%      |    22.8%  |   1.08    |   0.35   |   0.73
>>>=20
>>> From these results, we can see that Viresh's patch reduces the latency
>>> overhead of the side job, from 42% (in previous results) to 17%. And
>>> a 25% cpu.headroom further reduces the latency overhead to 8%.
>>> cpu.headroom reduces time spent in "cpu time" and "wall - cpu" time,
>>> which means cpu.headroom yields better IPC and lower scheduling latency=
.
>>>=20
>>> I think these data demonstrate that
>>>=20
>>> 1. Viresh's work is helpful in reducing scheduling latency introduced
>>>    by SCHED_IDLE side jobs.
>>> 2. cpu.headroom work provides mechanism to further reduce scheduling
>>>    latency on top of Viresh's work.
>>>=20
>>> Therefore, the combination of the two work would give us mechanisms to
>>> control the latency overhead of side workloads.
>>>=20
>>> @Vincent, do these data and analysis make sense from your point of view=
?
>>=20
>> Do you have further questions/concerns with this set?
>=20
> Viresh's patchset takes into account CPU running only sched_idle task
> only for the fast wakeup path. But nothing special is (yet) done for
> the slow path or during idle load balance.
> The histogram that you provided for "Fallback to sched-idle CPU for
> better performance", shows that even if we have significantly reduced
> the long wakeup latency, there are still some wakeup latency evenly
> distributed in the range [16us-2msec]. Such values are most probably
> because of sched_other task doesn't always preempt sched_idle task and
> sometime waits for the next tick. This means that there are still
> margin for improving the results with sched_idle without adding a new
> knob.
> The headroom knob forces cpus to be idle from time to time and the
> scheduler fallbacks to the normal scheduling policy that tries to fill
> idle CPU in this case. I'm still not convinced that most of the
> increase of the latency increase is linked to contention when
> accessing shared resources.

I would like clarify that, we are not trying to convince that most of=20
the increase of the latency is from resource contention. Actually, we=20
also have data showing scheduling latency contributes more to the=20
latency overhead:

side job | cpu.headroom |  cpu-idle | wall time | cpu time | wall - cpu
------------------------------------------------------------------------
 none    |     n/a      |    42.4%  |   1.00    |   0.31   |   0.69
ffmpeg   |       0      |    10.8%  |   1.17    |   0.38   |   0.79
ffmpeg   |     25%      |    22.8%  |   1.08    |   0.35   |   0.73

Compared against first row, second row shows 17% of latency overhead=20
(wall time). Among this 17%, 7% is in the "cpu time" column, which=20
is from resource contention (lower IPC). The other 10% (wall - cpu) is
mostly from scheduling latency. These experiments already have Viresh's
current patch. Scheduling latency contributes more in the overall=20
latency w/o Viresh's patch.=20

So we agree that, in this case, most of the increased latency comes=20
from scheduling latency.=20

However, we still think cpu.headroom would add value. The following=20
table shows comparison of ideal cases, where we totally eliminated the=20
overhead of scheduling latency.=20

side job | cpu.headroom |  cpu-idle | wall time | cpu time | wall - cpu
------------------------------------------------------------------------
 none    |     n/a      |    42.4%  |   1.00    |   0.31   |   0.69
------------------------------------------------------------------------
        below are all from estimation, not from experiments
------------------------------------------------------------------------
ffmpeg   |       0      |     TBD   |   1.07    |   0.38   |   0.69
ffmpeg   |     25%      |     TBD   |   1.04    |   0.35   |   0.69

We can see, cpu.headroom helps control latency even with ideal scheduling.=
=20
The saving here (from 7% overhead to 4%) is not as significant. But it is
still meaningful in some cases.=20
=20
More important, cpu.headroom gives us mechanism to control the latency
overhead. It is a _protection_ mechanism, not some optimization. It is=20
somehow similar to current cpu.max knob, which limits the max cpu usage
of certain workload. cpu.headroom is more flexible than cpu.max, because
cpu.headroom could adjust the limits based on system load level dynamically=
.=20

Does this explanation make sense?

Thanks,
Song

