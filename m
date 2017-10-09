From: Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Mon, 9 Oct 2017 18:57:46 +0530
Message-ID: <4668d1ec-dc43-8a9c-4f94-a421683d3c17@codeaurora.org>
References: <1504792583-10424-1-git-send-email-prsood@codeaurora.org>
 <20170907175107.GG17526@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1507555678;
        bh=hkxtn+CfNgakYDtx4lIaLFE2Lhs3kFiJkDuczuonZjE=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=kda47twMSBy0qCmkxiZX+fFZ9Ktlj8Gvm7uFVrDz8DbRFjrw2mCdFq3Z9GiG9GNW4
         3VPA6TxOOBiVRNaUeDAG0+8fgseLFPZoVgZd9qfwbcGI/gZIaDI3Z2QF+dt3eJFkxK
         punQLXijMtP0UlWShFNPgZ5yN+CITykyp/tZHrHE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1507555677;
        bh=hkxtn+CfNgakYDtx4lIaLFE2Lhs3kFiJkDuczuonZjE=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=VhOu0UTQweHG5iYKpgv515hkRErmURkASWVbelw+vcSakSAKn26zm14ygPyj3GDwE
         N0BTOobxO5BMRWHpcIegnaGxZ1+28GyantOo+R3hkDBOMrWe9zMpYQD2HSyU56WY6H
         ggC29dAM32FJ6J/Efz9pO3Z4H4H5ln/0mpRUhh5o=
In-Reply-To: <20170907175107.GG17526@worktop.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, mingo@kernel.org, longman@redhat.com, boqun.feng@gmail.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, sramana@codeaurora.org

On 09/07/2017 11:21 PM, Peter Zijlstra wrote:
> On Thu, Sep 07, 2017 at 07:26:23PM +0530, Prateek Sood wrote:
>> Remove circular dependency deadlock in a scenario where hotplug of CPU is
>> being done while there is updation in cgroup and cpuset triggered from
>> userspace.
> 
> You've forgotten to mention your solution to the deadlock, namely
> inverting cpuset_mutex and cpu_hotplug_lock.
> 
>> Signed-off-by: Prateek Sood <prsood@codeaurora.org>
>> ---
>>  kernel/cgroup/cpuset.c | 32 +++++++++++++++++++-------------
>>  1 file changed, 19 insertions(+), 13 deletions(-)
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 2f4039b..60dc0ac 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -816,16 +816,15 @@ static int generate_sched_domains(cpumask_var_t **domains,
>>   * 'cpus' is removed, then call this routine to rebuild the
>>   * scheduler's dynamic sched domains.
>>   *
>> - * Call with cpuset_mutex held.  Takes get_online_cpus().
>>   */
>> -static void rebuild_sched_domains_locked(void)
>> +static void rebuild_sched_domains_cpuslocked(void)
>>  {
>>  	struct sched_domain_attr *attr;
>>  	cpumask_var_t *doms;
>>  	int ndoms;
>>  
>> +	lockdep_assert_cpus_held();
>>  	lockdep_assert_held(&cpuset_mutex);
>> -	get_online_cpus();
>>  
>>  	/*
>>  	 * We have raced with CPU hotplug. Don't do anything to avoid
>> @@ -833,27 +832,27 @@ static void rebuild_sched_domains_locked(void)
>>  	 * Anyways, hotplug work item will rebuild sched domains.
>>  	 */
>>  	if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
>> -		goto out;
>> +		return;
>>  
>>  	/* Generate domain masks and attrs */
>>  	ndoms = generate_sched_domains(&doms, &attr);
>>  
>>  	/* Have scheduler rebuild the domains */
>>  	partition_sched_domains(ndoms, doms, attr);
>> -out:
>> -	put_online_cpus();
>>  }
>>  #else /* !CONFIG_SMP */
>> -static void rebuild_sched_domains_locked(void)
>> +static void rebuild_sched_domains_cpuslocked(void)
>>  {
>>  }
>>  #endif /* CONFIG_SMP */
>>  
>>  void rebuild_sched_domains(void)
>>  {
>> +	get_online_cpus();
>>  	mutex_lock(&cpuset_mutex);
>> -	rebuild_sched_domains_locked();
>> +	rebuild_sched_domains_cpuslocked();
>>  	mutex_unlock(&cpuset_mutex);
>> +	put_online_cpus();
>>  }
> 
> But if you invert these locks, the need for cpuset_hotplug_workfn() goes
> away, at least for the CPU part, and we can make in synchronous again.
> Yay!!
> 
> Also, I think new code should use cpus_read_lock() instead of
> get_online_cpus().
> 

Thanks for the review comments Peter.
For patch related to circular deadlock, I will send an updated version.

The callback making a call to cpuset_hotplug_workfn()in hotplug path are
        [CPUHP_AP_ACTIVE] = {
                .name                   = "sched:active",
                .startup.single         = sched_cpu_activate,
                .teardown.single        = sched_cpu_deactivate,
        },

if we make cpuset_hotplug_workfn() synchronous, deadlock might happen:
_cpu_down()
   cpus_write_lock()  //held
      cpuhp_kick_ap_work()
        cpuhp_kick_ap()
           __cpuhp_kick_ap()
              wake_up_process() //cpuhp_thread_fun
                wait_for_ap_thread() //wait for complete from cpuhp_thread_fun()

cpuhp_thread_fun()
   cpuhp_invoke_callback()
     sched_cpu_deactivate()
       cpuset_cpu_inactive()
          cpuset_update_active_cpus()
             cpuset_hotplug_work()
                rebuild_sched_domains()
                   cpus_read_lock() //waiting as acquired in _cpu_down()
                  

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
