From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH REBASED] mm: Throttle allocators when failing reclaim
 over memory.high
Date: Wed, 10 Apr 2019 16:34:49 +0100
Message-ID: <20190410153449.GA14915@chrisdown.name>
References: <20190201191636.GA17391@chrisdown.name>
 <20190410153307.GA11122@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=arxBGNSX0OUYGmyljwVEu7bbeV7OhkzO+FdllTWnzPo=;
        b=xJDIIxl1eeL/dAIbEYlOuZSAFwejku7gsZgBW1BS1TBrC2f9JSBLITDJqVqs0PSeI4
         maDchJybAJdG0zBjinmp9wRxhX9DKa0H/MmG6XAo+vD62eSzMbE6SshIV9gtBlg76KPQ
         89iiOrmmBwbKuVrud8G0hORSsuQSWFNviuPfM=
Content-Disposition: inline
In-Reply-To: <20190410153307.GA11122@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, Andrew Morton <akpm@linux-foundation.org>

Hey Michal,

Just to come back to your last e-mail about how this interacts with OOM.

Michal Hocko writes:
> I am not really opposed to the throttling in the absence of a reclaimable
> memory. We do that for the regular allocation paths already
> (should_reclaim_retry). A swapless system with anon memory is very likely to
> oom too quickly and this sounds like a real problem. But I do not think that
> we should throttle the allocation to freeze it completely. We should
> eventually OOM. And that was my question about essentially. How much we
> can/should throttle to give a high limit events consumer enough time to
> intervene. I am sorry to still not have time to study the patch more closely
> but this should be explained in the changelog. Are we talking about
> seconds/minutes or simply freeze each allocator to death?

Per-allocation, the maximum is 2 seconds (MEMCG_MAX_HIGH_DELAY_JIFFIES), so we 
don't freeze things to death -- they can recover if they are amenable to it.  
The idea here is that primarily you handle it, just like memory.oom_control in 
v1 (as mentioned in the commit message, or as a last resort, the kernel will 
still OOM if our userspace daemon has kicked the bucket or is otherwise 
ineffective.

If you're setting memory.high and memory.max together, then setting memory.high 
always has to come with a.) tolerance of heavy throttling by your application, 
and b.) userspace intervention in the case of high memory pressure resulting. 
This patch doesn't really change those semantics.
