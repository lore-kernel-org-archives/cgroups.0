Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793234915;
	b=cTrAVHLTbooeZtECLPWwvwoNvC8wfNDHP/z1OJt9BHDac8XcdxS6v25j2Dfi3Wh07V7S
	 etSTr/qN7keKiBBsWKF06NrN+XuhSmaR8eiPJ2b/91NNPIsxB04YcSfhPC2Jl5+yo/j83
	 hvsmFawSYmNfJQ2CLB3MZZ6co/oERRfUX//eBIoyt4KtrmCOWUCqBgMq1EsfygKqqv80E
	 KMoD6kuad130DxhCOF/Am93kwMzWxtmE9clONueI/JiR16zj+GV8osm5Fjt/kSiGOZ09q
	 JP7sYFtQhdhRBHiw6ezEkb5vaYJgNHzQF/alXWOFjGgxCNqM+M6cF/LLXsaTgs7uCHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793234915;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=RBKUF6AXFgaSWUb7Kj83+bMmMJKcRCg8xBUXyTLPZYg=;
	b=VlnPTLLOKCxDM+ilOCmntWq2SqrkZy3UuFD69BtiRZ7MY5SNPT3XeI6VryGIJA4kTWGc
	 Cy619kxOgZygB5KhvbI2duMa5Q7TDpK2vnLmNfm+koRWQKhD0ZdjAIVODfpVoRXxlOrkQ
	 QWN5JrLc/9hI+C4QA91GGkc5E9Nu8t8NZxjcRnn7imHC4KC9dsnirRDrfIymnoYAKO5vL
	 /KCYw48sX5CIRPX2QLWe38UpkVqyyaKVkw4ltVuepAK52MQ/xkLif7FlxqOnycVKq00eZ
	 4K16TAgg4iODQZpOTmaG1tqtMA7ER7OVkIElToXI2f2Auxaj50VtOWItM/vIEiH3s8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r2ZgFIxE;
	arc=none smtp.remote-ip=91.218.175.158
Received: from mta0.migadu.com (out-158.mta0.migadu.com [91.218.175.158])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3E4606A31A
	for <cgroups@vger.kernel.org>; Thu, 29 Oct 2026 00:48:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D3E4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r2ZgFIxE
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YzQ2Pc3WwUtKoWDSH3+5WqZrrR/yZR7jr8YByoE6Vi8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793234912; v=1; x=1793839712;
 b=r2ZgFIxEQRb9AtUouSFKV6VSKOIXUP2YOx2IHFPt/8gnhloT9z5A1CloHOOkRVYqgWUftXaN
 D/WK8Liiw/xy6PZddQDq0PeZqi+mx7Va9e9xD73gwJp0cB31fVpk1zehpE/3/yW+3sJIpY72n2B
 K1S22oh0jnVfwnjpLsTMZEfs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 469ed800a9d69200;
	Thu, 29 Oct 2026 00:48:32 +0000
X-Mizu-Trace-ID: 469ed800a9d69200
X-Migadu-Flow: FLOW_OUT
Date: Wed, 28 Oct 2026 17:48:26 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 1/6] memcg: Remove unnecessary READ_ONCE() under
 memcg_stock.lock.
Message-ID: <auKW_UkDicyxx6fQ@linux.dev>
References: <20261028185034.3607746-1-kuniyu@google.com>
 <20261028185034.3607746-2-kuniyu@google.com>
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
In-Reply-To: <20261028185034.3607746-2-kuniyu@google.com>

On Wed, Oct 28, 2026 at 06:50:13PM +0000, Kuniyuki Iwashima wrote:
> this_cpu_ptr(&memcg_stock) is always modified under
> local_lock(&memcg_stock.lock).

You need to be more precise here. Mainly the cached[] and nr_pages[] are only
modified under the local lock. There is flags field which is being modified
without it.

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

What are we gaining with that? Is this measurable? With READ_ONCE() at least we
are very explicit that this field can read and modified concurrently by
different CPUs i.e. better readability.

