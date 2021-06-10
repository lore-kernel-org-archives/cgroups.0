From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH 2/5] cgroup/cpuset: Add new cpus.partition type with no
 load balancing
Date: Thu, 10 Jun 2021 15:21:51 -0400
Message-ID: <f81f4867-1fea-03fc-639a-2783fbd68abf@redhat.com>
References: <20210603212416.25934-1-longman@redhat.com>
 <20210603212416.25934-3-longman@redhat.com>
 <YMJhObisfWJ1PzgR@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623352914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DVG4CWGfyu4y0g9i2OCoAuUtkr+80/M03bPDGkS4TS8=;
        b=KrmRPXTQzgcO01RxmExyB/c/8VLB/qa3V4z+12QANBuu1neQI+ONGRiBe9rfO3Dgk9vprf
        zhzFySb7gd8RSMbu6pd4vPLZATtD+gtaMKN5acximHIWBeXtWdzD+o3qWeNk4TKUtCMth1
        8+xBul22Y5wXyPAlTXCBPQ6IvJnKDuw=
In-Reply-To: <YMJhObisfWJ1PzgR@hirez.programming.kicks-ass.net>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Juri Lelli <juri.lelli@redhat.com>

On 6/10/21 3:00 PM, Peter Zijlstra wrote:
> On Thu, Jun 03, 2021 at 05:24:13PM -0400, Waiman Long wrote:
>> Cpuset v1 uses the sched_load_balance control file to determine if load
>> balancing should be enabled.  Cpuset v2 gets rid of sched_load_balance
>> as its use may require disabling load balancing at cgroup root.
>>
>> For workloads that require very low latency like DPDK, the latency
>> jitters caused by periodic load balancing may exceed the desired
>> latency limit.
>>
>> When cpuset v2 is in use, the only way to avoid this latency cost is to
>> use the "isolcpus=" kernel boot option to isolate a set of CPUs. After
>> the kernel boot, however, there is no way to add or remove CPUs from
>> this isolated set. For workloads that are more dynamic in nature, that
>> means users have to provision enough CPUs for the worst case situation
>> resulting in excess idle CPUs.
> Also, can we change isolcpus to create a default cgroup hierarchy
> instead of being the fugly hack that it is? I really hate isolcpus with
> a passion, it needs to die.
>
That is probably doable assuming that we can allow cpuset v2 to have a 
non-load balanced partition.

Depending on which cpuset version is set up, we can automatically set up 
a isolated subdirectory under / to contain cpus that are isolated. 
However, that will be a follow-on patch after this one.

Cheers,
Longman

