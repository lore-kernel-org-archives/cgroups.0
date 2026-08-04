Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BA0308F32;
	Tue,  4 Aug 2026 08:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785833406; cv=none; b=QvVnjK7trV/hYPiiQ0/Mbbkgb3xgpvrBc1AZ9SswAJkj6WX3u2TLj9cfJNqB73zW1SGAUaopRiDBIr1rXwRSfd0fgVT4YcXpmzR1S7KszfWz2HZnsIpbxLHqY/BF3bMKzhBeJW1TdxWzUI4C0cIGD7ogpT22OKP43m7wK27JY4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785833406; c=relaxed/simple;
	bh=SGtl0qmNBAFBQmFXxepn+3RT/Or69Np0vcXKrgq5Gxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rc+CNKDfZ51N6zYvXU0vhZ15vNYGLNNCfHPwWTJOGbG3WJOdqrw2JP8xuPRJVANpGsaaD5vnjPsL+xy2nroJpoSWKcjR+fm6riHNYFsXGsJnIXRL2FWJsXEwNfUlm74CdurHbFqW1xpTiNrnqu8dGLLjYy8uVwOs1kNffsKi75k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lFLV2/DH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lFLV2/DH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8131F000E9;
	Tue,  4 Aug 2026 08:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785833404;
	bh=+uqTdxpxgj59/pD/eN0s+qcsn/ruSBAWuyoWqrJSjf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lFLV2/DHk7epVoat/MY8IOSiQjL+cnqK6nXn1+0Q8tK/+T154ILDncpp/esKyKCLS
	 gHWHffFrp3RJqD+K0YHixylvpX+HPEgUlkAVxuRxGkCc8GMnAawtzNVeL2Mz4O8Wh8
	 ld4mAmKbW2T9Z2dvKWMr/fUEJsMTujnf0y9YKgHLr91mkvDldWitTHQhhjOEmf3jP8
	 qrJgLjZCi2eWLLYvyLP84Z0TKoTWwz7KdPG7dr8JzScZomY4edv9/aSW+0P/yXvmlk
	 EhCYjyeTD9wdHvEUgkSSfk+eOdGBA95eN8QULwIcd7i0qahp0fJxel5WgM+sc5KDcs
	 u/MI393jjqTfw==
Date: Tue, 4 Aug 2026 08:50:02 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 11/13] mm/slab: add cache_ and slab_needs_objcg()
 helpers
Message-ID: <anGjliizD1zRz60n@dev>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-11-c29ef0f1f257@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-11-c29ef0f1f257@kernel.org>

On Mon, Jul 27, 2026 at 02:54:05PM +0200, Vlastimil Babka (SUSE) wrote:
> Slabs of some caches never need the objcg part of struct slabobj_ext.
> Introduce helpers to query this for a cache or a slab.
> 
> Introduce SLAB_MAY_ACCOUNT flag that is currently only internal and all
> caches have it set except:
> 
> - KMALLOC_NORMAL caches, as long as KMALLOC_RECLAIM caches are separate
> - KMALLOC_NO_OBJ_EXT caches, if they exist
> 
> For named caches we currently can't derive SLAB_MAY_ACCOUNT from
> SLAB_ACCOUNT because some caches might be created without SLAB_ACCOUNT
> and then used both with and without __GFP_ACCOUNT concurrently,
> allocating obj_ext arrays on demand. So just add the SLAB_MAY_ACCOUNT
> to all kmem caches, unless kmem accounting is disabled.
> 
> This can be improved later by finding out all caches used with
> __GFP_ACCOUNT, creating them with the SLAB_MAY_ACCOUNT flag explicitly,
> and then ignoring __GFP_ACCOUNT for all other caches (possibly with a
> warning).
> 
> To make the evaluation of slab_needs_objcg() faster in the allocation
> and free fast paths, add a obj_exts_needs_objcg flag into slab itself.
> This optimization is only available on 64bit architectures where free
> bits are available for the flag.
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon
