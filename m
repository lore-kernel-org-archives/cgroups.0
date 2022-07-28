From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Keep current cpus list if cpus
 affinity was explicitly set
Date: Thu, 28 Jul 2022 14:57:28 -0400
Message-ID: <1ae1cc6c-dca9-4958-6b22-24a5777c5e8d@redhat.com>
References: <20220728005815.1715522-1-longman@redhat.com>
 <YuLF+xXaCzwWi2BR@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659034655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fjIYWUhlmn952PQamHyhfurxBgzciXNRkjegJKiOJW4=;
        b=PcCi3gU55ywwQ9YonL0ILXdb0EOs5LWocH3kKjiDfvUvvLEN02PCPfshU72Ex0TugBiit8
        2z5bCNICnrybAASirJGMfJahvnq46AQrz059TAN+b50PXecOr+BhqtLn5jWRhQucdGTKUx
        6N41JdkvgzLpwC4nzOkmujBAFB+53h8=
Content-Language: en-US
In-Reply-To: <YuLF+xXaCzwWi2BR@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 7/28/22 13:23, Tejun Heo wrote:
> Hello,
>
> On Wed, Jul 27, 2022 at 08:58:14PM -0400, Waiman Long wrote:
>> It was found that any change to the current cpuset hierarchy may reset
>> the cpus_allowed list of the tasks in the affected cpusets to the
>> default cpuset value even if those tasks have cpus affinity explicitly
>> set by the users before. That is especially easy to trigger under a
>> cgroup v2 environment where writing "+cpuset" to the root cgroup's
>> cgroup.subtree_control file will reset the cpus affinity of all the
>> processes in the system.
>>
>> That is especially problematic in a nohz_full environment where the
>> tasks running in the nohz_full CPUs usually have their cpus affinity
>> explicitly set and will behave incorrectly if cpus affinity changes.
>>
>> Fix this problem by adding a flag in the task structure to indicate that
>> a task has their cpus affinity explicitly set before and make cpuset
>> code not to change their cpus_allowed list unless the user chosen cpu
>> list is no longer a subset of the cpus_allowed list of the cpuset itself.
>>
>> With that change in place, it was verified that tasks that have its
>> cpus affinity explicitly set will not be affected by changes made to
>> the v2 cgroup.subtree_control files.
> I think the underlying cause here is cpuset overwriting the cpumask the user
> configured but that's a longer discussion.
>
>> +/*
>> + * Don't change the cpus_allowed list if cpus affinity has been explicitly
>> + * set before unless the current cpu list is not a subset of the new cpu list.
>> + */
>> +static int cpuset_set_cpus_allowed_ptr(struct task_struct *p,
>> +				       const struct cpumask *new_mask)
>> +{
>> +	if (p->cpus_affinity_set && cpumask_subset(p->cpus_ptr, new_mask))
>> +		return 0;
>> +
>> +	p->cpus_affinity_set = 0;
>> +	return set_cpus_allowed_ptr(p, new_mask);
>> +}
> I wonder whether the more predictable behavior would be always not resetting
> the cpumask if it's a subset of the new_mask.
There can be a counter argument that if a user found out that there is 
not enough cpus in a cpuset to meet its performance target, one can 
always increase the number of cpus in the cpuset. Generalizing this 
behavior to all the tasks irrespective if they have explicitly set cpus 
affinity before will disallow this use case.
> Also, shouldn't this check
> p->cpus_mask instead of p->cpus_ptr?

You are right. I should have used cpus_mask instead. Will send out a v2.

Cheers,
Longman

