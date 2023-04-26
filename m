From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 2/6] sched/cpuset: Bring back cpuset_mutex
Date: Wed, 26 Apr 2023 10:05:49 -0400
Message-ID: <d53a8af3-46e7-fe6e-5cdd-0421796f80d2@redhat.com>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
 <20230329125558.255239-3-juri.lelli@redhat.com>
 <fa585497-5c6d-f0ed-bdda-c71a81d315ad@redhat.com>
 <ZEkRq9iGkYP/8T5w@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682518432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rf30qPmkXFyg0eo0/oPK9xXJTsxFmQ7zB528P1kEZb8=;
        b=Rbzn3I7M0p9mLq/wL93Ea/yQphwMjqY5+XjdqPEwXvaQla6N17LyhMZC6dPdGbd09YORV7
        uvwOatKSakbSsvg3lgt11fPBM5xduzDB03K/1TOaN9LFOHREmGceKb2kKORajsIecfO1fp
        xUhEEwXiOsRGj30wqjBHr8YtNliHyXw=
Content-Language: en-US
In-Reply-To: <ZEkRq9iGkYP/8T5w@localhost.localdomain>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Juri Lelli <juri.lelli@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Qais Yousef <qyousef@layalina.io>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, cgroups@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.>

On 4/26/23 07:57, Juri Lelli wrote:
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

That is fine for me too.

Cheers,
Longman

