From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Mon, 4 May 2020 15:59:10 -0700
Message-ID: <20200504225910.GB20009@carbon.dhcp.thefacebook.com>
References: <cover.1588092152.git.chris@chrisdown.name>
 <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
 <20200429101510.GA28637@dhcp22.suse.cz>
 <20200429140330.GA5054@cmpxchg.org>
 <20200429150414.GI28637@dhcp22.suse.cz>
 <20200429165627.GA24768@cmpxchg.org>
 <20200430145721.GF12655@dhcp22.suse.cz>
 <CALOAHbBub_oojkb5DpXUoHV=-e9PDAeVzJvKvDtyk-9Jg6_Pkw@mail.gmail.com>
 <20200504072342.GD22838@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qk7zY96zEAYh4rvMwIjk8A7NLJslV82xfWPmoz/2mbU=;
 b=fIxd66/reIR7EQggwvNULLm2WznRadcpp00bKTN9nPdo9AQsKFgcRkaUSKlvWXvhSZUD
 7kRxyDnQdOk7SkLoGzC2jWHJihgTPNgso0cKuErKZwxW3n9zYYziw1m9udpl4UgrFhs2
 18d7OqBpWhbXu/d9tEld+EGgi06etafX4UM= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qk7zY96zEAYh4rvMwIjk8A7NLJslV82xfWPmoz/2mbU=;
 b=PUIRW1JkeV41KwtyqG4/E+k1B8wpw4w1VD9eOsNSiaGvKcmBaEKyhxcIYToRbe0Qwg3EktK6A/tKx1eE2Ny/xS1SbFGfKGjUjfKthsG2uJG5VflXo8Bx0Iq1JaM0t9B7bzunPHUYZQUzn8xXzlrRxLnv59YGgzktA7Wmfu7wE1o=
Content-Disposition: inline
In-Reply-To: <20200504072342.GD22838-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 04, 2020 at 09:23:42AM +0200, Michal Hocko wrote:
> On Fri 01-05-20 07:59:57, Yafang Shao wrote:
> > On Thu, Apr 30, 2020 at 10:57 PM Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > On Wed 29-04-20 12:56:27, Johannes Weiner wrote:
> > > [...]
> > > > I think to address this, we need a more comprehensive solution and
> > > > introduce some form of serialization. I'm not sure yet how that would
> > > > look like yet.
> > >
> > > Yeah, that is what I've tried to express earlier and that is why I would
> > > rather go with an uglier workaround for now and think about a more
> > > robust effective values calculation on top.
> > >
> > 
> > Agreed.
> > If there's a more robust effective values calculation on top, then we
> > don't need to hack it here and there.
> > 
> > > > I'm still not sure it's worth having a somewhat ugly workaround in
> > > > mem_cgroup_protection() to protect against half of the bug. If you
> > > > think so, the full problem should at least be documented and marked
> > > > XXX or something.
> > >
> > > Yes, this makes sense to me. What about the following?
> > 
> > Many thanks for the explaination on this workaround.
> > With this explanation, I think the others will have a clear idea why
> > we must add this ugly workaround here.
> 
> OK, this would be the patch with the full changelog. If both Chris and
> Johannes are ok with this I would suggest replacing the one Andrew took
> already
> 
> 
> From dfcdbfd336d2d23195ec9d90e6e58898f49f8998 Mon Sep 17 00:00:00 2001
> From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Mon, 4 May 2020 09:10:03 +0200
> Subject: [PATCH] mm, memcg: Avoid stale protection values when cgroup is above
>  protection
> 
> A cgroup can have both memory protection and a memory limit to isolate
> it from its siblings in both directions - for example, to prevent it
> from being shrunk below 2G under high pressure from outside, but also
> from growing beyond 4G under low pressure.
> 
> Commit 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> implemented proportional scan pressure so that multiple siblings in
> excess of their protection settings don't get reclaimed equally but
> instead in accordance to their unprotected portion.
> 
> During limit reclaim, this proportionality shouldn't apply of course:
> there is no competition, all pressure is from within the cgroup and
> should be applied as such. Reclaim should operate at full efficiency.
> 
> However, mem_cgroup_protected() never expected anybody to look at the
> effective protection values when it indicated that the cgroup is above
> its protection. As a result, a query during limit reclaim may return
> stale protection values that were calculated by a previous reclaim cycle
> in which the cgroup did have siblings.
> 
> When this happens, reclaim is unnecessarily hesitant and potentially
> slow to meet the desired limit. In theory this could lead to premature
> OOM kills, although it's not obvious this has occurred in practice.
> 
> Workaround the problem by special casing reclaim roots in
> mem_cgroup_protection. These memcgs are never participating in the
> reclaim protection because the reclaim is internal.
> 
> We have to ignore effective protection values for reclaim roots because
> mem_cgroup_protected might be called from racing reclaim contexts with
> different roots. Calculation is relying on root -> leaf tree traversal
> therefore top-down reclaim protection invariants should hold. The only
> exception is the reclaim root which should have effective protection set
> to 0 but that would be problematic for the following setup:
>  Let's have global and A's reclaim in parallel:
>   |
>   A (low=2G, usage = 3G, max = 3G, children_low_usage = 1.5G)
>   |\
>   | C (low = 1G, usage = 2.5G)
>   B (low = 1G, usage = 0.5G)
> 
>  for A reclaim we have
>  B.elow = B.low
>  C.elow = C.low
> 
>  For the global reclaim
>  A.elow = A.low
>  B.elow = min(B.usage, B.low) because children_low_usage <= A.elow
>  C.elow = min(C.usage, C.low)
> 
>  With the effective values resetting we have A reclaim
>  A.elow = 0
>  B.elow = B.low
>  C.elow = C.low
> 
>  and global reclaim could see the above and then
>  B.elow = C.elow = 0 because children_low_usage > A.elow
> 
> Which means that protected memcgs would get reclaimed.
> 
> In future we would like to make mem_cgroup_protected more robust against
> racing reclaim contexts but that is likely more complex solution that
> this simple workaround.
> 
> [hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org - large part of the changelog]
> [mhocko-IBi9RG/b67k@public.gmane.org - workaround explanation]
> Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

> ---
>  include/linux/memcontrol.h | 36 ++++++++++++++++++++++++++++++++++++
>  mm/memcontrol.c            |  8 ++++++++
>  2 files changed, 44 insertions(+)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 1b4150ff64be..50ffbc17cdd8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -350,6 +350,42 @@ static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
>  	if (mem_cgroup_disabled())
>  		return 0;
>  
> +	/*
> +	 * There is no reclaim protection applied to a targeted reclaim.
> +	 * We are special casing this specific case here because
> +	 * mem_cgroup_protected calculation is not robust enough to keep
> +	 * the protection invariant for calculated effective values for
> +	 * parallel reclaimers with different reclaim target. This is
> +	 * especially a problem for tail memcgs (as they have pages on LRU)
> +	 * which would want to have effective values 0 for targeted reclaim
> +	 * but a different value for external reclaim.
> +	 *
> +	 * Example
> +	 * Let's have global and A's reclaim in parallel:
> +	 *  |
> +	 *  A (low=2G, usage = 3G, max = 3G, children_low_usage = 1.5G)
> +	 *  |\
> +	 *  | C (low = 1G, usage = 2.5G)
> +	 *  B (low = 1G, usage = 0.5G)
> +	 *
> +	 * For the global reclaim
> +	 * A.elow = A.low
> +	 * B.elow = min(B.usage, B.low) because children_low_usage <= A.elow
> +	 * C.elow = min(C.usage, C.low)
> +	 *
> +	 * With the effective values resetting we have A reclaim
> +	 * A.elow = 0
> +	 * B.elow = B.low
> +	 * C.elow = C.low
> +	 *
> +	 * If the global reclaim races with A's reclaim then
> +	 * B.elow = C.elow = 0 because children_low_usage > A.elow)
> +	 * is possible and reclaiming B would be violating the protection.
> +	 *
> +	 */
> +	if (memcg == root)
> +		return 0;
> +
>  	if (in_low_reclaim)
>  		return READ_ONCE(memcg->memory.emin);
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 05b4ec2c6499..df88a22f09bc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6385,6 +6385,14 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>  
>  	if (!root)
>  		root = root_mem_cgroup;
> +
> +	/*
> +	 * Effective values of the reclaim targets are ignored so they
> +	 * can be stale. Have a look at mem_cgroup_protection for more
> +	 * details.
> +	 * TODO: calculation should be more robust so that we do not need
> +	 * that special casing.
> +	 */
>  	if (memcg == root)
>  		return MEMCG_PROT_NONE;
>  
> -- 
> 2.25.1
> 
> -- 
> Michal Hocko
> SUSE Labs
