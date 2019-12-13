From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/3] mm: memcontrol: recursive memory.low protection
Date: Fri, 13 Dec 2019 15:05:19 -0500
Message-ID: <20191213200519.GA168988@cmpxchg.org>
References: <20191213192158.188939-1-hannes@cmpxchg.org>
 <20191213192158.188939-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AGxRnEh5CXFWXGLun9RvFBMrbc3Csuo1hFkC8taJ9Ao=;
        b=fi8pocFAG1MtH+wrS/RwicUEW6vUdIGEjPL2lsSHOLPBs6UThnygqIyuQc95xton9e
         Yxoneci0+u6nu3ovdvs2nwA6RCfIMHAvQP7WkJLiEs9uazqRsxy1GzWplPGcynkU2vEK
         m7juwjZ8BwyfJRwNzTstai0DRHVpUgvjzk1Q5uqS/8LJE0nHMg3ldrRcWLKuHAHLT9dG
         VlArpH8BK+h7UwtXjWpyLxEFn8kV0wny/tRfB8fOru0yd0avuJOpcJRwpsLKPK0y/1/z
         q1OAdPQzLYkV9FLa/Gez/xOtKcg1Uv+ldtQ5Z2yWXT1+Sl1YJ5Vol1E4IiG9H3W6XsSS
         WQAg==
Content-Disposition: inline
In-Reply-To: <20191213192158.188939-4-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Dec 13, 2019 at 02:21:58PM -0500, Johannes Weiner wrote:
> +	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT) {
> +		unsigned long unclaimed;
> +		/*
> +		 * If the children aren't claiming (all of) the
> +		 * protection afforded to them by the parent,
> +		 * distribute the remainder in proportion to the
> +		 * (unprotected) size of each cgroup. That way,
> +		 * cgroups that aren't explicitly prioritized wrt each
> +		 * other compete freely over the allowance, but they
> +		 * are collectively protected from neighboring trees.
> +		 *
> +		 * We're using unprotected size for the weight so that
> +		 * if some cgroups DO claim explicit protection, we
> +		 * don't protect the same bytes twice.
> +		 */
> +		unclaimed = parent_effective - siblings_protected;
> +		unclaimed *= usage - protected;
> +		unclaimed /= parent_usage - siblings_protected;

Brainfart I noticed just after sending it out - naturally. If there is
unclaimed protection in the parent, but the children use exactly how
much they claim, this will div0. We have to check for usage that isn't
explicitly protected in the child to which to apply the float. Fixlet
below. Doesn't change the overall logic, though.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e352cd6c38d..8d7e9490740b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6328,21 +6328,24 @@ static unsigned long effective_protection(unsigned long usage,
 	 */
 	ep = protected;
 
-	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT) {
+	/*
+	 * If the children aren't claiming (all of) the protection
+	 * afforded to them by the parent, distribute the remainder in
+	 * proportion to the (unprotected) size of each cgroup. That
+	 * way, cgroups that aren't explicitly prioritized wrt each
+	 * other compete freely over the allowance, but they are
+	 * collectively protected from neighboring trees.
+	 *
+	 * We're using unprotected size for the weight so that if some
+	 * cgroups DO claim explicit protection, we don't protect the
+	 * same bytes twice.
+	 */
+	if (!(cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT))
+		return ep;
+
+	if (usage > protected && parent_effective > siblings_protected) {
 		unsigned long unclaimed;
-		/*
-		 * If the children aren't claiming (all of) the
-		 * protection afforded to them by the parent,
-		 * distribute the remainder in proportion to the
-		 * (unprotected) size of each cgroup. That way,
-		 * cgroups that aren't explicitly prioritized wrt each
-		 * other compete freely over the allowance, but they
-		 * are collectively protected from neighboring trees.
-		 *
-		 * We're using unprotected size for the weight so that
-		 * if some cgroups DO claim explicit protection, we
-		 * don't protect the same bytes twice.
-		 */
+
 		unclaimed = parent_effective - siblings_protected;
 		unclaimed *= usage - protected;
 		unclaimed /= parent_usage - siblings_protected;
