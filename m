From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Fri, 27 Oct 2017 13:33:41 +0530
Message-ID: <45cdac2f-4462-e5b5-d724-8cca58e3932a@codeaurora.org>
References: <20171025093041.GO3165@worktop.lehotels.local>
 <1509018722-30359-1-git-send-email-prsood@codeaurora.org>
 <dc80ad9d-5b3d-b991-76c8-35630bc139c5@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1509091427;
        bh=w5+f/o8m1u3ByRyiviaZBUjfK/qVwJij9VQLJoM1m6I=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Qp4nOZ9/C/f2l81Tj1EvZfFrAOrA3+hZTTdWJvUzop38y2NkilMnupRGHqGma+U7i
         MZadX6QaL3efa2q80srwLyNeg2vWvGT5zANwJC6TdmXSURzV/tliG8tk9pqYCLjZBL
         i6K+8WwdO1IkmuZqH2MjogvLohVMoaaPpKtG9q5Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1509091426;
        bh=w5+f/o8m1u3ByRyiviaZBUjfK/qVwJij9VQLJoM1m6I=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=i0lFeNB0jEy/f3IfWqjUNpStOl8pnHratONfpbPhJGyA+Py3FJKL6SRkk//pIMXaI
         z6STfLayEgPPrWybAYQwSRNamiGXPO/cmRK/4c1b4UgWEDI+xWuLjC6pipv55Spxbp
         aJpqRyoRm9KO6VL2mNJSmGd/Z1cnJY5L0XolrmNM=
In-Reply-To: <dc80ad9d-5b3d-b991-76c8-35630bc139c5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/26/2017 07:35 PM, Waiman Long wrote:
> On 10/26/2017 07:52 AM, Prateek Sood wrote:
>> Remove circular dependency deadlock in a scenario where hotplug of CPU is
>> being done while there is updation in cgroup and cpuset triggered from
>> userspace.
>>
>> Process A => kthreadd => Process B => Process C => Process A
>>
>> Process A
>> cpu_subsys_offline();
>>   cpu_down();
>>     _cpu_down();
>>       percpu_down_write(&cpu_hotplug_lock); //held
>>       cpuhp_invoke_callback();
>>         workqueue_offline_cpu();
>>           wq_update_unbound_numa();
>>             kthread_create_on_node();
>>               wake_up_process();  //wakeup kthreadd
>>           flush_work();
>>           wait_for_completion();
>>
>> kthreadd
>> kthreadd();
>>   kernel_thread();
>>     do_fork();
>>       copy_process();
>>         percpu_down_read(&cgroup_threadgroup_rwsem);
>>           __rwsem_down_read_failed_common(); //waiting
>>
>> Process B
>> kernfs_fop_write();
>>   cgroup_file_write();
>>     cgroup_procs_write();
>>       percpu_down_write(&cgroup_threadgroup_rwsem); //held
>>       cgroup_attach_task();
>>         cgroup_migrate();
>>           cgroup_migrate_execute();
>>             cpuset_can_attach();
>>               mutex_lock(&cpuset_mutex); //waiting
>>
>> Process C
>> kernfs_fop_write();
>>   cgroup_file_write();
>>     cpuset_write_resmask();
>>       mutex_lock(&cpuset_mutex); //held
>>       update_cpumask();
>>         update_cpumasks_hier();
>>           rebuild_sched_domains_locked();
>>             get_online_cpus();
>>               percpu_down_read(&cpu_hotplug_lock); //waiting
>>
>> Eliminating deadlock by reversing the locking order for cpuset_mutex and
>> cpu_hotplug_lock.
> 
> General comments:
> 
> Please add a version number of your patch. I have seen multiple versions
> of this patch and have lost track how many are there as there is no
> version number information.  In addition, there are changes beyond just
> swapping the lock order and they are not documented in this change log.
> I would like to see you discuss about those additional changes here as well.
Thanks for the comments Longman. I will introduce patch versioning and update
commit text to document extra changes.

Explaintaion for extra changes in this patch:
After inverting the locking sequence of cpu_hotplug_lock and cpuset_mutex,
cpuset_hotplug_workfn() related functionality can be done synchronously from
the context doing cpu hotplug. Extra changes in this patch intend to remove
queuing of cpuset_hotplug_workfn() as a work item for cpu hotplug path. For
memory hotplug it still gets queued as a work item.


This suggestion came in from Peter. 
Peter could you please elaborate if I have missed anything.

> 
>>  void rebuild_sched_domains(void)
>>  {
>> +	cpus_read_lock();
>>  	mutex_lock(&cpuset_mutex);
>> -	rebuild_sched_domains_locked();
>> +	rebuild_sched_domains_cpuslocked();
>>  	mutex_unlock(&cpuset_mutex);
>> +	cpus_read_unlock();
>>  }
> 
> I saw a lot of instances where cpus_read_lock() and mutex_lock() come
> together. Maybe some new lock/unlock helper functions may help.
Ok, I will introduce a single wrapper for locking and unlocking
of both locks
 
> 
>> @@ -2356,25 +2354,29 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>>  	}
>>  
>>  	/* rebuild sched domains if cpus_allowed has changed */
>> -	if (cpus_updated || force_rebuild) {
>> -		force_rebuild = false;
>> -		rebuild_sched_domains();
>> +	if (cpus_updated) {
>> +		if (use_cpu_hp_lock)
>> +			rebuild_sched_domains();
>> +		else {
>> +			/* When called during cpu hotplug cpu_hotplug_lock
>> +			 * is held by the calling thread, not
>> +			 * not cpuhp_thread_fun
>> +			 */
> 
> ??? The comment is not clear.

Following is the scenario that is described by the comment

Process A
_cpu_down()
   cpus_write_lock() //cpu_hotplug_lock held
      cpuhp_kick_ap_work()
         cpuhp_kick_ap()
            wake_up_process() // wake up cpuhp_thread_fun
            wait_for_ap_thread() //wait for hotplug thread to signal completion


cpuhp_thread_fun()
   cpuhp_invoke_callback()
     sched_cpu_deactivate()
        cpuset_cpu_inactive()
           cpuset_update_active_cpus()
             cpuset_hotplug(false) \\ do not use cpu_hotplug_lock from _cpu_down() path
                
I will update the comment in next version of patch to elaborate more.

> 
> Cheers,
> Longman
> 


-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
