Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213440;
	b=VvwHhONEd+dhbYX789a156LFigSxBPZIjK9hr7Iu1P9SATcAZm0gcWbhe6O8aBc3AAZo
	 WfU8acbtGDdRNCrnnAShD3cCcWoqyBuFAo56Llp8v//S4p3I7aKDfHSl+DAVeM2Jptaom
	 cysQADvxlJTAIft38XmkGXU0Kf9fTjBkG6DvWqAlPqwEVHHHDztJ/rZ2f2P00eRRLNr0F
	 eH4xqUQ2HaL+4/aR3k3QevLXaqFOiFSrUrjPKRfadRvdcrSIS4Ii2l7pmRLNRK3Se/Gb+
	 UqVk4ZgZywAUj6INzj54V1duL/OYERV9yDi4doEyIDLMBihcg5OuR64OvtpRCxPZ5IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213440;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=T9nw0DB7CsLYp+qBCSaeXNEfAGyso8jZ3gNpbY1bfAE=;
	b=NrMp4ayv1c6YcdjH0ygYe1R1n2kAZcZav4mBJLQ0NMdRYFLkgLTdSC7e3rxsorq8A2j9
	 5w05NUKtRioMfbrenOFs+ez/X+/SVVrnGsVnMD9HVG4FLOXJwW6m5aQ1amO3jTlUXX+bl
	 T2iJLYmELuELf+ITWlvCqTx3rNOwrfHJQJG9sK8YZAMLnOUuzXwIt7RnPLGrclY+yD1Nk
	 AREWwehjNt6u07Xc1VcRiSoY5Y6qrRrYFAkPCum4xli64tTMpxSilKKQ4OMmt4rG5fkEM
	 7sZ16sKRh0lD5/BwxJAyDUNC5cyeWOznBb/uOXaw8szJ3pnHX+Zl/aU/5CNxUM6g/Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=S95Lsscf;
	arc=none smtp.remote-ip=209.85.210.198
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52762606A32E
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:50:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52762606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=S95Lsscf
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-89ff475a0deso1245277b3a.2
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 11:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213440; x=1793818240; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T9nw0DB7CsLYp+qBCSaeXNEfAGyso8jZ3gNpbY1bfAE=;
        b=S95LsscfRZlPIvC7X7bEA5UDVQYo+VVYp8pk0U0QrL9n/w8FBUvEXivmD1QRe19RJb
         isj7e6WiH4CWjsVgli4wWfU54GSAqnElHsjYpCL4JVVonmKZ3t/EQxq2cUCOr4qQUQoX
         KTyoItaO9WR5/AHBZGQJHSI34KhpxpkHKYMJ0NowMUG0B37moxPP08+19qmuRjxb/dAs
         4IgASjzCr2JvBG4dlTWVj3iRn9MY3d89iMDB+VwvHz22NeJ1JAl3O+lDqPMJ6nY0k5z5
         yf1+Q6XICauDP1QnS1WsiwmwuVzwOaVKvBcc4PVL+sA3Ub7wjCloC+RHnlz0LUNbonST
         lTWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213440; x=1793818240;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T9nw0DB7CsLYp+qBCSaeXNEfAGyso8jZ3gNpbY1bfAE=;
        b=G/L7D/jpejJl8xT/2pBZaNfM+shktL+RBHNEkrhR27JRCpLVSwyKX1UfNSsuhAhEJh
         HvLX8ffpcp1WajaneQUOKmi4lA4OPKC00VU2HbApvv9m0fhhuGhtpA5biUs/ccrMMRro
         sSbwLLRnpzThza7NZMc8x8GkfYPgwogmRjAIbK5KK9e2e41Vc22QUGuEjAwT+n4YpnVH
         Olw3qfWB8k4VuCON87QB40gywH0wVmWw99hUu7jLnl/Z38oM8PJJkRm0UMPRNA7k5Ic7
         T2I629OQug8PVc+ncf/zCZHCOLqKfGtXKLbeDwwKcuMmiA35FVE0g9EEMMXQiFxCUic6
         h3Mg==
X-Forwarded-Encrypted: i=1; AKwUvBwhw2mBRHraLCPPxGAKYANRXbLF5AdySR8nm8v5B7D0aAB2BsOQwLd8NM+xXBoTD/UA+2OqhTRy@vger.kernel.org
X-Gm-Message-State: AFq9FYLJZnozqLBig3qSk8FYjpY2uuoFERuWzFAjEESgKfvIXcs7bwu+
	qez+zw0yEVHOtYZCcy+p58Oicq7ks5A6dLIeYxBL8Duh/MkcJXB06qn1jyycvjXAxcP32727f+y
	pc8NvMQ==
X-Received: from pfnz17.prod.google.com ([2002:aa7:85d1:0:b0:88e:7f97:e965])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3493:b0:89e:92e:4211
 with SMTP id d2e1a72fcca58-8a6e6efa283mr2539981b3a.16.1793213439488; Wed, 28
 Oct 2026 11:50:39 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:15 +0000
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
Message-ID: <20261028185034.3607746-4-kuniyu@google.com>
Subject: [PATCH v2 3/6] memcg: Annotate slow paths in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In consume_stock() and refill_stock(), each per-CPU stock slot
holds up to MEMCG_STOCK_HIGH (64) pages, so depleting a slot in
consume_stock() (!stock_pages) or trimming a slot in refill_stock()
(stock_pages > MEMCG_STOCK_HIGH) happens at most once per batch.

Similarly, requests larger than MEMCG_CHARGE_BATCH, local_trylock()
failure, and insufficient cached pages (stock_pages < nr_pages)
are all slow paths.

Without unlikely() annotations (when building without FDO, or
when an FDO profile does not cover a caller), the compiler treats
these branches as likely and inlines css_put() in consume_stock()
and memcg_uncharge() in refill_stock() right into the middle of
the hot path.

Consequently, the fast path has to jump over the inlined slow
path and jump again to the function epilogue after local_unlock().

Let's annotate the slow paths in consume_stock() and refill_stock()
with unlikely() so that the compiler keeps css_put() and
memcg_uncharge() out-of-line at the cold tail and lets local_unlock()
and the function epilogue fall through on the fast path:

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6666acc9cee8..a04b44656b38 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2157,8 +2157,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	bool ret = false;
 	int i;
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock))
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock)))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -2168,12 +2168,12 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages < nr_pages)
+		if (unlikely(stock_pages < nr_pages))
 			break;
 
 		stock_pages -= nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (!stock_pages) {
+		if (unlikely(!stock_pages)) {
 			WRITE_ONCE(stock->cached[i], NULL);
 			css_put(&memcg->css);
 		}
@@ -2273,8 +2273,8 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock)) {
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock))) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
@@ -2293,7 +2293,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i] + nr_pages;
-		if (stock_pages > MEMCG_STOCK_HIGH) {
+		if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
 			memcg_uncharge(memcg,
 				       stock_pages - MEMCG_STOCK_LOW);
 			stock_pages = MEMCG_STOCK_LOW;
-- 
2.56.0.313.g2479322e68-goog

