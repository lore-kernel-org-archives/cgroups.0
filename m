Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793235349;
	b=FycfdKyiZsHnbqAlKb48iX4c85pl4EVY2CSXBO7qTflFPRNeniDOgT+jh38EkyJBoRU1
	 aGN8t4ia5ZRWhoCQzPHBUynn+kh0rzfzT/vFGilgI5j07ua2DsNUkcmvvBwtoWAcxgW/a
	 ET5Soza+DhzOr/8Nx1nsvf7Oj4H/a/lOaQdRdHSUdUsvJVAO8LjHQr1WByN8E0gD/YlYI
	 I46JdG6Rqo0caeJuW4f6TaeKOFnCM83Ubu61OEmpAQn3RS8+PYHYBZCNAwm6YsFpieN4R
	 pTZrGyFQIImfv82B27W/bJ/Yuyxcq7dQ9Kl52mlM7rsDQOq+i/5YFk2BqLyy/8Z+M+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793235349;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=fFzYuQaJCauylA1fGRQBnIg3JJop64i3OCtTEnPOz/Y=;
	b=XaEqQwInxCXfH+3NZs6NblLYNkpPHJZ7zNqYVXF+h4gsoasGwUAoLV83gTb0gg17TYo5
	 dQD8l7l8zvjyovpPJxmMnruvCA/fq1ZclsZGmQWkf5Avasao0MIg2GVoFwQpIzmFSq+/4
	 Na4Qzk8AMdJykibpELRdgdArGR7bstkEJnRGKu+zVOgHIgN7ASG2/NocMrVlaICF61UxX
	 Dm5eicBFcgIxizjIcCt4PB1vN65CQromQI6yW0+38q+VfZZgtRyqVou9W7BVBe3mnVBsC
	 ifF2cZZhMKyXRcfpbBbAHaFdm7FPUJRuIqyc79gLO9LapXlwK0pJbAhRdKyquBQ2w+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="gTm/Crbh";
	arc=none smtp.remote-ip=91.218.175.227
Received: from mta0.migadu.com (out-227.mta0.migadu.com [91.218.175.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C3A606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 00:55:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51C3A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gTm/Crbh
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yT3k3zYkwm+Ajt3rhJuC2pHkaVqR6QAMaSTFBMTEmxg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793235346; v=1; x=1793840146;
 b=gTm/CrbhkInCIqsSmZ+9OtR7q7I/H+QeCeD+Te3Oy6kdn/OjfCmtxYRb2Jlhj4BDxGh6jexJ
 vhouNhtwbHX909bRb5jPoAyGxIG3cmHrDjXXhF2wVeC8m6BuIWOIMeMSILNZTWEw1pPngaN7YKe
 cX00ZRtSgoedd/vCmY6VegBs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1fc603a9cbf2cb33;
	Thu, 29 Oct 2026 00:55:33 +0000
X-Mizu-Trace-ID: 1fc603a9cbf2cb33
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 17:55:31 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 3/6] memcg: Annotate slow paths in consume_stock() and
 refill_stock().
Message-ID: <auKZIA-0j9WT_gFU@linux.dev>
References: <20261028185034.3607746-1-kuniyu@google.com>
 <20261028185034.3607746-4-kuniyu@google.com>
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
In-Reply-To: <20261028185034.3607746-4-kuniyu@google.com>

On Wed, Oct 28, 2026 at 06:50:15PM +0000, Kuniyuki Iwashima wrote:
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
> when an FDO profile does not cover a caller), the compiler treats
> these branches as likely and inlines css_put() in consume_stock()
> and memcg_uncharge() in refill_stock() right into the middle of
> the hot path.

Please state the compiler along with its version here. I didn't see this behavior
on gcc 14.

