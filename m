From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/3] mm: memcontrol: fix memory.low proportional
 distribution
Date: Mon, 16 Dec 2019 13:25:18 -0500
Message-ID: <20191216182518.GA209920@cmpxchg.org>
References: <20191213192158.188939-1-hannes@cmpxchg.org>
 <20191213192158.188939-2-hannes@cmpxchg.org>
 <20191213204026.GA6830@localhost.localdomain>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FWv9JbMsQZWcHgr3Y7gPkAtO8jwEzaE649iak91Bmts=;
        b=jjOrTQb8SYHaFZHILqDRmsF8b/h7ejI/AfFstavkuXkdh78Pjwl+RMaArmbEUuiLf6
         oNDxl7mEbWzutIThNJHH71DiGrB+YbtIMhKletH3+LaOpQ7kXFEKU0yVkECMgJssvu/z
         IkWr8F95Vk+K1WJqdvWs2RGRP7C1c/cgwDBAwYnZu11a/sHQfQqld9bIugthM2/GGZ5r
         M/PlHt9effc6/sgbf1T0mzN1MK6vCXfmYy2Di1r3HYP1CHyhbOmwl7uvoaJ1QiFf80Ob
         YvMw+p+W29yt3SJjj7QinbCp4Q138xYj4+pkVfF1NSluWjpcRgMweEbBdb0tqgV0PApv
         d3VQ==
Content-Disposition: inline
In-Reply-To: <20191213204026.GA6830@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Fri, Dec 13, 2019 at 08:40:31PM +0000, Roman Gushchin wrote:
> On Fri, Dec 13, 2019 at 02:21:56PM -0500, Johannes Weiner wrote:
> > When memory.low is overcommitted - i.e. the children claim more
> > protection than their shared ancestor grants them - the allowance is
> > distributed in proportion to each siblings's utilized protection:
> > 
> > 	low_usage = min(low, usage)
> > 	elow = parent_elow * (low_usage / siblings_low_usage)
> > 
> > However, siblings_low_usage is not the sum of all low_usages. It sums
> > up the usages of *only those cgroups that are within their memory.low*
> > That means that low_usage can be *bigger* than siblings_low_usage, and
> > consequently the total protection afforded to the children can be
> > bigger than what the ancestor grants the subtree.
> > 
> > Consider three groups where two are in excess of their protection:
> > 
> >   A/memory.low = 10G
> >   A/A1/memory.low = 10G, A/memory.current = 20G
> >   A/A2/memory.low = 10G, B/memory.current = 20G
> >   A/A3/memory.low = 10G, C/memory.current =  8G
> > 
> >   siblings_low_usage = 8G (only A3 contributes)
> >   A1/elow = parent_elow(10G) * low_usage(20G) / siblings_low_usage(8G) = 25G
> > 
> > The 25G are then capped to A1's own memory.low setting, i.e. 10G. The
> > same is true for A2. And A3 would also receive 10G. The combined
> > protection of A1, A2 and A3 is 30G, when A limits the tree to 10G.
> > 
> > What does this mean in practice? A1 and A2 would still be in excess of
> > their 10G allowance and would be reclaimed, whereas A3 would not. As
> > they eventually drop below their protection setting, they would be
> > counted in siblings_low_usage again and the error would right itself.
> > 
> > When reclaim is applied in a binary fashion - cgroup is reclaimed when
> > it's above its protection, otherwise it's skipped - this could work
> > actually work out just fine - although it's not quite clear to me why
> > we'd introduce this error in the first place.
> 
> This complication is not simple an error, it protects cgroups under
> their low limits if there is unprotected memory.
> 
> So, here is an example:
> 
>       A      A/memory.low = 2G, A/memory.current = 4G
>      / \
>     B   C    B/memory.low = 3G  B/memory.current = 2G
>              C/memory.low = 1G  C/memory.current = 2G
> 
> as now:
> 
> B/elow = 2G * 2G / 2G = 2G == B/memory.current
> C/elow = 2G * 1G / 2G = 1G < C/memory.current
> 
> with this fix:
> 
> B/elow = 2G * 2G / 3G = 4/3 G < B/memory.current
> C/elow = 2G * 1G / 3G = 2/3 G < C/memory.current
> 
> So in other words, currently B won't be scanned at all, because
> there is 1G of unprotected memory in C. With your patch both B and C
> will be scanned.

Looking at the B and C numbers alone: C is bigger than what it claims
for protection and B is smaller than what it claims for protection.

However, A doesn't provide 4G to its children. It provides 2G to be
distributed between the two. So how can B claim 3G and be exempted
from reclaim?

But more importantly, it isn't in either case! The end result is the
same in both implementations. Because as soon as C is reclaimed down
to below 1G, A is still in excess of its memory.low (because it's
overcommitted!), and they both will be reclaimed proportionally.

From the example in the current code:

 * For example, if there are memcgs A, A/B, A/C, A/D and A/E:
 *
 *     A      A/memory.low = 2G, A/memory.current = 6G
 *    //\\
 *   BC  DE   B/memory.low = 3G  B/memory.current = 2G
 *            C/memory.low = 1G  C/memory.current = 2G
 *            D/memory.low = 0   D/memory.current = 2G
 *            E/memory.low = 10G E/memory.current = 0
 *
 * and the memory pressure is applied, the following memory distribution
 * is expected (approximately):
 *
 *     A/memory.current = 2G
 *
 *     B/memory.current = 1.3G
 *     C/memory.current = 0.6G
 *     D/memory.current = 0
 *     E/memory.current = 0

Even though B starts out within whatever it claims to be its
protection, A is overcommitted and so B and C converge on their
proportional share of the parent's allowance.

So to go back to the example chosen above:

>       A      A/memory.low = 2G, A/memory.current = 4G
>      / \
>     B   C    B/memory.low = 3G  B/memory.current = 2G
>              C/memory.low = 1G  C/memory.current = 2G

With either implementation we'd expect the distribution to be about
1.5G and 0.5G for B and C, respectively.

And they'd have to be, too. Otherwise the semantics would be
completely unpredictable to anyone trying to configure this.

So I think mixing proportional distribution with absolute thresholds
like this makes the implementation unnecessarily hard to reason
about. It's also clearly buggy as pointed out in the changelog.

> > However, since
> > 1bc63fb1272b ("mm, memcg: make scan aggression always exclude
> > protection"), reclaim pressure is scaled to how much a cgroup is above
> > its protection. As a result this calculation error unduly skews
> > pressure away from A1 and A2 toward the rest of the system.
> 
> It could be that with 1bc63fb1272b the target memory distribution
> will be fine. However the patch will change the memory pressure in B and C
> (in the example above). Maybe it's ok, but at least it should be discussed
> and documented.

I'll try to improve the changelog based on this, thanks for filling in
the original motivation. But I do think it's a change we want to make.
