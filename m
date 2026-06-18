Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355393A1685
	for <cgroups@vger.kernel.org>; Thu, 18 Jun 2026 08:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781771028; cv=none; b=A/mBnnuKj8PwcR88/SiWSarvoToSEB2X4rBCQ5lx0wXrdXYXus9hhq8b75tNN2Marx79m5b8wreBZ5w08YOrp5ZSSN+gTElJ8Bkmdkjgum5fMOdBjCuLx3SqgCvG1nnCzlsY08mm7p3L8btVeBo6R8fwiG08GetgrPeh0U5sElA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781771028; c=relaxed/simple;
	bh=pbH1wzXv2lUBjk0W1MD4+Q/EdzDfAA7OAgSSLfvC/Pg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=llI8GBMKqLXIusPqmhlx1o2Aufrmy98lnIyQDs6cOBXdtgmFsWrlveVq5mgz/EPO35eIcqWgD077LTgbhNnFdYCJsk6FNu0KiPGuUxrJRCb0Mjn/zr0u48C6FyeDq8vq6ZG4xmpOk8f+zth8bNUyLrhCaLaUdwmzy/i1CzjNDkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bfJZ8O6W; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bfJZ8O6W"
Date: Thu, 18 Jun 2026 16:23:32 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781771024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dN14oRJSbqwIkwKM2Sd6jqKzksJad326cLtI3tbLbjY=;
	b=bfJZ8O6WD2awZZmLUvzA/vF9D97j0zbcGCT7hs5TGLZkvtVRvAg9wCKDtLDdxOHIPRm/rH
	+KnXftHvAr6qfI4Hs/4olirIdD/duq5cji1tkOMEOdBk8CcLv07Tl0yjlEKfbqjclJXE85
	u72nZHF49mtYJ3CjAYaaq35xEAvD8hA=
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
Subject: Re: [PATCH v3 14/15] mm/slab: remove __GFP_NO_OBJ_EXT usage from
 alloc_slab_obj_exts()
Message-ID: <ajOpMCibPiFTkj6d@fedora>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-14-ce1146d140fb@kernel.org>
 <78b67a9b-44e5-4649-957a-9d42bfaa098e@kernel.org>
 <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26c29e4b-09b1-424a-b4e4-3358aac20115@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 17, 2026 at 04:36:58PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/17/26 15:56, Harry Yoo wrote:
> > 
> > 
> > On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> >> __GFP_NO_OBJ_EXT has limited scope within the slab allocator itself and
> >> gfp flags are a scarce resource, unlike slab's alloc_flags.
> >> 
> >> Introduce SLAB_ALLOC_NO_RECURSE alloc flag that has the same intent as
> >> __GFP_NO_OBJ_EXT but a more generic name, meaning that a kmalloc()
> >> family function should not recurse into another kmalloc*() for the
> >> purposes of allocating auxiliary structures (obj_ext arrays or sheaves).
> >> 
> >> First, replace the __GFP_NO_OBJ_EXT for allocating obj_ext arrays in
> >> alloc_slab_obj_exts(). Make use of the newly added kmalloc_flags()
> >> function, where we can pass alloc_flags with SLAB_ALLOC_NO_RECURSE
> >> added. This will also pass through SLAB_ALLOC_NOLOCK so we don't need
> >> to special case kmalloc_nolock() anymore.
> >> 
> >> Note that until now the kmalloc_nolock() ignored the incoming gfp flags
> >> and hardcoded __GFP_ZERO | __GFP_NO_OBJ_EXT. But it's correct to pass on
> >> the incoming gfp flags (only augmented with __GFP_ZERO), because if
> >> alloc_flags contain SLAB_ALLOC_NOLOCK, the incoming gfp flags have to
> >> be also compatible with it. However, we might have added __GFP_THISNODE
> >> for opportunistic slab allocation, as pointed out by Hao Li, and
> >> __GFP_COMP by allocate_slab() as pointed out by Shengming Hu. Solve this
> >> by adding both flags to OBJCGS_CLEAR_MASK as it makes sense to strip
> >> them anyway for non-kmalloc_nolock() allocations of sheaves or obj_ext
> >> arrays as well.
> >> 
> >> To avoid recursion of sheaf -> obj_ext -> sheaf -> ... allocations at
> >> this patch, until the next patch converts sheaves to
> >> SLAB_ALLOC_NO_RECURSE, use both gfp and alloc_flags for obj_ext. The
> >> next patch will remove the gfp part.
> >> 
> >> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-15-7190909db118@kernel.org
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> > 
> > Looks good to me,
> > Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> Thanks!
>  
> > With some comments below.
> > 
> > I was worried that perhaps replacing SLAB_ALLOC_NO_RECURSE with
> > __GFP_NO_OBJ_EXT will create a cycle of
> > 
> > alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
> > -> kmalloc_flags(SLAB_ALLOC_NO_RECURSE)
> > -> alloc_from_pcs(SLAB_ALLOC_NO_RECURSE)
> > -> refill_objects(SLAB_ALLOC_DEFAULT)
> > -> new_slab(SLAB_ALLOC_DEFAULT)
> > -> account_slab(SLAB_ALLOC_DEFAULT)
> > -> alloc_slab_obj_exts(SLAB_ALLOC_DEFAULT)
> > 
> > with __GFP_NO_OBJ_EXT, it would have been passed to refill_objects(),
> > but SLAB_ALLOC_NO_RECURSE is not. However this cycle does not exist
> > because alloc_slab_obj_exts() clears __GFP_ACCOUNT (as part of
> > OBJCG_CLEAR_MASK) and memory profiling itself does not invoke
> > alloc_slab_obj_exts() when allocating new slabs if SLAB_ACCOUNT is not
> > set (which is interesting, by the way).
> 
> Hm yeah I think we should propagate alloc_flags to refill_objects() etc, to 
> avoid later surprise. But can be done as a later cleanup.
>  
> > Also alloc_slab_obj_exts() propagating SLAB_ALLOC_NEW_SLAB to
> > kmalloc_flags() is little bit confusing because it does not have any
> > effect due to SLAB_ALLOC_NO_RECURSE.
> 
> OK let's address this one by this fixup:

Both the patch and the fix looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
