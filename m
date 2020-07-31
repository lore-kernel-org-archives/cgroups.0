From: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2][next] mm: memcontrol: Use the preferred form for passing
 the size of a structure type
Date: Fri, 31 Jul 2020 12:13:14 -0500
Message-ID: <773e013ff2f07fe2a0b47153f14dea054c0c04f1.1596214831.git.gustavoars@kernel.org>
References: <cover.1596214831.git.gustavoars@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596215231;
        bh=I2tAEedcO9VAKEGuMTWWvln8PBMTfYVGS0os66wMkfY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rzpsvNgAslere3S82DjTwvt4tab3CYMOiNpoXLvhLB8lRZAaKKuwE2gd8Q2Unnar1
         rW1L8jrg1lAmdNP/L2KZmVwkriP+iGB19V1d1to8r3JHHDA18dKAAHbVnGngJCOSpT
         dNeRXn56qc4/r9Sn4I182ZDXqOKV8N9MDsxH77W8=
Content-Disposition: inline
In-Reply-To: <cover.1596214831.git.gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Use the preferred form for passing the size of a structure type. The
alternative form where the structure type is spelled out hurts
readability and introduces an opportunity for a bug when the object
type is changed but the corresponding object identifier to which the
sizeof operator is applied is not.

Signed-off-by: Gustavo A. R. Silva <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bd7f972ceea4..bd0f56785841 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4255,7 +4255,7 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	new->entries[size - 1].threshold = threshold;
 
 	/* Sort thresholds. Registering of new threshold isn't time-critical */
-	sort(new->entries, size, sizeof(struct mem_cgroup_threshold),
+	sort(new->entries, size, sizeof(*new->entries),
 			compare_thresholds, NULL);
 
 	/* Find current threshold */
-- 
2.27.0

