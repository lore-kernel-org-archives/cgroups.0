Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793238256;
	b=IUKuNF1F0nog2+b+7tpOSsNdQdyJhbRlZ+OEWKapWpusjhKmktkcxBdq1n0nyzyc6vuB
	 8ycTAunQyaDDpwzHUh3EFUA8bH7+tGiWFRPD8Bm0nXyZ+VHUDpMILt8V+tPGcE2LRmNPq
	 ycQoP8XFUfart9Sw6NZ+E/5O3nLbxo4LvEUO101RQcHvzc2jyNl6xtEUQbvXRob4fwSnV
	 wznrpl8JQHeQAkOgt4UB3fa1qkW0hLLb167ujUcXEOLP0g0N1OhrKJ6Jf4wlkPTFI84e5
	 KS1DFD+QIsRQh9WtXdg5yyGSkMsWiRbeAuohXHpkDW4lliap3DBkz++x8fIof13Kleg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793238256;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=yo+LbfVZEjg/Q8YdvdF/TXt6+PsEQJuuEdPnTyK7mdE=;
	b=wIXRRjcXIolm+lyxYbG5utafqw8hobfBDE8Kolffm5BqHuL3Z8GMtgEXSTMf/d6kwpC8
	 mqQjV7oTwRKRqZGtjBTLSmWJ2l6ZVqG8E668mxmy7CnJ9S8d3fEXZEO1nrYqgPKvFm/8g
	 N6GVbt38H15FtsHyQqkRzo8sLae3MP/S2zoCoY/ejyuPJd14uqvAvHdPDjhPaAUY6OZFU
	 Pn2ECrxqwg1pOQ7uVuVvlmS9DNFLIfW1A+rp9Am3g19xD3lWNmD7912eORyD5Nets/AP4
	 NcZi5IlxJVjvNdTBNQ1Qm9BO9qpHgWYEwOguIx/kxwFFU3gSQ89p+LTKJuU7HVc8Euw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jqn27f5d;
	arc=none smtp.remote-ip=209.85.215.200
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1B7606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 01:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C1B7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jqn27f5d
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4216aee8fso1851971a12.1
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793238256; x=1793843056; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yo+LbfVZEjg/Q8YdvdF/TXt6+PsEQJuuEdPnTyK7mdE=;
        b=jqn27f5dCqECLChDjd+w0K1p1Owuph49pD56cunX4NmaM6b2e5FoGt80thIIvpt9u1
         rGnob3fSolNQjtcA3XBTJVtDdgeScDJbHns8xlzzuDXOrB3ab09E2spmhx3IqM0PnPHW
         6D1wzQsWdGUG06H/kb/+4QArFieUfxEu6E/N2ZekiRYNC6ZUWYzmDfjKqH8280Wj4LMF
         FzDre32ouxIeCPwhnTBSQVcGQhtEvrpQETLQ7Az8SpnnHiv4IDyV5BIN7pPwL8w0Dxqg
         8h2CKsyrx80kQSI8S7jlrLKByjfoG91BhmYCTLLjUevlSvbhK0DW+3CuLBd5qMedVlOz
         INyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793238256; x=1793843056;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yo+LbfVZEjg/Q8YdvdF/TXt6+PsEQJuuEdPnTyK7mdE=;
        b=toaaZ/0ONSlu9gU/U/A9RGlbH6ZUiTetJAzxeC6ThjAPrYzaEv11Asf8MJGbLomFV6
         YpsTU8rysqMoKtpe77dFwqWo0784p49IMux3iQgR/e+Q8t1+Ia2BJkub7ugQDnDNjWhw
         fjrQV2ep/DKm/s4kdM9aKy8h4l4Z/NGLRng9vF/z+1Y3OpaI9HfZxJhSjBc6FH0YfzHH
         toDLjurCMrTmIG7KlPppQvv6mXOLyc27bQnbxuo6Zh91L1LbNEAgGd9NctqPKF56zNtg
         sPsoHILLHXlWNKHDezuO8qC7gPqFOIaGEftUxti//xzUGz/A9sH7oEKgxeDzZ92qR2XD
         BYXg==
X-Forwarded-Encrypted: i=1; AKwUvBzfHkRQsjW2FzgCBZlZs1vgeTqxzr7sYy/jyNqoTuInvmFk/ILgZMBU5S03Y77Kv4MTE4BdrvVI@vger.kernel.org
X-Gm-Message-State: AFq9FYLjvaHaX+7n4c/wrsRW1MKjF5fxk/yfci02HL/zttzciJBVslHc
	jxl3vqQUkiuCKmzI1mPr+bFdUk1Y1BrFfIeY3IHBRlkLvXrKOpG8iX6NzN6eQx1HGXCDwXIz4mD
	f1PPT3w==
X-Received: from pgbl4.prod.google.com ([2002:a63:5704:0:b0:cd6:14b:6a43])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:502:b0:3de:8ee8:8323
 with SMTP id adf61e73a8af0-3e902392f51mr3529188637.29.1793238255629; Wed, 28
 Oct 2026 18:44:15 -0700 (PDT)
Date: Thu, 29 Oct 2026 01:44:14 +0000
In-Reply-To: <auKW_UkDicyxx6fQ@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028185034.3607746-1-kuniyu@google.com> <20261028185034.3607746-2-kuniyu@google.com>
 <auKW_UkDicyxx6fQ@linux.dev>
Message-ID: <auKi4o_Dsb1MMPdc@google.com>
Subject: Re: [PATCH v2 1/6] memcg: Remove unnecessary READ_ONCE() under memcg_stock.lock.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, 28 Oct 2026 17:48:26 -0700, Shakeel Butt wrote:
> On Wed, Oct 28, 2026 at 06:50:13PM +0000, Kuniyuki Iwashima wrote:
> > this_cpu_ptr(&memcg_stock) is always modified under
> > local_lock(&memcg_stock.lock).
> 
> You need to be more precise here. Mainly the cached[] and nr_pages[] are only
> modified under the local lock. There is flags field which is being modified
> without it.

Will update.

> 
> > 
> > Unlike is_memcg_drain_needed() under RCU, consume_stock(),
> > drain_stock(), and refill_stock() do not need READ_ONCE().
> > 
> > Especially, in refill_stock(), READ_ONCE() is used twice for
> > stock->cached[i], which forces the compiler to emit two volatile
> > loads from stock->cached[i].
> > 
> > Let's remove the unnecessary READ_ONCE() and eliminate the
> > redundant loads in refill_stock():
> 
> What are we gaining with that? Is this measurable?

I haven't measured, but here clang unrolled 7 loops and
each iteration had two loads, where it should be a single load.


> With READ_ONCE() at least we
> are very explicit that this field can read and modified concurrently by
> different CPUs i.e. better readability.

For me, this is rather confusing.

READ_ONCE() means this field is modified concurrently,
and WRITE_ONCE() means this field is read concurrently
(or modified if the writer is not under lock).

So the genral rule is "use READ_ONCE() in a lockless context
and WRITE_ONCE() under lock", and at least we should not use
READ_ONCE() under lock, which adds unnecessary volatile load
and implies non-existing concurrent writer.
