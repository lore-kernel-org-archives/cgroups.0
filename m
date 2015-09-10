From: Juri Lelli <juri.lelli-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/4] sched/{cpuset,core}: restore complete root_domain
 status across hotplug
Date: Thu, 10 Sep 2015 10:03:07 +0100
Message-ID: <55F1474B.3020007@arm.com>
References: <1441188096-23021-1-git-send-email-juri.lelli@arm.com>
 <1441188096-23021-2-git-send-email-juri.lelli@arm.com>
 <20150909151134.GU16853@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150909151134.GU16853-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Peter,

On 09/09/15 16:11, Peter Zijlstra wrote:
> On Wed, Sep 02, 2015 at 11:01:33AM +0100, Juri Lelli wrote:
>> Hotplug operations are destructive w.r.t data associated with cpuset;
>> in this case we care about root_domains. SCHED_DEADLINE puts bandwidth
>> information regarding admitted tasks on root_domains, information that
>> is gone when an hotplug operation happens. Also, it is not currently
>> possible to tell to which task(s) the allocated bandwidth belongs, as
>> this link is lost after sched_setscheduler() succeeds.
>>
>> This patch forces rebuilding of allocated bandwidth information at
>> root_domain level after cpuset_hotplug_workfn() callback is done
>> setting up scheduling and root domains.
> 
>> +static void cpuset_hotplug_update_rd(void)
>> +{
>> +	struct cpuset *cs;
>> +	struct cgroup_subsys_state *pos_css;
>> +
>> +	mutex_lock(&cpuset_mutex);
>> +	rcu_read_lock();
>> +	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
>> +		if (!css_tryget_online(&cs->css))
>> +			continue;
>> +		rcu_read_unlock();
>> +
>> +		update_tasks_rd(cs);
>> +
>> +		rcu_read_lock();
>> +		css_put(&cs->css);
>> +	}
>> +	rcu_read_unlock();
>> +	mutex_unlock(&cpuset_mutex);
>> +}
>> +
>> +/**
>>   * cpuset_hotplug_workfn - handle CPU/memory hotunplug for a cpuset
>>   *
>>   * This function is called after either CPU or memory configuration has
>> @@ -2296,6 +2335,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>>  	/* rebuild sched domains if cpus_allowed has changed */
>>  	if (cpus_updated)
>>  		rebuild_sched_domains();
>> +
>> +	cpuset_hotplug_update_rd();
>>  }
> 
> So the problem is that rebuild_sched_domains() destroys rd->dl_bw ? I
> worry the above is racy in that you do not restore under the same
> cpuset_mutex instance as you rebuild.
>

Yes, problem is that root_domain is gone after rebuild_sched_domains().
We store admitted bandwidth information there, so we loose it during
hotplug. Problem also is that only other information about which task
has been admitted, in which cpuset, resides in cpusets themselves.

> That is, what will stop a new task from joining the cpuset and
> overloading the bandwidth between the root-domain getting rebuild and
> restoring the bandwidth?
> 

Right, this is broken. At first, I tried to fix this somewhere in
rebuild_sched_domains_locked() (for example via rq_{on,off}line_dl),
but I failed since, as I say above, we don't have required information
on rqs. I sort of remember I came up with a working-ish solution
saving bw in partition_sched_domains() across destroy and build, but
that was uglier that this patch :-/.

I'll keep thinking, just wanted to keep the problem known and share
what I have (not much indeed).

Thanks,

- Juri
