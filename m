Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793303096;
	b=WIvFXDuQ6o5XhRg5r2GZxNLqHIf6hty9Mn0O4etlmrGR3keLCmzMdMUvK7z5+Rfbm+Mh
	 2Pe6K9uP4uKvztQg8nbap8ME9rNeRNI1BEnJbfNtkmvbS53RSXWdRb4s5V35YkoiwTZ0z
	 xyxDEUeQ6UE7SK1DEF2LnxECw98HVjlJlt5W3SDhN5RCnS8d9So1PVBOyOuzhrvYQOLSX
	 2I8rnr7jiqnLq85n8NuJLFb34+DpGFhXwSjmhGYcI96AZC+rtBtCNzkaA6z9+SB9MyEOz
	 2Y7DFmZsLuaMNeCf977XDLezcfWiEGEq6DNixAhaZmfo0tsgJXlAuZYQRu48abywkXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793303096;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=QXjoG39Rs48qcptpkOzTtTXdAXXdVfiT7bG8UtqD1+4=;
	b=WoGi+JW7KH6PfacGH1dBMRMn0vV8INWspMU6LjHDnHwx9QPOof1z4ANnxFAcO8HFYWmR
	 cowf+ftoztvuH2uEPcAalzXkdvolE9lJcInfl5p8FhxYaiZxIAE+Vo+S2VaC2Z/fYOEti
	 MIfZyNfCNnCYwaiyLWqCCopyCkJfNRzr6uHFBnKmp8wTl/W5/u0M/1uVh1QmdN68wguTL
	 F5Oz02alEm3toSrimwDyU1opAfHpPPnY9MFuiZpHAqA/VDv+8eRbj/5j+Copuy5zv4bu9
	 HoXApQeGnSZsVVCRIyt7RxlsfytGTAqKS+p21J470f4u+jF9tF96l9sCyrqlqCPUf8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cHBQbFSe;
	arc=none smtp.remote-ip=209.85.210.197
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66889606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 19:44:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66889606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cHBQbFSe
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-89e96c03cd0so2132242b3a.1
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 12:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793303096; x=1793907896; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QXjoG39Rs48qcptpkOzTtTXdAXXdVfiT7bG8UtqD1+4=;
        b=cHBQbFSevRcHHuYomteHrlCdXcOpU145mcfJL24Zax4yfioMd8y/WL5jKo69dJkDnz
         Wq3toDL4t9E5S+u/uYf+AGBJJ6nTYwjOHFSwojGc/6sJJ0C1aDH90dPUmy0IxolYpuyK
         aH4lsbF92cdefPYrnXLpKBQzybNBkOrPZscuTBG2fk8KtogMZnoLhIk8DJKf3S0ib3p9
         7aEUYgOtbtuCODNOC+oh2DW1Azwq51xt9oMS9NaBqMwBPzdXukbGPEo/lDCg1sgKjjc2
         0IceWVGbFKQX4q6zT2SY0w/FasMbayTxiv0utLcCiVqvMUohg3o6f4KjvRqjzStunhEA
         Ztpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793303096; x=1793907896;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QXjoG39Rs48qcptpkOzTtTXdAXXdVfiT7bG8UtqD1+4=;
        b=Q+/hJGy8XWaCFWooKog2lb69aamUEfu75CN/iBZiVa/kvF4Of2iwW4eUM4Iv5kax9j
         qy7n/yipDNgPZRUexgJyB0dWuq1e/J33x/JgH1Glsn8QW31Rpx8JdMya48mYU+XuKHdj
         cUfFRfpbsvW+F2yb24P+EKBFoTlGd8uAes8rLDZEQLeZqRJul2+sxZas35cy+n05ejJq
         hTpuYOLbsfJOcZQV8zpyDpCc2+V8WYMVKQAc86x/nUad8z8OGEVY53eQdLY+MTsM8bWK
         487GTqChJl8ZshGJelXzXNXK+xlalWXV4BibF6RVfojxmx+rqsz3Z/1GFF01ZCUeROzU
         PGqA==
X-Forwarded-Encrypted: i=1; AKwUvBwuWeaR9Pq3JAcdOsIJKqWDJ6LxcqCmjb6cDMj+pUmORKyLB1gxspe2IxuB8w/iRDKswZdvgXo4@vger.kernel.org
X-Gm-Message-State: AFq9FYLjCuxedjCyYSB30bZbW+6iVZjcJIF8AvjQw3WbdjAD6HHnZLki
	F7u+QrXPbafVWr8Mrd4EHl1fQNUaLx/xnUW2JxhS0Cpnd3FHOFV0YtQggleKonZ5fQ1Lx18yTbl
	XDeRWIQ==
X-Received: from pfbhj9.prod.google.com ([2002:a05:6a00:8709:b0:88b:de0a:27d5])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:18a4:b0:89d:29fb:b5e7
 with SMTP id d2e1a72fcca58-8a9be4909b9mr128727b3a.24.1793303095560; Thu, 29
 Oct 2026 12:44:55 -0700 (PDT)
Date: Thu, 29 Oct 2026 19:44:13 +0000
In-Reply-To: <20261029194452.3189365-1-kuniyu@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261029194452.3189365-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261029194452.3189365-3-kuniyu@google.com>
Subject: [PATCH v3 2/4] memcg: Reduce nesting in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A later patch adds more code to the most nested block in
consume_stock() and refill_stock().

Let's reduce the nesting to make the later change cleaner.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 64 ++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8a401550dfaa..6666acc9cee8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2168,15 +2168,17 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages >= nr_pages) {
-			stock_pages -= nr_pages;
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (!stock_pages) {
-				WRITE_ONCE(stock->cached[i], NULL);
-				css_put(&memcg->css);
-			}
-			ret = true;
+		if (stock_pages < nr_pages)
+			break;
+
+		stock_pages -= nr_pages;
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+		if (!stock_pages) {
+			WRITE_ONCE(stock->cached[i], NULL);
+			css_put(&memcg->css);
 		}
+
+		ret = true;
 		break;
 	}
 
@@ -2258,7 +2260,6 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
 	unsigned int stock_pages;
-	bool success = false;
 	int empty_slot = -1;
 	int i;
 
@@ -2287,32 +2288,35 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 		cached = stock->cached[i];
 		if (!cached && empty_slot == -1)
 			empty_slot = i;
-		if (memcg == stock->cached[i]) {
-			stock_pages = stock->nr_pages[i] + nr_pages;
-			if (stock_pages > MEMCG_STOCK_HIGH) {
-				memcg_uncharge(memcg,
-					       stock_pages - MEMCG_STOCK_LOW);
-				stock_pages = MEMCG_STOCK_LOW;
-			}
-			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			success = true;
-			break;
+
+		if (memcg != cached)
+			continue;
+
+		stock_pages = stock->nr_pages[i] + nr_pages;
+		if (stock_pages > MEMCG_STOCK_HIGH) {
+			memcg_uncharge(memcg,
+				       stock_pages - MEMCG_STOCK_LOW);
+			stock_pages = MEMCG_STOCK_LOW;
 		}
+
+		WRITE_ONCE(stock->nr_pages[i], stock_pages);
+
+		local_unlock(&memcg_stock.lock);
+		return;
 	}
 
-	if (!success) {
-		i = empty_slot;
-		if (i == -1) {
-			i = stock->drain_idx++;
-			if (stock->drain_idx == NR_MEMCG_STOCK)
-				stock->drain_idx = 0;
-			drain_stock(stock, i);
-		}
-		css_get(&memcg->css);
-		WRITE_ONCE(stock->cached[i], memcg);
-		WRITE_ONCE(stock->nr_pages[i], nr_pages);
+	i = empty_slot;
+	if (i == -1) {
+		i = stock->drain_idx++;
+		if (stock->drain_idx == NR_MEMCG_STOCK)
+			stock->drain_idx = 0;
+		drain_stock(stock, i);
 	}
 
+	css_get(&memcg->css);
+	WRITE_ONCE(stock->cached[i], memcg);
+	WRITE_ONCE(stock->nr_pages[i], nr_pages);
+
 	local_unlock(&memcg_stock.lock);
 }
 
-- 
2.56.0.317.g454f8302e1-goog

