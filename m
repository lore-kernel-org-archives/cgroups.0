From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] cgroup/cpuset: Find another usable CPU if none found
 in current cpuset
Date: Tue, 14 Mar 2023 16:22:06 -0400
Message-ID: <58a1a878-fa0b-285d-3e43-2b5103d3c770@redhat.com>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230306200849.376804-4-longman@redhat.com>
 <20230314181749.5b4k6selbgdhl3up@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678825331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bbs0o/I6rpn+v4ABnfsXhv4qYHU4BQjlxXMhiiFts7A=;
        b=VRmntmaIh9tm+Him4nl0k/Tm+onrRuFosACMkLtxiDSEr5oYnzZg/BgNnlzNCf/9e8/O6R
        BMQVUBQsKFYJdXYeruawq5mx2KC9R9Wuyh3lsX13q3laKWWqACnoKJ/vx5Sjo27YQ7xBgt
        b5z105/85e10mVnCmSKtC8tPfeEQHiU=
Content-Language: en-US
In-Reply-To: <20230314181749.5b4k6selbgdhl3up@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 3/14/23 14:17, Michal Koutný wrote:
> Hello.
>
> On Mon, Mar 06, 2023 at 03:08:47PM -0500, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On a system with asymmetric CPUs, a restricted task is one that can run
>> only a selected subset of available CPUs.  When a CPU goes offline or
>> when "cpuset.cpus" is changed, it is possible that a restricted task
>> may not have any runnable CPUs left in the current cpuset even if there
>> is still some CPUs in effective_cpus. In this case, the restricted task
>> cannot be run at all.
>>
>> There are several ways we may be able to handle this situation. Treating
>> it like empty effective_cpus is probably too disruptive and is unfair to
>> the normal tasks. So it is better to have some special handling for these
>> restricted tasks. One possibility is to move the restricted tasks up the
>> cpuset hierarchy, but it is tricky to do it right. Another solution is
>> to assign other usable CPUs to these tasks. This patch implements the
>> later alternative by finding one usable CPU by walking up the cpuset
>> hierarchy and printing an informational message to let the users know
>> that these restricted tasks are running in a cpuset with no usable CPU.
>>
>> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>   kernel/cgroup/cpuset.c | 56 +++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 55 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index bbf57dcb2f68..aa8225daf1d3 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1202,6 +1202,38 @@ void rebuild_sched_domains(void)
>>   	cpus_read_unlock();
>>   }
>>   
>> [...]
>>   /**
>>    * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
>>    * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
>> @@ -1218,6 +1250,7 @@ static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
>>   	struct task_struct *task;
>>   	bool top_cs = cs == &top_cpuset;
>>   
>> +	percpu_rwsem_assert_held(&cpuset_rwsem);
>>   	css_task_iter_start(&cs->css, 0, &it);
>>   	while ((task = css_task_iter_next(&it))) {
>>   		const struct cpumask *possible_mask = task_cpu_possible_mask(task);
>> @@ -1232,7 +1265,28 @@ static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
>>   		} else {
>>   			cpumask_and(new_cpus, cs->effective_cpus, possible_mask);
>>   		}
>> -		set_cpus_allowed_ptr(task, new_cpus);
>> +		/*
>> +		 * On systems with assymetric CPUs, it is possible that
>> +		 * cpumask will become empty or set_cpus_allowed_ptr() will
>> +		 * return an error even if we still have CPUs in
>> +		 * effective_cpus. In this case, we find a usable CPU walking
>> +		 * up the cpuset hierarchy and use that for this particular
>> +		 * task with an informational message about the change in the
>> +		 * hope that the users will adjust "cpuset.cpus" accordingly.
>> +		 */
>> +		if (cpumask_empty(new_cpus) ||
>> +		    set_cpus_allowed_ptr(task, new_cpus)) {
> IIUC, cpumask_empty(new_cpus) here implies
> cpumask_empty(cs->effective_cpus) but that shouldn't happen (cs should
> inherit non-empty mask from an ancestor). Do I miss/forget anything?
>
> This thus covers the case when p->user_cpus_ptr is incompatible with
> hotplug or cpuset.cpus allowance and a different affinity must be
> chosen. But doesn't that mean that the task would run _out_ of
> cs->effective_cpus?
> I guess that's unavoidable on asymmetric CPU archs but not no SMPs.
> Shouldn't the solution distinguish between the two? (I.e. never run out
> of effective_cpus on SMP.)

Some arm64 systems can have asymmetric CPUs where certain tasks are only 
runnable on a selected subset of CPUs.  This information is not captured 
in the cpuset. As a result, task_cpu_possible_mask() may return a mask 
that have no overlap with effective_cpus causing new_cpus to become 
empty. It takes me a while to understand the implication of that. I will 
elaborate this point a bit more in the patch.

Cheers,
Longman

