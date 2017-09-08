From: Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Fri, 8 Sep 2017 07:43:21 +0530
Message-ID: <e5171d0d-5a4b-75b6-53b4-d1251cacc0ff@codeaurora.org>
References: <1504792583-10424-1-git-send-email-prsood@codeaurora.org>
 <20170907174505.GF17526@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504836807;
        bh=RC7vQv4odMVnZYUTR7lX3RqmkQy1XdeaNn9Sy3J8n0Y=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=G9OAohWXRCoRCFte43wRUupbA8V2vR37KvaqIX15EJ67yMmsOxYGY20xqWPjXWgrf
         64vTD1Obwx0nMGxGAe8oob8TF37AchcC3li+ufM8ha3XUuQhsiTDIP+CrMosNHHQNp
         o+nDNOPToen8XiojyfchiDz1LDgDPWZwfp3bJNLk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504836806;
        bh=RC7vQv4odMVnZYUTR7lX3RqmkQy1XdeaNn9Sy3J8n0Y=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=XrmB5ZbPljPEeArSBsNV83eBkGCKGqQeCJfM86DUHvRWQheTNx3OwHN7Xri+BDMbA
         8Ro2OFlfzd9qMZuIZItJU+sH+b4NGRpX65fk6Sj6W5C7f3rVuyj/s324zNNNjnGOB5
         MlB8XJRBJI4wSMBc6Z4GHQxF4af3hpirDA+DN7ZU=
In-Reply-To: <20170907174505.GF17526@worktop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, mingo@kernel.org, longman@redhat.com, boqun.feng@gmail.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, sramana@codeaurora.org

On 09/07/2017 11:15 PM, Peter Zijlstra wrote:
> On Thu, Sep 07, 2017 at 07:26:23PM +0530, Prateek Sood wrote:
>> Remove circular dependency deadlock in a scenario where hotplug of CPU is
>> being done while there is updation in cgroup and cpuset triggered from
>> userspace.
>>
>> Process A => kthreadd => Process B => Process C => Process A
> 
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
> 
> TJ, I'm puzzled, why would we need to spawn new threads to update NUMA
> affinity when taking a CPU out? That doesn't make sense to me, we can
> either shrink the affinity of an existing thread or completely kill of a
> thread if the mask becomes empty. But why spawn a new thread?
> 
>>           flush_work();
>>           wait_for_completion();
>>

> 
> Yes, inverting cpuset and hotplug would break that chain, but I'm still
> wondering why workqueue needs to spawn threads on CPU down.
> 

Thanks for the comments Peter

You rightly mentioned that a new thread will not be spawn
while updating NUMA affinity when taking a CPU out.

While a CPU is made offline, attempt is made to unbind per-cpu
worker for CPU going down. This is done by queuing unbind work
to system_highpri_wq. It results in an attempt to create one
bounded worker thread as there is none. 

wait_for_completion() in flush_work() waits for unbinding to
finish for CPU going down.

Process A
cpu_subsys_offline();
   cpu_down();
     _cpu_down();
       percpu_down_write(&cpu_hotplug_lock); //held
       cpuhp_invoke_callback();
         workqueue_offline_cpu();
           queue_work_on(system_highpri_wq);
             __queue_work();
               insert_work();
                 wake_up_worker(); //pool->nr_running = 0
           flush_work();
		   wait_for_completion();
		   
	   
worker_thread();
  need_more_worker(); // returns true
  manage_workers();
    maybe_create_worker();
	  create_worker();
	    kthread_create_on_node();
		  wake_up_process(kthreadd_task);



-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
