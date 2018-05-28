From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v8 3/6] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Mon, 28 May 2018 14:45:08 +0200
Message-ID: <20180528124508.GE3452@worktop.programming.kicks-ass.net>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
 <1526590545-3350-4-git-send-email-longman@redhat.com>
 <20180524154341.GJ12198@hirez.programming.kicks-ass.net>
 <9f547771-54e8-118e-80f7-48f99c7b0a12@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Qg2upbHUIP+Lq3k1kuOt3nwQiJ1wX2pgcfZxbw78mng=; b=OpOmeb4b1mZoeEb1Kpz1jXmVx
        MMdl9FzZ9nIcNbXYqKE8xskiW3Xpgf/I2FC4hBndj3xd7yFphz3NRXe2dRL0FqBW3YMu/CaTnnglv
        g14IR60HD+mSrZlPwsa1KFBq46AisBrhzif8ItOsbll3p0DJJg8UajEmYxUn25qF+Yh2GzGeb6BJL
        0dLOUpGRygjCWHLZCD0G3Y01etTnIJaAefxmlZdKTQpgpuiwuKYQs+4s4ow+qUS6bz31gczB06xgG
        oYB11pulnu1SqCP2j9lVmlG0qVQg86WPbSC/bpFHh11N6vtN4ic01AGxsQUJshW8wmpmmhUqKGhDM
      
Content-Disposition: inline
In-Reply-To: <9f547771-54e8-118e-80f7-48f99c7b0a12@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

On Thu, May 24, 2018 at 02:55:25PM -0400, Waiman Long wrote:
> On 05/24/2018 11:43 AM, Peter Zijlstra wrote:

> > I'm confused... why exactly do we have both domain and load_balance ?
> 
> The domain is for partitioning the CPUs only. It doesn't change the load
> balancing state. So the load_balance flag is still need to turn on and
> off load balancing.

OK, so we have to two boolean flags, giving 4 possible states. Lets just
go through them one by on:

A) domain:0 load_balance:0 -- we have no exclusive domain, but have
   load-balancing disabled across them. AFAICT this should be an invalid
   state.

B) domain:0 load_balance:1 -- we have no exclusive domain, but have
   load-balancing enabled. AFAICT this is the default state and is a
   no-op.

C) domain:1 load_balance:0 -- we have an exclusive domain, and have
   load-balancing disabled across it. This is, AFAICT, identical to
   having a bunch of sub/sibling groups each with a single CPU domain.

D) domain:1 load_balance:1 -- we have an exclusive domain, and have
   load-balancing enabled. This is a partition.

Now, I think I've overlooked the fact that load_balance==1 only really
means something when the parent's load_balance==0, but I'm not sure that
really changes anything.

So, afaict, the above only have two useful states: B and D. Which again
raises the question, why two knobs? What useful configurations does it
allow?
