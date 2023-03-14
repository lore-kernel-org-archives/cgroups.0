From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup/cpuset: Include offline CPUs when tasks'
 cpumasks in top_cpuset are updated
Date: Tue, 14 Mar 2023 15:02:53 -0400
Message-ID: <957bd5c2-1bae-de95-f119-483ef64dab60@redhat.com>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230306200849.376804-3-longman@redhat.com>
 <20230314173411.fqaxoa2tfifnj6i3@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678820580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UyKkF4M/yJ9pQotECcNeo3lMpmEkLTF8MPG6ILIYAd0=;
        b=ZSPLpLEuPfvGPpttX6+rdi3jkxESMz0kbKvUFTjC+lHzkx0R7+E8csjwTcsBWxRVUbbJKw
        hOlV5Nl4ND4Ir/vI7rnn0kfvA7yLThL/rj0tMUG4SL2T87jU3efnB2H6K8dCMejV3ma3He
        HAkzzOtkITAY/KW8wP/Wx+18B96Uos8=
Content-Language: en-US
In-Reply-To: <20230314173411.fqaxoa2tfifnj6i3@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 3/14/23 13:34, Michal Koutný wrote:
> Hello Waiman.
>
> On Mon, Mar 06, 2023 at 03:08:46PM -0500, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> -		/*
>> -		 * Percpu kthreads in top_cpuset are ignored
>> -		 */
>> -		if (top_cs && (task->flags & PF_KTHREAD) &&
>> -		    kthread_is_per_cpu(task))
>> -			continue;
>> +		const struct cpumask *possible_mask = task_cpu_possible_mask(task);
>>   
>> -		cpumask_and(new_cpus, cs->effective_cpus,
>> -			    task_cpu_possible_mask(task));
>> +		if (top_cs) {
>> +			/*
>> +			 * Percpu kthreads in top_cpuset are ignored
>> +			 */
>> +			if ((task->flags & PF_KTHREAD) && kthread_is_per_cpu(task))
>> +				continue;
>> +			cpumask_andnot(new_cpus, possible_mask, cs->subparts_cpus);
>> +		} else {
>> +			cpumask_and(new_cpus, cs->effective_cpus, possible_mask);
>> +		}
> I'm wrapping my head around this slightly.
> 1) I'd suggest swapping args in of cpumask_and() to have possible_mask
>     consistently first.
I don't quite understand what you meant by "swapping args". It is 
effective new_cpus = cs->effective_cpus ∩ possible_mask. What is the 
point of swapping cs->effective_cpus and possible_mask.
> 2) Then I'm wondering whether two branches are truly different when
>     effective_cpus := cpus_allowed - subparts_cpus
>     top_cpuset.cpus_allowed == possible_mask        (1)
effective_cpus may not be equal "cpus_allowed - subparts_cpus" if some 
of the CPUs are offline as effective_cpus contains only online CPUs. 
subparts_cpu can include offline cpus too. That is why I choose that 
expression. I will add a comment to clarify that.
>
> IOW, can you see a difference in what affinities are set to eligible
> top_cpuset tasks before and after this patch upon CPU hotplug?
> (Hm, (1) holds only in v2. So is this a fix for v1 only?)

This is due to the fact that cpu hotplug code currently doesn't update 
the cpu affinity of tasks in the top cpuset. Tasks not in the top cpuset 
can rely on the hotplug code to update the cpu affinity appropriately. 
For the tasks in the top cpuset, we have to make sure that all the 
offline CPUs are included.

Cheers,
Longman

