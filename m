Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F464417D65;
	Thu, 30 Jul 2026 11:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785411613; cv=none; b=NPIWY6krAD8ia4a6rshEv86DIuaBMLrC+varA4fhFA1LrtYGcPbTbiahWGcvO4B7MXxE53t+TIk8EhAOoGPxXe0rMM9Dma54lvpzOlcgH9T34scRKDIkX3iqx88OfMGYWTmUgM3Rv/KMhzk1Q7uju7ThokMmSbBvcH2kfH1cfSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785411613; c=relaxed/simple;
	bh=5NT0a5eueuuSoevyVz8GyhqL9CTMbQ0FgV6N3uCiy2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqAAh5nDZH0eaGq3vWowDz7Gg3ziN5489u48d6DwtM5wQ5kyfa5vnhzoorlNqVta2JwFCVbLvQkOsLjxDG6NgKReRqAlTpuxenR8jVlJZ25Eg+SKt5elNAL1KfHXKVbKq0OyJQpcWwjiZGGEZDVjkC4VObnC1/vsbCRXadGUdco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ndGdv9Br; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ndGdv9Br"
Date: Thu, 30 Jul 2026 19:39:24 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785411601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iB3gW7E5gBTJYv7yCW1pV41bx1pEZMVfRRS3zFR2cWM=;
	b=ndGdv9Br3wEn10awUNRH8EYTM1ogNtakYjE886JQ9r8m3gtOpYEDANTxWibZ8zujBaSHNa
	xEcGwFsUDZorOi9EqfPpyO//+1Bw4P6kmTLnJ0crKclTNd/ZxfCcWR/ZOSouUA70qZ/iPS
	qMLaztAy/hXzH37oyrJM3PNZKIiXQ9M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 08/13] mm/slab: change struct slabobj_ext to a union
Message-ID: <ams30IqyBediM9kd@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-8-c29ef0f1f257@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-8-c29ef0f1f257@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 02:54:02PM +0200, Vlastimil Babka (SUSE) wrote:
> Currently, struct slabobj_ext can hold both objcg pointer and
> codetag_ref (when both are compile-enabled) and there is an array of as
> many slabobj_ext instances as there are objects in a slab.
> 
> This makes the layout fixed so even if codetag_ref is unused (because
> memory allocation profiling is disabled), the space for them is
> allocated and wasted. Similarly, some caches (currently kmalloc_normal)
> do not ever need objcg pointers, leading to wasted memory with memory
> allocation profiling enabled.
> 
> To make this more flexible, change the layout so that struct slabobj_ext
> becomes a union of objcg pointer and codetag_ref (to ensure uniform
> size; in practice both are the same size anyway). The slabobj_ext array
> then can have twice as many elements as before. For cache locality
> purposes, the effective memory layout is unchanged, so objcg and codetag
> ref for a given object are still adjacent.
> 
> cache_obj_ext_size() returns the effective size of (0-2) struct
> slabobj_ext's for a cache, slab_obj_ext_size() for a slab. Currently
> both return a constant value derived from the config options, but will
> be made dynamic later. Replace all sizeof(slabobj_ext) usage with these.
> 
> No functional change intended, the layout is still effectively static.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

LGTM.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
