Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213439;
	b=wRB3ZJj2o1KGCNdI8Q6P4hhka2ZQ7rt2Eu1P2YqHGlM+LzH/jJlmlisJlIMUr6dGarTy
	 i8wxv9F8WmXtfzaKZsZx9l57HnDKUMYlicePpFU3GirS29OGcrWqPmRckqQ70RPNvwbYa
	 NMYfIPcew+xSQAQ0LJ9MTF+CJWz1hz1NM2Z0xXfNABGheWgE9/RHob6yElJ6ov8Tw8TiK
	 H8Pi/bwP+DDzYuMbTEPuXSvtdjJrJUIrCLNsiGw1ftfcepGmfBl9WXmO/Cd/Uhj3M1gy3
	 Qa5SGMm/JNAU8rgo8eZlIODwcGTfMR0JXfIDRFv6gh/YwFylrFciiLl/yUy/2F+QVyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213439;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=BPbbcuxF5q+RLuJiJ+mLQFtZWtmapi1mjMk7ap+q2GY=;
	b=hI2VLMsn7cNVYkuo+0EgHn1x3GEiNqO90wBWkOGVELsQFQQTu6hIoB+GAh1Y2eewWgfR
	 Y26vlEkQc5ez/3iYVZynejpItuqR7L8rNWwhckyfNQmOovBuShkX6Gcv9bLpy4+VJKRzS
	 bDHiCIAoSwhxqxMd6NLoVQbaE9N6fcyZbauwWj+8el5MoTdaqr1IKZZfTqi3+JeX+3SEU
	 f1AdLAMRzroxdC1LqSvejBkQGVQTKGctqFlkA7FskXY20jcAx18I64hrwsRgl9tj0AE0H
	 SGwpADXKo1+id//TE0aMdfGKXHS/BwQqykWJoiYUs87Lq2GdgCDh1uEmBqz/2n9A2iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=P9XPvb3X;
	arc=none smtp.remote-ip=209.85.210.198
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE04606A325
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:50:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AE04606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=P9XPvb3X
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a08903566dso1751082b3a.0
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 11:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213439; x=1793818239; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BPbbcuxF5q+RLuJiJ+mLQFtZWtmapi1mjMk7ap+q2GY=;
        b=P9XPvb3XuBfIpL3+QAh3DBVpWoybf654bp0KmTnoZr3+Xay74syzXniZGS5aF4EFk6
         i/cyrYYOx6iBZ7xdwdnZ+bGP9T2x2fUX692CSGCY0OmL0JFp+6bxDxWJ0NxixQ4l6hZl
         XwzDVtyb4lGh4Opbx7K6+H8U/u0PmcOcSKcxvqC6V0a71OMRi7dWLBD99K5TzvEhSflQ
         iMbTWVEOkbjnb6d9vnDxlThnB0iy6tNP2PfpKPryRCNsq1VqB7abKbTqncO9tj0+HUVB
         f7YjbVHi0sueQXCaw86yuEpF3CSJME0vwDqQ7hPEiWavDpPZUj4hgPsiGgmhGdwBhtdt
         8SFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213439; x=1793818239;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BPbbcuxF5q+RLuJiJ+mLQFtZWtmapi1mjMk7ap+q2GY=;
        b=PXGCgaRNXTOu/tq42hJ+L9+POtG1ex9DPhpRcXTkWZaq4SoUOA45YphNZyVcnnY+C0
         hYUKB2SrLMnjMHbbKAGP+1aiFko4ipIH7/OmOoF+UvZ+kaSoK0epFLSZl28sbS9VtIdj
         xZ/nmMPbRAWjnk9sAO0RXLMS/zlpN6Mp6oZRTJ73MUgVCiGu71k1z4EXGdXy3GrWX+dr
         58qZgXFgp9qabKaHKY6XxHBZBOQ5nPMfqBOOXiUjea4rkaoq9lbtTeL0BW1L+D1V/SnC
         yOcI71P0BWeQZb5u/AFOdl477In2sul4JfljHNmwumoIeJz4SMYJUwUk+qNV5pNERcHQ
         G74w==
X-Forwarded-Encrypted: i=1; AKwUvBy5wZfmLHbEGGx+yYPHGuCpz9MosLsNzd4zEJnIuLZc1DtbGzHjPPb78uQhnSprTHaKqJBY+sv+@vger.kernel.org
X-Gm-Message-State: AFq9FYIwsue4+L/AZjrymDWT6pQPyZSSE6d5WRasQYTPFRkom0XpIby9
	DtW8/cY0me1jSSADquY/Pg8HwbuVjdt3I+wAvSsQ8cbrnpHyJJZ2XyZwXjp1M2DSOL5P8Jl6AUX
	2GUvbWQ==
X-Received: from pgbm14-n1.prod.google.com ([2002:a05:6a02:618e:10b0:cd8:b247:590f])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3b8d:b0:3e1:def0:1052
 with SMTP id adf61e73a8af0-3e913d30b6dmr223055637.43.1793213438611; Wed, 28
 Oct 2026 11:50:38 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:14 +0000
In-Reply-To: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028185034.3607746-3-kuniyu@google.com>
Subject: [PATCH v2 2/6] memcg: Reduce nesting in consume_stock() and refill_stock().
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
2.56.0.313.g2479322e68-goog

