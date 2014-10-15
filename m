From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 1/5] mm: memcontrol: convert reclaim iterator to simple
 css refcounting
Date: Wed, 15 Oct 2014 17:02:56 +0200
Message-ID: <20141015150256.GF23547@dhcp22.suse.cz>
References: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
 <1413303637-23862-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1413303637-23862-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 14-10-14 12:20:33, Johannes Weiner wrote:
> The memcg reclaim iterators use a complicated weak reference scheme to
> prevent pinning cgroups indefinitely in the absence of memory pressure.
> 
> However, during the ongoing cgroup core rework, css lifetime has been
> decoupled such that a pinned css no longer interferes with removal of
> the user-visible cgroup, and all this complexity is now unnecessary.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  mm/memcontrol.c | 250 +++++++++++++++++---------------------------------------
>  1 file changed, 76 insertions(+), 174 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b62972c80055..67dabe8b0aa6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[...]
> +		do {
> +			pos = ACCESS_ONCE(iter->position);
> +			/*
> +			 * A racing update may change the position and
> +			 * put the last reference, hence css_tryget(),
> +			 * or retry to see the updated position.
> +			 */
> +		} while (pos && !css_tryget(&pos->css));
> +	}
[...]
> +	if (reclaim) {
> +		if (cmpxchg(&iter->position, pos, memcg) == pos && memcg)
> +			css_get(&memcg->css);
> +
> +		if (pos)
> +			css_put(&pos->css);

This looks like a reference leak. css_put pairs with the above
css_tryget but no css_put pairs with css_get for the cached one. We
need:
---
From 2810937ec6c16afc0bf924e761ff8305bd478a42 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Wed, 15 Oct 2014 16:26:22 +0200
Subject: [PATCH] 
 mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix

Make sure that the cached reference is always released.

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bdcd0416a017..42842a47b4c1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1160,9 +1160,17 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
 	}
 
 	if (reclaim) {
-		if (cmpxchg(&iter->position, pos, memcg) == pos && memcg)
-			css_get(&memcg->css);
+		if (cmpxchg(&iter->position, pos, memcg) == pos) {
+			if (memcg)
+				css_get(&memcg->css);
+			if (pos)
+				css_put(&pos->css);
+		}
 
+		/*
+		 * pairs with css_tryget when dereferencing iter->position
+		 * above.
+		 */
 		if (pos)
 			css_put(&pos->css);
 
-- 
2.1.1

-- 
Michal Hocko
SUSE Labs
