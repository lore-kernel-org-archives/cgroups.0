From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Optimize update_tasks_nodemask()
Date: Fri, 25 Nov 2022 10:14:19 +0800
Message-ID: <0f86b2d7-d197-574b-ded9-4af1c074a658@shopee.com>
References: <20221123082157.71326-1-haifeng.xu@shopee.com>
 <2ac6f207-e08a-2a7f-01ae-dfaf15eefaf6@redhat.com>
 <4de8821b-e0c0-bf63-4d76-b0ce208cce3b@shopee.com>
 <dfcbffb9-b58a-6d25-2174-39394eb0ccde@redhat.com>
 <21e73dad-c6d0-21ea-dcdf-355b71c8537b@shopee.com>
 <1a997ea7-bb63-1710-14d6-c3b88a22bdb3@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Br3OQZtK3UyZAW9R8ObAHLEhWzoDHHFos/UBtSFV900=;
        b=VlOUoJLPcGXo16QybyechvkdHIW1n/Wr/6u2etJiej/LPYuhMI3n8fkAKNy6arGeeo
         slRp9jjohJj41PLviufLIT0F6mjV9LmETthn5KWAZ69XbaquBfzdaG6p1+R+mVsnvkEc
         +wcGgBSMmy1ikMmuM+silTE1Ar4TuYOrObGmx2gEpodCEW2Tjigbn2hD3e2J7ZB+P5OD
         4r5KU6LMV3JzC7RupMVZHwE4Jzu0D+boNaoPhUs/kjQsRckhwJT6e+fVmY0jhecvwW1W
         +Gy7wj4RYbwT8abd0AXG3vptH4eEJyOmm+qSkY5Y36HuKyqrENFHCNIKZBB0jLzbrkXK
         Rcdw==
In-Reply-To: <1a997ea7-bb63-1710-14d6-c3b88a22bdb3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2022/11/25 07:00, Waiman Long wrote:
> On 11/24/22 02:49, Haifeng Xu wrote:
>>
>> On 2022/11/24 12:24, Waiman Long wrote:
>>> On 11/23/22 22:33, Haifeng Xu wrote:
>>>> On 2022/11/24 04:23, Waiman Long wrote:
>>>>> On 11/23/22 03:21, haifeng.xu wrote:
>>>>>> When change the 'cpuset.mems' under some cgroup, system will hung
>>>>>> for a long time. From the dmesg, many processes or theads are
>>>>>> stuck in fork/exit. The reason is show as follows.
>>>>>>
>>>>>> thread A:
>>>>>> cpuset_write_resmask /* takes cpuset_rwsem */
>>>>>>      ...
>>>>>>        update_tasks_nodemask
>>>>>>          mpol_rebind_mm /* waits mmap_lock */
>>>>>>
>>>>>> thread B:
>>>>>> worker_thread
>>>>>>      ...
>>>>>>        cpuset_migrate_mm_workfn
>>>>>>          do_migrate_pages /* takes mmap_lock */
>>>>>>
>>>>>> thread C:
>>>>>> cgroup_procs_write /* takes cgroup_mutex and
>>>>>> cgroup_threadgroup_rwsem */
>>>>>>      ...
>>>>>>        cpuset_can_attach
>>>>>>          percpu_down_write /* waits cpuset_rwsem */
>>>>>>
>>>>>> Once update the nodemasks of cpuset, thread A wakes up thread B to
>>>>>> migrate mm. But when thread A iterates through all tasks, including
>>>>>> child threads and group leader, it has to wait the mmap_lock which
>>>>>> has been take by thread B. Unfortunately, thread C wants to migrate
>>>>>> tasks into cgroup at this moment, it must wait thread A to release
>>>>>> cpuset_rwsem. If thread B spends much time to migrate mm, the
>>>>>> fork/exit which acquire cgroup_threadgroup_rwsem also need to
>>>>>> wait for a long time.
>>>>>>
>>>>>> There is no need to migrate the mm of child threads which is
>>>>>> shared with group leader. Just iterate through the group
>>>>>> leader only.
>>>>>>
>>>>>> Signed-off-by: haifeng.xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
>>>>>> ---
>>>>>>     kernel/cgroup/cpuset.c | 3 +++
>>>>>>     1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>>>>> index 589827ccda8b..43cbd09546d0 100644
>>>>>> --- a/kernel/cgroup/cpuset.c
>>>>>> +++ b/kernel/cgroup/cpuset.c
>>>>>> @@ -1968,6 +1968,9 @@ static void update_tasks_nodemask(struct cpuset
>>>>>> *cs)
>>>>>>               cpuset_change_task_nodemask(task, &newmems);
>>>>>>     +        if (!thread_group_leader(task))
>>>>>> +            continue;
>>>>>> +
>>>>>>             mm = get_task_mm(task);
>>>>>>             if (!mm)
>>>>>>                 continue;
>>>>> Could you try the attached test patch to see if it can fix your
>>>>> problem?
>>>>> Something along the line of this patch will be more acceptable.
>>>>>
>>>>> Thanks,
>>>>> Longman
>>>>>
>>>> Hi, Longman.
>>>> Thanks for your patch, but there are still some problems.
>>>>
>>>> 1）
>>>>     (group leader, node: 0,1)
>>>>            cgroup0
>>>>            /     \
>>>>           /       \
>>>>       cgroup1   cgroup2
>>>>      (threads)  (threads)
>>>>
>>>> If set node 0 in cgroup1 and node 1 in cgroup2, both of them will
>>>> update
>>>> the mm. And the nodemask of mm depends on who set the node last.
>>> Yes, that is the existing behavior. It was not that well defined in the
>>> past and so it is somewhat ambiguous as to what we need to do about it.
>>>
>> The test patch works if the child threads are in same cpuset with group
>> leader which has same logic with my patch. But if they are in different
>> cpusets, the test patch will fail because the contention of mmap_lock
>> still exsits and seems similar to the original logic.
> 
> That is true. I am thinking about adding a nodemask to mm_struct so that
> we can figure out if we need to propagate the changes down to all the
> VMAs and do the migration. That will enable us to avoid doing wasteful
> work.
> 
> Current node mask handling isn't that efficient especially for distros
> that have a relatively large NODES_SHIFT value. Some work may also be
> need in this area.
> 
>>> BTW, cgroup1 has a memory_migrate flag which will force page migration
>>> if set. I guess you may have it set in your case as it will introduce a
>>> lot more delay as page migration takes time. That is probably the reason
>>> why you are seeing a long delay. So one possible solution is to turn
>>> this flag off. Cgroup v2 doesn't have this flag.
>>>
>> Dou you mean 'CS_MEMORY_MIGRATE'? This flag can be turn off in Cgroup
>> v1, but it has been set in Cgroup v2 (cpuset_css_alloc) in default and
>> couldn't be changed.
> You are right. Cgroup v2 has CS_MEMORY_MIGRATE enabled by default and
> can't be turned off.
>>
>>>> 2）
>>>>      (process, node: 0,1)
>>>>            cgroup0
>>>>            /     \
>>>>           /       \
>>>>       cgroup1   cgroup2
>>>>      (node: 0)  (node: 1)
>>>>
>>>> If migrate thread from cgroup0 to cgroup1 or cgroup2, cpuset_attach
>>>> won't update the mm. So the nodemask of thread, including mems_allowed
>>>> and mempolicy（updated in cpuset_change_task_nodemask）, is different
>>>> from
>>>> the vm_policy in vma(updated in mpol_rebind_mm).
>>> Yes, that can be the case.
>>>
>>>>
>>>> In a word, if threads have different cpusets with different
>>>> nodemask, it
>>>> will cause inconsistent memory behavior.
>>> So do you have suggestion of what we need to do going forward?
>> Should we prevent thread from migrating to those cgroups which have
>> different nodemask with the cgroup that contains the group leader?
>>
>> In addition, the group leader and child threads should be in same cgroup
>> tree, also the level of cgroup containes group leader must be higher
>> than these cgroups contain child threads, so update_nodemask will work.
>>
>> Or just disable thread migration in cpuset？It's easy to achieve but will
>> affect cpu bind.
> 
> As said above, my current inclination is to add a nodemask to mm_struct
> and revise the way nodemask is being handled. That will take some time>
> Cheers,
> Longman
> 

OK, thanks.
