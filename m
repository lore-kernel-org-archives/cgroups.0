Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57A548CD4F
	for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 08:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789461265; cv=none; b=EadBO69emfMWCuncWANUq9tZch0w32343dBIMHKdxIWqJUFBGPYU768nP1nZgTd4Vh5KQIWh2Duvv/J0hP+P+/+yd5W9MVVC6SWB0MkN4P/ggDojRa7LQX/pR/3XzKicY9jDyNTIWt3wAvejneROSW9w4n8grqBbsX2FC1FN/2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789461265; c=relaxed/simple;
	bh=K1pwdWPABVVogrJVAed4JnUCOEc5sr2rqKIcsFZ8F8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qkGt61p60Bat79sKKk7cdg040WXmDL+wcaUibbdv3Gdzwd6jtrbvXMTViaGO8x+fn24zEG03SzP2CxfmtAH26mdLdBfNIQz08l1pUGo+EPYGWfl7NjQi0NGRUrAt7V1WGJaDm59rkITDaohfwDPkeIZKBkLprYy/7umVhiDE4tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=cO+gmjWp; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="cO+gmjWp"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1ceb47d53so414033a12.0
        for <cgroups@vger.kernel.org>; Tue, 15 Sep 2026 01:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789461263; x=1790066063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0/yQgHlhdL4OluQwF11kwgzbIv6YOPTPPpwWaUVKRIw=;
        b=cO+gmjWpaegtkKwbDay5XZ2WCKUWworurs0UpoD33U0W6vJlvxftECUHPOXuZfFVI1
         MvizvBk6oJVS+uLJAB+acZlPV+LllzJoo+bDtHz98AHUjS/GL7bj3qAqfOsk7j0w7D/d
         WJzHKJtef/lCb0PGj8/UquvNZ+jaI/7xd7vLUX6Cv30v1Uq/Pnv8P5oNEGwxtskaJmWc
         U09yk1+X4c3yVOCnOa5zWKBbrLEF5WmGatz6EigrRQNsni1vxMGXTccDGjALLc95wopT
         U90q/2d9vvEESAp3XAwZKUw3lxEMh/5kEu10gajlOurhW8/IhmcOCayyrdqSUo2+lBQs
         uCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789461263; x=1790066063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0/yQgHlhdL4OluQwF11kwgzbIv6YOPTPPpwWaUVKRIw=;
        b=f8jSDeucu29o/vQYpNj3uzyOdnsZfZWjRVKGo6IfTUPOI991nYM2iF7eyRUji7OJU5
         nOjNnjHe2sZ6msKQlwnQYy8dRXhqgd0QCym9qg2Ik/MDIH0SKKkLXc1pt4E75bDSFvhv
         vDfSImA7EVUrziap8JIBSu7I7kkLn2egs9vZNyRbarn0ODxalbq/5HyPxpX1YJ8MBIxz
         FeSBXoNps1efN3Eo5NHaB6xCNxk89WyfeTfKgQJf7GEFIH7Y4mlOuc4y9M94uMk99NFg
         toOOH37iw+w7oNJzUqs0PboCgcvgy1D38akB2MO7RgYzaLuch+3UDk2Mrqt82rZWK2wp
         pJHQ==
X-Forwarded-Encrypted: i=1; AKwUvBxiRkiEFnjThIG0I1rBqq/TM5JB80dFsKY5/TF8YxSXgV0Aw4uUM+dU6LDUX8nhGz3f8d1caDkg@vger.kernel.org
X-Gm-Message-State: AFuF++ka0Rueoln8VZItDf6XBNlp9nrItTbCFD3KpNO7LDabrLHIOnkx
	tjLczUU1EOKD59iFoOprfRXNOyLQ3LOI0yKz+NPhbmv0g0GwC75rosSfpXt1A0O76NE=
X-Gm-Gg: AYBFou3ax+mT/b9ztkBDy97EzklYh2ZXtfKpX54J0zOeK4gfdGjwV5kOA3NyGY46Jhn
	wo1YMmxuuWTGHlseSBK5NAUAl4GHqr8aBeTXrefqUL3p6S4q9iTOSg6Z4FKJu5la5ZWfHmEsPYW
	uFiapYq/5Bs6lcjhkh0/kmESvxDFhaeSSF5QEN597A7m1CprfCPy5H+o3I164VyA6miP7gWupzQ
	oVoI8J2S8az3nOhn8ae5EzuX1RQQZ+0LuCb9Z1MeCZutQb5/1SVtFEuz90dmZhOEnXjcUpHtVnK
	dMd0G+vdzbEWOMl2bgyF8g2AbtGcpJN3F7BbaVONPEDPAMOszy3C7soIQgJbv5tZXwRo+LQQnDb
	mijOPx8Fn0C7TuLrvCkfqEZj+/38otsN61PiBbiQvmWSOq6Sl7O2NiuHlzBxr09QzZP9yVNedFD
	JZIYrxyIDFvJksosdslvZ6Bwjkz6tt6pWgeIlyAPfGxkk+/gpydXHgEhxkHq8mO4R2HaRJqsasa
	w==
X-Received: by 2002:a17:90b:3842:b0:39e:b0d:d274 with SMTP id 98e67ed59e1d1-39e0b0dd4c1mr680798a91.10.1789461261990;
        Tue, 15 Sep 2026 01:34:21 -0700 (PDT)
Received: from localhost ([106.38.226.80])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfdd28acbsm3920243a91.10.2026.09.15.01.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:34:21 -0700 (PDT)
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
Subject: [PATCH v5 3/3] writeback: record bdev targets in foreign writeback tracepoints
Date: Tue, 15 Sep 2026 16:34:06 +0800
Message-Id: <20260915083406.3471036-4-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915083406.3471036-1-sunjunchao@bytedance.com>
References: <20260915083406.3471036-1-sunjunchao@bytedance.com>
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
index 61ebe4ab744f..74bc94826392 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3938,14 +3938,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
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
@@ -4020,6 +4021,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
 		spin_lock_irqsave(&memcg->frn_lock, flags);
 		if (!ctx->inflight && ctx->dev) {
 			ctx->inflight = true;
+			trace_flush_foreign(wb, 0, 0, ctx->dev);
 			queue_work(memcg_bdev_frn_wq, &ctx->work);
 		}
 		spin_unlock_irqrestore(&memcg->frn_lock, flags);
@@ -4037,7 +4039,8 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
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

