From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: Implement cgroup2 basic CPU usage accounting
Date: Sun, 13 Aug 2017 19:20:35 -0400
Message-ID: <a5ff145e-e2ca-d852-bd40-bc94ccc98167@redhat.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
 <e9682f27-a23c-802c-daed-e49fc9d4613c@redhat.com>
 <20170813194421.GB1438922@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170813194421.GB1438922-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On 08/13/2017 03:44 PM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Fri, Aug 11, 2017 at 04:19:07PM -0400, Waiman Long wrote:
>>> * CPU usage stats are collected and shown in "cgroup.stat" with "cpu."
>>>   prefix.  Total usage is collected from scheduling events.  User/sys
>>>   breakdown is sourced from tick sampling and adjusted to the usage
>>>   using cputime_adjuts().
>> Typo: cputime_adjust()
> Oops, will fix.
>
>>> +static DEFINE_MUTEX(cgroup_stat_mutex);
>>> +static DEFINE_PER_CPU(raw_spinlock_t, cgroup_cpu_stat_lock);
>> If the hierarchy is large enough and the stat data hasn't been read
>> recently, it may take a while to accumulate all the stat data even for
>> one cpu in cgroup_stat_flush_locked(). So I think it will make more
>> sense to use regular spinlock_t instead of raw_spinlock_t.
> They need to be raw spinlocks because the accounting side may grab
> them while scheduling.  If the accumulating latency becomes
> problematic, we can test for need_resched and spin_needbreak and break
> out as necessary.  The iteration logic is built to allow that and an
> earlier revision actually did that but I wasn't sure whether it's
> actually necessary and removed it for simplicity.
>
> If the latency ever becomes a problem, resurrecting that isn't
> difficult at all.

Right, I forgot they will be used by the scheduler.

I think it is prudent to limit the latency, but it can be another patch
when the need arises.

>>> +static struct cgroup *cgroup_cpu_stat_next_updated(struct cgroup *pos,
>>> +						   struct cgroup *root, int cpu)
>> This function is trying to unwind one cgrp from the updated_children and
>> updated_next linkage. It is somewhat like the opposite of
>> cgroup_cpu_stat_updated(). I just feel like its name isn't intuitive
>> enough to convey what it is doing. Maybe use name like
>> cgroup_cpu_stat_unlink_one() to match cgroup_cpu_stat_flush_one().
> Hmm... the name comes from it being an iterator - most interators are
> named _next.  But, yeah, the name doesn't signifiy that it unlinks as
> it goes along.  I'll rename it to cgroup_cpu_stat_pop_updated().

I am fine with that.

Thanks,
Longman
