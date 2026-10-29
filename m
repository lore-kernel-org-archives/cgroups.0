Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793303097;
	b=LAHwXHbFS1wClhFSNTNbd0R5RzEOjDVl5gvIBApr7r2FN00qhZ3p/TneBWbQDWINsZWV
	 VFzvR0XNLr63xRGUD8U4S5EJxSZUMuL4z64IsAgwE2UykQ6+fZers1cbdnVt2IPBd1hz/
	 XezJR2lgnQlxdYiy2riEJMSVvQLPdBkfFOFLRW+/UEwusTjLLNtrS0RC2VKRY2w+1M5x6
	 129kdb+S0uDKhYiKu/wpKfe/FSXCjowcM2IanVoJjMYI8J6qJrauSLw8IuQXDyWBUan3Z
	 2+1WCRfRYT7FrwdxxWcMxAaTxbTS/6ty1VH/uGOaLTFa0l961ErmA0Ayi2uyIC7LFHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793303097;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=mmiPDciMM745O6OK4mIZkgmoT8NAXW+ZepMGzFmeJLY=;
	b=jIyfKqfuq+2TV3y5Xl0s/IKPnJvCYDrRAwhC+D2ugigcTz/s9oYGGsLw4LONmMMcRAXr
	 1EF723Sy+Gq9PQPpLNZL6W7Em+2E6XRVtQauZBPWr9xKn6M78EkCTYQuDNsYBaLGVxmqq
	 Zstqf7WijKBNaayXXYlYme1O/s8gd/9j2ltw+8NMwSrRtTN5grDzS0ltb/6hw5n8uuBVZ
	 ZNdW9u7UDd2s6rsZCI9s8gyqhRWU5j3Dx4/Ud9835ZmJbAVEfNtCkSJBwR4PgOCGP5IMD
	 zZrOPfVGR7duw3kDgjf9SQ+7y6RESoPCs1Fq7CIXClrSit2u3IRXIGd3hXg5L7wHGNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gx+eQHH4;
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C84A606A31D
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 19:44:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C84A606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Gx+eQHH4
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a086f5d91aso3266896b3a.1
        for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 12:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793303097; x=1793907897; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mmiPDciMM745O6OK4mIZkgmoT8NAXW+ZepMGzFmeJLY=;
        b=Gx+eQHH4Aorlm5NQdTxry8Mmt7d07A9Yd8BihSW9Hkvv5F3GHzEUBkwtCkb/7gBCJE
         p+LFwoWSCrpDlyuya3Abrxvw4XtK0u9EMaB3XZ3h2JMnchIJ2SLCfJWhGO6d71KkJGp6
         IwTXZ9+iS13Ze0u45ywdxZYYVpOeZ1vXnECp/WKOEghFinROcT5PXorKRwC6jBhAV0h/
         wzB5MTR7OmC83jxlck6xBVAZtxNDIJGJhWd/q+3g2jK+f6vmXuWGmNYJWGsAyLlmviXm
         4Osjs6kKjsc6CJncgIAw3m4dLGIleVZPtSGNEsYeK8QQwr5oermQbgwVAhn6PoduthGZ
         r/gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793303097; x=1793907897;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mmiPDciMM745O6OK4mIZkgmoT8NAXW+ZepMGzFmeJLY=;
        b=PyTjMB07x19EiZ3X490IwhzgkEBL8tp4HHm0Nw9E4KBtkEi2t3yCk69jzjEFuMSnWH
         Wny1YluTTquvhj2Pa3N5X1+FifF/sE/KA6e8AHtnpUaiYoLqTujRA78+mC9SYPudqxXA
         h15n+NCWgSCUaDuynUH3uf5arJMij/4JDYjDE/9l4/PNR/jgeX6oY7O4DOiDolsc2haq
         qGdXSQgpHkfzMs8uAeJPxSFI8uQC9DDxVXwK7PzlgWMs/xNHCXNoRceLdRuQer7WwLNf
         lTyaiKrCjeqSq2OLxA+7e8XVuwnh+zbor+CVb92zLeP/+v4AOVWyGeLofvqiSdJdrBER
         iy6A==
X-Forwarded-Encrypted: i=1; AKwUvBwL1x0HTMSiF/WHSfO+hPcATvDYGK7AfbM7FjxdNxczekuSMTJB54ZH88Yc/PNWak6/qgzgtdrX@vger.kernel.org
X-Gm-Message-State: AFq9FYJjkMzUSNIDL/FrkGhbEQtr+MaJoIP+X3OKaxeEbN9WHv9drCuu
	ACRwgQd9MZH2DO5Jpy0DUD2uc+u5ecwoHdhYrdVwV2f2kyNnLRjdIajDpi6vu5wvPQatE3fK98l
	XEYtjkQ==
X-Received: from pfbic1.prod.google.com ([2002:a05:6a00:8a01:b0:887:137f:baf8])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ad0:b0:878:34d7:6a30
 with SMTP id d2e1a72fcca58-8a9bcd05c51mr141067b3a.36.1793303096363; Thu, 29
 Oct 2026 12:44:56 -0700 (PDT)
Date: Thu, 29 Oct 2026 19:44:14 +0000
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
Message-ID: <20261029194452.3189365-4-kuniyu@google.com>
Subject: [PATCH v3 3/4] memcg: Annotate slow paths in consume_stock() and refill_stock().
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
when an FDO profile does not cover a caller), Clang 23 treats
these branches as likely and inlines css_put() in consume_stock()
and memcg_uncharge() in refill_stock() right into the middle of
the hot path.

Consequently, the fast path has to jump over the inlined slow
path and jump again to the function epilogue after local_unlock().

Let's annotate the slow paths in consume_stock() and refill_stock()
with unlikely() so that the compiler keeps css_put() and
memcg_uncharge() out-of-line at the cold tail and lets local_unlock()
and the function epilogue fall through on the fast path:

Before (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   7ab2: 43 0f b6 44 26 01       movzbl  0x1(%r14,%r12), %eax
   7ab8: 01 c6                   addl    %eax, %esi
  if (stock_pages > MEMCG_STOCK_HIGH) {
   7aba: 83 fe 41                cmpl    $0x41, %esi
   7abd: 72 1d                   jb      0x7adc <refill_stock+0x21c>
  memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);   # inlined
   7abf: 41 89 f7                movl    %esi, %r15d
   7ac2: 41 83 c7 e0             addl    $-0x20, %r15d
   7ac6: 48 8d bb 00 01 00 00    leaq    0x100(%rbx), %rdi
   7acd: 4c 89 fe                movq    %r15, %rsi
   7ad0: e8 00 00 00 00          callq   <page_counter_uncharge>
   7ad5: be 20 00 00 00          movl    $0x20, %esi
   7ada: eb 41                   jmp     0x7b1d <refill_stock+0x25d>
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   7adc: 43 88 74 26 01          movb    %sil, 0x1(%r14,%r12)
  local_unlock(&memcg_stock.lock);
   7ae1: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   7ae9: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
   7af0: e9 03 fe ff ff          jmp     0x78f8 <refill_stock+0x38>

After (refill_stock):

  stock_pages = stock->nr_pages[i] + nr_pages;
   7b76: 42 0f b6 44 33 01       movzbl  0x1(%rbx,%r14), %eax
   7b7c: 01 c6                   addl    %eax, %esi
  if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
   7b7e: 83 fe 41                cmpl    $0x41, %esi
   7b81: 73 20                   jae     0x7ba3 <refill_stock+0x233>
  WRITE_ONCE(stock->nr_pages[i], stock_pages);
   7b83: 42 88 74 33 01          movb    %sil, 0x1(%rbx,%r14)
  local_unlock(&memcg_stock.lock);
   7b88: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
   7b90: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
  }
   7b97: 5b                      popq    %rbx
   7b98: 41 5e                   popq    %r14
   7b9a: 41 5f                   popq    %r15
   7b9c: 5d                      popq    %rbp
   7b9d: 2e e9 00 00 00 00       jmp     <__x86_return_thunk>
  memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);
   7ba3: 83 c6 e0                addl    $-0x20, %esi
   7ba6: e8 15 f2 ff ff          callq   0x6dc0 <memcg_uncharge>
   7bab: be 20 00 00 00          movl    $0x20, %esi
   7bb0: eb d1                   jmp     0x7b83 <refill_stock+0x213>

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
v3: Mention Clang 23 and restore asm output
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
2.56.0.317.g454f8302e1-goog

