Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE51725B090
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 04:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788064187; cv=none; b=O6R++gyTtxDzQdAOCDuDHFjBjCKYcRWrIAnKdgZysfEvrrSbwOihmFdS6olL/Ypyn3x6C8HCyV9j+a/bnazruNGh+fmHSqdZA+ap4++63FNIn1VGfgCVgm4f2+mXMe6mXkXtkkRkVMbDqys7X2ddqRPaKX3dCVvvsodIH7YrszA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788064187; c=relaxed/simple;
	bh=XaathRSrx29KQi5sCxP3i8qUQiCNwd8x5Hpg2To/nkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ad74Dt+o5Hltu7LYaxbrWxnKM+UfDwNNl8nUYd4LCHtdya3fiEdEb35AY8g4dc+sKmCS9bux20NsYswevzXzKJ7J417pulKa3JSNE0LxsiJpSjd5KedzHxNhWIZImhkVMmED8NM7SOtt0m26e8lcrjlqU739lsVViFzK6alPoE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HRrmLKzw; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HRrmLKzw"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d8f2ed7bdcso1622725ad.2
        for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 21:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788064185; x=1788668985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CEIXli5+VfZzqjxEvVpDIXpUlXMwSuWYvMfEYh72ukg=;
        b=HRrmLKzwgHsruDtwvH5wenI+NgxtY70HlZh/QbZ9kB+hg5QEXHKK8hnvgVYh4OFfIV
         3AtzTwUGHyn/A0LaIB8bnwtyM86aUgCl/0UDcDZ13e/irgKDvz02Gp18Yj6IThHlLW4z
         wJwMcTfuouXMdv342TAc+xlPAxCp4DoShhQUEZy7b8L9/62d+CsLHKZeUlH4ySDaG/Rh
         4aXIMVdwPsOzYl4D78y5ensfPgMUq9alJteX5z+SAEG5wk7XkuXBl9T09QX2OzlSuDYn
         Z5Mi5IgEjnigchkweIqRjIJ8SUGWDRFxXF6RSWAtExPs9v212zN17L0M4HqlNtTLFK+Z
         r5fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788064185; x=1788668985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CEIXli5+VfZzqjxEvVpDIXpUlXMwSuWYvMfEYh72ukg=;
        b=DZv5+5f7PkTlO4eKLtOkymwQTL3rIHRLpkiIrEUC8zdGvRnIGw8F8SHLiUOmW9njYX
         /Qta+JWc5214Zyyf5OUiqrJgL+mmd0oh/xd8rGw7hFfY4tFQpbawk4q/xsLmrERXtS9X
         33jd6SL/ZrBE1akNQrNn4jyhUtcjI/aHundWo0WXJyhSAq3i8+UakMEqZ4L2z7Ngooif
         NTwbNcynBq+6yIe428sSnutHhDuBvdcIDaKm9Xwrmp49DrpFseRXgq33IU0RySJQ/CQK
         9IOJqn/HfC+C5fSrd36Cypi5Ny06Uh62bZRMxTGNzpGZpY65N6T0n1yDq+uotYhZcuzJ
         1vTg==
X-Forwarded-Encrypted: i=1; AKwUvBzYpF7aujPUQufh72j+UjHl3G4nmDJSDM96ti+a3ghHzHl/bRCQQWPD10h3FFzz7wxcFYB6IN/G@vger.kernel.org
X-Gm-Message-State: AFuF++mL4dwO5q6idUSEs7WWsE9ZwCH197jp+eTZO522V2K+uRMYxXNM
	EoGK9EP1zuH+IYmGxjmjsWYKeeBI6hJAU67Q5ABzv4vhtWw+xPw7zMsq
X-Gm-Gg: AYBFou1paynmWRItGBo3jcGy9BHceXai3JKn2szQaercirpwAbDn5zLDp0dTBMviYGR
	u6PGpQp9xwWxZN5D45CxzHjea5/Tg4n5js8qVmPiWevCKHIDBOl5oj6AtHoTFbwkENgibL3GP3h
	s7E77/ig9UOwymb/gJGGlo/w3tkPRNPpLhRYg20TKmh0hqVessjBr36fSkx/i73pH0X6pnJZywH
	YazdVDUEYpypvO0UnyOGb7V2GerEYYk4U8Aj3R4Nroq+36f7Z8DMXM6xi1gTg2GUoD4dp0wtkh3
	SZO5zwYUuDdF4WxluZYEJB/8U+Aw/WITPBMAjmNCcqhgLd958FEE6FNsbMVECRCtymAK4miu4wL
	o2MgTNRaqOYhWpiEHVX8wE7pJEUQLZDWdwLVoWilUqFob9+A0/YrGU9vT2NHMIydtzAvIgnswyG
	vOoOtGrwroQr3j7fPaIFFcC7Ivbw4wrcvPQAa2bQsDrREWInkd2FPKSmC0FO2RprCOU6+T4+ufK
	szyp5l4vwV07WiDpCBgROxXJ1xOS5RB41ojE6VaBXt0W7a4Nfw=
X-Received: by 2002:a17:903:1104:b0:2c9:8287:fd0d with SMTP id d9443c01a7336-2d74df62ccemr151520335ad.3.1788064184852;
        Sat, 29 Aug 2026 21:29:44 -0700 (PDT)
Received: from o6.lan ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d8f98d46casm7493535ad.83.2026.08.29.21.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 21:29:44 -0700 (PDT)
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
Subject: [PATCH v7 3/4] mm/vmscan: avoid pointless large folio splits without swap
Date: Sun, 30 Aug 2026 12:29:19 +0800
Message-ID: <20260830042920.2280454-4-xueyuan.chen21@gmail.com>
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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

