Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D589C41A91F
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 09:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800627; cv=none; b=SCxdzu9t/JbA3cFMPzex1JW1Urm+RFZGKCoJHcRn7+Ybq320s9ZI/92sSZrkYvbULLbwocFn/eopjJHIV0CwPtMH+yGJZXfWz7fcvM72GgwfmDkNh2m9JvGmSrlPLYpweRVTP4EokFS/asGLCNjpbjobWZ/6qTlbmEsu8SQP2ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800627; c=relaxed/simple;
	bh=/3bs18c22En8Y6fmlGvcjNdT0MKJfjyKOwUI5z6JMLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BAmmSrDNnc99hWLlhfoc0Zbra4rrh97vs2Z9Wqz48bO5NJnDLzfSb+tzxaad1uJoCoCnj64qmeeGEMOD70w2t289aYgI8UYlVkccZsGYCEXgk8qht7vtNaIEEAOpaEqFvoJxzacbE5ox2Le/IxGSuyj4hNn8jtAmqLmDX+FOHfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gNalcYo6; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gNalcYo6"
Date: Thu, 23 Jul 2026 17:56:56 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784800623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n5Va5xqbBf3fhekckmlcg2X0hrc0i9E9Xp9SI7nV9WM=;
	b=gNalcYo6YMM9tSoRfU0ofQa40+wtblPqWAaxiKhOjK7x0Iw5UmBpQIa+Ye7cxVkj0Uy1AY
	K8HBT+TUYv/ZuBNMD5oqNdRNgzbaPIpIpKgviQ+8wsbpbRtPTAbkQNVb6QPRn19tNCTtLx
	TkfB7nEHflrI0sX2dTbbcAKderUB5iU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
Message-ID: <amHkbJsvOjcfUR3D@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora>
 <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 23, 2026 at 03:27:51PM +0900, Harry Yoo wrote:
> 
> 
> On 7/23/26 12:05 PM, Hao Li wrote:
> > On Mon, Jul 20, 2026 at 04:16:23PM +0200, Vlastimil Babka (SUSE) wrote:
> >> Currently, struct slabobj_ext can hold both objcg pointer and
> >> codetag_ref (when both are compile-enabled) and there is an array of as
> >> many slabobj_ext instances as there are objects in a slab.
> >>
> >> This makes the layout fixed so even if codetag_ref is unused (because
> >> memory allocation profiling is disabled), the space for them is
> >> allocated and wasted. Similarly, some caches (currently kmalloc_normal)
> >> do not ever need objcg pointers, leading to wasted memory with memory
> >> allocation profiling enabled.
> >>
> >> To make this more flexible, change the layout so that struct slabobj_ext
> >> becomes a union of objcg pointer and codetag_ref (to ensure uniform
> >> size; in practice both are the same size anyway). The slabobj_ext array
> >> then can have twice as many elements as before. For cache locality
> >> purposes, the effective memory layout is unchanged, so objcg and codetag
> >> ref for a given object are still adjacent.
> >>
> >> cache_obj_ext_size() returns the effective size of (0-2) struct
> >> slabobj_ext's for a cache, slab_obj_ext_size() for a slab. Currently
> >> both return a constant value derived from the config options, but will
> >> be made dynamic later. Replace all sizeof(slabobj_ext) usage with these.
> >>
> >> No functional change intended, the layout is still effectively static.
> >>
> >> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  mm/slab.h | 49 +++++++++++++++++++++++++++++++++++++++----------
> >>  mm/slub.c | 19 +++++++++++--------
> >>  2 files changed, 50 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/mm/slab.h b/mm/slab.h
> >> index e586798e4f16..f8446167e175 100644
> >> --- a/mm/slab.h
> >> +++ b/mm/slab.h
> >> @@ -550,18 +550,42 @@ static inline bool need_kmalloc_no_objext(void)
> >>  }
> >>  
> >>  /*
> >> - * Extended information for slab objects stored as an array in page->memcg_data
> >> - * if MEMCG_DATA_OBJEXTS is set.
> >> + * Extended information for slab objects stored as a pointer to an array in
> >> + * slab->obj_exts (aliasing page->memcg_data) if MEMCG_DATA_OBJEXTS is set.
> >>   */
> >>  struct slabobj_ext {
> >> +	/*
> >> +	 * All elements of the union should be pointer-sized to avoid memory
> >> +	 * waste
> >> +	 */
> >> +	union {
> >>  #ifdef CONFIG_MEMCG
> >> -	struct obj_cgroup *_objcg;
> >> +		struct obj_cgroup *_objcg;
> >>  #endif
> >>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> >> -	union codetag_ref _ctref;
> >> +		union codetag_ref _ctref;
> >>  #endif
> >> +	};
> >>  } __aligned(8);
> > 
> > slabobj_ext is now acting as a generic struct, serving as either _objcg or
> > _ctref. However, because it's set to __aligned(8), I'm wondering if this might
> > waste half the memory on 32-bit?
> 
> We could loosen the alignment to
> max(__NR_OBJEXTS_FLAGS, alignof(void *))
> 
> and drop OBJEXT_FLAG_UNUSED.

Yes, this idea is insightful and I think it may need a standalone patch without
blocking current patchset.

> 
> ...not sure how much we care about this on 32bit though.

Yeah, 32bit is a rare arch today :)

-- 
Thanks,
Hao
