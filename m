Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629F33254B3;
	Sun, 16 Aug 2026 09:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786874380; cv=none; b=i1neCmytmbsPjnhpgZSluHhKSyOQDiRxPkvwX6RzrMPfkTUnxUa9GfLay2XAoJsCZ5jNz52klaTyfUy7oaouJW73oe3efIO84EHLhGCqYvH/CG2rDQT+1BUTLhEC18gHlVfhMI3/vCmZs86TH9WoDniNH9rlz6YD5Ogr7LxMXuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786874380; c=relaxed/simple;
	bh=26ClslWXKX83YtocmQsYJ9Y7m7XsuPbIzraWvkjtjDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUX8/wYVYrFW06/lAbQlcH+Bif2fBLVgQ1O+oM6ZNdwJT6P8zsMTqA8S+tqxtNrBeQ+rx5FgGHHInQeRXx6jMKeeiCGehulBjHe5HvqwMl8OKylPHs9VPmp6Kd7Ci+wy8Mueb2M2o0ZIirZvKXLvP2IiYbdnB3neM3mtzLpot9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1kKAbt4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1kKAbt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF871F000E9;
	Sun, 16 Aug 2026 09:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786874379;
	bh=d7MREgld/BLjhaewklUc18IFPosE8Z7M0EaKNZ/CkJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S1kKAbt43t6hwTScs3DwkHJJCMlc7M7Ahq7fHaDVhxBEhEvHNLosu2UR1yXTrueFL
	 7CYT6F6LwZ4HsykK3FexnQN55RsVnCXzo0j3TTUr35kykQY03pIh4bIclOjim6FmQJ
	 X1qqD3+n2MJuioOA6Hm124D8c8bt8TpNy4BBI2JRwnteGGeH2c0GgNB8DmzJbAFw+V
	 nJNTCzD11VXk+k3chuvzXEhTx8Ztzd8H0BpkohlKoKKugqYXEJU+o9hFAyUPf6sSic
	 56UA8arTMiPOyvCey3yuknsaYM2vajh+PXaCI6L5wMOMcMYwKh+lvtJxSLiXXE6AKo
	 xv7oC/UfH7PKA==
Date: Sun, 16 Aug 2026 10:25:22 +0100
From: Harry Yoo <harry@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: Re: [PATCH] mm: memcg: fix slab over-accounting for in-object objcg
 metadata
Message-ID: <aoF-MIwlfeI78Aox@ubuntu-vm-arm64>
References: <20260812124858.73487-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812124858.73487-1-guopeng.zhang@linux.dev>

On Wed, Aug 12, 2026 at 08:48:58PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> obj_full_size() adds the size of an obj_cgroup pointer to s->size to
> account for slabobj_ext storage, which normally resides outside the
> object.
> 
> Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata in
> unused space within s->size"), slabobj_ext can reside in object padding
> already covered by s->size. The extra charge then accounts for the same
> memory twice.
> 
> The per-slab obj_exts_in_object bit introduced by commit b5bc35ace2c5
> ("mm/slab: replace slab.stride with obj_exts_in_object") identifies this
> layout. Use it to omit the extra charge only for in-object metadata.
> Unlike in-object metadata, slab-leftover and separately allocated metadata
> are not covered by the per-object s->size charge, so retain the existing
> charge for those cases.
> 
> Reported-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Link: https://lore.kernel.org/all/20260310113804.245647-1-ranxiaokai627@163.com/
> Fixes: a77d6d338685 ("mm/slab: place slabobj_ext metadata in unused space within s->size")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>  mm/memcontrol.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d1312441a02b..aef480f46891 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3526,12 +3526,16 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
>  	refill_obj_stock(objcg, size, true);
>  }
>  
> -static inline size_t obj_full_size(struct kmem_cache *s)
> +static inline size_t obj_full_size(struct kmem_cache *s, struct slab *slab)
>  {
>  	/*
>  	 * For each accounted object there is an extra space which is used
> -	 * to store obj_cgroup membership. Charge it too.
> +	 * to store obj_cgroup membership. Charge it too, unless it is stored
> +	 * in object padding already covered by s->size.
>  	 */
> +	if (obj_exts_in_object(slab))
> +		return s->size;
> +
>  	return s->size + sizeof(struct obj_cgroup *);

From correctness terms of view, even this is not 100% correct because
it doesn't account for the metadata for memory allocation profiling.

But as Vlastimil questioned 5 months ago [1]: is it worth the
complexity? Will simply charging s->size always make difference in
practice?

[1] https://lore.kernel.org/linux-mm/e7ccb3b0-791e-4e01-86c3-65b613e3cc5a@kernel.org
