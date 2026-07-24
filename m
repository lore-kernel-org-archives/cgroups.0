Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A46378813
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 09:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784887062; cv=none; b=U0lr25gTW6K9AHzQXp4L37PbxDjGcx0kzNBsZ+C28rBo/mfX55OfkSMUmv/pFg77vdW9Zsa05x/0EdKhQVmL6mLNS7inTxBJzdplYrBOyE+Dkmw95fuGTfx7Sf167qeagdnCL0yEeKfB2zFMyBR6F/m++yHHyBvnJ7M97KhloGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784887062; c=relaxed/simple;
	bh=InTNhT79oMdWXK6U8e+Z+Kxfc/R0U5F36Sd80JvQvzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1PAuGJn6ubZSPMwBda/N2A0GTyp/YnlpNN+jT/NyxzwHNwSTIuFHTk9AGAsdO2P9He+lJk92lCcg9xYkTy4GSZNXcnLYD0/LRJFN3NLtoFu/Gp95O1LVhB8v3k2sv7GpYGvV23iVKLQYXFebbCe7wM/0L7gXHyeDqofKthT/KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LxqBLyNF; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LxqBLyNF"
Date: Fri, 24 Jul 2026 17:57:15 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784887056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gtzI0WrHpPQ8NxhzSfdbFVkPslhXcvXb+1WfK67Ct6A=;
	b=LxqBLyNFCuRzvSTEZvQ+k7G4esSrSkIg3NL0E6nP9CWPApkKEhtzDaDQM/QTeJLcnFBqVl
	oHxoQs49THjbvWSHHm3yBfJq52vZKB1Sr2HHwBpnppRGMGUcmb7Xm6Swk5s6TktpmIskll
	agvkNhLDpxuI1IL7m2PtL80iYRQxKYM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 13/13] mm/slab: stop allocating objcg pointers when
 unnecessary
Message-ID: <amM2ybmTYfjlvDV7@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-13-2fa7c6f60dbe@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-13-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 20, 2026 at 04:16:27PM +0200, Vlastimil Babka (SUSE) wrote:
> Start using the slab_needs_objcg() helper to calculate slabobj_ext size.
> Caches that we know to never need objcg pointers (currently
> KMALLOC_NORMAL caches) will thus stop wasting memory on them when memory
> allocation profiling is enabled.
> 
> For things to work properly, we need to also add slab_needs_objcg()
> checks to mem_cgroup_from_obj_slab() and memcg_slab_free_hook(), because
> when obj_exts array exists for a slab only due to mem_alloc profiling,
> we would otherwise attempt to access a non-existing objcg pointer in
> that slab.
> 
> The function __memcg_slab_post_alloc_hook() should not be possible to
> call for a slab where slab_needs_objcg() is false, but add a DEBUG_VM
> check there to prevent breaking this assumption accidentally.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
