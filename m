Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86124028D8
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 12:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785414243; cv=none; b=MYhK5bW9+0zODOlLt88rSIOuNIIdPdeieoaCS+3gsbsiqs/rnYyiK5Bn/emyBKIIC1kGA0+qKAXksBRuQXsszjEvpUqix19Fb6YDGFhcsF5ksfwvEOaA4ZE/tDGvyX9eRICgOmexDW+Ab4ETuTTeOmpj9qHFLRCKa3izWDNPoNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785414243; c=relaxed/simple;
	bh=Lp5oumv5jrLvwHfN744HgL5BCyjCvVs25Kbgo0NFJdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDofU7R1rgQdmcFPxEWb6y9V3AU9AllFxbnZ8ha6wP0gRhPN2B8uxyeg3KlqNyIllt7hnKX3fDtRZKdxRZPUsAfSxEtwN2ZBFCAwrqLdOp21r+1c5jxfwNUfnlIdsm9cFfdhUIY2dv9NnClqWn6A3f4hDtx4bJe5V5RtG7GTciU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qz0I6D4g; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qz0I6D4g"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38eca09faa2so219840a91.3
        for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 05:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414241; x=1786019041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SH6mCGC7SVA7L7o4dC4xAqNxJgvdrWUhmXAualcScbA=;
        b=Qz0I6D4gb6PvL8itpd+gjr9q8eH7pmV+BU+8l71h5PEPpbsR5OJz9FxL1B/1LdnPfJ
         I+xEjH0DvIlxWqtxusidXNjwOpS3AVK0aNLGQ06AQ30J7riv7QDI43AcY6TbKjPbxRKb
         yDVIHbFgqriqEeY1+H937wdiI3hFhCsavoIx1asw+e9Cj4+E7jxGvVxUJSTyMiIaPET/
         8yRTG/zEgORnSpNkr+0iaN3EXYKugU7TKRtRi7pgbhX855Fb2gx+qyNj2hVMA6ISTRKi
         iZbGcIBOV6zXnD5H44kfJiud0v+YlnZ/qDX4PYN7k+qYqSKB+SSwZ7LjPRCFLiyExgsd
         uGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414241; x=1786019041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SH6mCGC7SVA7L7o4dC4xAqNxJgvdrWUhmXAualcScbA=;
        b=km3PpXg+0H/DclGQJ16/8+f8CP17UMJCmga+aRnUjfgr4Ds2bNqORe2aTVQiH/KTzB
         O4gAQ/2vheDpa9wta3qXfodqNhojdhLfw1/5p9fWoAzvIiTN0UYAFWxSyZMrb0ZHkLe+
         ax3BYcTikEW5zSEXa9pcytz7cyoFO3V4Nz9f1nKeQCgGskcwVuudSGIgUuEkC8qW3McF
         1hbHdNryeyAtge7MBIr+uuMC3j/qR8tOOnKa9nMvrpxjAhObohcvV9wIom6qpvGKvTI9
         NpXYyPYWwcfIAeBXewa7sTBHFpQiPW8Y/McDWG9Z+FMjxWc5vBF9iPzvKWzYeuI3wiid
         7jjg==
X-Forwarded-Encrypted: i=1; AHgh+RoPXS+1prwxjxZNEARaqQho3tuQqcFxuOQb0Zrtu2cvV8KMCFd+eXnWkb5SyJup3W/lEP3XFBdE@vger.kernel.org
X-Gm-Message-State: AOJu0YyTaf6fzoO5nJiBYSt/IrzEP65+NHF0t61+HZP5EgBOg6MdBgNW
	IKgAJcqToxulJaWHZ4jT798hxPtGh96WY7dLZUbZePIKFIYECG/M42yr
X-Gm-Gg: AR+sD10o9c5Zng3zxPz/jzpzGyjhjxswuQg7GGMHy5xVX7LZoimcyb1/tcNN64faHdZ
	e7j4tZ6YK/N4K93VbEMItlluQelP1J+Lnc+PzWLXEi+6NhMH1F0E93m2DdnDRLwBkhE0BjZhSSf
	wDm8BTYKmv6dnBN9xiYVAlBuntNDDDgsEc6kJ+IB7WTM5jTPMtqVlRreuxydIsNV8eoHlQ37/NP
	I0+Wu+MQKqmiKr6OHPoVv6CbB8ryMBdmR7cdr4PVjahoTT/kq/1T0d0IobNn1+jR53UDOzuB8E1
	PjsTbOf0HmFp1aqaBfWk/w9JuDkx8QbvH4g28NEps+j8qkR8qR4HoMsjveSoF7MACYoSIiH+rAL
	NXqnKsOvMhyUhN0Y1CDesu4J8am3SD/sxdrLFtmdPINJAZEOeybuAMT19QOZLprrngELZkv1nxf
	N6swveUFr8MmY2rHLnnLOMWgLYzIfheVP0nM6xatQgHH6+gZf062M4PPXUu3CmsxGHkygU57CnS
	HlZVD5Yxhl+1MIa0lkCJIaf+R6IYI+1IGL9wHdxDey6Q+0FGXg/
X-Received: by 2002:a17:90b:4fc3:b0:38d:90c1:2400 with SMTP id 98e67ed59e1d1-38f9bff9c78mr2879463a91.2.1785414240965;
        Thu, 30 Jul 2026 05:24:00 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b72d243sm995698a91.10.2026.07.30.05.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:24:00 -0700 (PDT)
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
Subject: [RFC PATCH v5 3/4] mm/vmscan: avoid pointless large folio splits without swap
Date: Thu, 30 Jul 2026 20:23:03 +0800
Message-ID: <20260730122304.2496440-4-xueyuan.chen21@gmail.com>
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
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmscan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 26df81e773ff..457049e130df 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1263,6 +1263,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 				!folio_test_swapcache(folio)) {
+			int ret;
+
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (folio_maybe_dma_pinned(folio))
@@ -1281,11 +1283,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				    split_folio_to_list(folio, folio_list))
 					goto activate_locked;
 			}
-			if (folio_alloc_swap(folio)) {
+			ret = folio_alloc_swap(folio);
+			if (ret) {
 				int __maybe_unused order = folio_order(folio);
 
 				if (!folio_test_large(folio))
 					goto activate_locked_split;
+				if (ret != -E2BIG)
+					goto activate_locked;
 				/* Fallback to swap normal pages */
 				if (split_folio_to_list(folio, folio_list))
 					goto activate_locked;
-- 
2.47.3

