Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70D336A03A
	for <cgroups@vger.kernel.org>; Fri, 12 Jun 2026 08:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781251415; cv=none; b=QGVwYok1C/2+mVq5XLe3lLjqrH0xpJyGD92hQGvFaSVigkVch7/QQS18kTJG4L0qrGcKgXk23FEMlIY62qvZ/KJKBl3H2oD7l+2V+sjI3XS+WzT/fGxN5XUrqQdZVDNF0PEUvK7noxpc3hZvPubmw046L8AlzbxNgJZfm25wOrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781251415; c=relaxed/simple;
	bh=UawdF7yf0yUluBwQollRTj54zoJW1sCSfdICxCy4UVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J5bJ3Imxlz3y5zh/VzbIe3ie2/lrdhfo8Vjk/SujM5Pm/9Or1bni1jwKgAfOzt3dfq9Fs+s7NwqLST+DxUXC1HOpQED6B6MmKDDGBu3ImLwSRgYqVGdHwOx6ElPAQsGT38OIJVtxFOrh6g1efag2iAuB1yBUD1IrhmX3x7AAKLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rn3tCeCy; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rn3tCeCy"
Date: Fri, 12 Jun 2026 16:02:51 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781251399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cpaBDcnd03Rl1JTLs5faOENgBW+ak0IDfAB1rJ8oj0g=;
	b=Rn3tCeCyjTYry5rK2dNU3DI/xAdxSKj6UZkgMeIHm/Wse+dqXRXkzq9MGHfpePUU4F1wAA
	NpMELWWqM5o7p05gBoEaZXDiVcggeTFsoDVIGVUuIABHrcm/RfX/13pdoe9vyqGG/oHZ6+
	b/xyQ7UFNPSsJXyk4iddelK5Ls3LSj0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 14/16] mm/slab: introduce kmalloc_flags()
Message-ID: <aiu8W3EQhalCP9HW@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-14-7190909db118@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-14-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 10, 2026 at 05:40:16PM +0200, Vlastimil Babka (SUSE) wrote:
> With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an
> alloc flag that prevents kmalloc recursion. For that we need a version
> of kmalloc() that takes alloc_flags and use it in places that perform
> these potentially recursive kmalloc allocations (of sheaves or obj_ext
> arrays).
> 
> Add this function, named kmalloc_flags(). Right now it's only useful for
> these nested allocations, so it doesn't need to optimize build-time
> constant sizes like kmalloc() or kmalloc_buckets.
> 
> Since we need it to support both normal and non-spinning
> kmalloc_nolock() context through the SLAB_ALLOC_TRYLOCK flag, split out
> most of the special _kmalloc_nolock_noprof() implementation to
> __kmalloc_nolock_noprof() that takes a slab_alloc_context, and make
> _kmalloc_nolock_noprof() a simple tail calling wrapper with the proper
> context.
> 
> kmalloc_flags() can thus determine whether to call
> __kmalloc_nolock_noprof() or __do_kmalloc_node(), based on the
> given alloc_flags.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
