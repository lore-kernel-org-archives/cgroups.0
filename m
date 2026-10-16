Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73CE38C2A7
	for <cgroups@vger.kernel.org>; Fri, 16 Oct 2026 05:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792128499; cv=none; b=bJIg6ZDCaKG9U9Nb9PWQLQjp30GgNwIwJOi+Cf2uAlyj/XO9wiAVi6A+Rif4paN0gq6L9uVrcKxf7zBJiYrc1Xl4DZb+aDXjHPa8ngKIOJJUIuT5YVGouKn1cz8ugi2eP2axCHcdB+VHiukd7L6nw+U47kw2UbC3yyyZoYF78Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792128499; c=relaxed/simple;
	bh=ujrff+erUxXKsT+FpHLpMV9IekY4YVWksLBkb9iwYpA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UwBj5DD1gYilR4FPAO2jXjyeBf1CsPdbD8nwzReU5nWwYdBMt75f4dR8UvS1wyZx90eAKDwvG113BRrJ1Z/2/NzOhCMm0BRq7iVQDQU0tzzy48QkC+dQwrGSVzR9FfoSnXg4Hb6xGhSXWhP3R/nZxSghgNU/qoK7wrmFzHBfmN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ucm3vUHN; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ucm3vUHN"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2df8d1e91c9so114288335ad.0
        for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 22:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792128497; x=1792733297; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ma7gRnhklfq3RjMbrjvxO/tJj3AQPjFTVpV8/fRuCwc=;
        b=Ucm3vUHNMAPbnsdrjpXXk8svtfjT1xSTElEzhfJSjP/wx8uhguF9Ew9jkBmjYymKlZ
         J+wEPqsH4J+4pW0nJyf3tDR2Ibh+ik5uRKXQQMyxGbIkbMF9OHYWTxp49TLz7tIskQj1
         ufgIrhXO2aMZ/bQDTkkesQAwKTochmu1xDDnecQsMqdmMJ6KBIbC6ZJIH4CVIY8OlVa6
         3pGKNiccAyc0MGqdRiBZZjgfdcqcfQgUa7UJG4qSvriiSBTKRfCDlLUohbJK7HuKGdU8
         fc1MpKyk36Btf73R8UpCSIlMwWKCeH2p58xu+I4ieHMV1mUHT0G9BrsezZg0absuIVvc
         cciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792128497; x=1792733297;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ma7gRnhklfq3RjMbrjvxO/tJj3AQPjFTVpV8/fRuCwc=;
        b=O1EeOT8vyT0Yf9Hao+HNU3VDXV8nQSIvmEgI76Eh6elNQP+AHG3or15PUBFhtcbLS6
         DSrcg6anp8DHG1A6NzEP/zhT4piUDa8RbYqrjs+un8LHUv4iE+hwSpZKk3Q3e5IBUzze
         NO1BfHqBL10HoFTLoh4GUi72o3zx8Rh4brHyXxI9LZNyZfjKogWdaYyDD8OGpD5H0L+q
         sVLJ9QZv7GKA6lOnX9V9JYpZFBqn1CDci9uPMOkUG7p2SMuBMIm0QSVzi6iPt/LJkQrA
         NrJnGwpf9Y6EYf/vzJfYeg3L6NSsZprO6o7L7T2nz/b0boqwWSfF3lYY20boRlPlFIwu
         K0Jg==
X-Forwarded-Encrypted: i=1; AKwUvBxv+GeZP8S5IzQ6JzDx0TadJP+C4YdhyYI/pJLK6LZNbK975IxwI5gzsye/g2+LnVsBvRZVCifX@vger.kernel.org
X-Gm-Message-State: AFq9FYJGu6bidbvyV6JpcGOxjq60htIfKVPwBYUtVqCilfSPb1ApA51R
	N0XD7Kev7XHhcWAyMoKFtlRaRBc0i4NhTSjWJCvyhwSr7jhZa5FNskrAwKi1dbM8ZsF3jFeSHh5
	SjzdhMw==
X-Received: from plou8.prod.google.com ([2002:a17:903:1ae8:b0:2e8:486b:aed])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f64f:b0:2e9:7b4f:b994
 with SMTP id d9443c01a7336-2e97b4fbb2amr19450185ad.33.1792128496943; Thu, 15
 Oct 2026 22:28:16 -0700 (PDT)
Date: Fri, 16 Oct 2026 05:27:47 +0000
In-Reply-To: <20261016052811.3085635-1-kuniyu@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261016052811.3085635-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261016052811.3085635-4-kuniyu@google.com>
Subject: [PATCH 3/5] memcg: Annotate slow paths in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In consume_stock() and refill_stock(), each per-CPU stock slot
holds up to MEMCG_CHARGE_BATCH (64) pages, so depleting a slot
in consume_stock() (!stock_pages) or overflowing a slot in
refill_stock() (stock_pages > MEMCG_CHARGE_BATCH) happens at most
once per batch.

Similarly, requests larger than MEMCG_CHARGE_BATCH, local_trylock()
failure, and insufficient cached pages (stock_pages < nr_pages) are
all slow paths.

Without unlikely() annotations (when building without FDO, or when
an FDO profile does not cover a caller), the compiler treats these
branches as likely and inlines css_put() in consume_stock() and
drain_stock() in refill_stock() right into the middle of the hot path.

Consequently, the fast path has to jump over the inlined slow path
and jump again to the function epilogue after local_unlock().

Let's annotate the slow paths in consume_stock() and refill_stock()
with unlikely() so that the compiler keeps css_put() and
drain_stock() out-of-line at the cold tail and lets local_unlock()
and the function epilogue fall through on the fast path:

Before (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   b242: 43 02 74 3c 01          addb    0x1(%r12,%r15), %sil
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   b247: 43 88 74 3c 01          movb    %sil, 0x1(%r12,%r15)
  if (stock_pages > MEMCG_CHARGE_BATCH)
   b24c: 40 80 fe 41             cmpb    $0x41, %sil
   b250: 72 4f                   jb      0xb2a1 <refill_stock+0x2a1>
  struct mem_cgroup *old = stock->cached[i];   # drain_stock() inlined
   b252: 4b 8b 5c fc 08          movq    0x8(%r12,%r15,8), %rbx
   ...
   b276: e8 00 00 00 00          callq   <page_counter_uncharge>
   ...
  local_unlock(&memcg_stock.lock);
   b2a1: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   b2a9: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
   b2b0: e9 93 fd ff ff          jmp     0xb048 <refill_stock+0x48>

After (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   b278: 40 02 74 03 01          addb    0x1(%rbx,%rax), %sil
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   b27d: 40 88 74 03 01          movb    %sil, 0x1(%rbx,%rax)
  if (unlikely(stock_pages > MEMCG_CHARGE_BATCH))
   b282: 40 80 fe 41             cmpb    $0x41, %sil
   b286: 73 23                   jae     0xb2ab <refill_stock+0x27b>
  local_unlock(&memcg_stock.lock);
   b288: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   b290: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
  }
   b297: 48 83 c4 08             addq    $0x8, %rsp
   b29b: 5b                      popq    %rbx
   b29c: 41 5c                   popq    %r12
   b29e: 41 5d                   popq    %r13
   b2a0: 41 5e                   popq    %r14
   b2a2: 41 5f                   popq    %r15
   b2a4: 5d                      popq    %rbp
   b2a5: 2e e9 00 00 00 00       jmp     <__x86_return_thunk>
  drain_stock(stock, i);
   b2ab: 48 89 df                movq    %rbx, %rdi
   b2ae: 89 c6                   movl    %eax, %esi
   b2b0: e8 2b 16 00 00          callq   0xc8e0 <drain_stock>
   b2b5: eb d1                   jmp     0xb288 <refill_stock+0x258>

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 mm/memcontrol.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7c722a593cb5..cc3d78938b34 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2128,8 +2128,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	bool ret = false;
 	int i;
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock))
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock)))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -2139,12 +2139,12 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			continue;
 
 		stock_pages = stock->nr_pages[i];
-		if (stock_pages < nr_pages)
+		if (unlikely(stock_pages < nr_pages))
 			break;
 
 		stock_pages -= nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (!stock_pages) {
+		if (unlikely(!stock_pages)) {
 			css_put(&memcg->css);
 			WRITE_ONCE(stock->cached[i], NULL);
 		}
@@ -2243,8 +2243,8 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
-	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock)) {
+	if (unlikely(nr_pages > MEMCG_CHARGE_BATCH ||
+		     !local_trylock(&memcg_stock.lock))) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
@@ -2264,7 +2264,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 		stock_pages = stock->nr_pages[i] + nr_pages;
 		WRITE_ONCE(stock->nr_pages[i], stock_pages);
-		if (stock_pages > MEMCG_CHARGE_BATCH)
+		if (unlikely(stock_pages > MEMCG_CHARGE_BATCH))
 			drain_stock(stock, i);
 
 		local_unlock(&memcg_stock.lock);
-- 
2.56.0.212.g129ede20d9-goog

