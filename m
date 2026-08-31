Received: from mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EF144B663
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 17:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198760; cv=none; b=ty6WwO3FgSB2EbW+n3RiUCHa2f+X6OLbNA+KGwvqhud7iiyCDoHrJKX1zp0yu8Ixvjvpd6eVDN3rl7hboxH4mwVZCuED+Gntt7YenfUuf/aEbxPB/11yUMPSS4lHy7E3cFHyLZwXa5p8vpuG6vapLqhiztmJT1P7Eh7BpnjoMXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198760; c=relaxed/simple;
	bh=BsIgtLWDoXUh0LcK2P6/hUTeOlcXonOAihqw77WsqZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KxM22yZ5Zbm1DnCmBiW8HS64jiJ151lOanRgG2iBBOX6/77SsUvV8oYcd9EhSJCuOjNxmjE+jnc2bQyDXWNbHnxThCj8wKJiHaIab8ZJOAfWF5RsQRKHhLbAO3HFNjp5u1a8y4fvSb4B0KjoUoUvGqTZUR9R18Gna0vFyYehBgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EysNYDPb; arc=none smtp.client-ip=95.215.58.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EysNYDPb"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BsIgtLWDoXUh0LcK2P6/hUTeOlcXonOAihqw77WsqZc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788198755; v=1; x=1788803555;
 b=EysNYDPbm29lnd0WwA7frAsRFjMi4JP6Dbhubg19rV+YF/a1FRmwOffP0gtCCInxKo0DH4eo
 7cDhh6Gyv2Eh7k3igIYoth2pPObDwxbNAIGG9tNChPJoK/lWdzu5tnVVQDxZTX/EPZgboPV1Ngo
 At11PyHF/xpUOwC7mmzgsGTA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d7054335f12e2924;
	Mon, 31 Aug 2026 17:52:35 +0000
X-Mizu-Trace-ID: d7054335f12e2924
X-Migadu-Flow: FLOW_OUT
Date: Mon, 31 Aug 2026 10:52:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joe Damato <joe@dama.to>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	stable@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] mm: memcontrol: raise MEMCG_MAX for charges that fail
 without reclaiming
Message-ID: <apW_N1urVjfCLmbZ@linux.dev>
References: <20260831174836.3102406-1-joe@dama.to>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831174836.3102406-1-joe@dama.to>

On Mon, Aug 31, 2026 at 10:48:35AM -0700, Joe Damato wrote:
> Charges that exceed memory.max and return through the nomem label can
> raise no event and simply return -ENOMEM.
> 
> A non-blocking charge can hit the limit, get rejected, but is not
> visible in memory.events.
> 
> This was noticed in a production setting where bpf_mem_alloc() attempted
> to refill its per-cpu freelists, which triggered a non-blocking charge
> while at the limit.
> 
> Commit d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for
> enforced allocations") added raised_max_event to cover charges that are
> force charged without ever reaching reclaim, but charges that are
> rejected outright were left out. Getting an allocation failure without
> the corresponding MEMCG_MAX event is unexpected and makes debugging and
> monitoring harder.
> 
> Raise the event on the way out for rejected charges as well, by routing
> the -ENOMEM return through the same exit path that already covers forced
> charges. The existing behavior of raising a MEMCG_MAX event on every
> charge/reclaim/retry iteration is left unchanged.
> 
> Tested with a module that performs accounted GFP_NOWAIT page allocations
> from a task in a cgroup at its memory.max, and measures the resulting
> memory.events:max delta. Without this patch the rejected charges raise
> no event at all; with it the delta matches the number of rejected charges
> exactly. A GFP_KERNEL|__GFP_NORETRY control, which reaches reclaim, raises
> the same two events per failed charge before and after, confirming the
> existing charge/reclaim/retry accounting is unchanged.
> 
> Fixes: d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations")
> Cc: stable@vger.kernel.org
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Joe Damato <joe@dama.to>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

