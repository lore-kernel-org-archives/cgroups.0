Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682E93845C1
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 05:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792128497; cv=none; b=M3aTz4Wc9Wt0yu5pvQDhoRsBo73E9LQMh8jRzVZ7Mhs26g8bAO2X/dHT6l71OQinSZZxKFVXMbwYfMaOmQ7SKu8D25zTYJMtxlXo91N/mm/mttIUJBpCltzzK6wH82/U5gk4GdnJk4YAi6ZExwup3H+Ts2WD34TquXByHsbZl3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792128497; c=relaxed/simple;
	bh=0lTZQF+jnH3DXAdEsTYp+jT8gzGanh+XWAUWoY+i1+0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SVoyyx0R/Vstq/0kYiIN3n4Z+J4wsDpcCaALk2rXhVdM2ybzB+LXcJr6rZlQcL5JITTplgwdCGZtr8PdjHhjtNW3J7OqnIDartWmZEI5kz4xPD00mBuven+RN2ELDMJVwKFcbCFjcTLeDjGh4xuuIMKR/CnyBL3wsHQmLCX9jj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gu2YPper; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gu2YPper"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e93f67358eso25488435ad.1
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 22:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128496; x=1792733296; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q1BwP+lE50kzIYlwSLzl3kyosGMcVYA6qJzXgYspyIw=;
        b=Gu2YPperF+9CMIyg0q+w4ad01+fLZ0A5DEvhOTQGIwfs5rECOrfCUJCdSxnsTylHve
         NyV67uHklj+n00KZyV/eednjjb3Bl7TVEhi2l270GfDRQ7OQjsguMgIrDhuK50JtwNTO
         xG8t8RWjJA7jeZIzGboIf1jNNbS3Ut7TwAXVAi6O9+XssMpCYdlsf1BGVC1ueL6oed8r
         fQhI56n4M3Tk2pPRNemYl2aOZjWzJpHy+h6qo1jMJU9u/bXJcwRKctBfwEeViO9uC6bf
         D9wdoHyxMAY597Iyg3bXOI1dPaDFvzE1OZnfvUn/HfZg7N1AkftzvDURBC4XiQQHgExl
         E1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128496; x=1792733296;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q1BwP+lE50kzIYlwSLzl3kyosGMcVYA6qJzXgYspyIw=;
        b=k+bAEVKjNxPC0QYmJBDJuFrerjKOHse11+AF2JUepuLAQMX+26/7XDYL6+EzKMP314
         LQjHWwKMM8e7aTve1U2r4eKnnhk0M3QMuuU4ObVWhwrxaSP+RZSxTt0iuAP+rWqT5dVL
         w9vOEbVy727oXhGTAXBVkkXO7H4D1Bjn0X+4EpSSO1ZmarXd89WDmKCi4+7dMlbBuTRW
         9KDhVUd0PdEmuaffyF4rmKdbvs0bzDxias4imuQwIvW+OQUTkOPFDaoMbJuKOvuD6fgD
         b9Veusst20Lv4AdlIWRjSVkg5gH3q4QAp4QPSK31NIoolF3I201IwXhVuO1O9gxg3EWD
         ly0A==
X-Forwarded-Encrypted: i=1; AKwUvBz+8f2hgkize9L2BwTPUSvx2a6EWOK6YMmNce5D4BRGKSRIfSnUdLnFrx24AOTmPGAk9rw+B5v1@vger.kernel.org
X-Gm-Message-State: AFq9FYL/FbLK78Fgh69LV+0XrYzl157uSooY3sV4GTuNC43sFbs/vlSM
	eRecWnMbgsMQ5gonY1GeTtLvryZFIQjqnuxpBD7zf0w9waFiau6iarVgTejdBZ1Uwrelmo8GmIg
	gsjYsXQ==
X-Received: from plje19.prod.google.com ([2002:a17:902:ed93:b0:2e5:e061:9fb3])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:124c:b0:2e9:5c55:c477
 with SMTP id d9443c01a7336-2e95c55c800mr44184965ad.4.1792128495239; Thu, 15
 Oct 2026 22:28:15 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:45 +0000
In-Reply-To: <20261016052811.3085635-1-kuniyu@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261016052811.3085635-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-2-kuniyu@google.com>
Subject: [PATCH 1/5] memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

this_cpu_ptr(&memcg_stock) is always modified under
local_lock(&memcg_stock.lock).

Unlike is_memcg_drain_needed() under RCU, consume_stock(),
drain_stock(), and refill_stock() do not need READ_ONCE().

Especially, in refill_stock(), READ_ONCE() is used twice for
stock->cached[i], which forces the compiler to emit two volatile
loads from stock->cached[i].

Let's remove the unnecessary READ_ONCE() and eliminate the
redundant loads in refill_stock():

Before:

  cached = READ_ONCE(stock->cached[i]);
   4c 8b 80 88 d7 bd 84 	movq	-0x7b422878(%rax), %r8
  if (memcg == READ_ONCE(stock->cached[i])) {
   48 3b 98 88 d7 bd 84 	cmpq	-0x7b422878(%rax), %rbx
   0f 84 86 01 00 00    	je	0xffffffff817d01e0 <refill_stock+0x210>

After:

  cached = stock->cached[i];
   4c 8b 88 88 d7 bd 84 	movq	-0x7b422878(%rax), %r9
  if (memcg == stock->cached[i]) {
   4c 39 cb             	cmpq	%r9, %rbx
   0f 84 7a 01 00 00    	je	0xffffffff817d01d0 <refill_stock+0x200>

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..c268a7864547 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2135,10 +2135,10 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	stock = this_cpu_ptr(&memcg_stock);
 
 	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		if (memcg != READ_ONCE(stock->cached[i]))
+		if (memcg != stock->cached[i])
 			continue;
 
-		stock_pages = READ_ONCE(stock->nr_pages[i]);
+		stock_pages = stock->nr_pages[i];
 		if (stock_pages >= nr_pages) {
 			stock_pages -= nr_pages;
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
@@ -2168,13 +2168,13 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
  */
 static void drain_stock(struct memcg_stock_pcp *stock, int i)
 {
-	struct mem_cgroup *old = READ_ONCE(stock->cached[i]);
+	struct mem_cgroup *old = stock->cached[i];
 	uint8_t stock_pages;
 
 	if (!old)
 		return;
 
-	stock_pages = READ_ONCE(stock->nr_pages[i]);
+	stock_pages = stock->nr_pages[i];
 	if (stock_pages) {
 		memcg_uncharge(old, stock_pages);
 		WRITE_ONCE(stock->nr_pages[i], 0);
@@ -2254,11 +2254,11 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 	stock = this_cpu_ptr(&memcg_stock);
 	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
-		cached = READ_ONCE(stock->cached[i]);
+		cached = stock->cached[i];
 		if (!cached && empty_slot == -1)
 			empty_slot = i;
-		if (memcg == READ_ONCE(stock->cached[i])) {
-			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
+		if (memcg == stock->cached[i]) {
+			stock_pages = stock->nr_pages[i] + nr_pages;
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
 			if (stock_pages > MEMCG_CHARGE_BATCH)
 				drain_stock(stock, i);
-- 
2.56.0.212.g129ede20d9-goog

