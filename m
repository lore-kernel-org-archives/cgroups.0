From: Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH 2/6] sched/cpuset: Bring back cpuset_mutex
Date: Wed, 26 Apr 2023 16:31:09 +0200
Message-ID: <10fdfdd8-06bc-0f35-0fea-e604aa5c103a@redhat.com>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
 <20230329125558.255239-3-juri.lelli@redhat.com>
 <fa585497-5c6d-f0ed-bdda-c71a81d315ad@redhat.com>
 <ZEkRq9iGkYP/8T5w@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682519474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x0YRJ7TlPoY9IYDWRjmvki/mO0TL+b3mD3tzGtLzoUc=;
        b=FGGwXsJdjZL6AC3t2yAOiFXB86dk4ifPNSwMF4LokYKW35ZK7v3jIX5crX5IwVpWhr/Agv
        CA1u0RV50rXUT4aarKAAtc7zkLVuBGlNVNoBD1msuXWfax6aMq6vkTZ8ZPWPBt8gTvd07p
        cQUbj62HcUYiy/ixIhUWGwfY2Kl4kIs=
Content-Language: en-US
In-Reply-To: <ZEkRq9iGkYP/8T5w@localhost.localdomain>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Qais Yousef <qyousef@layalina.io>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, mathieu.poirier@linaro.org, cgroups@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Sudeep Holla <>

On 4/26/23 13:57, Juri Lelli wrote:
> On 04/04/23 13:31, Waiman Long wrote:
>> On 3/29/23 08:55, Juri Lelli wrote:
>>> Turns out percpu_cpuset_rwsem - commit 1243dc518c9d ("cgroup/cpuset:
>>> Convert cpuset_mutex to percpu_rwsem") - wasn't such a brilliant idea,
>>> as it has been reported to cause slowdowns in workloads that need to
>>> change cpuset configuration frequently and it is also not implementing
>>> priority inheritance (which causes troubles with realtime workloads).
>>>
>>> Convert percpu_cpuset_rwsem back to regular cpuset_mutex. Also grab it
>>> only for SCHED_DEADLINE tasks (other policies don't care about stable
>>> cpusets anyway).
>>>
>>> Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
>> I am thinking that maybe we should switch the percpu rwsem to a regular
>> rwsem as there are cases where a read lock is sufficient. This will also
>> avoid the potential PREEMPT_RT problem with PI and reduce the time it needs
>> to take a write lock.
> I'm not a big fan of rwsems for reasons like
> https://lore.kernel.org/lkml/20230321161140.HMcQEhHb@linutronix.de/, so
> I'd vote for a standard mutex unless we have a strong argument and/or
> numbers.

+1

-- Daniel

