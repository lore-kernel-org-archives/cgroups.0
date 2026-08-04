Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40793603C2;
	Tue,  4 Aug 2026 06:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785824328; cv=none; b=OujQ/J2ABW3WFQTVYd7pYz1il1dDHHkvPebp/CNBqJd2lfXvDdXjOcgBxl9pco3NejDmTaAMzt0vKKEbTKCsAutDefmqb4JMiCpk1OE/jdv976R2SSRNynzvN5XRwLKC55MBpTPumNCmg/r0UiD5fEE1nG1eQkYOVC6xGWMq+yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785824328; c=relaxed/simple;
	bh=jEF1yDyayFF2FeEfHOrpLnQicMIfy9p+vJvknkBAtJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTD+Ap19WLordsQFcl6xHcABA0ifsyxMq7Q7IJTZ/Xcjk0C+6tkjrJCD3decjXTpwXWCXSVoMMPTf29e/tIA88pjWIwmVy9ei0E3DrJXeilfEPUVvgvoqSZeMoA6KxmZ+tTnpq8ABKLm1Eu8vJFzHSNUluiKounh0vMeABGr90A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CqNJu8E1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CqNJu8E1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57C31F000E9;
	Tue,  4 Aug 2026 06:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785824327;
	bh=n7dtQCREeKicw/uo0vrti8DvbE0GI4CDzkory5DnZAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CqNJu8E1M059ow3uLrsPvsetL/UITExaBEmfeHx6bfTqQSEH57l5B1b6sLDn9G3P+
	 x8hHbM71E69sHJJgV/7GsphSuaqvqqeUePWUSHyAVuW30aFwQjSnBx17yFdflYY2Fm
	 GlR/j4O7++O1NQZT+1pl6euihLxnoqCtnm5DWBldOnJoH6NwgIF59QNfcglKH8YYRT
	 LQ0GQJfjGY/eLH9CqkKqEbtXDj0/dB51yaOeagJGjGCILhwQTyL+qHIcijPiK+BzAA
	 cePgPMqYfvPOcwwGDPfqsx9UHePLYZZCjQqtnnDfa/NQH5dSPGqg2KYKqAEX10/KlA
	 IpMpo/8pQRd0A==
Date: Tue, 4 Aug 2026 06:18:44 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 09/13] mm/slab: introduce slab_obj_ext_has_codetag()
Message-ID: <anGDu9pzT3Forx7_@dev>
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
> ---

Reviewed-by: Harry Yoo <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon
