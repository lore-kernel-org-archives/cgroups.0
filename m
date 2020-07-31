From: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2][next] mm: memcontrol: Use flex_array_size() helper in
 memcpy()
Date: Fri, 31 Jul 2020 12:12:53 -0500
Message-ID: <ddd60dae2d9aea1ccdd2be66634815c93696125e.1596214831.git.gustavoars@kernel.org>
References: <cover.1596214831.git.gustavoars@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596215210;
        bh=+VUSWtEU2obYc+ePK90t3RP8I0yTyfzAx4iIOrUuZ74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GAtSmDC2w2Ln8WEh56WQL62yee5akpVM/VnuiX7LQro9A/Sugff2KEgX4ZZhQfEjt
         AXtxfpZPx3m5Ximt3xarWPZ9mJHS/3AZd/8YL4lrbbEMgE983KIrz+1CvhlmfuC4/W
         lBnYRB/UOVWASkawWXD+zIapf/NNgOuCqNtAFETk=
Content-Disposition: inline
In-Reply-To: <cover.1596214831.git.gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Make use of the flex_array_size() helper to calculate the size of a
flexible array member within an enclosing structure.

This helper offers defense-in-depth against potential integer
overflows, while at the same time makes it explicitly clear that
we are dealing with a flexible array member.

Also, remove unnecessary braces.

Signed-off-by: Gustavo A. R. Silva <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e84c2b5596f2..bd7f972ceea4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4246,10 +4246,9 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	new->size = size;
 
 	/* Copy thresholds (if any) to new array */
-	if (thresholds->primary) {
-		memcpy(new->entries, thresholds->primary->entries, (size - 1) *
-				sizeof(struct mem_cgroup_threshold));
-	}
+	if (thresholds->primary)
+		memcpy(new->entries, thresholds->primary->entries,
+		       flex_array_size(new, entries, size - 1));
 
 	/* Add new threshold */
 	new->entries[size - 1].eventfd = eventfd;
-- 
2.27.0

