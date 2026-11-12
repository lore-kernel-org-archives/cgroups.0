Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794456874;
	b=FpFolRMwVpvKGNKz05I0ijbJrzzSddn2AZ4DjYxOhPqSHyLGGFCswtH+nGMH8u4pCI1+
	 VOlPJg4lNF7KHnf1BrsbHl2HTpcpOrhbN76qTd84pyJg0qL5Shs0tn6zZOK8rPs9IAwei
	 08Sd5uQlxjFOqjGcc/5h1J4wqtKIl/dGLXlhihvEKXVgUfs95w5RvAZ+aUiPbb9H5LUrh
	 0lvecQ1AShD/Hi8FHp8+544u9XCFCvxQkrhQ1kr/ovZd6D9SNL6h18cVQ1L9wZVTkbQkL
	 5tGhcbN7CAzRBAGaBAsmNT7NC0JJEJHGNVcysxQKaNLYnIwjEFy9zVL40RrihAzJwHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794456874;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=P0qgmrxWcWb/JksWnHKqO69AaEHX+kvzj5Qtlp7QKxg=;
	b=FB4iZ5guBa+Ib95PpmrH5zBdB6L89VlzN2BYqBxX9Dnqe63hf1I4db6xk7xAXULL6vlP
	 WeFp/Hiz8Z06+355zafCVRckbeKGbTw3KCru+wh6/boAVvmJN7Bshbkq/u5kdvID8k/R+
	 MUma62P6J450q+a2pr30yCPoslF/b1yAEVA3wtdv/DSnfRMUmsBnCe9I6GRFnMb0m6QRT
	 UxyhVh3h867MXHPPb+4YrUTOH6qf8MAbKi5KW24I6Yy0vyEQ/WuI5gl5SqrpxBibisxBY
	 EhBURJHzdvjDETysi3KtAMGD8alS78S2DOdOnbIj04ToMvJEnKfZ2bhEX1QlUddHzjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=shopee.com;
	spf=pass smtp.mailfrom=shopee.com;
	dkim=pass header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=BnefFp7f;
	arc=none smtp.remote-ip=209.85.216.45
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECDB606A321
	for <cgroups@vger.kernel.org>; Thu, 12 Nov 2026 04:14:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EECDB606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=BnefFp7f
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b10ca4e3f9so2173968a91.0
        for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 20:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1794456873; x=1795061673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=P0qgmrxWcWb/JksWnHKqO69AaEHX+kvzj5Qtlp7QKxg=;
        b=BnefFp7fEaefuztJEvVHtLXepmApEfi/9by6urloQN6Qu7KZmIj4rvSs5W2n4699PV
         O0uDtEPA0Qjh8XFv4tzc/HRWgvM9j6kTwqblWzWXTK8QcTGCGtINI+FacZ3QZaUswnFj
         Ssi8HqC8Mnu9EN8DjgEUSMKFvbYMDdyNG5m60kLa3A/Xvv9x02bBgwtVUhMGvVdvT0po
         E7GCnGZrF9v86RdOihFm/oE90FWSJ4j+4P+DzuLkm2ba7SxEYkTN0njN0rIBvlMKRiFc
         KZCRClgfIhGyi1nfp4wm7wCPVkQRKXIHakLY0v6wfjJe3TB1VIXtQqNMt61mYsonKp2o
         kUKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794456873; x=1795061673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P0qgmrxWcWb/JksWnHKqO69AaEHX+kvzj5Qtlp7QKxg=;
        b=G1P94qFd0XlwHKTUCFWHiVw9xaoW8eBh4peWyx0OrY0AyBaRhiOvzOKk/8kd7XkY9z
         QUpGiW5q21BLxt8GYh6dFm9TZHL1h+KIkBz4BI9bVWSdlHabtlMCPE3XjE0O6tFNA2f1
         oleNSJQSwmSoT3qHOUi5pfD10Mqo/zxFWNlr5yZXVHzZzJ/UKyteFDQgSjEx9UxdDSj/
         bm+qvu32wDhrYlpSvcvM3XYBPaL5BVMDQTjvks1p6WzLfphTiPMveQQ9RLhZnX/xOZMB
         nzNbVbdu0t1LlwkjgFApPvHjBuNLV8Aqoy3fxcscGy/RpXMvjz3iUd5ki/3arx0Qijy8
         Trdg==
X-Forwarded-Encrypted: i=1; AL+hErHZLY6IWVvkNzQ6MHgbefODJKNt53hnv5JGNDqooaFGXxoAkbApR6A1ae6YUeefF1ogvivSMiDk@vger.kernel.org
X-Gm-Message-State: APuU4Z9H5t+xKuhWx2p5qJywQdSBoNPr+d6a07N1EqIsbYMnSh4rmTX/
	F4iy1Whg477tYotgMgcmJX6GtK9T5TuXYkP3cq6nHOmVRdKMFkgKtrVDcCJKuB49uh8=
X-Gm-Gg: AYBFou2jsnfAQJdQOYkbYn57n2jqrSrOMw8xaB9PoDqA8hLO0iUzx0E+jH/QjaalTg0
	ZxT6wVaM4RANE6VX+I2K8m5sFPKjcrUtJPGJ6mbjZkdWt3Nw22oXxGIbA8yUY9zgoaqHno1BvFy
	3kTPQYdSb71fFObYHCrCVYfQRlutylO1+42WQy55TtKieNQMPQ9kBbDobsTS/2gn8PeWVMN05YB
	f8Ld3PyuhUXDqM1XqLNpw00i9iG5MTVoBVeC969jsPfKQHqavDljS3ZYNJE+72z/buVR+YjoXpx
	9GprKNttzKZgiu2f4VMLCWnM2H6Z4jcRwfs40xITMW8RlS/csZdaYMHDzp3GUvlTcM8JEF466oH
	aMQwrn8JzBTr8uXAil8vs1M0VbNGbCEssEkYoCPhCFGj/M6/EGm0Waoh0FU3H7qkDV6n2ylM2N+
	x6T/Q3gCvJc1dJKhQHcNurg06I0cXLaB6mRubCiq1K10mmH2CVMujgj+TnPfJLVIJBxZe+WI1w3
	KQOSYVS9TL/nsFtLkGY5pp+PRpVbB4XbLuiznan/45GVBTzy/nugOW71iipI4XMImMQHywKs2rh
	nCJEgNsn6GNgCa75PSAGQudBpyDxzMMllvmhjsQzPf5Z7MXQgpye+0emoIO7N5R2jo1c2YMnjoB
	QohOUdRJiv7OAJtU=
X-Received: by 2002:a17:90b:1e47:b0:3ad:818f:3da2 with SMTP id 98e67ed59e1d1-3b182fcd7b0mr3552008a91.63.1794456873292;
        Wed, 11 Nov 2026 20:14:33 -0800 (PST)
Received: from LPMV6FJ9FM.cn.corp.seagroup.com ([143.92.118.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b182de1dafsm3451131a91.3.2026.11.11.20.14.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 20:14:32 -0800 (PST)
From: Runli <mingyu.he@shopee.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	littleswimmingwhale@gmail.com,
	Runli <mingyu.he@shopee.com>
Subject: [PATCH v3] mm/bpf: Always flush memcg stats when explicitly requested
Date: Thu, 12 Nov 2026 12:13:48 +0800
Message-Id: <20261112041348.66915-1-mingyu.he@shopee.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
the flush threshold. A concurrent flush can leave an ancestor below the
threshold, so the early exit prevents it from receiving further updates.

Consider root and leaf on a 4-CPU system, with a threshold of 256.
CPU 0 is flushing another CPU's stats after CPU 1's stats have already
been flushed. The counts below are shared stats_updates counters:

  CPU 0 (root flush)                CPU 1 (leaf updates)
  ------------------               --------------------
  clear leaf->stats_updates
                                   add 64 to leaf and root
  clear root->stats_updates
  finish flush
                                   leaf = 64, root = 0
                                   4 more batches of 64:
                                     leaf = 320, root = 256
                                   next update:
                                     leaf > threshold
                                     break; root is not updated

Root remains at the threshold, which is insufficient to trigger a flush,
while further leaf updates keep taking the early exit. The periodic
forced flush restores progress, but until then the root's aggregated
statistics can fall far behind. For example, page cache grows at rate of
1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
the actual usage.

Make bpf_mem_cgroup_flush_stats() force a flush without waiting for the
periodic flusher, while preserving the memcg flush bookkeeping.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://lore.kernel.org/all/avKy9oMwDRjKjfzm@linux.dev/
Signed-off-by: Runli <mingyu.he@shopee.com>
---
Changes since v2:
- Add mem_cgroup_flush_stats_force() and use it in the BPF kfunc to
  preserve the memcg flush bookkeeping.

v2: https://lore.kernel.org/all/20261111071434.34547-1-mingyu.he@shopee.com/

Changes since v1:
- Make the BPF kfunc flush unconditionally, as suggested by Shakeel.
- Leave memcg_rstat_updated() unchanged.

v1: https://lore.kernel.org/all/20260911032905.63683-1-mingyu.he@shopee.com/

 include/linux/memcontrol.h |  5 +++++
 mm/bpf_memcontrol.c        |  5 +++--
 mm/memcontrol.c            | 17 +++++++++++++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 69e1bcc67c58..e4131a368d8c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -988,6 +988,7 @@ void mod_memcg_lruvec_state(struct lruvec *lruvec,
 			    enum node_stat_item idx, int val);
 
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
+void mem_cgroup_flush_stats_force(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
 void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
@@ -1464,6 +1465,10 @@ static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
 }
 
+static inline void mem_cgroup_flush_stats_force(struct mem_cgroup *memcg)
+{
+}
+
 static inline void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 }
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c28560..f04be9479e38 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -154,11 +154,12 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, in
  * bpf_mem_cgroup_flush_stats - Flush memory cgroup's statistics
  * @memcg: memory cgroup
  *
- * Propagate memory cgroup's statistics up the cgroup tree.
+ * Flush the memory cgroup subtree and propagate its statistics up the cgroup
+ * tree, regardless of the number of pending updates.
  */
 __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
-	mem_cgroup_flush_stats(memcg);
+	mem_cgroup_flush_stats_force(memcg);
 }
 
 /**
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..0057e0ab5a45 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -824,6 +824,23 @@ void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	__mem_cgroup_flush_stats(memcg, false);
 }
 
+/**
+ * mem_cgroup_flush_stats_force - unconditionally flush memory cgroup statistics
+ * @memcg: root of the subtree to flush, or NULL for the root memory cgroup
+ *
+ * Flush the statistics regardless of the number of pending updates.
+ */
+void mem_cgroup_flush_stats_force(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!memcg)
+		memcg = root_mem_cgroup;
+
+	__mem_cgroup_flush_stats(memcg, true);
+}
+
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
 {
 	/* Only flush if the periodic flusher is one full cycle late */
-- 
2.39.2 (Apple Git-143)

