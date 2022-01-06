From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] mm/memcg: Allow the task_obj optimization only on
 non-PREEMPTIBLE kernels.
Date: Wed, 5 Jan 2022 22:28:10 -0500
Message-ID: <29457251-cf4f-4c7d-b36d-c2a0af4da707@redhat.com>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
 <20211222114111.2206248-4-bigeasy@linutronix.de>
 <f6bb93c8-3940-6141-d0e0-50144549a4f5@redhat.com>
 <YdML2zaU17clEZgt@linutronix.de>
 <df637005-6c72-a1c6-c6b9-70f81f74884d@redhat.com>
 <YdX+INO9gQje6d0S@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641439696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKJG1VmDGIJ+f+XRZiZXcEOKHaGBB5Bukhi4QqPlWNQ=;
        b=PfEe+F4NwZqOfwQibDSsC1pW2IJYKPQltvAlYoCQa0Wx7zrqlzVCJPnZ7NvzlHFsSJTLDb
        gHZaRwkbmn95AytYQZ5o1as9ddy6lbNT24UhcP2y95YgYQiT7iBeto1L8eHjynwiAiYK7C
        GUtZc1IGdFmWm1/8gAa+syTuV1Cdjqw=
Content-Language: en-US
In-Reply-To: <YdX+INO9gQje6d0S-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 1/5/22 15:22, Sebastian Andrzej Siewior wrote:
> On 2022-01-03 10:04:29 [-0500], Waiman Long wrote:
>> On 1/3/22 09:44, Sebastian Andrzej Siewior wrote:
>>> Is there something you recommend as a benchmark where I could get some
>>> numbers?
>> In the case of PREEMPT_DYNAMIC, it depends on the default setting which =
is
>> used by most users. I will support disabling the optimization if
>> defined(CONFIG_PREEMPT_RT) || defined(CONFIG_PREEMPT), just not by
>> CONFIG_)PREEMPTION alone.
>>
>> As for microbenchmark, something that makes a lot of calls to malloc() or
>> related allocations can be used.
> Numbers I made:
>
>          Sandy Bridge   Haswell        Skylake         AMD-A8 7100    Zen=
2           ARM64
> PREEMPT 5,123,896,822  5,215,055,226   5,077,611,590  6,012,287,874  6,23=
4,674,489  20,000,000,100
> IRQ     7,494,119,638  6,810,367,629  10,620,130,377  4,178,546,086  4,89=
8,076,012  13,538,461,925

Thanks for the extensive testing. I usually perform my performance test=20
on Intel hardware. I don't realize that Zen2 and arm64 perform better=20
with irq on/off.


>
> For micro benchmarking I did 1.000.000.000 iterations of
> preempt_disable()/enable() [PREEMPT] and local_irq_save()/restore()
> [IRQ].
> On a Sandy Bridge the PREEMPT loop took 5,123,896,822ns while the IRQ
> loop took 7,494,119,638ns. The absolute numbers are not important, it is
> worth noting that preemption off/on is less expensive than IRQ off/on.
> Except for AMD and ARM64 where IRQ off/on was less expensive. The whole
> loop was performed with disabled interrupts so I don't expect much
> interference - but then I don't know much the =C2=B5Arch optimized away on
> local_irq_restore() given that the interrupts were already disabled.
> I don't have any recent Intel HW (I think) so I don't know if this is an
> Intel only thing (IRQ off/on cheaper than preemption off/on) but I guess
> that the recent uArch would behave similar to AMD.
>
> Moving on: For the test I run 100,000,000 iterations of
>       kfree(kmalloc(128, GFP_ATOMIC | __GFP_ACCOUNT));
>
> The BH suffix means that in_task() reported false during the allocation,
> otherwise it reported true.
> SD is the standard deviation.
> SERVER means PREEMPT_NONE while PREEMPT means CONFIG_PREEMPT.
> OPT means the optimisation (in_task() + task_obj) is active, NO-OPT
> means no optimisation (irq_obj is always used).
> The numbers are the time in ns needed for 100,000,000 iteration (alloc +
> free). I run 5 tests and used the median value here. If the standard
> deviation exceeded 10^9 then I repeated the test. The values remained in
> the same range since usually only one value was off and the other
> remained in the same range.
>
> Sandy Bridge
>                   SERVER OPT   SERVER NO-OPT    PREEMPT OPT     PREEMPT N=
O-OPT
> ALLOC/FREE    8,519,295,176   9,051,200,652    10,627,431,395  11,198,189=
,843
> SD                5,309,768      29,253,976       129,102,317      40,681=
,909
> ALLOC/FREE BH 9,996,704,330   8,927,026,031    11,680,149,900  11,139,356=
,465
> SD               38,237,534      72,913,120        23,626,932     116,413=
,331

My own testing when tracking the number of times in_task() is true or=20
false indicated most of the kmalloc() call is done by tasks. Only a few=20
percents of the time is in_task() false. That is the reason why I=20
optimize the case that in_task() is true.


>
> The optimisation is visible in the SERVER-OPT case (~1.5s difference in
> the runtime (or 14.7ns per iteration)). There is hardly any difference
> between BH and !BH in the SERVER-NO-OPT case.
> For the SERVER case, the optimisation improves ~0.5s in runtime for the
> !BH case.
> For the PREEMPT case it also looks like ~0.5s improvement in the BH case
> while in the BH case it looks the other way around.
>
>                   DYN-SRV-OPT   DYN-SRV-NO-OPT    DYN-FULL-OPT   DYN-FULL=
-NO-OPT
> ALLOC/FREE     11,069,180,584  10,773,407,543  10,963,581,285    10,826,2=
07,969
> SD                 23,195,912     112,763,104      13,145,589        33,5=
43,625
> ALLOC/FREE BH  11,443,342,069  10,720,094,700  11,064,914,727    10,955,8=
83,521
> SD                 81,150,074     171,299,554      58,603,778        84,1=
31,143
>
> DYN is CONFIG_PREEMPT_DYNAMIC enabled and CONFIG_PREEMPT_NONE is
> default.  I don't see any difference vs CONFIG_PREEMPT except the
> default preemption state (so I didn't test that). The preemption counter
> is always forced-in so preempt_enable()/disable() is not optimized away.
> SRV is the default value (PREEMPT_NONE) and FULL is the overriden
> (preempt=3Dfull) state.
>
> Based on that, I don't see any added value by the optimisation once
> PREEMPT_DYNAMIC is enabled.

The PREEMPT_DYNAMIC result is a bit surprising to me. Given the data=20
points, I am not going to object to this patch then. I will try to look=20
further into why this is the case when I have time.

Cheers,
Longman

