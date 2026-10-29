Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.116
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793303450;
	b=YzY+vzkBOHka6xqylEkkHHla1h4A+plToLjG+zBmr5qKxaZFYPJqcQL7J9Dk/yYRT7y9
	 Fir/T6pSWn5GxNPJeZOY16Qkfg6TAy3VK+wj+EfN0JtAkOYUO/Hlmax9acIb0SO8c8epJ
	 0BAnfQ2f/YhJBvidS7uOhvc+UxEysyipxSAwzDBq3WZ8l58UM14aSFuOdnZ6nYM3drdpV
	 jJ8R2qtXab5C71iGUaZTZJX/3di7nAIYuoNg0nSqiMmc+0jjPWrnw7xz1aaXTQ5XelLuN
	 NuILNzKyOU5M6lNDeJhGAG8qtsDq7UncnNAAd+oJDY0gHMJurKbMCIFovVmn3SueJKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793303450;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VtEOaWfP8tv9g+g92adSRdR2qBq/UBZnhwhpMjBubc8=;
	b=uz18V3/oZ02eJ9FmpiiY27rWqKfybwgOogrRWIf9vFxq0mfhNGDosT0TGNJJ2twQ5HFc
	 lX1PO2zVuuLN4A2SHwY36lFRqzhb36VipwEFVpiUUxgVNOXejWjDEEprb52MTIPsmRPts
	 6gweUoqzJZ7iVWFkVtwvCOAsZ6PbzRP1lWg23WyyHkb0wuKVKqjlI7hRFNClD8I6VJL+K
	 8mvKbTK/DFFO3Y7blx/dh0BRHkVOPYd4OtbUbUCz/bKbJVTZlY+dYiIwjSxQ0xu5hLBJ+
	 f8f3gfKGLu9xIzR6FV4XHRPrTxaLJNbDe6Kvi6HbNMYKbgrWsCIR5xbf1p3Z7BucQqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uRciS9rC;
	arc=none smtp.remote-ip=91.218.175.116
Received: from mta0.migadu.com (out-116.mta0.migadu.com [91.218.175.116])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADCF606A323
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 19:50:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4ADCF606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uRciS9rC
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oCF7P8x0NM5ij/TruM3+Ta2vikeg2OnPaSW/zqp0m6w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793303446; v=1; x=1793908246;
 b=uRciS9rCWJvjIvL53tFhY+unPeSonBJ9hhSlAeP3crnJZn12wyxCH5y3Mc24ALrA8I7/WS6V
 yX0r++CQPnNXsok4cZUiy26ASibkVTP4q5ybrQUuaAjQ53wcqPSywSTIyFp72w9AEXZEYVVW2cg
 w1bGm4rKF6L0fegR5WCV9reo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 796089e730b762cd;
	Thu, 29 Oct 2026 19:50:21 +0000
X-Mizu-Trace-ID: 796089e730b762cd
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 12:50:15 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 3/4] memcg: Annotate slow paths in consume_stock() and
 refill_stock().
Message-ID: <auOjX_O3vwou-lJ6@linux.dev>
References: <20261029194452.3189365-1-kuniyu@google.com>
 <20261029194452.3189365-4-kuniyu@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029194452.3189365-4-kuniyu@google.com>

On Thu, Oct 29, 2026 at 07:44:14PM +0000, Kuniyuki Iwashima wrote:
> In consume_stock() and refill_stock(), each per-CPU stock slot
> holds up to MEMCG_STOCK_HIGH (64) pages, so depleting a slot in
> consume_stock() (!stock_pages) or trimming a slot in refill_stock()
> (stock_pages > MEMCG_STOCK_HIGH) happens at most once per batch.
> 
> Similarly, requests larger than MEMCG_CHARGE_BATCH, local_trylock()
> failure, and insufficient cached pages (stock_pages < nr_pages)
> are all slow paths.
> 
> Without unlikely() annotations (when building without FDO, or
> when an FDO profile does not cover a caller), Clang 23 treats
> these branches as likely and inlines css_put() in consume_stock()
> and memcg_uncharge() in refill_stock() right into the middle of
> the hot path.
> 
> Consequently, the fast path has to jump over the inlined slow
> path and jump again to the function epilogue after local_unlock().
> 
> Let's annotate the slow paths in consume_stock() and refill_stock()
> with unlikely() so that the compiler keeps css_put() and
> memcg_uncharge() out-of-line at the cold tail and lets local_unlock()
> and the function epilogue fall through on the fast path:
> 
> Before (refill_stock):
> 
>   stock_pages = stock->nr_pages[i] + nr_pages;
>    7ab2: 43 0f b6 44 26 01       movzbl  0x1(%r14,%r12), %eax
>    7ab8: 01 c6                   addl    %eax, %esi
>   if (stock_pages > MEMCG_STOCK_HIGH) {
>    7aba: 83 fe 41                cmpl    $0x41, %esi
>    7abd: 72 1d                   jb      0x7adc <refill_stock+0x21c>
>   memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);   # inlined
>    7abf: 41 89 f7                movl    %esi, %r15d
>    7ac2: 41 83 c7 e0             addl    $-0x20, %r15d
>    7ac6: 48 8d bb 00 01 00 00    leaq    0x100(%rbx), %rdi
>    7acd: 4c 89 fe                movq    %r15, %rsi
>    7ad0: e8 00 00 00 00          callq   <page_counter_uncharge>
>    7ad5: be 20 00 00 00          movl    $0x20, %esi
>    7ada: eb 41                   jmp     0x7b1d <refill_stock+0x25d>
>   WRITE_ONCE(stock->nr_pages[i], stock_pages);
>    7adc: 43 88 74 26 01          movb    %sil, 0x1(%r14,%r12)
>   local_unlock(&memcg_stock.lock);
>    7ae1: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
>    7ae9: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
>    7af0: e9 03 fe ff ff          jmp     0x78f8 <refill_stock+0x38>
> 
> After (refill_stock):
> 
>   stock_pages = stock->nr_pages[i] + nr_pages;
>    7b76: 42 0f b6 44 33 01       movzbl  0x1(%rbx,%r14), %eax
>    7b7c: 01 c6                   addl    %eax, %esi
>   if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
>    7b7e: 83 fe 41                cmpl    $0x41, %esi
>    7b81: 73 20                   jae     0x7ba3 <refill_stock+0x233>
>   WRITE_ONCE(stock->nr_pages[i], stock_pages);
>    7b83: 42 88 74 33 01          movb    %sil, 0x1(%rbx,%r14)
>   local_unlock(&memcg_stock.lock);
>    7b88: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
>    7b90: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
>   }
>    7b97: 5b                      popq    %rbx
>    7b98: 41 5e                   popq    %r14
>    7b9a: 41 5f                   popq    %r15
>    7b9c: 5d                      popq    %rbp
>    7b9d: 2e e9 00 00 00 00       jmp     <__x86_return_thunk>
>   memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);
>    7ba3: 83 c6 e0                addl    $-0x20, %esi
>    7ba6: e8 15 f2 ff ff          callq   0x6dc0 <memcg_uncharge>
>    7bab: be 20 00 00 00          movl    $0x20, %esi
>    7bb0: eb d1                   jmp     0x7b83 <refill_stock+0x213>
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

