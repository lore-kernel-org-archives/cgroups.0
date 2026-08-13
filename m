Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EC5439F6C
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 07:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607462; cv=none; b=sTsDQo6omhB93Dy8YrTq6EHY42hqh0R/ImpPq1tKuCBO3AIQ2CcMqVJ+hJ4vZ6VwcozjRClmrG2EnK0KTOeRv6UG5NI1JmZ8stjt0AT/JzvltRzQl5FO3a6qRnqldYvb0nW2a5c42dAGNcSc3H6RvmjHqlUQFRE+6VuNZ+Kb/u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607462; c=relaxed/simple;
	bh=XaathRSrx29KQi5sCxP3i8qUQiCNwd8x5Hpg2To/nkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSmvTn9XDizvD3ieDmECYr/R4j7486ycR8PxfLUtA0ct5mvn1gOnT9wcybrTHMJr2z4BXIUnXwXw5YARfJhO/HixFwbXoOonpVzqraJ6XtW62hSca6RHHE4/sXQrcf1UV7K7gdnytzkeewBh+oaR+IKbManpkRn5cMonhhemxGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rfyWWZgr; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rfyWWZgr"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cffd93cdedso3056675ad.3
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 00:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607456; x=1787212256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CEIXli5+VfZzqjxEvVpDIXpUlXMwSuWYvMfEYh72ukg=;
        b=rfyWWZgrjxYy6a7hzh1BPH1dAWviFf/8OOMiZLoLzV3naUVLpsWbErSLtK1qmg4bWB
         AQjcqpsO605q/5/GzOvhvp0xUshJ/qKhTM2VkZdFsjxVjvdshQztW/C5lrVDH8N7WX7P
         7Vynsu2i8qVCm3nHaQhWb4/gmcjBZmjsnHlDjkiTtEJdUroKKRnlgC0hK9X05TqVpB/k
         TMp5p87ud++D+FT05iyITkGBR3TppBD7HvSQm1jStGuGcAga9ObtUwevJhp3alQQ2X42
         F+HdyHyPmA4j3h2aujg+C2XHreEnhPSll9JhyhiEgB3z/c8o7DtxxGulWU3H0cNXstWR
         Gplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607456; x=1787212256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CEIXli5+VfZzqjxEvVpDIXpUlXMwSuWYvMfEYh72ukg=;
        b=G03W1h1NmbgNH/P3NjvtixdSWJQMlIo/88n/IyrS2QL4q3ReaG+65HEZOKniydV+ho
         RNxkC5REjJ9/600MG2OJubNa7Ss/eXisde/aqPDcECjZWTkkxroJcKK9CMMhrP/Say2N
         VwuYvhIIR88QjKc5tjYnw4g8pjb0iKR8I8NkDm/KRQeIp7cNC9Bd+izr7CRPurUYQ7aU
         yb6XV/CfUK9PBDFBdhDKZX6mJol5rxidCZEVDoHpstvSqhAmGSzfS/7n6WaG7a5Dv4Z9
         +oKaqvVI7/ZWV3GXXFjtiiVemFlvcnL3U5gY2vbxfD2c3JPtstIUTG8BSDszzlfg76Si
         9SNQ==
X-Forwarded-Encrypted: i=1; AHgh+RrG84AmAUIGp9oU/8kVBKetv+OSafhkTN8pC8Y615o+UR8NAJlaq0haYaD047+yaFfha+9vjYCO@vger.kernel.org
X-Gm-Message-State: AOJu0YwtvTdAt3+O1HH2OM7aaYIS6jYqhzYF7UigkOdrxROkT5XzLohZ
	80mtoYQLqBkwnHXc8mhPAPzOwbwjhsVwB+KL695c25N2nFToeBRqjBw2
X-Gm-Gg: AR+sD10L3MkJesGtXtYsuz8qinfKrKMMXQ0/hZEPWTytbRXC71KM4fO1kTU6WLItuEy
	mP2tVfBdg2ObGXOVcDA95lQ89hfO1ohsnF0OBguJ5JvRDxu3eSDHU2ikhTE+vH74+u3S7m2A2LV
	EIlkG1LLhheoXYdkfxGl7jxPWJAivX89d3Q53AMu6oy9xwj81AB3oNft0kksYkDezP45vZR+I5I
	6lb0Es31KIMosLhQu8yoZ1kq+YTOHIjpqTTagNl9xlzOc/cZKgLeczfEeDyo+8+wsGDU3DbHrXb
	pTXZj59VONVOWoPCZFeQKHIa8VuyZgGRCInY1ySxi/ZZeV6Wr41z8DfjITARQ11o4HRUiQe/38X
	OhHc9JFBoNZx6LBrTk8+Jmvl+9vEbq/vC+efdd6tkZGnY6/t6rWrgdGWb7BU1W9F3KMqvu+nwSl
	8AAGx9XbzWlpD9jLtZHxj2+efWQrEczeCEAYbPm44prSMo3jk+8G7xhSMULYTzmDRS9cS2bF/y1
	UtWcbKOvB0cpE9Fs+rU1BIsQjmxoeW1zp42CXFIxynVor2mP/E7/NCFpMo6XaYOcZD20tDFMWzv
	sp3qSiY=
X-Received: by 2002:a17:903:1a8c:b0:2c7:ef84:c58e with SMTP id d9443c01a7336-2d37d53f7ffmr34359475ad.1.1786607456117;
        Thu, 13 Aug 2026 00:50:56 -0700 (PDT)
Received: from debian.lan (n058152058183.netvigator.com. [58.152.58.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c40d6b0sm5550125ad.40.2026.08.13.00.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:50:55 -0700 (PDT)
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
Subject: [PATCH v6 3/4] mm/vmscan: avoid pointless large folio splits without swap
Date: Thu, 13 Aug 2026 15:50:24 +0800
Message-ID: <20260813075025.1406585-4-xueyuan.chen21@gmail.com>
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

