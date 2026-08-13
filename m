Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5997443802D
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 07:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607466; cv=none; b=DZQk951AXk5OhzAZk/G7qJM8tJW9YkTSrffTZ9s03nmY6OvhJprYUVrJDOqaEEIEPUuTAFE6ywCCfRanHqpnhwSNJMm8/bgSp3/fHWZ9PgJpzp0/4e4aMbjQebjJmMdejIWo37jlF/e8vgOF02i0eY5Hv3RdnFJVf3xO4MFq1Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607466; c=relaxed/simple;
	bh=jlsMADLwJ/8YxSz9rHL6HMJ91PlPCeP88izjFdx/g98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYK/5Vq8hNSoGOUrlykdBPkX7h8OUJ+wqMC/9ayx9QP5qtzsqE8udGcA/e9mDN+kKEPuhWo5PSP2QFW+9DM2E4cbBAk0nzcYgeI/1p1s4dbjyjxzTVWFECYIi/tQmqxO6eqoqvI/fw2sZGqtTr8BxyUpAFZFObBWyPYrLEh7Qwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pNjXJjxR; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pNjXJjxR"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cc8311c6ddso2753375ad.0
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 00:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607462; x=1787212262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KIo/hskvY35I+xlwCnjLbjXGmC9TvGJPu5fGHiHuA6o=;
        b=pNjXJjxRevRNPCQHBZj83wnTWvpLCqOKOGkLNOI18DacrxHc3xnf1HzUA1EO4PNcym
         lEFNpfSoqNlwnAI/go33H/vEiFu1CmYFmOI549tFbKUTynD/gvSQdrVxVARqf5+Oy8PU
         rlkMUcJ0QdsCGESHCQErPQBeOBLTSmLGF386AT83FM4p/rO5oBpMk13I3HudNXHHkGBz
         UqP24KXbYX9nZ7ug6kOFoPDlMQejjjkVryjLhPwYnKa4ljz3nowx8TRdjI55vxtpZNIo
         AsYf8RyPVGdfF04AVGUBM8/ZcElpBeaVKA7jw6bsvSx0nrcBLKfIBvlvTSF/9arb6nEY
         j/4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607462; x=1787212262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KIo/hskvY35I+xlwCnjLbjXGmC9TvGJPu5fGHiHuA6o=;
        b=CBVio/YWPxfoGX3hU6qPWllt4hWdFE38BTDmogOMnh04ytVKwiuTdbI6XRD0bGmjfz
         2cVm8wbi5KCrVIHptkyqKZOogSVZujPXND3bpl8bKTxkGLQQcT6lEesd8AyXUrPSDbUe
         ebJFHkWMrQvbzk4x0pG9l5aa+2rIHk6q3PPWe/OyRmHKa0511ZePIf3Z49GMVY+b0rNf
         tjshN4NilQG6lw98JJJ7L6uobk1envYQLCRDbF+VMZt1COpU/E4BQY2pUjRKCXfWZBa+
         VOjgC/OGp2PGXvbPLXcA4GBjxPMuyzkh2sJiJ2rFB9tKm1hGC9OavFQgQSWRxhf2xX+X
         P5UA==
X-Forwarded-Encrypted: i=1; AHgh+RpUMOwu0VQnwEfVL+VHCX51UJNMFsrMhPMonLQ5F4u4fNnbNEA30vJepRLW44a91NZKmqVDNHM4@vger.kernel.org
X-Gm-Message-State: AOJu0YyVJGL44FuvlOYYzgAN4+gqdq7pkyl8LmDdtwECElk7UGQEv8HT
	jKTastAJArmSqpFK+i277oGrJXuhJv1FGKai6KtUsqhMTLpYBe5evL6M
X-Gm-Gg: AR+sD10Q3/N3YWfU27fpeDz1RltRhUX2XPpRhdcGZ2e3kxvK6GAGVv6C0WIBZaSjRY8
	eyUyetc+AEBLiDnRrgwIEuKQbfghcCgfkCY51ovva3uQ2OKc0sNsxSJ6mG0k7S0cUnh+NpThDxk
	1v1pL9owV9qh2Tg1/ZycPBU2coqVkZnyL0ptswUlmfgUsrouj0FAzhi2MFY+4sKg96H5PL/4XzD
	7ljX+wwxVxIklmEJuAzg6A7jZG58Yw4Pe84LBjULpv5XWytgHyAxJPO0c66XkMRqTIpuGeN7dp2
	nh+tvwXtrdKUOIU38RAzp2jLfuFzpbk0O/QS8xDp5ermlcMNRo1kxEyt9lL827d3tcX7FW0FQKl
	IkZ7Fw2d03+PodXeH/WYzLS1X5C99fqmQ8WgdjoMagj3JRg0yi1oltddUkNl2stF5jWXvw6sXDp
	KPKNCtBg4VZlUM3F1MDbzUysXFu5D2OCTLbQnVkp82d05rK9CZMoz2oueDSxVHl2xzZkIATVAaj
	WOlz9JGF2oWOttsVE53mgvaL03g2awbTAFtv/KD/GdSr1PyQMCrsjaDgsNgrm7RQ+mssWkrMFpF
	RsiIog==
X-Received: by 2002:a17:902:fc46:b0:2cf:9e90:8be with SMTP id d9443c01a7336-2d37efb393emr33092015ad.4.1786607462232;
        Thu, 13 Aug 2026 00:51:02 -0700 (PDT)
Received: from debian.lan (n058152058183.netvigator.com. [58.152.58.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c40d6b0sm5550125ad.40.2026.08.13.00.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:51:01 -0700 (PDT)
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
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v6 4/4] mm/shmem: split large folios only on -E2BIG
Date: Thu, 13 Aug 2026 15:50:25 +0800
Message-ID: <20260813075025.1406585-5-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
References: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
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

