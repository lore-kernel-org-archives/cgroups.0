From: Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Thu, 7 Sep 2017 14:37:15 +0530
Message-ID: <88abfcfd-3d85-b903-e404-d101c34613a8@codeaurora.org>
References: <1504764252-29091-1-git-send-email-prsood@codeaurora.org>
 <20170907072848.2sjjddwincaeplju@hirez.programming.kicks-ass.net>
 <20170907085534.GA30135@tardis>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504775244;
        bh=afRpialAfwSDSdImm6H2SnBHQm8yOFMBKykyP8znJSk=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=XdalCDmamKAfy1RdDtnA4DE1JwH/x2Ahs7o4GAFyvmZ4yFLWDVwBTU+0musnCvcRD
         XKDJWOAYKAWd0ouydQAWTZj2y/8bJ+3vszKpTo+vob6pzugwrVWfZPFOEh433P++E9
         4mLB9ZxoRQxCWg9RTC6NBc2W6L4XxgodpL1dvyI8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504775240;
        bh=afRpialAfwSDSdImm6H2SnBHQm8yOFMBKykyP8znJSk=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=kxAtuRVFF8rV7E0PyGnpYPStSWtEacueY/8/vx1xkQoC7eyQxbzzsQXvI71fnt+h1
         AOZmh4pkZwGagsbb8Cw9MztZdd0nHQp1yWCl5kCom5lgzPGkFbtqPQMyX/O/BS/Mhi
         Kdsthygw0PWYCsPQdBKyAufRxfiODbK1PdPORiAE=
In-Reply-To: <20170907085534.GA30135@tardis>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, mingo@kernel.org, longman@redhat.com, linux-kernel@vger.kernel.org, sramana@codeaurora.org, Thomas Gleixner <tglx@linutronix.de>

On 09/07/2017 02:26 PM, Boqun Feng wrote:
> On Thu, Sep 07, 2017 at 09:28:48AM +0200, Peter Zijlstra wrote:
>> On Thu, Sep 07, 2017 at 11:34:12AM +0530, Prateek Sood wrote:
>>> Remove circular dependency deadlock in a scenario where hotplug of CPU is
>>> being done while there is updation in cgroup and cpuset triggered from
>>> userspace.
>>>
>>> Example scenario:
>>> kworker/0:0 => kthreadd => init:729 => init:1 => kworker/0:0
>>>
>>> kworker/0:0 - percpu_down_write(&cpu_hotplug_lock)  [held]
>>>               flush(work)   [no high prio workqueue available on CPU]
>>>               wait_for_completion()
> 
> Hi Prateek,
> 
> so this is:
> 
> 	_cpu_down():
> 	  cpus_write_lock(); // percpu_down_write(&cpu_hotlug_lock)
> 	  cpuhp_invoke_callbacks():
> 	    workqueue_offine_cpu():
> 	      wq_update_unbound_numa():
> 	        alloc_unbound_pool():
> 	          get_unbound_pool():
> 		    create_worker():
> 		      kthread_create_on_node():
> 		        wake_up_process(kthreadd_task);
> 		        wait_for_completion(); // create->done
> 
> , right?
> 
> Wonder running in a kworker is necessary to trigger this, I mean running
> a cpu_down() in a normal process context could also trigger this, no?
> Just ask out of curiosity.
> 
> Regards,
> Boqun

Hi Boqun,

cpu_down() in normal process can also trigger this.



Regards
Prateek
> 
>>>
>>> kthreadd    - percpu_down_read(cgroup_threadgroup_rwsem)  [waiting]
>>>
>>> init:729    - percpu_down_write(cgroup_threadgroup_rwsem)   [held]
>>>               lock(cpuset_mutex)   [waiting]
>>>
>>> init:1      - lock(cpuset_mutex)   [held]
>>>               percpu_down_read(&cpu_hotplug_lock)   [waiting]
>>
>> That's both unreadable and useless :/ You want to tell what code paths
>> that were, not which random tasks happened to run them.
>>
>>
> [...]
> 


-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
