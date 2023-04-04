From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: oom: introduce cpuset oom
Date: Tue, 4 Apr 2023 13:24:03 -0400
Message-ID: <342c1967-8a68-275c-042e-765d5993157c@redhat.com>
References: <20230404115509.14299-1-ligang.bdlg@bytedance.com>
 <ZCw0sR6IqYa5Es7Q@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680629235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+yJ2HBFPQ7R/vP49e1zoV0yoKAMKg83JKUSNAzQmCY=;
        b=FB9m9UcPKN8UZP1jbyjg0t2VF79UGUH1n7Pa0+OkNDbsylYV6hf9HuzEVjRZBYGtdsrxJU
        y9w/DJpbtUcOBuZEl8v74Yf/zDGM4effnRW1SZJbIZ1dwu+fNL15VqTKiEJ6UAREeVWrjs
        9VAGZbbQ0S2v8yEwWLuBS21GVQjCwTI=
Content-Language: en-US
In-Reply-To: <ZCw0sR6IqYa5Es7Q-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 4/4/23 10:31, Michal Hocko wrote:
> [CC cpuset people]
>
> On Tue 04-04-23 19:55:09, Gang Li wrote:
>> When a process in cpuset triggers oom, it may kill a completely
>> irrelevant process on another numa node, which will not release any
>> memory for this cpuset.
>>
>> It seems that `CONSTRAINT_CPUSET` is not really doing much these
>> days. Using CONSTRAINT_CPUSET, we can easily achieve node aware oom
>> by selecting victim from all cpusets with the same mems_allowed as
>> the current cpuset.
> This should go into more details about the usecase, testing and ideally
> also spend couple of words about how CONSTRAINT_CPUSET is actually
> implemented because this is not really immediately obvious. An example
> of before/after behavior would have been really nice as well.
>
> You should also go into much more details about how oom victims are
> actually evaluated.
>
>> Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>> Signed-off-by: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>> ---
>> Changes in v2:
>> - Select victim from all cpusets with the same mems_allowed as the current cpuset.
>>    (David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>)
>>
>> v1:
>> - https://lore.kernel.org/all/20220921064710.89663-1-ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
>>
>> ---
>>   include/linux/cpuset.h |  6 ++++++
>>   kernel/cgroup/cpuset.c | 28 ++++++++++++++++++++++++++++
>>   mm/oom_kill.c          |  4 ++++
>>   3 files changed, 38 insertions(+)
> As this is a userspace visible change it should also be documented
> somewhere  in Documentation.
>
> I am not really familiar with cpusets internals so I cannot really judge
> cpuset_cgroup_scan_tasks implementation.
>
> The oom report should be explicit about this being CPUSET specific oom
> handling so unexpected behavior could be nailed down to this change so I
> do not see a major concern from the oom POV. Nevertheless it would be
> still good to consider whether this should be an opt-in behavior. I
> personally do not see a major problem because most cpuset deployments I
> have seen tend to be well partitioned so the new behavior makes more
> sense.
>
>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
>> index 980b76a1237e..fc244141bd52 100644
>> --- a/include/linux/cpuset.h
>> +++ b/include/linux/cpuset.h
>> @@ -171,6 +171,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
>>   	task_unlock(current);
>>   }
>>   
>> +int cpuset_cgroup_scan_tasks(int (*fn)(struct task_struct *, void *), void *arg);
>> +
>>   #else /* !CONFIG_CPUSETS */
>>   
>>   static inline bool cpusets_enabled(void) { return false; }
>> @@ -287,6 +289,10 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
>>   	return false;
>>   }
>>   
>> +static inline int cpuset_cgroup_scan_tasks(int (*fn)(struct task_struct *, void *), void *arg)
>> +{
>> +	return 0;
>> +}
>>   #endif /* !CONFIG_CPUSETS */
>>   
>>   #endif /* _LINUX_CPUSET_H */
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index bc4dcfd7bee5..b009c98ca19e 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -4013,6 +4013,34 @@ void cpuset_print_current_mems_allowed(void)
>>   	rcu_read_unlock();
>>   }
>>   
>> +int cpuset_cgroup_scan_tasks(int (*fn)(struct task_struct *, void *), void *arg)
>> +{
>> +	int ret = 0;
>> +	struct css_task_iter it;
>> +	struct task_struct *task;
>> +	struct cpuset *cs;
>> +	struct cgroup_subsys_state *pos_css;
>> +
>> +	/*
>> +	 * Situation gets complex with overlapping nodemasks in different cpusets.
>> +	 * TODO: Maybe we should calculate the "distance" between different mems_allowed.
>> +	 *
>> +	 * But for now, let's make it simple. Just iterate through all cpusets
>> +	 * with the same mems_allowed as the current cpuset.
>> +	 */
>> +	rcu_read_lock();
>> +	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
>> +		if (nodes_equal(cs->mems_allowed, task_cs(current)->mems_allowed)) {
>> +			css_task_iter_start(&(cs->css), CSS_TASK_ITER_PROCS, &it);
>> +			while (!ret && (task = css_task_iter_next(&it)))
>> +				ret = fn(task, arg);
>> +			css_task_iter_end(&it);
>> +		}
>> +	}
>> +	rcu_read_unlock();
>> +	return ret;
>> +}

You will also need to take cpuset_rwsem to make sure that cpusets are 
stable. BTW, the cpuset_cgroup_scan_tasks() name is kind of redundant. I 
will suggest you just name it as cpuset_scan_tasks(). Please also add a 
doctext comment about its purpose and how it should be used.

Cheers,
Longman

