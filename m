Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D86F2E2DF2
	for <cgroups@vger.kernel.org>; Fri, 12 Jun 2026 03:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781236099; cv=none; b=KrxIamOa6EXLky2olD7tUoY25RBvrCQa7y60f+cLPF8dXy1jp8+AuK3wIb04TMYHw4GXf8bp6AtDaeEHcnsYwrgrYr1iW5uiiYZxK3Ce/Td2GLAtU+r59vAiipJQiTL+zXhoh6ol4FahmJskSw/cWOxa4GCRIr+7crf/ppzFMkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781236099; c=relaxed/simple;
	bh=OuLUiybnuD4mbTuiO39TaMRL1NG9vYPp6uUs4xKIAN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VNyA5HFO8fFoxBf/E5A4sSaiWBkdimfCg4wbhv4cRbGLsdpRkQlD1Qkv/hjecQhtpKzgzOQa8tsGqlZLbOenf9nAQPUxUe/N8O6PQ5P7Cmo7iGxpPNi27gcI1+o9egeYcumfDm6QvG2ibPiXKreGTNd3GbSVVW/Lw/aUg1OK7FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X64yesLt; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X64yesLt"
Date: Fri, 12 Jun 2026 11:48:04 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781236096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M4acUcN5cewJBmGpl3WpO5aKCvDT+7GaPC8r+f7iGxU=;
	b=X64yesLtOC7VbaPN8dpYre1uzI5cHOBiNSM9VJh4CDBD7FO0tzhTA7DmzzyhqknI4rADra
	lWe+NbZpB4CSHevsAVgJg2T/aiD438EaEneqIMDDPTVQQhdqPTbvWkJVWF/y1h0dzASrrp
	faoX9kIfCeBVGwAvx9kNvUW8DDUyYz4=
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
Subject: Re: [PATCH v2 03/16] mm/slab: stop inlining __slab_alloc_node()
Message-ID: <aiuBW_xY6x5IBQfE@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-3-7190909db118@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-3-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 10, 2026 at 05:40:05PM +0200, Vlastimil Babka (SUSE) wrote:
> With sheaves, this is no longer part of the allocation fastpath.  For
> the same reason, also mark the call to it from slab_alloc_node() as
> unlikely().
> 
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
