Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A44643AB0;
	Tue,  4 Aug 2026 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836732; cv=none; b=bOtNh8Kwf0WfHo4U5I2TWV1Lvqhzu7bshZSOd1uNq9kl2hVSbt7KbTOW9Z5HzvaEYhmPDwhXt990Dbvt7VSjkF1RhZxJ2Vj1VPFrcjW8pDAlCU0lI0lIyH3o7VjVvqueDYk/D6cGqP58Ldd9JTFiK3fw4W5NJ51a46anTmHkyiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836732; c=relaxed/simple;
	bh=FcoTQdXfsbavXXodwObHqhDRNGCDWJ3gGAI5eY7qSwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mn52leMOYC2dZJtX+IkFY409ycY/DX9QDpH8TbxSkx6cD185quiQGIGAdXlJHAi207dlodZVbKtPkfk3PHiDxVuFvmhLBLO/EFTUFB5D45aY3kq9YpEkK2AW71i285AusxuUNTICvU/Lqh5fV3bG9/RQFVkAlMPlyqTr1LlQA2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iOaeAXgx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iOaeAXgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F8B1F000E9;
	Tue,  4 Aug 2026 09:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785836725;
	bh=fKWR0SwKJT8yHZCF6DXy0CeI9/hC6lA1gVKEHbWgAoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iOaeAXgxp3bP1yTJLE10k//do1NmTbsVlMpkddzS/qi/X1YxwJN8ZXweK6N2l3Fan
	 cR8nFzH3Ig2pWAASS4Xx8CUJg9+Ad6YpbumDNVNCDzE1g9wOXI5Ahs97U8YfTccU+t
	 8/oWc6hLaWJ8Q6q2YBxyHwPAK07CQEf/nuc9eHXoucwAvfcvT39THdsFTOlC2HJVgH
	 tFQqzsJ2/Bp20xeiHO+7OOzEmeNjSPZFBX37vVGtaGC5QE66Tdxa3qw9Yph1UAZB1g
	 yajR0nIJHreVyrZydgX0vCNfE2YFcyGg8NTsox1YZ4gu5k5VYcM+3jy5tkk3cC+pxb
	 ehc3qKNfkzvYw==
Date: Tue, 4 Aug 2026 09:45:23 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 12/13] mm/slab: stop allocating objcg pointers when
 unnecessary
Message-ID: <anGzWSrjIWZ2jZmf@dev>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-12-c29ef0f1f257@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-12-c29ef0f1f257@kernel.org>

On Mon, Jul 27, 2026 at 02:54:06PM +0200, Vlastimil Babka (SUSE) wrote:
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

Perhaps this part is not necessary as slab_obj_ext_set_objcg() now has
a debug warning?

> 
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Otherwise LGTM so please feel free to add:
Reviewed-by: Harry Yoo <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon
