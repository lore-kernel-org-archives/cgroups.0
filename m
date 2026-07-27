Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070153750C9
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 06:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785133102; cv=none; b=BvV1V5GpSZgdknTo74qugqNHl/nqHTJb/W77cfk6BXOToH91r2ju0U+vSkrPCZDkD0LU7uHSiA8kK6PNNN0cxECl8JM+CGCi0lwTjMwKJGgHkRlVGoZmNv667qQfpxAfLN3xDpJZyFkEvI/9T9TNrY9xfqDLZ6UVDIUjzimPC1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785133102; c=relaxed/simple;
	bh=zuU0Un4sCudMrmbJDUX0yvqEQptyBLfp6QZSg2Lz12U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZoMeU3oQ7Y0HYr8glr5L1QE3huygaxf9l/WniQwjDzj4Z/YCpVtL/0El9u6hmfoorXwDWzQYHn7mHsMTx/PvRUW2EBt37ob/KMvkeBWC4iXHr0zmR5W3ig7XJ60T0INIe2RbiAUUC6nYH0E4FJQnwVEBxXIX9MtoKjzY0vy0TPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GY6yWQxd; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GY6yWQxd"
Date: Mon, 27 Jul 2026 14:17:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785133088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q1RvP5F+5cbF/LfhOCxOJZyT9O4mMLwMJsRDu/s7ZFU=;
	b=GY6yWQxdjDW5if6+h5Exj1gChFKXrWvA8vUg9yXECQsjk2QLg17DvCOCTVog17HlQdfZ9W
	ciL3/rs0ECCTCPnDST6bgyYNsR3k7ZTsfRuF7b6rNZjdR0YXuZDMa03wOk6ZKUReMgOfqv
	brT13tjWt4V1njx/XO1L9X0Pg80lKX4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 12/13] mm/slab: add cache_ and slab_needs_objcg()
 helpers
Message-ID: <amb0jBAYvObMYBVv@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-12-2fa7c6f60dbe@kernel.org>
 <amMt7baftCrU-OJq@fedora>
 <df871664-09ea-4e83-bff0-bbd3ff9f3ccc@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df871664-09ea-4e83-bff0-bbd3ff9f3ccc@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 24, 2026 at 06:31:51PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/24/26 11:41, Hao Li wrote:
> > On Mon, Jul 20, 2026 at 04:16:26PM +0200, Vlastimil Babka (SUSE) wrote:
> >> Slabs of some caches never need the objcg part of struct slabobj_ext.
> >> Introduce helpers to query this for a cache or a slab.
> >> 
> >> Introduce SLAB_MAY_ACCOUNT flag that is currently only internal and only
> >> is_kmalloc_normal() caches don't have the flag.
> > 
> > it seems this could be "only type == KMALLOC_NORMAL caches don't have this
> > flag".
> 
> I think not, because with SLUB_TINY,

Ah, right, I missed the SLUB_TINY case.

> a KMALLOC_NORMAL cache can have
> SLAB_RECLAIM_ACCOUNT flag and thus is not is_kmalloc_normal()

Just a minor detail though: under SLUB_TINY, SLAB_RECLAIM_ACCOUNT isn't used,
and new_kmalloc_cache() checks KMALLOC_RECLAIM != KMALLOC_NORMAL before setting
it. So is_kmalloc_normal() should still evaluate to true.

> and may need objcgs?

Agree. Under SLUB_TINY, we indeed need to set SLAB_MAY_ACCOUNT.

> 
> Yep it's subtle :/
> 

Yeah, it's pretty subtle. Since the full case matrix is tricky to summarize
accurately in one sentence, I think it might be cleaner to simply drop "only
is_kmalloc_normal() caches don't have the flag".

-- 
Thanks,
Hao
