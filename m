From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH 2/5] cgroup/cpuset: Add new cpus.partition type with no
 load balancing
Date: Thu, 10 Jun 2021 15:16:29 -0400
Message-ID: <820aff72-fce2-ac2f-88e6-787249e04308@redhat.com>
References: <20210603212416.25934-1-longman@redhat.com>
 <20210603212416.25934-3-longman@redhat.com>
 <YMJfDHr1+xxm6SBi@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623352592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=liO0eMHLLQxFJzTbME5X4nacHbq/D6xkCgBqqSco7f0=;
        b=UKN+VJFnPT1Qyo3v1npa3BNUZAI5MynuwJj6j1bhiY7PgYNDadnJiKxiSqCfqlg+CR+/Dc
        +a2PtBDDqQNbbPd+VasXaEE0uJ7hI2W9T773WubC+23Di5HiXGq+fjZj3RznfOg8b2brr1
        U58N3WY9z3khNJP/ah9cLwXYoHprR48=
In-Reply-To: <YMJfDHr1+xxm6SBi@hirez.programming.kicks-ass.net>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Juri Lelli <juri.lelli@redhat.com>

On 6/10/21 2:50 PM, Peter Zijlstra wrote:
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
>>
>> To address this issue for cpuset v2, a new cpuset.cpus.partition type
>> "root-nolb" is added which allows the creation of a cpuset partition with
>> no load balancing. This will allow system administrators to dynamically
>> adjust the size of the no load balancing partition to the current need
>> of the workload without rebooting the system.
> I'm confused, why do you need this? Just create a parition for each cpu.
>
 From a management point of view, it is more cumbersome to do one cpu 
per partition. I have suggested this idea of 1 cpu per partition to the 
container developers, but they don't seem to like it.

Cheers,
Longman

