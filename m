Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD99E3F9292
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 12:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784291157; cv=none; b=Xo/8tnoL3vDzV3jX0kTmnsW6SkXbLSzi1OyDgdxli8cBUcI2tBS5Ydp8uwa2eZGzz/jN03jeNhCo+KXtIfLqlFN89eRKo23UeokgFqHwoRjLJ2lEGQ7ObxpE/NmoeCMGMD3www/Kg6wUSQCA6ihiX9joPHCgmaPbnE7/x/knKWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784291157; c=relaxed/simple;
	bh=2aWhzNwCb1BPCutP5oLGQCez7hpPKAKMLp03Caf1XA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbutPwIDOVkcXV74n1s0guvLe2XKGFb4e8GcPN5HSYns7cJspqpEyVCa0br3+9eJujk7p9kpOu9BRLpH/zVFiNd0wmP6oOurMVUUrLiL88qwtcllf/5g0nl9IXEytlUQFkbZw8KHPpiZvw0P+jozYL0BskUusXG1XwG418FfGyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ljbm+NDx; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ljbm+NDx"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cecc8a3dbfso4242445ad.0
        for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 05:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784291152; x=1784895952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TomD5kQp4QDVC9gWt3p58S/rBPFQXp4PWIaI11lLUvQ=;
        b=ljbm+NDxp2Ve297pyq8DLLHe6Ax4IRi9VHeq/WLyf+XAHGegomh6sN0CNhq83rsY4j
         OqfWbE1alXJMxHlrgWKlli6row4hhD1nOXiKGB82bG9XWDfKo/VA5klboyhBULB45MT7
         UbC4oJgCZd5XASw3vSawAQ2l1i+8UnRc4iI8K8pwFqpAp74NtnZdHW8BhAaf00QKr98q
         tsS1KhgYtXgxMik/f8BBAIit17gnHsnDyFfpXHQbgu0u6dAChnxd0lSUF/LwAZPoUoXH
         durgplNqv6pMPhF+P9joJ/zxOAkPwFJtceuruLBvod9XTcm0VgrkQyiql1ypTBtl0U6C
         A/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784291152; x=1784895952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TomD5kQp4QDVC9gWt3p58S/rBPFQXp4PWIaI11lLUvQ=;
        b=VDvRxkZTG1rOF6PPgQIGqovk1pHshgayRTN1GZxYMJBnTR23UpGb6TmdYxphZVH25Y
         TjaY+oq87Aos7wrRvRu67FLnk5NCqicpP1wf8kNAkj3aGnOC28dDnPDnTB0kGwR8xGkn
         QZfHFNf9EG4NfPl/f6PWxfcqVMVBsuE/Fywm/+4dL8SA+tPotExSS5P29u9nxwDNG724
         sjh0lmL7mBqw3/7zc27YJpMuG5Jt39r4R0o+nC88MWZh2axqbsUa9CFMKbm1erLdgQRb
         ZjLSirpr4ZDGEz5fg+nOvC673efaDsPB00CCpOdlgNq7p9UXh83ZprbDrXXcZSU1K5ar
         fTRA==
X-Forwarded-Encrypted: i=1; AHgh+RpVixSUR53+563Mm3u418s43WXMAwjsz5Z8gK/bZlR5G1ELtKy/OzSTn+PPbbJVU29reWPvaJvl@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8TSkVOUIBxm1DCCsP7Z10wzD5LZLDmJebaxvpFJ+kJW3UvbDY
	k5gZxtzNeCBBB6gWDsah3NTI/Gvv2fwGIbuZa166NHTxYqirwm7HJR7j
X-Gm-Gg: AfdE7cmTzNxfAz0XXZVzNH8gvp00sQEJriyMw7/KdjbpS4KM98XYQBCjFM/MI9EastA
	cvorzK+tw/iY1hC88YtFxk8KRFXZYsB2YthkXwt0Eay8AE86jFcSv9fTZg0zNzdxIJIZiE/eXo2
	nhvxNBoT/F11GNAVQZFkbgacnbTDO9CS/BnZqgASKbCF8Y0vjLc3I/KAczRKGcCKx3wQ5xf3dVc
	0fdm2HhYzHukvfNTmrQMlpjlYjUYWS6T9/YGTujTVYt6pKop16NfEyXGHGwjnGcOP6a1dVbeboL
	/PaWuBOcyItD9uoRXh1KVRFhQomlvhwJSY8QQkquKnIdUeonCoq15YLcxnJ1035DMAGLs82YEas
	/59MU48CEm8Hvk80dcOyl6uq44sqpEhdYBidX1RrJGdZ0drh/tkD9yeAlmKxE/bda0rbQVCQTic
	J1r3GTas0R8ddkDHf9NVfGE+6ru3F43GWxCJQxI/8cEA27
X-Received: by 2002:a17:902:f686:b0:2c9:d8c6:1db3 with SMTP id d9443c01a7336-2cf349c0eedmr20955805ad.8.1784291151963;
        Fri, 17 Jul 2026 05:25:51 -0700 (PDT)
Received: from debian.lan ([240e:391:eb4:a240::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347119dfsm9935955ad.56.2026.07.17.05.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 05:25:51 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	baohua@kernel.org,
	zhaonanzhe@xiaomi.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com
Subject: [RFC PATCH v3 3/4] mm/vmscan: avoid pointless large folio splits without swap
Date: Fri, 17 Jul 2026 20:25:13 +0800
Message-ID: <20260717122514.51514-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717122514.51514-1-xueyuan.chen21@gmail.com>
References: <20260717122514.51514-1-xueyuan.chen21@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

When swap is disabled, exhausted, or unavailable due to memcg swap
limits, splitting a large anonymous folio cannot make swapout progress.
The fallback only destroys the large folio and inflates split statistics.

Use -E2BIG from folio_alloc_swap() as the explicit signal that splitting
the folio might allow swapout of smaller pieces. For other allocation
failures, keep the existing activation path and avoid the split.

This preserves the split fallback for fragmented or partially available
swap, while avoiding it when there is no backing space for any part of the
folio.

Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..40340a88f78e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1260,6 +1260,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 				!folio_test_swapcache(folio)) {
+			int ret;
+
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (folio_maybe_dma_pinned(folio))
@@ -1278,10 +1280,11 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				    split_folio_to_list(folio, folio_list))
 					goto activate_locked;
 			}
-			if (folio_alloc_swap(folio)) {
+			ret = folio_alloc_swap(folio);
+			if (ret) {
 				int __maybe_unused order = folio_order(folio);
 
-				if (!folio_test_large(folio))
+				if (!folio_test_large(folio) || ret != -E2BIG)
 					goto activate_locked_split;
 				/* Fallback to swap normal pages */
 				if (split_folio_to_list(folio, folio_list))
-- 
2.47.3

