Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.188
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793303923;
	b=o+PwHnWA0d+5Q8OQBmiJzpsk93JmS16QZ3GKJjXNiygqOMfXFxSOj086JbNIDFj3NzHN
	 S2SQ1LuvkzWZl72a76XPyyLjVNZABSJFKai9IXTD5DDsaphKOUvfbKzEU1SLUb+U1Zrdq
	 2L9rHtH7ghaSBSI4Wi6N3h+XbyQG8FsC1jyqIBQ0iXrkMg1CIMICI+btrI8Z4yHYqWvZD
	 Ex8iw/+xfMo1DohUONi1lRW2t67wDAyh+rCzsAJAde3k8t/QyOI5hEcEMJI5YMVMdVw8A
	 ltwffzQFiTE6QULu3G8fWHpK2igibeHQ1rYhQj79zBHl3qehOe3S/NkmwY0csxEHXxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793303923;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=pVeEdJtlXA25iorxAj4BG6N6zIAVHrWYsjlt6JZGNBA=;
	b=ugUn53+zZOi2Q8ThRQbZjQjd8yMxtIG/o88kZjdesOMTmI5RvR2QANL3HJ13CGXNCosQ
	 CqT9rLvT/nsWFPQy2OcY4p/adKfwBMVkfP8wWK17R7vAW9gE6Htw4Co5BOZ0RlQ0o7TWb
	 WAyLClNyMDD6vLZVF20nu1G8beKeJlU0P4lTsLqVim+aatAl5JoYGeOdBjUTL79Q28CfU
	 HR4dWZmlX7qeQP13TOWDNJSb926W19mPhtMaR1xAH3MszmYNA3OXIn1R2I6R5ePy81Ki3
	 3DldE7DSwzOh+4EtLjhZVrNFiOUMuYhmaiLZlncl+KrTDEWl797Sgrv4odILKh2lIFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hEe2oV5n;
	arc=none smtp.remote-ip=95.215.58.188
Received: from mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C45F606A329
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 19:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C45F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hEe2oV5n
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Rv8ify/EDz+JQqoM8pTjIvCmOvRL5bSqPDPKODDV4kg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793303919; v=1; x=1793908719;
 b=hEe2oV5nqrcMnFsNW5746z+Cp1JNiXRXKgKx3cYeiTMjXe5ZYZz33Zj8ppVLV2wud5vTYhAV
 Z0BS+/26uakHvBxM64v4rrsYb55aRJAF/YsiaSbK9kYstKHyX+2LaaauYoVT45C0Jtg800/LAZ4
 Ao5XbzB3bw2hb8IgIjoCKnNI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 400292d4dbe12dae;
	Thu, 29 Oct 2026 19:58:39 +0000
X-Mizu-Trace-ID: 400292d4dbe12dae
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 12:58:34 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 1/4] memcg: Remove unnecessary READ_ONCE() under
 memcg_stock.lock.
Message-ID: <auOlVi4b4kOGy7qh@linux.dev>
References: <20261029194452.3189365-1-kuniyu@google.com>
 <20261029194452.3189365-2-kuniyu@google.com>
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
In-Reply-To: <20261029194452.3189365-2-kuniyu@google.com>

On Thu, Oct 29, 2026 at 07:44:12PM +0000, Kuniyuki Iwashima wrote:
> this_cpu_ptr(&memcg_stock)->{cached[],nr_pages[]} are always
> modified under local_lock(&memcg_stock.lock).
> 
> Unlike is_memcg_drain_needed() under RCU, consume_stock(),
> drain_stock(), and refill_stock() do not need READ_ONCE().
> 
> Especially, in refill_stock(), READ_ONCE() is used twice for
> stock->cached[i], which forces the compiler to emit two volatile
> loads from stock->cached[i].
> 
> Let's remove the unnecessary READ_ONCE() and eliminate the
> redundant loads in refill_stock():
> 
> Before:
> 
>   cached = READ_ONCE(stock->cached[i]);
>    4c 8b 80 88 d7 bd 84 	movq	-0x7b422878(%rax), %r8
>   if (memcg == READ_ONCE(stock->cached[i])) {
>    48 3b 98 88 d7 bd 84 	cmpq	-0x7b422878(%rax), %rbx
>    0f 84 86 01 00 00    	je	0xffffffff817d01e0 <refill_stock+0x210>
> 
> After:
> 
>   cached = stock->cached[i];
>    4c 8b 88 88 d7 bd 84 	movq	-0x7b422878(%rax), %r9
>   if (memcg == stock->cached[i]) {
>    4c 39 cb             	cmpq	%r9, %rbx
>    0f 84 7a 01 00 00    	je	0xffffffff817d01d0 <refill_stock+0x200>
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
