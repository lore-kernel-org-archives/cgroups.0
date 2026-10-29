Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793303095;
	b=BMkWhEaW2iA3jRG6mO7d1WPscZWau4hvk+JEuedO9Wanxds+2OwZIHxC2NENgwisBxzQ
	 FOy4pV61OD3bXVlrcI82P2ZQ9F+QQeTVQubAjarZc/2Z1u7YQ36NSGPpYSKCjLge9tLI+
	 y2j5B1uOu7AEqzGHA+I/Ma7CDMQJA4oGYRKX1cESo6OGaXsdv/yHmlt+M4MUD8AIBw06T
	 dUd9qJ9pzicsoN73THELs7UvB1aTFO7mCaycygUTea2yTHEWyIg0nvilxkXRuCn1J4qNn
	 3N3d9MA+V3JFaJFVW8ybRY1AAruKOLzhgyZMvFaZ6IYu60RPXhxp5D4GNlYyU6dVB5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793303095;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=XKP9XqF6WNttRjhAQCndRzAJLGq8oPUqGtmSvk9voCs=;
	b=T/TX5M8EHXnm+H000sTliVK30z/WMINJ3+SjONCI8gDUnjmCNce7v1pIbrtmos5+oiHf
	 ozPfPoxWYbCqA25CZ2OeitCnrPhHzWHBqHCGZxmBOyH20gvkOb/ZtSme9wOGJIhdTYofk
	 5TrPE39z9NDq9WNBoPv1rTc4Y4vytrzkpMt8Q5uU5CPtG9+H8nX4DqCHpiN4oxwXymPbh
	 yfvfwfeDXm+37LvjJziM6REpOEcmHdiNo5M8emtrcbLwQb9sMI9qywi3csRDaChrCliML
	 nA2qBP9o5aWhw8Jiv2rMIF+IwsvW4NNvcDj+JGKvrWeX4nihKT3dxGuQZqg8htAPWmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="PHk/O5qm";
	arc=none smtp.remote-ip=209.85.216.72
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F13606A31C
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 19:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86F13606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PHk/O5qm
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3abfcf726dcso3140313a91.2
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 12:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793303095; x=1793907895; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XKP9XqF6WNttRjhAQCndRzAJLGq8oPUqGtmSvk9voCs=;
        b=PHk/O5qmk5YY4MwgzyP5kDRJYH0QvBF/BvMdOCkTenMNmSxo5Z5qz4f/JS2WDd8Pqo
         /+kXXtmr3RT570OMq9asXku7rhfS1mBLUGv1Np72bf3QO+6eYBMOHAn8BMQIWBplQ40e
         9KHvVdWWEIEh+8+vcL8FDmR6LnJpyiQOUNXg7Y6QfICHQ8HWwv0WDeZxFJdlkq6AGZt+
         WEXhVlV2DiQQv9bZuRFbwaG6ZmODIKaI2LYLeJ8NcePs7vFTV5gbjN4nkyvKWszgYX9k
         YP+QuOXqAnR2HWmwzbjSdmtucen9f/wVGw68wi81Fy5tbDQMfC3vTcGCdfCEl5pEdWcb
         vQcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793303095; x=1793907895;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XKP9XqF6WNttRjhAQCndRzAJLGq8oPUqGtmSvk9voCs=;
        b=nOV6mIgLwI8G98na452uMXiUT0ENKKCIwlrxUVwN3/yMJUBuFoe/fMhFsXNPfBcmBz
         fhhAcYhcVPXm2ikVGEs7+E2n+j6/j/pUQ4tjjxdoMGAnh97C7BuQH8rEJiY7ett6fTGf
         bAM3eHC0QxNSr08Op7xEwDa4yoDZv44XrQ6e6AhhEWFC+RL+hULzzppI6oikCHFkhmSa
         TkfoM48eeXV8dtS6n+rpoeKkCoH5wt8e+i2G9HQ9CrTVSbarGSwBfTEt5dIiEHTZi/8y
         57DNLqZP4m2bFWudn7HkVHmm253DRQEOgp7GwxKC18qe3z0n0568dnNB5GPiooJqRYgT
         /WFA==
X-Forwarded-Encrypted: i=1; AKwUvBwoxm5DtdNcVsLcjh6sC9j7BzAX7H7z+BSog0lkw1K2J3NHeMrXnBYSGIh6coXUzqMQm88tC9u5@vger.kernel.org
X-Gm-Message-State: AFq9FYJ8Uu5Xgx2Kx++iOaEi2n7ZTLAucTCTtmnpiHLSujK6gRaLKW4J
	a0lJRFmWANlbmaHZfERIbpCtpayraED1PG2/kXOLWhspxWD8FltqYv7VhhR0ELTqXwhVUuL+Wnr
	P8lBomA==
X-Received: from pjso24.prod.google.com ([2002:a17:90a:c098:b0:3a8:837d:95c7])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2891:b0:3ab:2c2b:1026
 with SMTP id 98e67ed59e1d1-3ae580a1c9dmr5741824a91.34.1793303094831; Thu, 29
 Oct 2026 12:44:54 -0700 (PDT)
Date: Thu, 29 Oct 2026 19:44:12 +0000
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
Message-ID: <20261029194452.3189365-2-kuniyu@google.com>
Subject: [PATCH v3 1/4] memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

this_cpu_ptr(&memcg_stock)->{cached[],nr_pages[]} are always
modified under local_lock(&memcg_stock.lock).

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
v3: Be more specific in sentence 1
---
 mm/memcontrol.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..8a401550dfaa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2164,10 +2164,10 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
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
@@ -2197,13 +2197,13 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
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
@@ -2284,11 +2284,11 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
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
 			if (stock_pages > MEMCG_STOCK_HIGH) {
 				memcg_uncharge(memcg,
 					       stock_pages - MEMCG_STOCK_LOW);
-- 
2.56.0.317.g454f8302e1-goog

