Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B65A2459E1
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 04:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788064192; cv=none; b=LsCICS2R/JS9m8hh+Q71MSHZLRhwpqV86sHS11TXcMRcn9eH08VW6JGhIWc59V4o/et2Fy+y4oqi2QvarxtLnEFtVZj5tnSYbVrg3aN89mXFUTuFeSZqYOJrIgp3XonPb1UjbzHYKBJ2ZX6DlD/KyK/5Dk8HYawpxp3OhBeoxg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788064192; c=relaxed/simple;
	bh=jlsMADLwJ/8YxSz9rHL6HMJ91PlPCeP88izjFdx/g98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPYSs3C8Ck34Xmit4kFHhAVSkEABGc0E8CFjRbYT6Tz8vCzULdDhwPZhNGSMp/1nZNXpPXH2dICDcDr1yAZBboNlNGc0I2Qg3yWxLT2m9UqzkpIeKzGBsgxkvCLF2CuPx+eRJs7NUpzPnssae2Ks2AXVVWxBTjDISbwaW5piZBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpbJopTz; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpbJopTz"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cbedaf975a3so431979a12.1
        for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 21:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788064190; x=1788668990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KIo/hskvY35I+xlwCnjLbjXGmC9TvGJPu5fGHiHuA6o=;
        b=mpbJopTz2shr256SUkJKWCQdm9lOEfGY945rK4iIzon94pyGIhVrnIOqPkwgJhnUP2
         dbypGfwEkK7zPUNt3mioR6C+IX/r+eaPEKZgBPGTUCLOnBkEXLSrXV92isi4HWFsVo0K
         Zkll0fwfSiKia8d1fJzZg3ulaF6qpzMWzi8Jucr7T9pKSyPILIC2rR0E/0iKoj8Ctwb6
         or4m9wiiWepxRxbRUJkoXeSyNexWayThA0K7bKupVSFY/lI6MM1NCBu5CBaFjMmlbUYR
         Dnylv3hkUwyvjpdZnDhsqN7+kQMn6BDYzE7h3nL7Z+i/Z9p2PtqTsdlS1375k9N5ArBx
         d8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788064190; x=1788668990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KIo/hskvY35I+xlwCnjLbjXGmC9TvGJPu5fGHiHuA6o=;
        b=UWj/mwd+uEa8dbD1FkGLOftYJkjE0UiRN6hDidg4AItlVzNA6It7DbLolSPuRtQLTi
         PU9+79vG75EkecaH7I97d/Z4EbHLQEyaPbu5DV1W1bFfyVbnLHStqgDDuclTVFby0x9E
         siLXZHOYmThEfn0x/fS8M6BplflRr5jEGL7osPqz4G6YgQLDmwT8wkWBl9Vlm91ULP0B
         AxNTHzQl0/J7thU2aa1Y6mjj96tgj6oMWT6uy7MGLrlkSSxy0P00Xzs1rSLY3LJ4lBdv
         q9WKtneW2uftjtxUk2YUnbPZ1tTrKpt3BbE6PV8mNhQSwi5w6pBNsWYccCWaw3dENahr
         ky6A==
X-Forwarded-Encrypted: i=1; AKwUvByRXsc8Zx2dGAqIhAcQ1fSjeMOFQrrrgkUYYjWkjwJmSCwP1m3ykqaHiyNgv355eRocI38dtF/l@vger.kernel.org
X-Gm-Message-State: AFuF++mcibzcwv3AoXDUjhLoKkX7pF1GJ7ukSJpdLk2IbwA2NYhKjmnz
	RQKQFfCIl5O9PL4fqLyNPkq22OXZCmOuqB2/KbmKZEv/4cX+IdQG72I8
X-Gm-Gg: AYBFou04Wk4GyK6sBvH91ntJ1RYdXmFJphoHH6RMTgAv+o0ykYBjvbEK43lKsVxEk0V
	57PcGzZ7AwRv8m0XFXUqnsQtzNYxS3Q7Ju1pHy8MawL/eQg0xaH9hJNlT1HXc26ImGuQHe/RMBq
	dtJ/wrNM9w4kgs7jhNVAflyxUT90yjyyXIfwZJlZ/s+enxNSLKyhGlQXXjqkNea8eQrG71F2/gC
	H371+DMQ7NuUhb+/9LLy91UeTJTFHxsacyzeZ2OVT4Itu1EIRCUZv1aGsaOUsyv3UIU06So7mhF
	hxpvMGJrqLUDj4VmmNHqisRAgvixkO5Y1opB/L1JMigiqEw7WcOT5aEVmESDPgXMsAgS8Qo8Eda
	7QOMSncJi8CpKBBnepK2Y7C96SZ+3suWtGDqDXSb+gKJljPemXGve+wfydBoFvdOFZa+lImy4Kx
	GgsW56oaN9NhVtfS+KliiNrrRh/0FzSZKLGvFLRm6SYf77e2o9uhD/DCybBh7TaRmOGn6xxwdOn
	3oY2zSBXXt7hy4cMUmaav/bsK5dj3xIibhhQccfUfkwmqfolVgr
X-Received: by 2002:a17:903:1106:b0:2d7:1a3f:8db5 with SMTP id d9443c01a7336-2d74e0c729bmr155654705ad.4.1788064190386;
        Sat, 29 Aug 2026 21:29:50 -0700 (PDT)
Received: from o6.lan ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8f98d46casm7493535ad.83.2026.08.29.21.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 21:29:50 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	xueyuan.chen21@gmail.com
Subject: [PATCH v7 4/4] mm/shmem: split large folios only on -E2BIG
Date: Sun, 30 Aug 2026 12:29:20 +0800
Message-ID: <20260830042920.2280454-5-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

shmem_writeout() currently splits a large folio on every
folio_alloc_swap() failure. With the refined return-value contract, only
-E2BIG indicates that splitting might allow smaller folios to be swapped
out.

Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
redirty and reactivate the folio as before.

Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/shmem.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6641823bed16..eff38bb33d8a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1608,7 +1608,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	pgoff_t index;
-	int nr_pages;
+	int nr_pages, ret;
 	bool split = false;
 
 	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
@@ -1689,7 +1689,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio)) {
+	ret = folio_alloc_swap(folio);
+	if (!ret) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
@@ -1742,7 +1743,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		swap_cache_del_folio(folio);
 		goto redirty;
 	}
-	if (nr_pages > 1)
+	if (nr_pages > 1 && ret == -E2BIG)
 		goto try_split;
 redirty:
 	folio_mark_dirty(folio);
-- 
2.47.3

