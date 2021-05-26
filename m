From: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [RFC 4/7] mm: introduce slice analysis into memory speed throttle mechanism
Date: Thu, 27 May 2021 00:18:01 +0800
Message-ID: <5b82f959fb0ae1b0c5a830262c8a455a81da98ad.1622043596.git.yuleixzhang@tencent.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Aj0wDGrf3506OWqgGnOpLsSVIAl44mT2D54DwojMHLc=;
        b=IpoTU6bBMLNJIY/bJBfraSLZcBrMG0J8S0TSD8IAYkrQ5gUi0gAOi/qWF1AuG7PiED
         X9oir5M8gFV/WO1qgS4Tqu9M2uZHFnQYlZza9124S5ZW3c7jAl2OhFTE+dyJLSVJzq8Q
         AAQRKsjhgDvqRr/qhfMwqD+dz1ArA7BCnw1xBjrhAzrZrrWwe11+PhO8nqnQH3TI6RjF
         J1KzlSjqSyishnFJaI8BnG+KxKnBwLpbjSKfJGIkV7+mSl1MsHo8J3aXLZ2odyjhm/gA
         2yxKmDmD7msHP9+Zu4oDLgui9oTK0FdPQhKzwp1NPtt4CGTgibiD5Lsat5b7VQf5BLoZ
         mQbg==
In-Reply-To: <cover.1622043596.git.yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

We separate the statistical period into 10 slices, count the memory
charge in each slice, and compare to the slice speed limit to determine
to turn on the throttle or not.

Signed-off-by: Jiang Biao <benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/memcontrol.h |  4 ++++
 mm/memcontrol.c            | 25 +++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 435515b1a709..230acdc635b5 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -231,8 +231,12 @@ struct obj_cgroup {
 };
 
 #ifdef CONFIG_MEM_SPEED_THROTTLE
+#define MST_SLICE		(HZ/10)
 struct mem_spd_ctl {
 	unsigned long mem_spd_lmt;
+	unsigned long slice_lmt;
+	unsigned long prev_thl_jifs;
+	unsigned long prev_chg;
 	int has_lmt;
 };
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9d7a86f7f51c..05bf4ba0da15 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1403,6 +1403,9 @@ static void mem_cgroup_mst_msc_reset(struct mem_cgroup *memcg)
 	msc = &memcg->msc;
 	msc->has_lmt = 0;
 	msc->mem_spd_lmt = 0;
+	msc->slice_lmt = 0;
+	msc->prev_chg = 0;
+	msc->prev_thl_jifs = 0;
 }
 
 static void mem_cgroup_mst_has_lmt_init(struct mem_cgroup *memcg)
@@ -1440,6 +1443,7 @@ static int mem_cgroup_mem_spd_lmt_write(struct cgroup_subsys_state *css,
 	lmt = val >> PAGE_SHIFT;
 
 	memcg->msc.mem_spd_lmt = lmt;
+	memcg->msc.slice_lmt = lmt * MST_SLICE / HZ;
 
 	/* Sync with mst_has_lmt_init*/
 	synchronize_rcu();
@@ -1452,6 +1456,27 @@ static int mem_cgroup_mem_spd_lmt_write(struct cgroup_subsys_state *css,
 	return 0;
 }
 
+/*
+ * Update the memory speed throttle slice window.
+ * Return 0 when we still in the previous slice window
+ * Return 1 when we start a new slice window
+ */
+static int mem_cgroup_update_mst_slice(struct mem_cgroup *memcg)
+{
+	unsigned long total_charge;
+	struct mem_spd_ctl *msc = &memcg->msc;
+
+	if (msc->prev_thl_jifs &&
+	    time_before(jiffies, (msc->prev_thl_jifs + MST_SLICE)))
+		return 0;
+
+	total_charge = atomic_long_read(&memcg->memory.total_chg);
+	msc->prev_chg = total_charge;
+	msc->prev_thl_jifs = jiffies;
+
+	return 1;
+}
+
 static unsigned long mem_cgroup_mst_get_mem_spd_max(struct mem_cgroup *memcg)
 {
 	struct page_counter *c = &memcg->memory;
-- 
2.28.0

