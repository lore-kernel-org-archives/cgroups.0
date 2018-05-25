From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 2/6] cpuset: Add new v2 cpuset.sched.domain flag
Date: Fri, 25 May 2018 09:15:24 +0200
Message-ID: <20180525071524.GQ12198@hirez.programming.kicks-ass.net>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-3-git-send-email-longman@redhat.com>
 <20180524154156.GI12198@hirez.programming.kicks-ass.net>
 <675f0f38-9154-4e73-1679-179eefdb7c9f@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ccSGORzi1kauMm9VoF/P9IEFnX4OPSySDEXnF3jN2C8=; b=wKVe4SZEc9Gn53UoLaWFvXM8h
        E9xZ1B4TcXPwXv0ZruOHpmFClM4UD1u4HcDRaX/NlrfByFFPoQczdrBpMuVCUu3hWkBKbljfhAmR0
        EQnGuj5AiirNCjgF1S+DxoUB8rjZKHN8wkXs4VcE1fWz3WiJnb4oQ9c03qlbOkUHDJE1HuRHcND94
        fpDQS4ErE1peJC8+XyVLysOobjgD9Xpug2sLZkdh2V5G8yk02SizUa4aTtA2ej2wbPjvaM3aBcD9/
        kb634XPIHGd1zbOfxK+ngkeaTHDcyKzG11jESQpkmcv1AFzDqPtgYZxxdhsoemurT/0Pk9hMjkSXJ
      
Content-Disposition: inline
In-Reply-To: <675f0f38-9154-4e73-1679-179eefdb7c9f@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On Thu, May 24, 2018 at 02:53:31PM -0400, Waiman Long wrote:
> On 05/24/2018 11:41 AM, Peter Zijlstra wrote:
> > On Thu, May 17, 2018 at 04:55:41PM -0400, Waiman Long wrote:
> >> A new cpuset.sched.domain boolean flag is added to cpuset v2. This new
> >> flag indicates that the CPUs in the current cpuset should be treated
> >> as a separate scheduling domain.
> > The traditional name for this is a partition.
> 
> Do you want to call it cpuset.sched.partition? That name sounds strange
> to me.

Let me explore the whole domain x load-balance space first. I'm thinking
the two parameters are mostly redundant, but I might be overlooking
something (trivial or otherwise).

> >> +  cpuset.sched.domain
> >> +	A read-write single value file which exists on non-root
> >> +	cpuset-enabled cgroups.  It is a binary value flag that accepts
> >> +	either "0" (off) or a non-zero value (on).
> > I would be conservative and only allow 0/1.
> 
> I stated that because echoing other integer value like 2 into the flag
> file won't return any error. I will modify it to say just 0 and 1.

Ah, I would make the file error on >1.

Because then you can always extend the meaning afterwards because you
know it won't be written to with the new value.

> >> +	3) There is no child cgroups with cpuset enabled.
> >> +
> >> +	Setting this flag will take the CPUs away from the effective
> >> +	CPUs of the parent cgroup. Once it is set, this flag cannot be
> >> +	cleared if there are any child cgroups with cpuset enabled.
> > This I'm not clear on. Why?
> >
> That is for pragmatic reason as it is easier to code this way. We could
> remove this restriction but that will make the code more complex.

Best to mention that I think.
