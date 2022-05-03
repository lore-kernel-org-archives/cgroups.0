From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v10 3/8] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Tue, 3 May 2022 14:39:23 -0400
Message-ID: <66910f2d-a8c0-6c04-cca0-62a00fbad6cf@redhat.com>
References: <20220503162149.1764245-1-longman@redhat.com>
 <20220503162149.1764245-4-longman@redhat.com>
 <20220503175454.GA20433@pauld.bos.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651603361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wAjZbwqar/ddmAXQ+agT5r7ZgOk1RQOfgtbGHsbQLps=;
        b=GcodJl/V4zmfE+roTzDhurHBZnS/cZ5y/z9DXX2/Xo/KuqxRUHHgMm62/u5RftswNUXO6A
        cE4X1qAn3raMvv3ncc9itP9/p0ZrhDCkxTsO3euc6i6Axo5I0ZVbVLs2udqjCRaN57tNS6
        u5HE46gYc6Y4CAHJfgbKVcf3iu0TIYg=
Content-Language: en-US
In-Reply-To: <20220503175454.GA20433@pauld.bos.csb>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Phil Auld <pauld@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 5/3/22 13:54, Phil Auld wrote:
> Hi Waiman
>
> On Tue, May 03, 2022 at 12:21:44PM -0400 Waiman Long wrote:
>> Currently, a partition root cannot have empty "cpuset.cpus.effective".
>> As a result, a parent partition root cannot distribute out all its CPUs
>>   to child partitions with no CPUs left. However in most cases, there
>> shouldn't be any tasks associated with intermediate nodes of the default
>>   hierarchy. So the current rule is too restrictive and can waste valuable
>>   CPU resource.
>>
>> To address this issue, we are now allowing a partition to have empty
>> "cpuset.cpus.effective" as long as it has no task. Therefore, a parent
>> partition with no task can now have all its CPUs distributed out to its
>> child partitions. The top cpuset always have some house-keeping tasks
>> running and so its list of effective cpu can't never be empty.
> s/never/ever/
It is a double negative. I think I will just remove "never".
>> Once a partition with empty "cpuset.cpus.effective" is formed, no
>> new task can be moved into it until "cpuset.cpus.effective" becomes
>> non-empty.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c | 111 +++++++++++++++++++++++++++++++----------
>>   1 file changed, 84 insertions(+), 27 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index d156a39d7a08..7d9abd50a1b9 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -412,6 +412,41 @@ static inline bool is_in_v2_mode(void)
>>   	      (cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE);
>>   }
>>   
>> +/**
>> + * partition_is_populated - check if partition has tasks
>> + * @cs: partition root to be checked
>> + * @excluded_child: a child cpuset to be excluded in task checking
>> + * Return: true if there are tasks, false otherwise
>> + *
>> + * It is assumed that @cs is a valid partition root. @excluded_child should
>> + * be non-NULL when this cpuset is going to become a partition itself.
>> + */
>> +static inline bool partition_is_populated(struct cpuset *cs,
>> +					  struct cpuset *excluded_child)
>> +{
>> +	struct cgroup_subsys_state *css;
>> +	struct cpuset *child;
>> +
>> +	if (cs->css.cgroup->nr_populated_csets)
>> +		return true;
>> +	if (!excluded_child && !cs->nr_subparts_cpus)
>> +		return cgroup_is_populated(cs->css.cgroup);
>> +
>> +	rcu_read_lock();
>> +	cpuset_for_each_child(child, css, cs) {
>> +		if (child == excluded_child)
>> +			continue;
>> +		if (is_partition_valid(child))
>> +			continue;
>> +		if (cgroup_is_populated(child->css.cgroup)) {
>> +			rcu_read_unlock();
>> +			return true;
>> +		}
>> +	}
>> +	rcu_read_unlock();
>> +	return false;
>> +}
>> +
>>   /*
>>    * Return in pmask the portion of a task's cpusets's cpus_allowed that
>>    * are online and are capable of running the task.  If none are found,
>> @@ -1252,22 +1287,25 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
>>   	if ((cmd != partcmd_update) && css_has_online_children(&cs->css))
>>   		return -EBUSY;
>>   
>> -	/*
>> -	 * Enabling partition root is not allowed if not all the CPUs
>> -	 * can be granted from parent's effective_cpus or at least one
>> -	 * CPU will be left after that.
>> -	 */
>> -	if ((cmd == partcmd_enable) &&
>> -	   (!cpumask_subset(cs->cpus_allowed, parent->effective_cpus) ||
>> -	     cpumask_equal(cs->cpus_allowed, parent->effective_cpus)))
>> -		return -EINVAL;
>> -
>> -	/*
>> -	 * A cpumask update cannot make parent's effective_cpus become empty.
>> -	 */
>>   	adding = deleting = false;
>>   	old_prs = new_prs = cs->partition_root_state;
>>   	if (cmd == partcmd_enable) {
>> +		/*
>> +		 * Enabling partition root is not allowed if not all the CPUs
>> +		 * can be granted from parent's effective_cpus.
>> +		 */
>> +		if (!cpumask_subset(cs->cpus_allowed, parent->effective_cpus))
>> +			return -EINVAL;
>> +
>> +		/*
>> +		 * A parent can be left with no CPU as long as there is no
>> +		 * task directly associated with the parent partition. For
>> +		 * such a parent, no new task can be moved into it.
>> +		 */
>> +		if (partition_is_populated(parent, cs) &&
>> +		    cpumask_equal(cs->cpus_allowed, parent->effective_cpus))
>> +			return -EINVAL;
>> +
> You might consider switching these around to check the cpumasks first.
Good point, partition_is_populated() is more expensive.
>
>
>>   		cpumask_copy(tmp->addmask, cs->cpus_allowed);
>>   		adding = true;
>>   	} else if (cmd == partcmd_disable) {
>> @@ -1289,9 +1327,10 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
>>   		adding = cpumask_andnot(tmp->addmask, tmp->addmask,
>>   					parent->subparts_cpus);
>>   		/*
>> -		 * Return error if the new effective_cpus could become empty.
>> +		 * Return error if the new effective_cpus could become empty
>> +		 * and there are tasks in the parent.
>>   		 */
>> -		if (adding &&
>> +		if (adding && partition_is_populated(parent, cs) &&
>>   		    cpumask_equal(parent->effective_cpus, tmp->addmask)) {
> Same.
Thanks,
Longman

