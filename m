Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41673D3305
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 11:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785411802; cv=none; b=HQDtknI1/nFBwW47B+JBXhqlPpCeLFpJdhwboEbsjUV4vrhAphX306Xhzob+WbscnCd0/XucFfrxryvEKxW2PjlOYYjdOpZkM3KeagN2JSU4Qrlg8zZI9tmeZFTE14aGCKOBKozycZgcT0MPi6JKjcp0pmQWAJzycc2rRKmUHuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785411802; c=relaxed/simple;
	bh=AvG44hWfCpaxdBcz+S4YlDXxi9rjrWiYvGChV3tKSrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtX9OTWNFlKCxlj7SFKQ0JbRXK10tIXvDmugbxId/Z1dQrPX5NXBawirVylv0T/g+Lk3bQZbzk7ok52wFsVojKfjVHD0gtQStlMPm8j3/muCnSL0OlT5Pje2iQjuKfrZB4RSUwwV35JurOCWbvkTcJe7+F1bLfOTGC/wsBQJjcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C/siyrsm; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C/siyrsm"
Date: Thu, 30 Jul 2026 19:42:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785411788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lTqFA7K6MPk5apzin5nmxQMjq9hPrkBYRMuS0oyOFec=;
	b=C/siyrsma3utDpfgdIXQWOQSCVE5HOZxSBg7SL58NypteKUNQgGSivRAcdNxR+MAV9mb0i
	jA9bgnQhSoVJHMgVvznfvdgEr1KpaxmQQA/nazLq58jI6djhPEcGu0n5DQGR8DweYbvuCk
	EJRRztuscKB/3kVpvRbH0h/I1eQpqTo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 09/13] mm/slab: introduce slab_obj_ext_has_codetag()
Message-ID: <ams4ndW0HZGjhODA@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-9-c29ef0f1f257@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-9-c29ef0f1f257@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 02:54:03PM +0200, Vlastimil Babka (SUSE) wrote:
> mem_alloc_profiling_enabled() allows evaluating (with a static key) if
> memory profiling is currently enabled. mem_profiling_support is a
> variable where false means it's not possible to enable it anymore,
> because the system was booted with "never" or it was later shut down.
> This is possible to query by mem_alloc_profiling_permanently_disabled().
> 
> To make slabobj_ext array size handling dynamic, we need a snapshot of
> mem_alloc_profiling_permanently_disabled() early in boot, so that's not
> affected by a later shutdown. We also need it to be static key based for
> performance. Neither mem_alloc_profiling_enabled() nor
> mem_alloc_profiling_permanently_disabled() satisfy this.
> 
> Therefore introduce slab_obj_ext_has_codetag() with an underlying static
> key for that use case. Its state is made to reflect the result of
> mem_alloc_profiling_permanently_disabled() during kmem_cache_init(),
> which does happen after setup_early_mem_profiling().
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

LGTM.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
