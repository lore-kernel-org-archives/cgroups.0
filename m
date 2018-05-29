From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v8 2/6] cpuset: Add new v2 cpuset.sched.domain flag
Date: Mon, 28 May 2018 20:55:13 -0400
Message-ID: <595ad976-6859-95bc-179f-88e11ba98dbf@redhat.com>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-3-git-send-email-longman@redhat.com>
 <20180522125750.GA31040@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180522125750.GA31040@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On 05/22/2018 08:57 AM, Juri Lelli wrote:
> Hi,
>
> On 17/05/18 16:55, Waiman Long wrote:
>
> [...]
>
>>  /**
>> + * update_isolated_cpumask - update the isolated_cpus mask of parent cpuset
>> + * @cpuset:  The cpuset that requests CPU isolation
>> + * @oldmask: The old isolated cpumask to be removed from the parent
>> + * @newmask: The new isolated cpumask to be added to the parent
>> + * Return: 0 if successful, an error code otherwise
>> + *
>> + * Changes to the isolated CPUs are not allowed if any of CPUs changing
>> + * state are in any of the child cpusets of the parent except the requesting
>> + * child.
>> + *
>> + * If the sched_domain flag changes, either the oldmask (0=>1) or the
>> + * newmask (1=>0) will be NULL.
>> + *
>> + * Called with cpuset_mutex held.
>> + */
>> +static int update_isolated_cpumask(struct cpuset *cpuset,
>> +	struct cpumask *oldmask, struct cpumask *newmask)
>> +{
>> +	int retval;
>> +	int adding, deleting;
>> +	cpumask_var_t addmask, delmask;
>> +	struct cpuset *parent = parent_cs(cpuset);
>> +	struct cpuset *sibling;
>> +	struct cgroup_subsys_state *pos_css;
>> +	int old_count = parent->isolation_count;
>> +	bool dying = cpuset->css.flags & CSS_DYING;
>> +
>> +	/*
>> +	 * Parent must be a scheduling domain with non-empty cpus_allowed.
>> +	 */
>> +	if (!is_sched_domain(parent) || cpumask_empty(parent->cpus_allowed))
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * The oldmask, if present, must be a subset of parent's isolated
>> +	 * CPUs.
>> +	 */
>> +	if (oldmask && !cpumask_empty(oldmask) && (!parent->isolation_count ||
>> +			!cpumask_subset(oldmask, parent->isolated_cpus))) {
>> +		WARN_ON_ONCE(1);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/*
>> +	 * A sched_domain state change is not allowed if there are
>> +	 * online children and the cpuset is not dying.
>> +	 */
>> +	if (!dying && (!oldmask || !newmask) &&
>> +	    css_has_online_children(&cpuset->css))
>> +		return -EBUSY;
>> +
>> +	if (!zalloc_cpumask_var(&addmask, GFP_KERNEL))
>> +		return -ENOMEM;
>> +	if (!zalloc_cpumask_var(&delmask, GFP_KERNEL)) {
>> +		free_cpumask_var(addmask);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	if (!old_count) {
>> +		if (!zalloc_cpumask_var(&parent->isolated_cpus, GFP_KERNEL)) {
>> +			retval = -ENOMEM;
>> +			goto out;
>> +		}
>> +		old_count = 1;
>> +	}
>> +
>> +	retval = -EBUSY;
>> +	adding = deleting = false;
>> +	if (newmask)
>> +		cpumask_copy(addmask, newmask);
>> +	if (oldmask)
>> +		deleting = cpumask_andnot(delmask, oldmask, addmask);
>> +	if (newmask)
>> +		adding = cpumask_andnot(addmask, newmask, delmask);
>> +
>> +	if (!adding && !deleting)
>> +		goto out_ok;
>> +
>> +	/*
>> +	 * The cpus to be added must be in the parent's effective_cpus mask
>> +	 * but not in the isolated_cpus mask.
>> +	 */
>> +	if (!cpumask_subset(addmask, parent->effective_cpus))
>> +		goto out;
>> +	if (parent->isolation_count &&
>> +	    cpumask_intersects(parent->isolated_cpus, addmask))
>> +		goto out;
>> +
>> +	/*
>> +	 * Check if any CPUs in addmask or delmask are in a sibling cpuset.
>> +	 * An empty sibling cpus_allowed means it is the same as parent's
>> +	 * effective_cpus. This checking is skipped if the cpuset is dying.
>> +	 */
>> +	if (dying)
>> +		goto updated_isolated_cpus;
>> +
>> +	cpuset_for_each_child(sibling, pos_css, parent) {
>> +		if ((sibling == cpuset) || !(sibling->css.flags & CSS_ONLINE))
>> +			continue;
>> +		if (cpumask_empty(sibling->cpus_allowed))
>> +			goto out;
>> +		if (adding &&
>> +		    cpumask_intersects(sibling->cpus_allowed, addmask))
>> +			goto out;
>> +		if (deleting &&
>> +		    cpumask_intersects(sibling->cpus_allowed, delmask))
>> +			goto out;
>> +	}
> Just got the below by echoing 1 into cpuset.sched.domain of a sibling with
> "isolated" cpuset.cpus. Guess you are missing proper locking about here
> above.
>
> --->8---
> [ 7509.905005] =============================
> [ 7509.905009] WARNING: suspicious RCU usage
> [ 7509.905014] 4.17.0-rc5+ #11 Not tainted
> [ 7509.905017] -----------------------------
> [ 7509.905023] /home/juri/work/kernel/linux/kernel/cgroup/cgroup.c:3826 cgroup_mutex or RCU read lock required!
> [ 7509.905026] 
>                other info that might help us debug this:

The cause is missing rcu_lock/rcu_unlock in section of the code. It will
be fixed in the next version.

Cheers,
Longman

