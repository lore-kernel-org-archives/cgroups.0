Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CC92931E6;
	Tue,  4 Aug 2026 06:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785825278; cv=none; b=i6OkzoSNjVhu5v5nzSoraDDvK67+UhTh7XgS3P1vy7GH+ujl8zLrRDiv+wgjcIcs+fyUckJ/C0Aig89zk1REldqDWNPOu/OifXnAlHtR/mX9dxqqPMuI/SuZOnoEF3Q5QQqzMSzGvjdCUMpVdA0LWOZcSHhK9fAKP70yNRoxXRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785825278; c=relaxed/simple;
	bh=i754xvP+LDFO1GyYMKp//RooW5ggc/DjlDSf0MJhkzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DfqENlPBM8V/f4909/KCQqDiJ3iD53zf8w9RYx3ei8aGjAbjnpZTeU5cmRgsyFR0Ugmwy7mdVq/ohNvT/22m4aOUdhArsLwMsQbFG/GsOFK1H6XesSA70rqSOcqXIFBfVb30B19pAvDbo503zdf5mr5S65y3FqQ3h79PYsvZJ7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oH3l93hB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oH3l93hB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324491F000E9;
	Tue,  4 Aug 2026 06:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785825276;
	bh=54nmXqq3AIRTEXyGpqSuMjddawIFilkZEF3e3YY6aaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oH3l93hBrTwvx1mlrE2uZWVQ+fMqtoKPI4YjLh9U8mJdCT8BCq18UxysIMjMbIV7i
	 2wrgRAMayxk3GnsoTl6hsf9mM0sgB2vVn54P8wAmatIeWv16KO7q0KMOEVAW2ODZm9
	 WgTiTdLrjOBD2VcTb1NgvCo+FlZpCmMST4NL1TXwvnYk7ppWlICozAvED4/qAiKGLW
	 O1Kh1/ZOGvJJDH4rs4YESi9W0wHe0L6580o5i+jmeKvKrr6UgEhqcgcY/f4fJ+KmYp
	 nqLAlMhYd0djXHbqiSQmwixBwmUXKrcGLYCmgvwKMJwNWVbIFz7X+PLlpuwakI1pjt
	 I/VZ1gRmmK7sA==
Date: Tue, 4 Aug 2026 06:34:34 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 10/13] mm/slab: reduce slabobj_ext memory with
 allocation profiling disabled
Message-ID: <anGHvwehVz5H5GO0@dev>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-10-c29ef0f1f257@kernel.org>
 <11f5028a-3fdc-47b4-9712-559c065b87ba@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11f5028a-3fdc-47b4-9712-559c065b87ba@kernel.org>

On Mon, Jul 27, 2026 at 04:07:48PM +0200, Vlastimil Babka (SUSE) wrote:
> Per sashiko [1], a fixed up version below. Couldn't trigger the issue
> although seems to me it's real. Perhaps can happen only with SLUB_TINY
> otherwise the sheaf can't have obj_exts allocated from objcg charge path.
> 
> [1] https://sashiko.dev/#/patchset/20260727-b4-objext_split-v3-0-c29ef0f1f257%40kernel.org?part=10
> 
> ----8<----
> From 905c6500e597a8ecf123ad167698f0a0c1a764bd Mon Sep 17 00:00:00 2001
> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Date: Wed, 8 Jul 2026 17:04:36 +0200
> Subject: [PATCH] mm/slab: reduce slabobj_ext memory with allocation profiling
>  disabled
> 
> When memory allocation profiling is compiled in but permanently disabled
> on boot with (implicit or explicit) "never" parameter, stop allocating
> (thus wasting) memory for the codetag_ref parts of slabobj_ext metadata.
> 
> Do this by using the new slab_obj_ext_has_codetag() helper in
> cache_obj_ext_size().
> 
> Additionally add slab_obj_ext_has_codetag() checks in
> mark_obj_codetag_empty() and handle_failed_objexts_alloc(). The
> functions might get called with memory allocation profiling disabled,
> when the obj_ext array is allocated for objcg pointers only. Setting
> codetag refs as empty is unnecessary in that case, and with them not
> allocated anymore would now result in memory corruption.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon
