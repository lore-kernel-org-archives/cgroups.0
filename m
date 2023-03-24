From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Fri, 24 Mar 2023 10:12:42 -0400
Message-ID: <53582a07-81c6-35eb-10bf-7920b27483be@redhat.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
 <20230323040037.2389095-2-yosryahmed@google.com>
 <ZBz/V5a7/6PZeM7S@slm.duckdns.org>
 <CAJD7tkYNZeEytm_Px9_73Y-AYJfHAxaoTmmnO71HW5hd1B5tPg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679667167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ADiIDdAPnjqVAbV/udpxZCAiMLd8rfZn004mVe2ENYg=;
        b=G/cI7qNh8pMup3dqG0lDObOxhELU85vzmbBgCa8hpHnLijDcjA75Cf6NWNHpOU9Gu+BZpL
        rwGCW6fyC8/Zl8Bpw3CJlBUHhuYXnJaNFVroylsJ+rtIH2HzExZIhe20jFJalJ0MYMUqe9
        S2hkcmAT1bQzWQNiinYJGQ91mZS41pQ=
Content-Language: en-US
In-Reply-To: <CAJD7tkYNZeEytm_Px9_73Y-AYJfHAxaoTmmnO71HW5hd1B5tPg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On 3/24/23 03:22, Yosry Ahmed wrote:
> On Thu, Mar 23, 2023 at 6:39=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>> Hello,
>>
>> On Thu, Mar 23, 2023 at 04:00:31AM +0000, Yosry Ahmed wrote:
>>> Currently, when sleeping is not allowed during rstat flushing, we hold
>>> the global rstat lock with interrupts disabled throughout the entire
>>> flush operation. Flushing in an O(# cgroups * # cpus) operation, and
>>> having interrupts disabled throughout is dangerous.
>>>
>>> For some contexts, we may not want to sleep, but can be interrupted
>>> (e.g. while holding a spinlock or RCU read lock). As such, do not
>>> disable interrupts throughout rstat flushing, only when holding the
>>> percpu lock. This breaks down the O(# cgroups * # cpus) duration with
>>> interrupts disabled to a series of O(# cgroups) durations.
>>>
>>> Furthermore, if a cpu spinning waiting for the global rstat lock, it
>>> doesn't need to spin with interrupts disabled anymore.
>> I'm generally not a fan of big spin locks w/o irq protection. They too o=
ften
>> become a source of unpredictable latency spikes. As you said, the global
>> rstat lock can be held for quite a while. Removing _irq makes irq latency
>> better on the CPU but on the other hand it makes a lot more likely that =
the
>> lock is gonna be held even longer, possibly significantly so depending on
>> the configuration and workload which will in turn stall other CPUs waiti=
ng
>> for the lock. Sure, irqs are being serviced quicker but if the cost is m=
ore
>> and longer !irq context multi-cpu stalls, what's the point?
>>
>> I don't think there's anything which requires the global lock to be held
>> throughout the entire flushing sequence and irq needs to be disabled when
>> grabbing the percpu lock anyway, so why not just release the global lock=
 on
>> CPU boundaries instead? We don't really lose anything significant that w=
ay.
>> The durations of irq disabled sections are still about the same as in the
>> currently proposed solution at O(# cgroups) and we avoid the risk of hol=
ding
>> the global lock for too long unexpectedly from getting hit repeatedly by
>> irqs while holding the global lock.
> Thanks for taking a look!
>
> I think a problem with this approach is that we risk having to contend
> for the global lock at every CPU boundary in atomic contexts. Right
Isn't it the plan to just do a trylock in atomic contexts so that it=20
won't get stuck spinning for the lock for an indeterminate amount of time?
> now we contend for the global lock once, and once we have it we go
> through all CPUs to flush, only having to contend with updates taking
> the percpu locks at this point. If we unconditionally release &
> reacquire the global lock at every CPU boundary then we may contend
> for it much more frequently with concurrent flushers.

Note that with the use of qspinlock in all the major arches, the impact=20
of thundering herds of lockers are much less serious than before. There=20
are certainly some overhead in doing multiple lock acquires and=20
releases, but that shouldn't been too excessive.

I am all in for reducing lock hold time as much as possible as it will=20
improve the response time.

Cheers,
Longman

