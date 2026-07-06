Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3532C2D0C62
	for <cgroups@vger.kernel.org>; Mon,  6 Jul 2026 04:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783313023; cv=none; b=KylAG0OJRej9tmobf6QxLLmoDrbooJdM5zpxLgiR2PchHGtg3eVOIuFRozBsgd7AgnEPxy48tvCrrQiD54gXk77rFd+UuV8phui15ITEhvAYZq0DNW7UuolIf3Y0HNZQwd2ubuz2MYNFSbF6fahK2ER2wc3klh3pr7V31qbvuDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783313023; c=relaxed/simple;
	bh=0C1cTso3XTgflVd/Get1ozzQQHUtvyHn+UYqc8kdJUQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d33ATxZgUqOOvfokw82pXFVsUR6nGwF6ncOrIr8HoHwDooSMQCjsb3oq2IF3q+4Ml/3uPZxTpyKnOAP+rWmtGZuGUax9z2ljCK/YVN6KSAIb+RE9ImVpXp/FRZ08TSyp9CZWcKei3lXTxIGRlUwFV0eHYSiSVkPpVZ2AK7tXK4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LWbBPGHC; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWbBPGHC"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cc61541f8cso17940755ad.0
        for <cgroups@vger.kernel.org>; Sun, 05 Jul 2026 21:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783313021; x=1783917821; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pzXSERi3Pv+24MnZlTaOis5p3sESbH98phLSZixVlWU=;
        b=LWbBPGHC/kXLVI/HaLauEaQX4oxoVBvcky7rebefvU9ecudxRSULO8dzWm2sj1peLJ
         dIocVr+mpQ4DQYoq+7C2zZlpXbBpl6olLETaIqYoQxPdCrKGh49LP2JXbtUof6gPxY2L
         yS8UeiEPPMC4aSpwVXHCG5B1/IS+Kkrpj+3yE7oO9FZpD44VfACh4BYJpcPfszI/0UHg
         mWPcH7RB34jYaFtl3ZFgDgfpVH1o3ZSvoaGCScou+R2IiabJGJKFSSD6ck3gh/BIz4RW
         RBbOTgd2ktkTg/qRfmizpQSK9GBN2vSQgvyAMXes5xRnSVCLIMLlDXcqMI2cysi5DKta
         rQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783313021; x=1783917821;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pzXSERi3Pv+24MnZlTaOis5p3sESbH98phLSZixVlWU=;
        b=SDw6bklaU8/H+NJoQ2sPn5uc8sCoX1buDxFkcBZCSuQQTLbFYF4cukSl2KcLuD1GYR
         B+SC4CyJmlDvFmNsf6/SitdpUqkCILYl+GZa7MtH0feHmm1YAw6WkR5RP0Xs0bOj8RuG
         w5xEyeoyz1sFNgvZ/mNoY28GoBRjmLnraK3nQqKB4sySKkRzh+aYBQ2pw7BReRNZ9s7d
         KOpvwULwzO4UeQqePhWPoLp6vUYYKB8PIpRpQYPCP8CBqcQS8g3U39CtxU17vnC2gq/C
         AOBju3C6UelQPJT+D0CX7Mni3A07CWGjX9uAQ1SdKAXjQzFh8pifI8WfCB5rDAgceWPV
         W+pw==
X-Forwarded-Encrypted: i=1; AHgh+Rqwig9UPXRXBOJQI8HzK+AX+xSHNx1xY1pwciZgl+I6h+WWTT8eQL6AvwlogqoKbA5lruxgma2l@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8vHsFLr3qEwz7h9MA48k5r+mpNXVG4fatidb0rohD7qzbtZt/
	S13F11kbt+ZaTkSwBfUDFgbg1HTe506LkWtihHD8GYK4s2F6qS5RqQd/eksUX3AjwJONOQ==
X-Gm-Gg: AfdE7ckIGqEwqlJsvILo5uq0wIhHdPrITctElGAY6m8aTZ1dNi9tSARZTi1kdM8wYH7
	gpkd8B0qqgSARI6xLhW0CvGO+sO9VedsciFYJI0HToRvdNI81FZ2lpuNAi5IhWruvM1sLpcpK3N
	2fVGbce49ledILMRO8Odl5DD94rGL8r5EatW0M+GZzWz3XnauXcV5B5aWnbo9yTr2VbOYoOd8vb
	ZmN1y2qk54dUUYJBmwIq/leJY6Umig8LC3PvLT4V6PfwjQBFZkIU5JG/RomT2mKz/+NTXxkIDzA
	3g6zV5+4ODzzUpM9+2qYUsNhLWBqBFi5A86choNOPe+qvcrcHV9p/cXk5/ivZMWzBHiifotWI7K
	50SDw9xhWtNKcZH7DrZLBNfzakTBhLT38NSF6DD4/nP3HactSN0LyJqp2gHdKEgl5sKeijYWaBi
	fKtGog6AtPG0gyEmD8ZKbTGR/yt49nUCDGE5p0u3t2iL+AoSMPC7CFE5XX2/ZJ65ThaRCivmeIR
	IMt6SKgglAiLYdHugodeb2Yb4sd+ASw50uUD60XNGiJTg/UmQ==
X-Received: by 2002:a17:903:984:b0:2ca:12aa:a390 with SMTP id d9443c01a7336-2cbd53584acmr60946875ad.0.1783313021423;
        Sun, 05 Jul 2026 21:43:41 -0700 (PDT)
Received: from localhost.localdomain (2001-b400-e282-3e93-b8c9-a5bb-8a3b-0c89.emome-ip6.hinet.net. [2001:b400:e282:3e93:b8c9:a5bb:8a3b:c89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad776516dsm41440215ad.52.2026.07.05.21.43.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 05 Jul 2026 21:43:40 -0700 (PDT)
From: Po-Sheng Lin <posheng.lin.tw@gmail.com>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	akpm@linux-foundation.org
Cc: muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Po-Sheng Lin <posheng.lin.tw@gmail.com>
Subject: [PATCH] mm: memcontrol: use 'unsigned int' instead of bare 'unsigned'
Date: Mon,  6 Jul 2026 12:43:30 +0800
Message-Id: <20260706044330.10283-1-posheng.lin.tw@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use 'unsigned int' instead of bare 'unsigned' for the order
parameters in split_page_memcg() and folio_split_memcg_refs(),
and for the new_refs local variable, for consistency with kernel
coding style guidelines.

Signed-off-by: Po-Sheng Lin <posheng.lin.tw@gmail.com>
---
 include/linux/memcontrol.h | 10 +++++-----
 mm/memcontrol.c            |  8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fcf..903a57664f88f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1001,9 +1001,9 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 	rcu_read_unlock();
 }
 
-void split_page_memcg(struct page *first, unsigned order);
-void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
-		unsigned new_order);
+void split_page_memcg(struct page *first, unsigned int order);
+void folio_split_memcg_refs(struct folio *folio, unsigned int old_order,
+			    unsigned int new_order);
 
 static inline u64 cgroup_id_from_mm(struct mm_struct *mm)
 {
@@ -1421,12 +1421,12 @@ void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
 {
 }
 
-static inline void split_page_memcg(struct page *first, unsigned order)
+static inline void split_page_memcg(struct page *first, unsigned int order)
 {
 }
 
 static inline void folio_split_memcg_refs(struct folio *folio,
-		unsigned old_order, unsigned new_order)
+		unsigned int old_order, unsigned int new_order)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3f..33017eb772a3a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3659,7 +3659,7 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
  * The objcg is only set on the first page, so transfer it to all the
  * other pages.
  */
-void split_page_memcg(struct page *page, unsigned order)
+void split_page_memcg(struct page *page, unsigned int order)
 {
 	struct obj_cgroup *objcg = page_objcg(page);
 	unsigned int i, nr = 1 << order;
@@ -3673,10 +3673,10 @@ void split_page_memcg(struct page *page, unsigned order)
 	obj_cgroup_get_many(objcg, nr - 1);
 }
 
-void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
-		unsigned new_order)
+void folio_split_memcg_refs(struct folio *folio, unsigned int old_order,
+			    unsigned int new_order)
 {
-	unsigned new_refs;
+	unsigned int new_refs;
 
 	if (mem_cgroup_disabled() || !folio_memcg_charged(folio))
 		return;
-- 
2.40.1

