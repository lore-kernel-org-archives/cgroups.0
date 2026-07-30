Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131A733FE1F
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 12:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785414255; cv=none; b=kopNx/4zSBSwLcHSJOvn7qbo3rODv4+ZNVFlqZt6G5dqQdMWQaKEgB+TD60r2q2eE3n/eAILb1QWr8Fmib9MGO1NioGcZBM4n3GXDfHdVIoqGVS3n6xLWy2WUB1m23e/aD43x6uV5Z3PC/x2beuMdK3UNYMEpLcbs2BHuCy+ZGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785414255; c=relaxed/simple;
	bh=/YLwAIx1IePtTLRpcEJB72jvYszfyQ9kOX87oJ92Qp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWnssuNT+HXiiIX89Tkr9HxOIFFRe+sFAsEb4mGKk+VfR2F+RlmCY8IT9FTneYjX7yyhZAleyJQWQon5D9o5dMnl5909KnCEtS9nR1EnhEi0rJ8lirPIiFo2fMvL1ki2MdQf15BadFhT0P6sfjoCER4DY+vEaFoFiekUdF+IsAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MUYYvj/E; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MUYYvj/E"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-848c995c29dso168716b3a.3
        for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 05:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414253; x=1786019053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/RGpHiNOj0NcL67RlZfv7xKhE6bvWiukeFGqq8NSX9Y=;
        b=MUYYvj/E7O5uJ0n1yDEct5uzYc56wpZy/YzIQgYSxddp2nW35SSHetjLmdUN94pkUl
         WXD47H2ZxqwMQX7fqZCf0aZyhm7tNew0kguYxi7If0LHmTT7LIdiTjme/XCKl1RDTfiZ
         rjHf4yX0krUNv7W5meCDpgqi591EZ/Hp72KICTFO5fFlNh7IrCMT0zNwlcnKgxylxCVs
         a7T4JR/F3F98GgqZJ+dmp6iFtSwVaMPAc80V+cLBOvTzWuObb1QcxJzcw1nxZZjveVNr
         G/P4/qD/4WgDbv8cYviWdZ78/m/KtyBe2c2DiIUbwkwKw/Q7LNltgsgHKatILNRZ37vL
         nnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414253; x=1786019053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/RGpHiNOj0NcL67RlZfv7xKhE6bvWiukeFGqq8NSX9Y=;
        b=YaVs8mV/Z9ChDXoFkH4ipCC4jOEm0r1l701+6iWGegtYSH2Cn4lJ689+S1YmGSwY31
         w9GfxuFv/5g/dHlo9Us5WOk9Y+G5hNN0qsz8yxDbDrpcdiSdYDN7SJFCi8bIMpk1VyI6
         R+OgQRhYuNsaWhtRvadJS5x5vZNXkJ8Kjj1Lg7UsI6SZIztXYuh7XpcntHkmuA5fsTco
         BgXfRiV9mJejS53SVWUW94DqRPVPZtnZtq09lS67d+iG3VNO8o+We/p9xmBFCDXVCJmr
         rpyV008fuPaqL1RTZ1EYkZ+ogasYjAMVjukEtOi2DhnPApYa3EMSJcxqWi/H5stFwtzD
         27Fw==
X-Forwarded-Encrypted: i=1; AHgh+RqZnfI5a8YbVZmrxJQTI4SKcx1uHMbGM44q3bAPwZ3EyXUkzlsMoaolWWaJE/cpw4CFZwGowynb@vger.kernel.org
X-Gm-Message-State: AOJu0YzcQurK3BCXnk0bRPbvAyZiVnb6yPHvOuPB8a52tFaE97qd3ald
	+a+nDtosekqhn9Z4EB+jqxoGilPSuJWgCaKVk2klBaRGknZbbaoICv80
X-Gm-Gg: AR+sD1255Rx8tKk9HUt1L4mHvo/CkP4absRU4az8rGdUj9kJYgIp8Rj1z4FW7QZcMqe
	ZqmaESCJ+kNCyUBrskzG9Z1zD08jdUWIJr6jwPq+7vBBmQUb2jVozt0b/OzbkCdt93hmUnwNEVp
	22lH505BHNHd+8mnHkiCr1tjXD1ARGswvD48F68OEOQoF0Zasnow1CpZbcqTlFGSOgEUWTwCqBg
	Irsubc9vygnBC/okQqOsyV89OpgDXq8GVxhGJdWQvy51R5cjpteyWXrGBat0P/OUUChbRt8atEL
	92DBWXoQ2r8i6Ozn62hT3PDErXOSvIEYBXiv5psxzryPHz3TjDT7tezE26uDrlL0GWmykdtkyB0
	mgignEVJybXbRpRw0amf1pjLMGlfm1/0uq23SWdZk+S0J0vFqXuLiRXDrH5ewOLOC+JY4un2c6o
	4FnPprVgkojGEhQilKLqswT5J5QE4pvO+bmCj7QaB01WOUVwve8T4vdLyNXzDmh58zlBpibLPnO
	uikXtcCjyAk8u7RyXN9J2Fki5foSwFA+/kEA/GiOJvUnIYa5cd/
X-Received: by 2002:a17:90b:33ce:b0:38e:549:9e04 with SMTP id 98e67ed59e1d1-38f9bd12949mr2653937a91.1.1785414253215;
        Thu, 30 Jul 2026 05:24:13 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b72d243sm995698a91.10.2026.07.30.05.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:24:12 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Subject: [RFC PATCH v5 4/4] mm/shmem: split large folios only on -E2BIG
Date: Thu, 30 Jul 2026 20:23:04 +0800
Message-ID: <20260730122304.2496440-5-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
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

