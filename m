From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] Revert "mm/vmscan: never demote for memcg reclaim"
Date: Wed, 18 May 2022 15:09:11 -0400
Message-ID: <20220518190911.82400-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RYqL0MLG1DbGBmgYMURzmvbXpQhyxhj8gl5i89V5r90=;
        b=f4jYk60DD7udDhMwkKHqiV6/3YrbRjeifcxR7rq36/5EDL0R7jhskIGVLU0Im7kLx8
         70gOwl8k95pY8w6wTsYt4l1qya3jYGUjdU4krCPxnEwDJZa+O9K1GV6WOJqvpU0N2hsU
         jNbS2Xf5epeNioenJq5vogiBiqKhhtztNd332raQBunqiAtMwZXRSZ4vS9FZ2zahG2Xz
         Tdtr/WGcNNFQ3sVbXiMJDn7gQQlPw+hV9neokhvbfEx5F6p+rgK6OIluXTNfrNY5OHg2
         kr/uYhgBp3FfZ8WlbmqCx/n3SI1I2Qukgj7FPLw+jAg39ZLZlyNizMY6oHGkhfwWayAv
         A6pQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

This reverts commit 3a235693d3930e1276c8d9cc0ca5807ef292cf0a.

Its premise was that cgroup reclaim cares about freeing memory inside
the cgroup, and demotion just moves them around within the cgroup
limit. Hence, pages from toptier nodes should be reclaimed directly.

However, with NUMA balancing now doing tier promotions, demotion is
part of the page aging process. Global reclaim demotes the coldest
toptier pages to secondary memory, where their life continues and from
which they have a chance to get promoted back. Essentially, tiered
memory systems have an LRU order that spans multiple nodes.

When cgroup reclaims pages coming off the toptier directly, there can
be colder pages on lower tier nodes that were demoted by global
reclaim. This is an aging inversion, not unlike if cgroups were to
reclaim directly from the active lists while there are inactive pages.

Proactive reclaim is another factor. The goal of that it is to offload
colder pages from expensive RAM to cheaper storage. When lower tier
memory is available as an intermediate layer, we want offloading to
take advantage of it instead of bypassing to storage.

Revert the patch so that cgroups respect the LRU order spanning the
memory hierarchy.

Of note is a specific undercommit scenario, where all cgroup limits in
the system add up to <= available toptier memory. In that case,
shuffling pages out to lower tiers first to reclaim them from there is
inefficient. This is something could be optimized/short-circuited
later on (although care must be taken not to accidentally recreate the
aging inversion). Let's ensure correctness first.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Zi Yan <ziy-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
 mm/vmscan.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c6918fff06e1..7a4090712177 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -528,13 +528,8 @@ static bool can_demote(int nid, struct scan_control *sc)
 {
 	if (!numa_demotion_enabled)
 		return false;
-	if (sc) {
-		if (sc->no_demotion)
-			return false;
-		/* It is pointless to do demotion in memcg reclaim */
-		if (cgroup_reclaim(sc))
-			return false;
-	}
+	if (sc && sc->no_demotion)
+		return false;
 	if (next_demotion_node(nid) == NUMA_NO_NODE)
 		return false;
 
-- 
2.36.1

