Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F602E7368
	for <cgroups@vger.kernel.org>; Wed, 17 Jun 2026 02:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781664824; cv=none; b=XqvcdzO7C+Ab+GuJhmEFUMBmo+v3+pMQzv4Kr0Ax7z68UZsJzMC+81VzkJtZ7xJzVP4ZQIh7HR8tp4dd0sgwrjObsLo/ek6UG1JTiyKBspCZleDGqDCJDB5UAmD7EFdQglHG5y9vDNa0OiwOHaGnR+GpjhYAcqMKWFITPfuTjQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781664824; c=relaxed/simple;
	bh=qhhLfmVttQM0BB8S/1qqja3e5gT3EVLGFpf+QIDHmlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PiQSRKRYaBCoi8w8oxHqckJeO9u7nL3h9IL/VOWX17plCQvNVWWOYwrpDuH5as0JM93u4vBkRb3Uszc87V2kLJeGiVfjCdmGRzEDMwf3pcx2fI60QzYuGZg54wkA9L8YbxI1863ANBjFlz5xiD2rrVpvCQwns4bAcODrVKyS/TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EE4gYESy; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EE4gYESy"
Date: Wed, 17 Jun 2026 10:52:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781664820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=41Mx9FoeSF64UfuXJhcRsL5/0BftSoOC6T056MV8iVQ=;
	b=EE4gYESyRB8TTGNIHYb4kgt24rizl6mFUDeVfxlZAjknr2uChkOftYLs53KZJNpJ2O9VCL
	ZxFUoBYIik/KhfRsNPH/gecYRlraV/RNq9WlMP72xeDGGP7aZAjVBz9hslnD+ebgiI2MsR
	ZxHmxyl8QFzu8IhJHod2M8NrWUMvSFc=
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
Subject: Re: [PATCH v3 03/15] mm/slab: introduce slab_alloc_context
Message-ID: <ajIKP4pQRnPHsB6k@fedora>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-3-ce1146d140fb@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-slab_alloc_flags-v3-3-ce1146d140fb@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 15, 2026 at 01:54:36PM +0200, Vlastimil Babka (SUSE) wrote:
> Similarly to page allocator's struct alloc_context, introduce a helper
> struct to hold a part of the allocation arguments. This will allow
> reducing the number of parameters in many functions of the
> implementation, and extend them easily if needed.
> 
> For now, make it hold the caller address and the originally requested
> allocation size.
> 
> Convert alloc_single_from_new_slab(), __slab_alloc_node() and
> ___slab_alloc(). No functional change intended.
> 
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-4-7190909db118@kernel.org
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
