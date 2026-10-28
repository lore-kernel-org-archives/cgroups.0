Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213439;
	b=mWzLcoQTaRhVXIF5ChIPahXF4eUu9zBowCz/8Hy5ym43rYrG69fQslklc8jUvJygQSvy
	 ZRpvQHPZsXT3H1ML5tFxNsOy8ESsdK6p7lMQxLnJBbCM5684abvuPUGXg9V2C+ayjJQZa
	 r/BcGDufNavKB9Gs9ZQQW//yA1wTATiJfixAEm5mwB0qtJOGq71yFPHEWc8pYkNBE5H5t
	 LUjcxhFzlW/xJ7spN+Q0yXghRFYih2glYsFdbgmsGNsH6gONLasy2RR65kRTZyRtyvtdZ
	 tBhGSKXkyqwI6+xhFJFLTn+vpE1wC5srdd9Cs1gAue1TQea6uMEj9Dzc+FklSu3Nt+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213439;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=EpQRB08l5UZSujvvwukdQkP4PzBe/9iZhbN3mOIOr3E=;
	b=iaFtTyK132dnahU3ejoHEMoMSzoCUNxUsFuPbzhic9fjiv34ekPUGH7FZv/4UMTdyNVf
	 Kp2DgXzu06YhGfWMdcGIeVCvLppTEdIAXED1v9b0C3BpA3z5rOkConnvnmaPeoX7+mnLi
	 IpqatTOy3WklEf8OYwn0OYUbckBjcSMX0285vky/Be4ffuOz33M+mbgoDc8+wIDZYCpEu
	 P03xrb/kSHBcEscU7cL9Y4Z6ufoY9EHccxt6lximiEbaY6Qsx8ANp5KYd5Vj7IdXFR3nv
	 w3G7xW150WLGJz+SW9o2fBbNYqL6kJu/gfXU7QM7HBIq/pTT9qhVqM9i0gZznyvVYbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XAtRkBzz;
	arc=none smtp.remote-ip=209.85.210.198
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C42606A322
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:50:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8C42606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XAtRkBzz
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a05c820ecbso1845853b3a.0
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 11:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793213438; x=1793818238; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EpQRB08l5UZSujvvwukdQkP4PzBe/9iZhbN3mOIOr3E=;
        b=XAtRkBzzyZFDyh4sfpfRt8rDPmaVNzlY3SFoiJt3RjR5mFfFJJ0w9g851dse6EdMB4
         h/Mua17vy7VtQbhFnDv8WylQk78nus5rjizbaIzhKk748P8Jv0tjdg4BlWelF0YzAQgx
         Csw6D7xVQGkhk1AhjkBgRuN/CHyRWf70AHK8ksp4Bk7a01EQhHujnsOQlJgC0OCSzrUv
         Mc76BDs2SdTWcXEST6TqRAgyLFMmz/ZHsETJ2Ksax95yNaKFr40VMRghsL5kmJxLUTwx
         QtNK+ebOguGpzC2Jx7JaTougAeUwSsD403U9kIFwRB2cOoS+6roBvQzwPmXJJpBs1ato
         6XSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213438; x=1793818238;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EpQRB08l5UZSujvvwukdQkP4PzBe/9iZhbN3mOIOr3E=;
        b=igiMFbs6WV/jhxiWDjxRFFjroJRaQ34+93rc0PYDOpYY0pfPwACsmiUQWv8uShTxiX
         1xe+xwY1gbSSjpcUFa4TF7QRCHEYq51iZG7CLBe01MCW1a5gQC05/T15R0+jBukiII54
         eRU2Rl9uWPG+2SxiMSk9GUK+0W2uladBCz+9R+CN/1/6RljxcHvJRyHBnfFCZDZ+HWtf
         vIY4gX4nsbMioDD4JYarSuvFISW3cJCLgiht0P59Ktd8KRAffxscK4oON9XCaKQxP991
         WJMeae5J8AmnUS2iHrvvXeDEBfPCQ601afn1jfSh0WIbmqA+N56FxWdVGoQAJ+jWwGJc
         c8hA==
X-Forwarded-Encrypted: i=1; AKwUvBybHU1U12AiddbNSqTNCYZr9NiQKhyABur6KEEZRGr8CRrLFpqsF6Im84SlPBR+l4+R+5JzOscC@vger.kernel.org
X-Gm-Message-State: AFq9FYLz2mQU4gPFiCpRBvYdKsRKGJwW5Znko4DnzQgfOhFL0jArPGfh
	nEdyss1OXUEaqYllurX4xgKgCLbXSIkUaG1IPXlqrjOsIetE282YupHpaHw8J8NYsnM5qnHrsH9
	F5CLaHA==
X-Received: from pgbm14-n1.prod.google.com ([2002:a05:6a02:618e:10b0:cd8:b247:590f])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9d8f:b0:3d3:aec2:4dcd
 with SMTP id adf61e73a8af0-3e9023310b2mr2741331637.25.1793213437872; Wed, 28
 Oct 2026 11:50:37 -0700 (PDT)
Date: Wed, 28 Oct 2026 18:50:13 +0000
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
Message-ID: <20261028185034.3607746-2-kuniyu@google.com>
Subject: [PATCH v2 1/6] memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
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
2.56.0.313.g2479322e68-goog

