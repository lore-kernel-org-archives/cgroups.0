Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1549E328243;
	Wed, 29 Jul 2026 09:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785315785; cv=none; b=r3smKNzl4FP0fDbsN+cjohX5gpTKmcr/WabRMvBxlHfIRm30PuRzFoERiSjcc0oKDZPW94rkVV+kRRU7W3fDQB3yfHwtpAsuMGDVVq0iBubCZo7uxfhJRiC6PRFI1twd8madLkHuPFa1SP/jgjIl6x/rHfovYWVN7w4At4Bg6RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785315785; c=relaxed/simple;
	bh=JmlVSTsAKmCHzJkQ8+s7eLXxjpbziOV5lrCLG3yfPA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PnM1g2mJdP70lAM354XLpQAT6dmi2slxEHlhvqwNG51QNjUMsJJ1pbh04ZBXdhNliJ1Npl8pW1/Z6j8sxrIuauYu3i9XGOHgHo1DNpdqj4gktq6vR2SAoMj4eis2yaLYgC7cTPcavj7tBSc4ttj+YKvf8iQ/orcD/7uAfIYPoNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TY6fh0Vm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TY6fh0Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B119D1F000E9;
	Wed, 29 Jul 2026 09:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785315783;
	bh=Hk/wmzjRin7wzdv1xCpmqWE7MxHPtowEg27I7xdjRXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TY6fh0Vm6QKgQYYTN50HivvfDbEnYiqss8uAwCns6ZiK1ZrYS2G4S8O8Wg89ptNW/
	 1Sm2IEzvau6S6bDvvOMCCihghEtUDk5cPqIckytaeMbQ2WjaWpwJdt3zgRsytmXoe8
	 6CTVS/lSqjWfYES/NUbJu63q0hKVAHUTCN+I5JlLMEBcqpEQjDMbvAaGGuqBBHDgIi
	 kuFbIb/naGe1/y+UjD/F38chD3213P2dXgm33V4fh4nbuS9u6XHHacu8pNf8w5n7VZ
	 dZEkt0Sx2v+jz0gJkzRynTw7eOwZW1J3texZ4MFuLn6L+XyNdYne7OKiCz+HF6lUgD
	 6JEUpLNzTXGzg==
Date: Wed, 29 Jul 2026 18:03:00 +0900
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 08/13] mm/slab: change struct slabobj_ext to a union
Message-ID: <amm6Ke2U2J0RwW07@thinkpad>
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

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
