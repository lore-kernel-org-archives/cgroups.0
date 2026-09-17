Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC273D9556
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 07:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789628490; cv=none; b=mi7hGjDBER3FOxcVGlYPgitbiXzfg5HMOj2Ovy+qhmfXbAP2fqjGhEt/EwN9FB0GDgna/s1ZN2YZmciUSPtPaQDlRQ67kKeaKV7CBMcXCklSpJxJMvGOBvtC+3a2JxVLCywI7hSMJSMW6gktNqP+QG1OCGPACMyt3t/wqlneAOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789628490; c=relaxed/simple;
	bh=4PMSPRmeJVSA0/LfRDquf5uYBdjnY0Aenl/yglzKIVI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kb1HbHl5UzpZFig/+z8cO4KpPRvdafRwYTSHaroVC+cT7IrMaWP4ejuotZ4WeHN50cIIesX072s9OJQIU0ufMouWHBQTcQ03Oc/eNuXpJBOrVFRyu3hyNl5NGHq4iBjg0MxEgqZ+lV6Qgs8YaCymBDAqmYzvthgOkWc3NW4zuxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=JWES4zIx; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="JWES4zIx"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccafb74fso488030a91.3
        for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 00:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789628487; x=1790233287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CWcZ32DEcvckTxaHfwF/iY9dOheOeLm1G2879tq/8J0=;
        b=JWES4zIx2ev7VXkoYCq6u/iDmSehD4/DU2Io/8RzB7moMX8URhZm06MtC3AJF+HI5f
         xubqhDl+BfNXVcZIs2mpTLmNKWA7azeyLSEG88Yc+2Us2u54ZmbTVIs5YTDrqGeIlUL3
         eqbhMX0nlWCCfxXw/H+FJ6wJT7IAqBV+XqoPGjk91XTWT+RFlQ6b8BhlNOD78kvad5wd
         voJpkmsWsZk7pil77vHz9kMXemlK29NDJpE5hjoZmImHe/y0ieaJBkAk1XDw8p4r4bOo
         sRvwMhGze8U7RZbzEePgfbzKesd/2a3+Av2K4PHPjj9kFBP+VfHsL/jrBWKjfWOI+Hf9
         S7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789628487; x=1790233287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CWcZ32DEcvckTxaHfwF/iY9dOheOeLm1G2879tq/8J0=;
        b=2tCtN3dXH2v0fwahELRqrJq9FJGGobK1I6MjBSDtuZiIoVwVi7g/C/jeaPUNaVqCEQ
         J6NS0Oc7hXAoR7zqJ+H4cs8wtkszbjrYuUSlrTtMctlgQy+GwXU2onBimLBjewTcDJ1R
         ujfTdzHj6wdonKQLDcklCQfE/gRfJrMgWJElSxfbZJOAjtKwD9f0NAt42AlvXc5ZIlif
         CdDjW/tTLRHLnwy+E5vV0Mn6GXSseSNoJPg8l/LupvD7i+jDJsBf+VjV9K+gK3LoruRk
         O8dX1lPGG+NJh4t20bJn/npiKobau8wL1Yk5Fmzi39Y8POx+lGdf5Xlyxu+0UNWLKwrn
         3PDA==
X-Forwarded-Encrypted: i=1; AKwUvBxv49+2uldRHjt1EXcRk83XhbGaMENhAzVaZgkW2S8OYWG3rEZoMnVuIquxsG3F3o/jJxR0BrmQ@vger.kernel.org
X-Gm-Message-State: AFuF++n5C73wxroJWAD2EVZRrfFO1k8ty6/+vl67Z8Q2zmfGxtAGjKau
	EdZJVAJOs4w3/CA6tBJ8m74mzDwiddJMaNyjTtr2tY4ksd4sYcCRr2+f4/3BqGozbA0=
X-Gm-Gg: AYBFou1xMxjpI8yg8VlVioGGeF6m1zN+fdBLQ5YtSboFLDq9MVNkTODaf99UHswbLvt
	EhRQGtdgQuP6cGWhwpOFbPPtGnr9zqkWGN+4nVYjM4hYC5wltF+U+dHkiDQCaVHUTgh6/4VMDda
	Z3fcIj6dmzjJpZ9t5bimefsTKLMKF3UUPsxXjzjneEucm3Ed8cFCHafoNoOYwxqYUrzO0xhjTSy
	PQSnJOrFBJx6Z1/I+fhD02uNmalDDmMCi9ckFBqi+Kv441vUBgK5PWSUn3gzXWeuBOpzXg60it/
	dCr6O4+nrXMCMl6bcanAVAFIm2pKyWZZEM7qblAF2kLg7ju+aKy9dhyNGO82Y6Giuf+McN+rYhW
	ba188aA2K8fpGvKLYd/7inKETWJ6XscFEtuT9u80IUlG7Mkk8b/ZyxFK2KF/ZY9unVRp6TMmecd
	bM26eBUI4xN6Fzzh2L30VrYLXeF4A0SanTwJpPhSkkJAp5VPsLKDap9UuNz7tIzBkNey6Muxw42
	g==
X-Received: by 2002:a17:90b:390e:b0:39e:8d5:fcee with SMTP id 98e67ed59e1d1-39e1e4d750emr15487090a91.17.1789628487085;
        Thu, 17 Sep 2026 00:01:27 -0700 (PDT)
Received: from localhost ([106.38.226.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e361b3a39sm3418041a91.11.2026.09.17.00.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 00:01:26 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: [PATCH v6 3/3] writeback: record bdev targets in foreign writeback tracepoints
Date: Thu, 17 Sep 2026 15:01:19 +0800
Message-Id: <20260917070119.2648123-2-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260917065759.2643940-1-sunjunchao@bytedance.com>
References: <20260917065759.2643940-1-sunjunchao@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add dev to track_foreign_dirty and flush_foreign so traces can
distinguish foreign-wb tracking from the bdev-only path. Append the
field to each event and print it as major:minor; zero denotes the
normal foreign-wb path.

Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 include/trace/events/writeback.h | 22 ++++++++++++++--------
 mm/memcontrol.c                  |  9 ++++++---
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 13ee076ccd16..ffd1b8df4231 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -273,9 +273,9 @@ TRACE_EVENT(inode_switch_wbs,
 
 TRACE_EVENT(track_foreign_dirty,
 
-	TP_PROTO(struct folio *folio, struct bdi_writeback *wb),
+	TP_PROTO(struct folio *folio, struct bdi_writeback *wb, dev_t dev),
 
-	TP_ARGS(folio, wb),
+	TP_ARGS(folio, wb, dev),
 
 	TP_STRUCT__entry(
 		__array(char,		name, 32)
@@ -284,6 +284,7 @@ TRACE_EVENT(track_foreign_dirty,
 		__field(u64,		cgroup_ino)
 		__field(u64,		page_cgroup_ino)
 		__field(unsigned int,	memcg_id)
+		__field(dev_t,		dev)
 	),
 
 	TP_fast_assign(
@@ -295,34 +296,37 @@ TRACE_EVENT(track_foreign_dirty,
 		__entry->ino		= inode ? inode->i_ino : 0;
 		__entry->memcg_id	= wb->memcg_css->id;
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
+		__entry->dev		= dev;
 
 		rcu_read_lock();
 		__entry->page_cgroup_ino = cgroup_ino(folio_memcg(folio)->css.cgroup);
 		rcu_read_unlock();
 	),
 
-	TP_printk("bdi %s[%llu]: ino=%llu memcg_id=%u cgroup_ino=%llu page_cgroup_ino=%llu",
+	TP_printk("bdi %s[%llu]: ino=%llu memcg_id=%u cgroup_ino=%llu page_cgroup_ino=%llu dev=%u:%u",
 		__entry->name,
 		__entry->bdi_id,
 		__entry->ino,
 		__entry->memcg_id,
 		__entry->cgroup_ino,
-		__entry->page_cgroup_ino
+		__entry->page_cgroup_ino,
+		MAJOR(__entry->dev), MINOR(__entry->dev)
 	)
 );
 
 TRACE_EVENT(flush_foreign,
 
 	TP_PROTO(struct bdi_writeback *wb, unsigned int frn_bdi_id,
-		 unsigned int frn_memcg_id),
+		 unsigned int frn_memcg_id, dev_t dev),
 
-	TP_ARGS(wb, frn_bdi_id, frn_memcg_id),
+	TP_ARGS(wb, frn_bdi_id, frn_memcg_id, dev),
 
 	TP_STRUCT__entry(
 		__array(char,		name, 32)
 		__field(u64,		cgroup_ino)
 		__field(unsigned int,	frn_bdi_id)
 		__field(unsigned int,	frn_memcg_id)
+		__field(dev_t,		dev)
 	),
 
 	TP_fast_assign(
@@ -330,13 +334,15 @@ TRACE_EVENT(flush_foreign,
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
 		__entry->frn_bdi_id	= frn_bdi_id;
 		__entry->frn_memcg_id	= frn_memcg_id;
+		__entry->dev		= dev;
 	),
 
-	TP_printk("bdi %s: cgroup_ino=%llu frn_bdi_id=%u frn_memcg_id=%u",
+	TP_printk("bdi %s: cgroup_ino=%llu frn_bdi_id=%u frn_memcg_id=%u dev=%u:%u",
 		__entry->name,
 		__entry->cgroup_ino,
 		__entry->frn_bdi_id,
-		__entry->frn_memcg_id
+		__entry->frn_memcg_id,
+		MAJOR(__entry->dev), MINOR(__entry->dev)
 	)
 );
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 55bd5d100caa..f634874bbcef 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3949,14 +3949,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	struct address_space *mapping = folio_mapping(folio);
 	struct inode *bdev_inode = mapping ? mapping->host : NULL;
 
-	trace_track_foreign_dirty(folio, wb);
-
 	if (memcg_bdev_frn_wq && bdev_inode &&
 	    sb_is_blkdev_sb(bdev_inode->i_sb)) {
+		trace_track_foreign_dirty(folio, wb, bdev_inode->i_rdev);
 		mem_cgroup_track_foreign_bdev(memcg, bdev_inode->i_rdev);
 		return;
 	}
 
+	trace_track_foreign_dirty(folio, wb, 0);
+
 	/*
 	 * Pick the slot to use.  If there is already a slot for @wb, keep
 	 * using it.  If not replace the oldest one which isn't being
@@ -4031,6 +4032,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 		spin_lock_irqsave(&memcg->frn_lock, flags);
 		if (!ctx->inflight && ctx->dev) {
 			ctx->inflight = true;
+			trace_flush_foreign(wb, 0, 0, ctx->dev);
 			queue_work(memcg_bdev_frn_wq, &ctx->work);
 		}
 		spin_unlock_irqrestore(&memcg->frn_lock, flags);
@@ -4048,7 +4050,8 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 		if (time_after64(frn->at, now - intv) &&
 		    atomic_read(&frn->done.cnt) == 1) {
 			frn->at = 0;
-			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id);
+			trace_flush_foreign(wb, frn->bdi_id, frn->memcg_id,
+					    0);
 			cgroup_writeback_by_id(frn->bdi_id, frn->memcg_id,
 					       WB_REASON_FOREIGN_FLUSH,
 					       &frn->done);
-- 
2.39.5

