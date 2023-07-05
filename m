From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: simplify the percpu kthreads check in
 update_tasks_cpumask()
Date: Wed, 5 Jul 2023 13:56:02 +0800
Message-ID: <33c2bf85-6def-fce9-9ea7-3b3e80db67b7@huawei.com>
References: <20230704113049.1019118-1-linmiaohe@huawei.com>
 <bc8202fd-a31c-2b08-bd01-8b5868aab230@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bc8202fd-a31c-2b08-bd01-8b5868aab230-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On 2023/7/5 11:14, Waiman Long wrote:
> On 7/4/23 07:30, Miaohe Lin wrote:
>> kthread_is_per_cpu() can be called directly without checking whether
>> PF_KTHREAD is set in task->flags. So remove PF_KTHREAD check to make
>> code more concise.
>>
>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>   kernel/cgroup/cpuset.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 58e6f18f01c1..601c40da8e03 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1230,7 +1230,7 @@ static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
>>               /*
>>                * Percpu kthreads in top_cpuset are ignored
>>                */
>> -            if ((task->flags & PF_KTHREAD) && kthread_is_per_cpu(task))
>> +            if (kthread_is_per_cpu(task))
>>                   continue;
>>               cpumask_andnot(new_cpus, possible_mask, cs->subparts_cpus);
>>           } else {
> 
> The initial intention was to ignore only percpu kthreads. The current code likely ignore all the kthreads. Removing the PF_KTHREAD flag, however, may introduce unexpected regression at this point. I would like to hold off for now until more investigation are done.

IMHO, the current code will ignore only percpu kthreads:
  1.If PF_KTHREAD is set in task->flags, this patch doesn't make any difference.
  2.If PF_KTHREAD is not set in task->flags, kthread_is_per_cpu will *always return false*. So this patch doesn't make any functional change.

    bool kthread_is_per_cpu(struct task_struct *p)
    {
        struct kthread *kthread = __to_kthread(p);
	if (!kthread)
		return false;
        ....
    }

    static inline struct kthread *__to_kthread(struct task_struct *p)
    {
	void *kthread = p->worker_private;
	if (kthread && !(p->flags & PF_KTHREAD))
			 ^^^^^^^^^^^^^^^^^^^^^^
			 PF_KTHREAD is not set, so kthread = NULL.
		kthread = NULL;
	return kthread;
    }

Or am I miss something? Thanks for comment and review.

