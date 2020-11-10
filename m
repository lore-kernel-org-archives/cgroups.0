From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: fix race between hotplug work and later CPU
 offline
Date: Tue, 10 Nov 2020 15:34:31 -0500
Message-ID: <87zh3pt0h4.fsf@mr.pineapple.says.hi.net>
References: <20201029181845.415517-1-daniel.m.jordan@oracle.com>
 <20201110164504.GL2594@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=s4nyry0mSPgh1FrvXm8VEB2bCAXmh9/aI1iL5kwnE7o=;
 b=MF+5WKq4vr3MUTA6g7wFb5dE9tfejt9KvBDxWLBe5SyR4tn+KB8wIBonc5JTNB7hJwB/
 qrP6eeCzoy7nqQvQ2EcvbNw5p1jd2fBAY36U3SA9WjAPqqnjclHo+NnObpxPLwg9ZUcK
 rBWZSV2ZoV3SRFk8V1O4V8nU6hYuEtDkz9qrBY6u0t/ojtHmhUfYlnojLtc+xUUV28Xc
 feumLPaql28r4xrEnnokxLa5xfFznLWZ9aDVbTLXPL1fm2Kj1MQVPIE7ImtDabENM+ZO
 9FZZNYcRlJyzo2OYOpzyqCoH+NFiAzkORBr36nz6dXSXxL0H/lCxO8FXawwILEN6rq6n gw== 
In-Reply-To: <20201110164504.GL2594-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> writes:
> On Thu, Oct 29, 2020 at 02:18:45PM -0400, Daniel Jordan wrote:
>> rebuild_sched_domains_locked() prevented the race during the cgroup2
>> cpuset series up until the Fixes commit changed its check.  Make the
>> check more robust so that it can detect an offline CPU in any exclusive
>> cpuset's effective mask, not just the top one.
>
> *groan*, what a mess...

Ah, the joys of cpu hotplug!

>> I think the right thing to do long-term is make the hotplug work
>> synchronous, fixing the lockdep splats of past attempts, and then take
>> these checks out of rebuild_sched_domains_locked, but this fixes the
>> immediate issue and is small enough for stable.  Open to suggestions.
>> 
>> Prateek, are you planning on picking up your patches again?
>
> Yeah, that might help, but those deadlocks were nasty iirc :/

It might end up being too invasive to be worth it, but I'm being
optimistic for now.

>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 57b5b5d0a5fd..ac3124010b2a 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -983,8 +983,10 @@ partition_and_rebuild_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
>>   */
>>  static void rebuild_sched_domains_locked(void)
>>  {
>> +	struct cgroup_subsys_state *pos_css;
>>  	struct sched_domain_attr *attr;
>>  	cpumask_var_t *doms;
>> +	struct cpuset *cs;
>>  	int ndoms;
>>  
>>  	lockdep_assert_cpus_held();
>> @@ -999,9 +1001,21 @@ static void rebuild_sched_domains_locked(void)
>>  	    !cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
>>  		return;
>
> So you argued above that effective_cpus was stale, I suppose the above
> one works because its an equality test instead of a subset?

Yep, fortunately enough.

> Does that wants a comment?

Ok, I'll change the comments to this absent other ideas.

	/*
	 * If we have raced with CPU hotplug, return early to avoid
	 * passing doms with offlined cpu to partition_sched_domains().
	 * Anyways, cpuset_hotplug_workfn() will rebuild sched domains.
	 *
	 * With no CPUs in any subpartitions, top_cpuset's effective CPUs
	 * should be the same as the active CPUs, so checking only top_cpuset
	 * is enough to detect racing CPU offlines.
	 */
	if (!top_cpuset.nr_subparts_cpus &&
	    !cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
		return;

	/*
	 * With subpartition CPUs, however, the effective CPUs of a partition
	 * root should be only a subset of the active CPUs.  Since a CPU in any
	 * partition root could be offlined, all must be checked.
	 */
	if (top_cpuset.nr_subparts_cpus) {
		rcu_read_lock();
        ...


Thanks for looking.
