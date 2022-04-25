From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cgroup/cpuset: Remove redundant cpu/node masks setup in
 cpuset_init_smp()
Date: Mon, 25 Apr 2022 10:43:16 -0400
Message-ID: <690fb0ac-6f8c-7e52-2485-4acc030bbc07@redhat.com>
References: <20220425020926.1264611-1-longman@redhat.com>
 <20220425073011.GJ46405@shbuild999.sh.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650897801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oj3e9OxZuBcl3Mrg5cN9YNi1sy73Km34y8js1iAThkg=;
        b=TgOiHEGsr5t5g6WByWuw/mdpdKpH/n0377+oWJzx8Q1TF8H5eBnT9rsLIjTLj29iEALX4R
        RacUnXJTx7UFgVv0rrzYYk7jj03gU7UOIkYHgPXMvQpjQoFRaLC2huTbGueqT0LYQ7iSl5
        qRAZ0dBecTCMhwvuzrYpncyGhSabQlQ=
Content-Language: en-US
In-Reply-To: <20220425073011.GJ46405@shbuild999.sh.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Feng Tang <feng.tang@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Dave Hansen <dave.hansen@intel.com>, ying.huang@intel.com, stable@vger.kernel.org

On 4/25/22 03:30, Feng Tang wrote:
> Hi Waiman,
>
> Thanks for the patch!
>
> On Sun, Apr 24, 2022 at 10:09:26PM -0400, Waiman Long wrote:
>> There are 3 places where the cpu and node masks of the top cpuset can
>> be initialized in the order they are executed:
>>   1) start_kernel -> cpuset_init()
>>   2) start_kernel -> cgroup_init() -> cpuset_bind()
>>   3) kernel_init_freeable() -> do_basic_setup() -> cpuset_init_smp()
>>
>> The first cpuset_init() function just sets all the bits in the masks.
>> The last one executed is cpuset_init_smp() which sets up cpu and node
>> masks suitable for v1, but not v2.  cpuset_bind() does the right setup
>> for both v1 and v2 assuming that effective_mems and effective_cpus have
>> been set up properly which is not strictly the case here. As a result,
>> cpu and memory node hot add may fail to update the cpu and node masks
>> of the top cpuset to include the newly added cpu or node in a cgroup
>> v2 environment.
>>
>> To fix this problem, the redundant cpus_allowed and mems_allowed
>> mask setup in cpuset_init_smp() are removed. The effective_cpus and
>> effective_mems setup there are moved to cpuset_bind().
>>
>> cc: stable@vger.kernel.org
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   kernel/cgroup/cpuset.c | 10 +++-------
>>   1 file changed, 3 insertions(+), 7 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 9390bfd9f1cd..a2e15a43397e 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2961,6 +2961,9 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
>>   	percpu_down_write(&cpuset_rwsem);
>>   	spin_lock_irq(&callback_lock);
>>   
>> +	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
>> +	top_cpuset.effective_mems = node_states[N_MEMORY];
>> +
>>   	if (is_in_v2_mode()) {
>>   		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
>>   		top_cpuset.mems_allowed = node_possible_map;
>> @@ -3390,13 +3393,6 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
>>    */
>>   void __init cpuset_init_smp(void)
>>   {
>> -	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
>> -	top_cpuset.mems_allowed = node_states[N_MEMORY];
>> -	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
>> -
>> -	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
>> -	top_cpuset.effective_mems = node_states[N_MEMORY];
> IIUC, the init order is:
> 	cpuset_bind()
> 	smp_init()
> 	cpuset_init_smp()
>
> while all cpus except boot cpu is brought up in smp_init(), so I'm
> thinking moving the cpus_allowed init from cpuset_init_smp() to
> cpuset_bind() may cause some problem.

Good point. So cpuset_init_smp() is still useful for setting the right 
effective_cpus and probably effective_mems. I will update the patch 
accordingly.

Thanks,
Longman

>
> Thanks,
> Feng
>

