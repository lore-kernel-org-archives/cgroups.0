Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184C43A7820;
	Wed, 29 Jul 2026 06:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785305928; cv=none; b=GEIButypa44cD2vO2Oct+OIhhnRTLTRdtLg5fMrUGqyhLuU/vcahnosonbsZk7D6697JvRT3x1q/65jlT9OqoQPeDW07tCPiaApD5wqTv1ZaDkkKVsMcxElaVwqSjrGKdGOUPizprc/3Stiwbf4qzse+artJgqCBFWQDvSTMUec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785305928; c=relaxed/simple;
	bh=IVWPvcxWvs/qL++i+UCQK/3/LHdTfC1FylvRNZhML7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwMSP0bH22LS9iA8xsUJEgpdS4mj91aneZvSGc82GLp7CqmXKgr4jWX/pFqodpjGCw9x8QFwsfnSTm2xC7QQIZsGbvm4V8a4TWFBt1YC4KR5JC/vTjQbzvI0TmRDY1NKEwrO8X5tns1iY2WZciSeXK7HQdtguUG6UHV/RI6wUr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IpxI1fde; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IpxI1fde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CF31F00A3A;
	Wed, 29 Jul 2026 06:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785305926;
	bh=8aYJY9eFGdOEIgL8Dqi8cQU7ifkugqTWviGLduSbw30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IpxI1fdeSQBhQ7ZGkZTOQuEPFZ1TJ0B2VthQ6AR1k2WBwOxcLW6xhTzugez/mIXl+
	 3slTyE1QclugptWka4V4JXZEIYAtgRXs2McJ0TkrqXBa03tzwCZRqBM2RWxMytuoZ3
	 a+vyKk1lYyz7GpETh0gE6dWYdAukTd+DAPurvHH6AKAx6O4QkmkfljI+mmeBhMmYC1
	 c/Jb4yxlVAZnwkikwLRjPPogjtp9qq/YkV7WvCGRb+8D1sLiZPrxFiCbq0fYtGyeEg
	 mjYzeHIBngZ1ARgMlNMrK6xl0Kqn+uqqY+e7yxC7hFkGh2Nb6agsDTpPg5rT4LyiAf
	 lzwZL12gZ/sWg==
Date: Wed, 29 Jul 2026 06:18:44 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 06/13] mm/slab: abstract slabobj_ext.ref access
Message-ID: <ammZpX_77SMsxvPz@dev>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-6-c29ef0f1f257@kernel.org>
 <amivCT7AaPux-GSK@thinkpad>
 <365d8e50-5aeb-45e9-97a3-87d0024cdc5f@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <365d8e50-5aeb-45e9-97a3-87d0024cdc5f@kernel.org>

On Tue, Jul 28, 2026 at 07:41:15PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/28/26 15:41, Harry Yoo wrote:
> > On Mon, Jul 27, 2026 at 02:54:00PM +0200, Vlastimil Babka (SUSE) wrote:
> >> In preparation for changes to the structure, abstract access to the ref
> >> field with a slab_obj_ext_codetag_ref() function. Rename the field to
> >> _ctref to make an unexpected direct access a compile error.
> >> 
> >> No functional change intended.
> >> 
> >> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >> Reviewed-by: Hao Li <hao.li@linux.dev>
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> > 
> > Looks good to me,
> > Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> > 
> > With a suggestion: it would be nice to have debug warnings
> > that trigger when slab_obj_ext_codetag_ref() is compiled but
> > not supposed to be called.
> > 
> > e.g.) for kfence objects, or later in the series when we
> > reduce slabobj_ext memory (!slab_obj_ext_has_codetag()) 
> > 
> > Similarly, it would be nice (later in the series) to have a warning
> > in slab_obj_ext_objcg() when slab_needs_objcg() returns false.
> 
> OK good idea but we can't do it right now as the helpers are introduced
> later.
> 
> So for 9/13 mm/slab: introduce slab_obj_ext_has_codetag():
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 8f352d9f4d91..fbad99da093c 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -726,6 +726,8 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
>  static inline union codetag_ref *
>  slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
>  {
> +       VM_WARN_ON_ONCE(!slab_obj_ext_has_codetag());
> +
>         if (IS_ENABLED(CONFIG_MEMCG))
>                 obj_ext += 1;
>  
> ... and for objcg we would need to start passing slab pointer to
> slab_obj_ext_objcg() and slab_obj_ext_set_objcg(). Hmm...

But slab_obj_ext_codetag_ref() already takes the parameter to
calculate offset. I think it's worth as it'll be optimized away on
non-debug kerenels and there is no way to detect type confusion
due to subtle errors in the objext layout.
