From: Pierre Gondois <pierre.gondois-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup/cpuset: Rebuild sched domains if isolated
 partition changed
Date: Mon, 18 Sep 2023 09:07:04 +0200
Message-ID: <9777f0d2-2fdf-41cb-bd01-19c52939ef42@arm.com>
References: <20230915154505.363754-1-pierre.gondois@arm.com>
 <20230915154505.363754-2-pierre.gondois@arm.com>
 <5e513c72-7198-a55e-6e2b-a811d5529284@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <5e513c72-7198-a55e-6e2b-a811d5529284-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, aaron.lu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Longman,

On 9/17/23 18:51, Waiman Long wrote:
> On 9/15/23 11:45, Pierre Gondois wrote:
>> When an isolated parition is created, the sched domains (sds) are
>> rebuilt and the sds of the isolated CPUs are detached. This only
>> happens at the creation of the isolated parition. Updating
>> the cpuset of the partition doesn't rebuild the sds:
>>
>> To reproduce:
>>     # ls /sys/kernel/debug/sched/domains/cpu0/
>>     domain0
>>     # ls /sys/kernel/debug/sched/domains/cpu1/
>>     domain0
>>     #
>>     # mkdir cgroup
>>     # mount -t cgroup2 none cgroup/
>>     # mkdir cgroup/A1/
>>     # echo "+cpuset" > cgroup/cgroup.subtree_control
>>     # echo 0-3 > cgroup/A1/cpuset.cpus
>>     # echo isolated > cgroup/A1/cpuset.cpus.partition
>>     #
>>     # ls /sys/kernel/debug/sched/domains/cpu0/
>>     # ls /sys/kernel/debug/sched/domains/cpu1/
>>     #
>>     # echo 0 > cgroup/A1/cpuset.cpus
>>     # ls /sys/kernel/debug/sched/domains/cpu0/
>>     # ls /sys/kernel/debug/sched/domains/cpu1/
>>     #
>>
>> Here CPU1 should have a sched domain re-attached.
>>
>> Signed-off-by: Pierre Gondois <pierre.gondois-5wv7dgnIgG8@public.gmane.org>
>> ---
>>    kernel/cgroup/cpuset.c | 12 ++++++++----
>>    1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 58e6f18f01c1..e3eb27ff9b68 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -1680,11 +1680,15 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
>>    		 * empty cpuset is changed, we need to rebuild sched domains.
>>    		 * On default hierarchy, the cpuset needs to be a partition
>>    		 * root as well.
>> +		 * Also rebuild sched domains if the cpuset of an isolated
>> +		 * partition changed.
>>    		 */
>> -		if (!cpumask_empty(cp->cpus_allowed) &&
>> -		    is_sched_load_balance(cp) &&
>> -		   (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
>> -		    is_partition_valid(cp)))
>> +		if ((!cpumask_empty(cp->cpus_allowed) &&
>> +		     is_sched_load_balance(cp) &&
>> +		     (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
>> +		      is_partition_valid(cp))) ||
>> +		    (cp->partition_root_state == PRS_ISOLATED ||
>> +		     cp->partition_root_state == PRS_INVALID_ISOLATED))
>>    			need_rebuild_sched_domains = true;
>>    
>>    		rcu_read_lock();
> 
> Thanks for spotting the problem and sending out a patch to fix it.
> However, it should be done in the update_cpumask(). The sched_domain
> rebuild in update_cpumasks_hier() is supposed to be used for impacted
> descendant cpusets lower down in the hierarchy.
> 
> Anyway, I believe this problem should have been fixed in commit
> a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE &
> CS_SCHED_LOAD_BALANCE handling") recently merged into the v6.6 kernel.
> Would you mind testing the latest upstream kernel to see if this problem
> is gone or not?

Yes right, v6.6-rc2 kernel doesn't have this issue. My bad for not updating
it ...

However I think the second issue described in the cover letter can still be
reproduced on v6.6-rc2. This present patch was not aiming to fix it though.

Commands:
# mkdir cgroup
# mount -t cgroup2 none cgroup/
# mkdir cgroup/A1 cgroup/B1
# echo "+cpuset" > cgroup/cgroup.subtree_control
# echo 0-3 > cgroup/A1/cpuset.cpus
# echo isolated > cgroup/A1/cpuset.cpus.partition
# echo 4-6 > cgroup/B1/cpuset.cpus
# cat cgroup/A1/cpuset.cpus.partition
isolated
# echo 0-4 > cgroup/A1/cpuset.cpus
# cat cgroup/A1/cpuset.cpus.partition
isolated invalid (Cpu list in cpuset.cpus not exclusive)
# echo 0-3 > cgroup/A1/cpuset.cpus
# cat cgroup/A1/cpuset.cpus.partition
isolated invalid (Cpu list in cpuset.cpus not exclusive)

Cgroup A1 should be a valid isolated partition once its CPUs become
exclusive again I believe,

Regards,
Pierre

> 
> Thanks,
> Longman
> 
