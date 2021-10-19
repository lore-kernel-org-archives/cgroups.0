From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH memcg 0/1] false global OOM triggered by memcg-limited
 task
Date: Tue, 19 Oct 2021 16:26:50 +0300
Message-ID: <6c422150-593f-f601-8f91-914c6c5e82f4@virtuozzo.com>
References: <9d10df01-0127-fb40-81c3-cc53c9733c3e@virtuozzo.com>
 <YW04jWSv6pQb2Goe@dhcp22.suse.cz>
 <6b751abe-aa52-d1d8-2631-ec471975cc3a@virtuozzo.com>
 <YW1gRz0rTkJrvc4L@dhcp22.suse.cz>
 <339ae4b5-6efd-8fc2-33f1-2eb3aee71cb2@virtuozzo.com>
 <YW6GoZhFUJc1uLYr@dhcp22.suse.cz>
 <687bf489-f7a7-5604-25c5-0c1a09e0905b@virtuozzo.com>
 <YW6yAeAO+TeS3OdB@dhcp22.suse.cz> <YW60Rs1mi24sJmp4@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=/PQsb2dM0oFSPlxvAAc6dyIPl0/QcXaCgaYTwTTHcCo=; b=cZpZJ2mRO3f3GNSKw
        XLAO8S6kyieJLawIdS/gJRQz8yix6idY6Hc/p++bKMFw7d+AijUA1Nc5XPrZqKDIbrtVGT2CGVZZH
        xQEGfdidIGKULnHpY+TzuVwSuLIcwPK4lXaqzVZ4uk5eZL+Dj3zFeCWCM9kABRKqdSOqpGLexHD98
        =;
In-Reply-To: <YW60Rs1mi24sJmp4-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 19.10.2021 15:04, Michal Hocko wrote:
> On Tue 19-10-21 13:54:42, Michal Hocko wrote:
>> On Tue 19-10-21 13:30:06, Vasily Averin wrote:
>>> On 19.10.2021 11:49, Michal Hocko wrote:
>>>> On Tue 19-10-21 09:30:18, Vasily Averin wrote:
>>>> [...]
>>>>> With my patch ("memcg: prohibit unconditional exceeding the limit of dying tasks") try_charge_memcg() can fail:
>>>>> a) due to fatal signal
>>>>> b) when mem_cgroup_oom -> mem_cgroup_out_of_memory -> out_of_memory() returns false (when select_bad_process() found nothing)
>>>>>
>>>>> To handle a) we can follow to your suggestion and skip excution of out_of_memory() in pagefault_out_of memory()
>>>>> To handle b) we can go to retry: if mem_cgroup_oom() return OOM_FAILED.
>>>
>>>> How is b) possible without current being killed? Do we allow remote
>>>> charging?
>>>
>>> out_of_memory for memcg_oom
>>>  select_bad_process
>>>   mem_cgroup_scan_tasks
>>>    oom_evaluate_task
>>>     oom_badness
>>>
>>>         /*
>>>          * Do not even consider tasks which are explicitly marked oom
>>>          * unkillable or have been already oom reaped or the are in
>>>          * the middle of vfork
>>>          */
>>>         adj = (long)p->signal->oom_score_adj;
>>>         if (adj == OOM_SCORE_ADJ_MIN ||
>>>                         test_bit(MMF_OOM_SKIP, &p->mm->flags) ||
>>>                         in_vfork(p)) {
>>>                 task_unlock(p);
>>>                 return LONG_MIN;
>>>         }
>>>
>>> This time we handle userspace page fault, so we cannot be kenrel thread,
>>> and cannot be in_vfork().
>>> However task can be marked as oom unkillable, 
>>> i.e. have p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN
>>
>> You are right. I am not sure there is a way out of this though. The task
>> can only retry for ever in this case. There is nothing actionable here.
>> We cannot kill the task and there is no other way to release the memory.
> 
> Btw. don't we force the charge in that case?

We should force charge for allocation from inside page fault handler,
to prevent endless cycle in retried page faults.
However we should not do it for allocations from task context,
to prevent memcg-limited vmalloc-eaters from to consume all host memory.

Also I would like to return to the following hunk.
@@ -1575,7 +1575,7 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * A few threads which were not waiting at mutex_lock_killable() can
 	 * fail to bail out. Therefore, check again after holding oom_lock.
 	 */
-	ret = should_force_charge() || out_of_memory(&oc);
+	ret = task_is_dying() || out_of_memory(&oc);
 
 unlock:
 	mutex_unlock(&oom_lock);

Now I think it's better to keep task_is_dying() check here.
if task is dying, it is not necessary to push other task to free the memory.
We broke vmalloc cycle already, so it looks like nothing should prevent us
from returning to userspace, handle fatal signal, exit and free the memory.

Thank you,
	Vasily Averin
