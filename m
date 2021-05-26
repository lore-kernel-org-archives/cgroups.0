From: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [RFC 7/7] mm: introduce mst low and min watermark
Date: Thu, 27 May 2021 00:18:04 +0800
Message-ID: <8bcece04ee8ac9a065ad7603fc07a097c69a1278.1622043596.git.yuleixzhang@tencent.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pl6dvHU30PgX6inAcxI6IEegFN0mmkGWsJaYSmJnWfo=;
        b=H1iSHg/ma1Xsf1EM6/6EaiMPq6PgnGV3dfuWqsO/+rxQm+dS7MOO88auKUH80uZjma
         x0EDL0h0MjNBsI9h4evzDOmlTCpQbB2H+wOdUWCekdgmqM3TAP9pins9czC5lqXkh9TM
         SNglB/DSaOsTplFXR9SBXOrfY09JkU10llOSYtUcruCe7EdpHkRPSD3BrKO2VIAL/oaq
         P6DZshctJHsEbi5PH/LpozNSV2lwAkMBnkxONPa4rgYKb7NcP4LHVzEQRvIjCuT5thux
         bHCruQgQtP+6a+5UGRdp4qsR5j1wRZ1+UOrfYu3HG2d4G3xRF51UtzX+xAh3GzvmpCP5
         OKaA==
In-Reply-To: <cover.1622043596.git.yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jiang Biao <benbjiang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Memory allocation speed throttle aims to avoid direct reclaim caused
by memory usage burst, which mostly happens under memory pressure.
As unconditional throttling could introduce unnecessary overhead, we add
two watermarks to control the throttling.

When mst low wmark reached, we start to throttle memory speed if it is
overspeed. And if mst min wmark reached, we do throttling directly everytime
charging without checking the memory allocation speed.

Signed-off-by: Jiang Biao <benbjiang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/memcontrol.h |  6 ++++++
 mm/memcontrol.c            | 31 ++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 59e6cb78a07a..011d1426a924 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -241,6 +241,12 @@ struct mem_spd_ctl {
 	atomic_t updating;
 	atomic_long_t nr_throttled;
 };
+
+enum mst_wmark_stat {
+	WMARK_OK = 0,
+	WMARK_REACH_LOW,
+	WMARK_REACH_MIN,
+};
 #endif
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ca39974403a3..b1111dc8e585 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1546,18 +1546,47 @@ static int mem_cgroup_mst_overspd_tree(struct mem_cgroup *memcg)
 	return ret;
 }
 
+static enum mst_wmark_stat mem_cgroup_mst_wmark_ok(struct mem_cgroup *memcg)
+{
+	int nid;
+
+	for_each_online_node(nid) {
+		unsigned long free, low, min;
+		struct zone *zone;
+
+		zone = &NODE_DATA(nid)->node_zones[ZONE_NORMAL];
+		free = zone_page_state(zone, NR_FREE_PAGES);
+		low = low_wmark_pages(zone);
+		min = min_wmark_pages(zone);
+		min += (low - min) >> 2;
+
+		if (free <= min)
+			return WMARK_REACH_MIN;
+
+		if (free <= low)
+			return WMARK_REACH_LOW;
+
+	}
+	return WMARK_OK;
+}
+
 static void mem_cgroup_mst_spd_throttle(struct mem_cgroup *memcg)
 {
 	struct mem_spd_ctl *msc = &memcg->msc;
 	long timeout;
 	int ret = 0;
+	enum mst_wmark_stat stat;
 
 	if (!memcg->msc.has_lmt || in_interrupt() || in_atomic() ||
 		irqs_disabled() || oops_in_progress)
 		return;
 
+	stat = mem_cgroup_mst_wmark_ok(memcg);
+	if (stat == WMARK_OK)
+		return;
+
 	ret = mem_cgroup_mst_overspd_tree(memcg);
-	if (!ret)
+	if (stat == WMARK_REACH_LOW && !ret)
 		return;
 
 	atomic_long_inc(&msc->nr_throttled);
-- 
2.28.0

