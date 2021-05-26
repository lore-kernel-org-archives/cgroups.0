From: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [RFC 6/7] mm: record the numbers of memory allocation throttle
Date: Thu, 27 May 2021 00:18:03 +0800
Message-ID: <46a38b81ebd7b43b6603249aea1d2361634b6c27.1622043596.git.yuleixzhang@tencent.com>
References: <cover.1622043596.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zQ040QfcPG4lHUi4S0IEUYk2U7PBxtj8LmdZLbyNSis=;
        b=DTr76h8fO+Od5pZx0kuxRvXY9JknFBdGEDQqcSpfO88BQBthVVuifFlteZt2EpcI3s
         vNmfenAlhMAEmAADaBDQp3v6L4SqONcJnxl19ESUK5+D/wQ3FilO3hpJtccIICkPlPfU
         gWHvYCAeSrIMHcS78AbQfawpcUEIeg10EEpDJ0SDYhl0O5h1HXDdKpoPvmyAOZF1tqqR
         Lw5UlNG0YUqNvgodO2nyl1JCTiIvxk6VzVZUy1+0qKVz1aEThq/PUMwpWacqY0y678WF
         dVoIJ0tjKlSLZkdFNNEx0iXTAp4ohaPscDuPjKI5Rk4mFXnCwACKPA7cKjI8dpeR9rf2
         O1Fw==
In-Reply-To: <cover.1622043596.git.yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jiang Biao <benbjiang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Record the number of times we trigger the memory allocation
throttle.

Signed-off-by: Jiang Biao <benbjiang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b20820f7fdbf..59e6cb78a07a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -239,6 +239,7 @@ struct mem_spd_ctl {
 	unsigned long prev_chg;
 	int has_lmt;
 	atomic_t updating;
+	atomic_long_t nr_throttled;
 };
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a1e33a9e6594..ca39974403a3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1401,11 +1401,19 @@ static void mem_cgroup_mst_msc_reset(struct mem_cgroup *memcg)
 		return;
 
 	msc = &memcg->msc;
-	msc->has_lmt = 0;
-	msc->mem_spd_lmt = 0;
-	msc->slice_lmt = 0;
-	msc->prev_chg = 0;
-	msc->prev_thl_jifs = 0;
+	while (msc->prev_thl_jifs ||
+	    msc->prev_chg ||
+	    msc->slice_lmt ||
+	    msc->mem_spd_lmt ||
+	    msc->has_lmt ||
+	    atomic_long_read(&msc->nr_throttled)) {
+		atomic_long_set(&msc->nr_throttled, 0);
+		msc->has_lmt = 0;
+		msc->mem_spd_lmt = 0;
+		msc->slice_lmt = 0;
+		msc->prev_chg = 0;
+		msc->prev_thl_jifs = 0;
+	}
 }
 
 static void mem_cgroup_mst_has_lmt_init(struct mem_cgroup *memcg)
@@ -1552,6 +1560,8 @@ static void mem_cgroup_mst_spd_throttle(struct mem_cgroup *memcg)
 	if (!ret)
 		return;
 
+	atomic_long_inc(&msc->nr_throttled);
+
 	/*
 	 * Throttle the allocation for amount of jiffies according to
 	 * the fraction between the actual memory usage and allowed
@@ -1586,11 +1596,22 @@ static void mem_cgroup_mst_show_mem_spd_max(struct mem_cgroup *memcg,
 	seq_printf(m, "mst_mem_spd_max %lu\n",
 		   mem_cgroup_mst_get_mem_spd_max(memcg));
 }
+
+static void mem_cgroup_mst_show_nr_throttled(struct mem_cgroup *memcg,
+					     struct seq_file *m)
+{
+	seq_printf(m, "mst_nr_throttled %lu\n",
+		   atomic_long_read(&memcg->msc.nr_throttled));
+}
 #else /* CONFIG_MEM_SPEED_THROTTLE */
 static void mem_cgroup_mst_spd_throttle(struct mem_cgroup *memcg)
 {
 }
 
+static void mem_cgroup_mst_spd_throttle(struct mem_cgroup *memcg)
+{
+}
+
 static void mem_cgroup_mst_has_lmt_init(struct mem_cgroup *memcg)
 {
 }
@@ -1678,6 +1699,8 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 #ifdef CONFIG_MEM_SPEED_THROTTLE
 	seq_buf_printf(&s, "mst_mem_spd_max %lu\n",
 		mem_cgroup_mst_get_mem_spd_max(memcg));
+	seq_buf_printf(&s, "mst_nr_throttled %lu\n",
+		atomic_long_read(&memcg->msc.nr_throttled));
 #endif
 
 	/* The above should easily fit into one page */
@@ -4131,6 +4154,7 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 #endif
 
 	mem_cgroup_mst_show_mem_spd_max(memcg, m);
+	mem_cgroup_mst_show_nr_throttled(memcg, m);
 
 	return 0;
 }
-- 
2.28.0

