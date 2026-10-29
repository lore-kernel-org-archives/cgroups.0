Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793238564;
	b=xUx+6Fskfw6j5faj8vDyA5tPBLChV+zmbOR77B70UBgu/kHjH4OjYfzmyFjr7gL2b/mq
	 T6p/KRDCDEkuNFHSDncdPOMx3TjpMc17JWFtTsHLKVAf1liweYbRzLSv/HfpYr9SNwdnM
	 YfrxKIJ2gDi90XUr+prWB3JgaX+tGRzLBIFXTSjWi6pBX9w/2dLf1gABbgvenSTHN+BF0
	 PVhDztKV8VaSuYef8BSshMJFsY2fSDLHuBZzyKT2FSkHzZSW0o+qrO4h9i/TtiURyhNfo
	 wws3HFtWDQiaVhmFlLhjKGejz5QizRn4C6AVK0ItKLB7ZzLs7hQFthak6lGT7Kkgsfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793238564;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=hOkILSEQ28uD8BSJvTlIwGhNwyqSpmKjEG8uIJhVgiU=;
	b=odWYisaj+hGIRrIIYQuNRWlIga9/Mjx1Pos/BD2R8xyght1vZwWVuuxgaO50W/V+BMSy
	 6e2MqadFM49hbTDNGGnQk/qOGBBMCg87gGtHzmpkhpfPHVT0IVYG47pkuI3UySxaNYgpL
	 nbTp74ILwd9mIQhhDSMdmOJcvI6OV9Gcx1LOs10Y9NsG2bjsYtiw3hLKRHkwQSLYjEX5o
	 xFYCzGdhZxavTdCdqho8an4aCVKnVTdrpSZbRmFZqDo/AKpFWHKEPjafGHMEuXjn3DVjD
	 DYrfAfs9IIFizd1TBqV9K/1k3DGuX0GW/bZyaqtYnVDj29nUqmm6129undXmXSxfk7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZxGrTRzH;
	arc=none smtp.remote-ip=209.85.214.199
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8219C606A31C
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 01:49:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8219C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZxGrTRzH
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ea71803effso16181155ad.3
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793238564; x=1793843364; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hOkILSEQ28uD8BSJvTlIwGhNwyqSpmKjEG8uIJhVgiU=;
        b=ZxGrTRzHfmND1PmdVvGfcJmZtTYVzhRzcrN6kX0grWVOKkE9yBHi73nFYzyUd2Gd3/
         BNOj6bT7flu0syJUH2Xkxb2jbpkLXApmyWxeom8XIfLK+pbTPAfRVPTPlYAKz87gKTlb
         vcIVEbY94ctop0TawHSVwLs6P8/4u1oLa2YNJy4tRBUUDe+1TZXBdjE1NWd0QBBbWz1c
         6/3bnVlw9yXdLzxGg2Qxaa1LE2XS6kCqxiJ6iLYU4iOD6T/K5oPJo2AZ/gwGgtrUrFaN
         PAGgwlWmP47Phql6+qX7KnHc2+c84OYmqEUp2q4Dh4He/68YTadI5x8NCaorZy7ouXCS
         NQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793238564; x=1793843364;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hOkILSEQ28uD8BSJvTlIwGhNwyqSpmKjEG8uIJhVgiU=;
        b=gLdqkeKQC5sI2eBxja47mO2mh7BdvTcPm6UOR2Aw4J28Q7OR9oXS9q+BWpFO/DpWaP
         pszv5FHvAOawU3nKKNA0WI/Fd7WHzePBxkq5JjyoZtNidZZiohAR0fDsy72J6bZe/xyH
         Y5zM9AFITjrUoirk3e0KM4HaYgBjnFiLNkHpfGi4z3yklnKJeookwo1NaCoXUcAfSSSE
         PgbvZVhX8moH6L1pJhNvVGrtMcnqsa2vdTVXy/MfLBH1MZQCPfw81KoAax3GfnrtH0Me
         cSALfh7K3L+16m+lqekz4JeGD0dRiwJTvRw4k9JLCqt+Iq9FHnnQFmAefD5hjpgrZ7r8
         yV0w==
X-Forwarded-Encrypted: i=1; AKwUvByQfMtTZIAtVxdRJNHmuv2oqSgoPY8/lHfMbkEhzNOBNDJ6IZwxyxxp9rsRHS4rj0EcKWYs2K1O@vger.kernel.org
X-Gm-Message-State: AFq9FYJTKySeyVTVgSgJJWQSLiSEWiUXiQBB2a/YsH6Qgn6pMNNNpUNS
	MVY+HMHHKPYLB0WSkeYoNtAfLmH9mL5kJpTPnHdBxTJg5il6i4L/L9UhzfBAoxOtSOZA7kinmoR
	vdrYqhQ==
X-Received: from pjbcm5.prod.google.com ([2002:a17:90a:fa05:b0:3ad:ce88:b6b5])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:57e3:b0:3ab:413:49bc
 with SMTP id 98e67ed59e1d1-3ae58123796mr2862133a91.37.1793238563618; Wed, 28
 Oct 2026 18:49:23 -0700 (PDT)
Date: Thu, 29 Oct 2026 01:49:23 +0000
In-Reply-To: <auKZIA-0j9WT_gFU@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com> <20261028185034.3607746-4-kuniyu@google.com>
 <auKZIA-0j9WT_gFU@linux.dev>
Message-ID: <auKlAaXEbw23OcOO@google.com>
Subject: Re: [PATCH v2 3/6] memcg: Annotate slow paths in consume_stock() and refill_stock().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, 28 Oct 2026 17:55:31 -0700, Shakeel Butt wrote:
> On Wed, Oct 28, 2026 at 06:50:15PM +0000, Kuniyuki Iwashima wrote:
> > In consume_stock() and refill_stock(), each per-CPU stock slot
> > holds up to MEMCG_STOCK_HIGH (64) pages, so depleting a slot in
> > consume_stock() (!stock_pages) or trimming a slot in refill_stock()
> > (stock_pages > MEMCG_STOCK_HIGH) happens at most once per batch.
> > 
> > Similarly, requests larger than MEMCG_CHARGE_BATCH, local_trylock()
> > failure, and insufficient cached pages (stock_pages < nr_pages)
> > are all slow paths.
> > 
> > Without unlikely() annotations (when building without FDO, or
> > when an FDO profile does not cover a caller), the compiler treats
> > these branches as likely and inlines css_put() in consume_stock()
> > and memcg_uncharge() in refill_stock() right into the middle of
> > the hot path.
> 
> Please state the compiler along with its version here. I didn't see this behavior
> on gcc 14.

Sure, actually I included asm in v1 but thought no one is
interested in it and this might make my patch look AI-sloppy,
but I'm happy that it wasn't the case :)

https://lore.kernel.org/linux-mm/20261016052811.3085635-4-kuniyu@google.com/

This was generated w/ Clang 23, but I was able to see the
same result w/ Clang 21 too.  I'll include them in v3 again.

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
