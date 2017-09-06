From: Prateek Sood <prsood@codeaurora.org>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Wed, 6 Sep 2017 19:53:59 +0530
Message-ID: <0667dcec-ba42-5f44-596f-c2af891a770e@codeaurora.org>
References: <1504698535-8187-1-git-send-email-prsood@codeaurora.org>
 <3992b0d5-947c-e343-5c07-8da43af5646d@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504707844;
        bh=ZCsTk00gbyzU4EEdIcSA5SvxEPXIeqKk1GxFBc5oWD4=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=lRCUAvE3tJkGfKOO/1srpdwLTSHMWbHJwRiQ9zX2c+LAix4yyv7jYVhK8kVgcr/XT
         qfCWkEoYETJjN8xghsSdtwOyvP5M5YUxSy73rm/T1nglnePU2SLw9i855jE/Y9RHSl
         rHO0kJSPnY+yFqI4tj/9EQPh/6U7uZlpStvNkFi8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504707844;
        bh=ZCsTk00gbyzU4EEdIcSA5SvxEPXIeqKk1GxFBc5oWD4=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=lRCUAvE3tJkGfKOO/1srpdwLTSHMWbHJwRiQ9zX2c+LAix4yyv7jYVhK8kVgcr/XT
         qfCWkEoYETJjN8xghsSdtwOyvP5M5YUxSy73rm/T1nglnePU2SLw9i855jE/Y9RHSl
         rHO0kJSPnY+yFqI4tj/9EQPh/6U7uZlpStvNkFi8=
In-Reply-To: <3992b0d5-947c-e343-5c07-8da43af5646d@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>, tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, sramana@codeaurora.org

On 09/06/2017 06:26 PM, Waiman Long wrote:
> On 09/06/2017 07:48 AM, Prateek Sood wrote:
>> Remove circular dependency deadlock in a scenario where hotplug of CPU is
>> being done while there is updation in cgroup and cpuset triggered from
>> userspace.
>>
>> Example scenario:
>> kworker/0:0 => kthreadd => init:729 => init:1 => kworker/0:0
>>
>> kworker/0:0 - lock(cpuhotplug.mutex)  [held]
>>               flush(work)   [no high prio workqueue available on CPU]
>>               wait_for_completion()
>>
>> kthreadd    - percpu_down_read(cgroup_threadgroup_rwsem)  [waiting]
>>
>> init:729    - percpu_down_write(cgroup_threadgroup_rwsem)   [held]
>>               lock(cpuset_mutex)   [waiting]
>>
>> init:1      - lock(cpuset_mutex)   [held]
>>               lock(cpuhotplug.mutex)   [waiting]
>>
>> Eliminate this dependecy by reordering locking of cpuset_mutex
>> and cpuhotplug.mutex in following order
>> 1. Acquire cpuhotplug.mutex
>> 2. Acquire cpuset_mutex
>>
>> Signed-off-by: Prateek Sood <prsood@codeaurora.org>
> 
> Is this patch for the latest upstream kernel or 4.4? There is no
> cpuhotplug.mutex anymore in upstream kernel. It is a per-cpu rwsem
> cpu_hotplug_lock.
> 
> Cheers,
> Longman
> 

Thanks for inputs, I will check latest kernel for details

Regards
Prateek

-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation
Center, Inc., is a member of Code Aurora Forum, a Linux Foundation
Collaborative Project
