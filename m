From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter
 offline CPUs
Date: Thu, 2 Feb 2023 16:05:14 -0500
Message-ID: <8787b5f7-9822-e49b-0357-d0ce224ca920@redhat.com>
References: <20230131221719.3176-1-will@kernel.org>
 <20230131221719.3176-2-will@kernel.org>
 <6b068916-5e1b-a943-1aad-554964d8b746@redhat.com>
 <Y9t1sP/6nFht7RSN@hirez.programming.kicks-ass.net>
 <d630ca53-71f0-c735-fbc3-e826479aa86b@redhat.com>
 <Y9wSC1Wxlm8CKKlN@hirez.programming.kicks-ass.net>
 <2bc730db-704d-080b-6869-02f6d0035fad@redhat.com>
 <Y9whrU4IUeleqdrt@slm.duckdns.org>
 <75de91db-d3bc-0c0e-6199-ef00591e8878@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675371920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WEHQNucTuGpLdaQhxf42z+oDGAmuQAok38hbITp7osg=;
        b=MVuNhkqw8wUxTa6R7Wp3ziLfgjd8OaN23xcD8+OYAlIVgizJMvbtNVpCRaJyQcx3aBz3wT
        EqV8mUMKd1z7w6Q5o6cshKl+fLg+XxZBpsfDRtgWHaqHQ1qTfv2ROmNEEnbViQ6Lxysu2l
        6fkq9cSPQTrAdDpERhy/uTtjkZVPTEM=
Content-Language: en-US
In-Reply-To: <75de91db-d3bc-0c0e-6199-ef00591e8878@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, kernel-team@android.com, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org


On 2/2/23 15:53, Waiman Long wrote:
>
> On 2/2/23 15:48, Tejun Heo wrote:
>> On Thu, Feb 02, 2023 at 03:46:02PM -0500, Waiman Long wrote:
>>>>> I will work on a patchset to do that as a counter offer.
>>>> We will need a small and simple patch for /urgent, or I will need to
>>>> revert all your patches -- your call.
>>>>
>>>> I also don't tihnk you fully appreciate the ramifications of
>>>> task_cpu_possible_mask(), cpuset currently gets that quite wrong.
>>> OK, I don't realize the urgency of that. If it is that urgent, I 
>>> will have
>>> no objection to get it in for now. We can improve it later on. So 
>>> are you
>>> planning to get it into the current 6.2 rc or 6.3?
>>>
>>> Tejun, are you OK with that as you are the cgroup maintainer?
>> Yeah, gotta fix the regression but is there currently a solution 
>> which fixes
>> the regression but doesn't further break other stuff?
>
> I believe there is a better way to do that, but it will need more time 
> to flex out. Since cpuset_cpus_allowed() is only used by 
> kernel/sched/core.c, Peter will be responsible if it somehow breaks 
> other stuff.

Maybe my cpuset patch that don't update task's cpumask on cpu offline 
event can help. However, I don't know the exact scenario where the 
regression happen, so it may not.

Cheers,
Longman

