From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/1] cgroup/cpuset: Rebuild sched domains if isolated
 partition changed
Date: Mon, 18 Sep 2023 09:47:02 -0400
Message-ID: <e4e9505d-f55c-5047-5686-40cd49742d45@redhat.com>
References: <20230915154505.363754-1-pierre.gondois@arm.com>
 <20230915154505.363754-2-pierre.gondois@arm.com>
 <5e513c72-7198-a55e-6e2b-a811d5529284@redhat.com>
 <9777f0d2-2fdf-41cb-bd01-19c52939ef42@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695055813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nnaf/+YZv/hYci2QoG7tyRLioIFXko+bbyYD+KlJj7w=;
        b=Zog+F6Rx+b1dc3Pdx17YeVyGmDpjJr95U3u38ctwVYtFK0Ae0RkwF0VSaJNxG2byLMiv2x
        ZxaHCg0euZUzl2ErrqFuePvvisSJRpCHGXJuXJkPUi1/eEwcLgnblNoQY5E7z4W479IzsD
        dQOq6BFvspy2hpoHEihsCq0yX2eGEPI=
Content-Language: en-US
In-Reply-To: <9777f0d2-2fdf-41cb-bd01-19c52939ef42@arm.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Pierre Gondois <pierre.gondois@arm.com>, linux-kernel@vger.kernel.org
Cc: rui.zhang@intel.com, aaron.lu@intel.com, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

On 9/18/23 03:07, Pierre Gondois wrote:
> Hello Longman,
>
> On 9/17/23 18:51, Waiman Long wrote:
>> On 9/15/23 11:45, Pierre Gondois wrote:
>>> When an isolated parition is created, the sched domains (sds) are
>>> rebuilt and the sds of the isolated CPUs are detached. This only
>>> happens at the creation of the isolated parition. Updating
>>> the cpuset of the partition doesn't rebuild the sds:
>>>
>>> To reproduce:
>>>     # ls /sys/kernel/debug/sched/domains/cpu0/
>>>     domain0
>>>     # ls /sys/kernel/debug/sched/domains/cpu1/
>>>     domain0
>>>     #
>>>     # mkdir cgroup
>>>     # mount -t cgroup2 none cgroup/
>>>     # mkdir cgroup/A1/
>>>     # echo "+cpuset" > cgroup/cgroup.subtree_control
>>>     # echo 0-3 > cgroup/A1/cpuset.cpus
>>>     # echo isolated > cgroup/A1/cpuset.cpus.partition
>>>     #
>>>     # ls /sys/kernel/debug/sched/domains/cpu0/
>>>     # ls /sys/kernel/debug/sched/domains/cpu1/
>>>     #
>>>     # echo 0 > cgroup/A1/cpuset.cpus
>>>     # ls /sys/kernel/debug/sched/domains/cpu0/
>>>     # ls /sys/kernel/debug/sched/domains/cpu1/
>>>     #
>>>
>>> Here CPU1 should have a sched domain re-attached.
>>>
>>> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
>>> ---
>>>    kernel/cgroup/cpuset.c | 12 ++++++++----
>>>    1 file changed, 8 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index 58e6f18f01c1..e3eb27ff9b68 100644
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -1680,11 +1680,15 @@ static void update_cpumasks_hier(struct 
>>> cpuset *cs, struct tmpmasks *tmp,
>>>             * empty cpuset is changed, we need to rebuild sched 
>>> domains.
>>>             * On default hierarchy, the cpuset needs to be a partition
>>>             * root as well.
>>> +         * Also rebuild sched domains if the cpuset of an isolated
>>> +         * partition changed.
>>>             */
>>> -        if (!cpumask_empty(cp->cpus_allowed) &&
>>> -            is_sched_load_balance(cp) &&
>>> -           (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
>>> -            is_partition_valid(cp)))
>>> +        if ((!cpumask_empty(cp->cpus_allowed) &&
>>> +             is_sched_load_balance(cp) &&
>>> +             (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
>>> +              is_partition_valid(cp))) ||
>>> +            (cp->partition_root_state == PRS_ISOLATED ||
>>> +             cp->partition_root_state == PRS_INVALID_ISOLATED))
>>>                need_rebuild_sched_domains = true;
>>>               rcu_read_lock();
>>
>> Thanks for spotting the problem and sending out a patch to fix it.
>> However, it should be done in the update_cpumask(). The sched_domain
>> rebuild in update_cpumasks_hier() is supposed to be used for impacted
>> descendant cpusets lower down in the hierarchy.
>>
>> Anyway, I believe this problem should have been fixed in commit
>> a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE &
>> CS_SCHED_LOAD_BALANCE handling") recently merged into the v6.6 kernel.
>> Would you mind testing the latest upstream kernel to see if this problem
>> is gone or not?
>
> Yes right, v6.6-rc2 kernel doesn't have this issue. My bad for not 
> updating
> it ...
>
> However I think the second issue described in the cover letter can 
> still be
> reproduced on v6.6-rc2. This present patch was not aiming to fix it 
> though.
>
> Commands:
> # mkdir cgroup
> # mount -t cgroup2 none cgroup/
> # mkdir cgroup/A1 cgroup/B1
> # echo "+cpuset" > cgroup/cgroup.subtree_control
> # echo 0-3 > cgroup/A1/cpuset.cpus
> # echo isolated > cgroup/A1/cpuset.cpus.partition
> # echo 4-6 > cgroup/B1/cpuset.cpus
> # cat cgroup/A1/cpuset.cpus.partition
> isolated
> # echo 0-4 > cgroup/A1/cpuset.cpus
> # cat cgroup/A1/cpuset.cpus.partition
> isolated invalid (Cpu list in cpuset.cpus not exclusive)
> # echo 0-3 > cgroup/A1/cpuset.cpus
> # cat cgroup/A1/cpuset.cpus.partition
> isolated invalid (Cpu list in cpuset.cpus not exclusive)
>
> Cgroup A1 should be a valid isolated partition once its CPUs become
> exclusive again I believe,

Yes, the current code doesn't always detect that an invalid partition 
can be valid again and turn it back on. Will try to fix that. In the 
mean time, a workaround is to do

# echo member > cgroup/A1/cpuset.cpus.partition
# echo isolated > cgroup/A1/cpuset.cpus.partition

Thanks,
Longman

