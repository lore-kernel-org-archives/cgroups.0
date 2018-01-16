From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Tue, 16 Jan 2018 08:27:30 -0800
Message-ID: <20180116162730.GQ3460072@devbig577.frc2.facebook.com>
References: <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <20171211152059.GH2421075@devbig577.frc2.facebook.com>
 <cca9aea2-9bff-decf-d669-8f90b928ea18@codeaurora.org>
 <20171213160617.GQ3919388@devbig577.frc2.facebook.com>
 <9843d982-d201-8702-2e4e-0541a4d96b53@codeaurora.org>
 <20180102161656.GD3668920@devbig577.frc2.facebook.com>
 <3c9b2a2d-ede4-1242-418a-353ec9f78db3@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=k9CQ4BQYCVjd1vbkfKs8OWfM2QHiZLnzOUVM7n+kZ34=;
        b=c+/GcqGJITfyC6RPLsu1FzyJMji84m9OKs2GJE/hm9lh3e2noTFjNRBtvUfsUvKTkN
         aw1xbGgXQKsjRnRAxTtO7ezlK+Q0TfpMdMVvUEyjHjGeFRg6FvF6wuDhAUkbo1YdipeJ
         EQ2z97qB1A6tiJ4rE23MjOdCb7bqDcV95qUjdBnJFVyNnrti7kjUFCS7ZnJAgZoh9OEE
         pu7RWiXF/ED2M440E+LRl55KNTtPsdql2JRYc7fz8jZjGzEt7ZAYgipUz2g1ZnXciUza
         fobtV6RgzsC2oEy++TkBsxLGPKJNzLIwPISvwMsJJF2n6vgesA76UcbcQR0x51no0v7G
         nM8A==
Content-Disposition: inline
In-Reply-To: <3c9b2a2d-ede4-1242-418a-353ec9f78db3@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood@codeaurora.org>
Cc: Peter Zijlstra <peterz@infradead.org>, avagin@gmail.com, mingo@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, sramana@codeaurora.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Hello, Prateek.

On Mon, Jan 15, 2018 at 05:32:18PM +0530, Prateek Sood wrote:
> My understanding of WQ_MEM_RECLAIM was that it needs to be used for
> cases where memory pressure could cause deadlocks.

Yes, that is the primary role; however, there are a couple places
where we need it to isolate a low level subsystem's forward progress
from the dependencies of the dynanic worker pool management.

> In this case it does not seem to be a memory pressure issue.
> Overloading WQ_MEM_RECLAIM usage for solution to another problem
> is the correct approach?

In general, we don't face this issue but for things like RCU, I do
believe this is the right approach.  The name of the flag is a bit of
misnomer for those cases as it only describes one of the dependencies
of worker pool management.  I don't think it's an actual problem given
that vast majority of the usages are protecting against memory
dependency.

> This scenario can be resolved by using WQ_MEM_RECLAIM and a separate
> workqueue for rcu. But there seems to be a possibility in future if
> any cpu hotplug callbacks use other predefined workqueues which do not
> have WQ_MEM_RECLAIM option.

We want to isolate from this sort of dependencies anyway, especially
how widely and deeply we depend on RCU these days.  Maybe we will
develop a justified case in the future but at least up until now every
case around this issue seems to be something to be fixed on their own.

Thanks.

-- 
tejun
