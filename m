Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A903DEAC3;
	Tue,  9 Jun 2026 07:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780990544; cv=none; b=t8RK0tA3M7bLqmVRL7VZ8iB99FBB9kytMBtG27LezKFoEzpN+VpNMlC+vlVHNg6IK6EbabN5nbjAkdbOrQ4PiPoych3YV1vtjyxgW2PD+E/Inw6Ro7XIxXYz4rTA9Holb97VnG05M2eOtPJZOLWndysbuocMoRsjy2kK3KY2M4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780990544; c=relaxed/simple;
	bh=KwUNQ9cZs/pIlSeDAu0pgxS8JGTfN/76PWxF0LhR1Jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tHvJxC1NFeXnFABu8w2gYMJOzlfenOJRuxmjXwj9DDhUBZhbJs2+yNZmvdZJdMn6X1bBJSKZkww7ZnvIKHSzRbt0SlI2S1qCpIA1lmQ6061zKQdrAGBJvWTkf/pBEpb9zxU1GZD6Rh19SbKxMMUToY8LcrV9mYQfuH53i3LYY7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QKM7zKoO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QKM7zKoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D521F00893;
	Tue,  9 Jun 2026 07:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780990539;
	bh=y7BX3CVcz1NCkcZ9VRBH6DdOLwzw/KIRmNNQBjRMkfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QKM7zKoOEGCmMOgjqz22FaKfmugoiB47u0nOGoRF+NOmN4l3nOkdpksy+GKxK4DWw
	 4WYMWzVXJI9bMUCaTElKkEpgWpCvycuMhBRMi9/Kyc7WnxI/o0F1HEYfT4OJPt2gwV
	 riQ4+si0ZdaOzfmaT5XiUDCG1nF3cyT2H8LjMY2KxQcEhxAM6gjWI59jaAgMxBsZMd
	 /J7YJBXZnPGAhxBqBCDJXfiw3gGo+Y6FCNaomGkb9Yt1KNyfICXjtq8UOOz61RIsXN
	 SCVTcDdXsg9MUCvSC5qXuq6jKSFtShI3F19CxxVnfKCdj013Dw2LsQ4QuwouEHROp4
	 QJSRvJNsI0rbw==
Date: Tue, 9 Jun 2026 08:35:29 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: hannes@cmpxchg.org, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, david@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	qi.zheng@linux.dev, yosry.ahmed@linux.dev, ziy@nvidia.com, liam@infradead.org, 
	usama.arif@linux.dev, kas@kernel.org, vbabka@kernel.org, ryncsn@gmail.com, 
	zaslonko@linux.ibm.com, gor@linux.ibm.com, baohua@kernel.org, dev.jain@arm.com, 
	npache@redhat.com, ryan.roberts@arm.com, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Message-ID: <aifB-YGdJAGzgprt@lucifer>
References: <ah3MuK3GuimKVORB@cmpxchg.org>
 <20260609032058.23770-1-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609032058.23770-1-lance.yang@linux.dev>

On Tue, Jun 09, 2026 at 11:20:58AM +0800, Lance Yang wrote:
>
> On Mon, Jun 01, 2026 at 02:17:28PM -0400, Johannes Weiner wrote:
> >On Mon, Jun 01, 2026 at 09:21:35PM +0800, Lance Yang wrote:
> >>
> >> On Wed, May 27, 2026 at 04:45:16PM -0400, Johannes Weiner wrote:
> >> [...]
> >> >diff --git a/mm/swap_state.c b/mm/swap_state.c
> >> >index 04f5ce992401..9c3a5cf99778 100644
> >> >--- a/mm/swap_state.c
> >> >+++ b/mm/swap_state.c
> >> >@@ -465,6 +465,16 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
> >> > 		return ERR_PTR(-ENOMEM);
> >> > 	}
> >> >
> >>
> >> Shouldn't this be limited to anon swapin?
> >>
> >> e.g. vmf && vma_is_anonymous(vmf->vma)
> >>
> >> >+	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> >>
> >> __swap_cache_alloc() is also used by shmem direct swapin, so shmem can
> >> get here too when handling a large swap entry:
> >>
> >> shmem_get_folio_gfp()
> >>   shmem_swapin_folio()
> >>     shmem_swap_alloc_folio()
> >>       swapin_sync()
> >>         swap_cache_alloc_folio()
> >>           __swap_cache_alloc()
> >>             folio_memcg_alloc_deferred()
> >
> >Good catch, I think you're right. I shouldn't have dismissed that
> >branch due to "/* Direct swapin skipping swap cache & readahead */"
> >
> >> @Baolin please correct me if I got it wrong :)
> >>
> >> folio_memcg_alloc_deferred() itself doesn't filter shmem out either; it
> >> only allocates the memcg list_lru metadata for deferred_split_lru:
> >>
> >> int folio_memcg_alloc_deferred(struct folio *folio)
> >> {
> >> 	if (mem_cgroup_disabled())
> >> 		return 0;
> >> 	return folio_memcg_list_lru_alloc(folio, &deferred_split_lru, GFP_KERNEL);
> >> }
> >>
> >> Since deferred_split_lru only queues anon large folios, doing this for
> >> shmem swapin doesn't buy us anything :)
> >
> >Yes, agreed. I don't think it's a big deal / show stopper in terms of
> >user-visible effect, but of course still worth fixing.
> >
> >I'll send a follow-up patch.
>
> Thanks.
>
> Looks like this has already landed in mm-stable. If you're okay with it,
> I can send the follow-up.
>
> From: Lance Yang <lance.yang@linux.dev>
> Date: Tue, 9 Jun 2026 10:56:45 +0800
> Subject: [PATCH] mm: prepare deferred split metadata only for anon swapin
>
> __swap_cache_alloc() prepares deferred split metadata for large swapcache
> folios.
>
> That also covers shmem swapin, because shmem_swap_alloc_folio() can call
> swapin_sync() with a large order[1]. But shmem folios are not queued on
> the deferred split queue, so preparing the metadata doesn't buy us
> anything there.
>
> So let's limit it to anon swapin.
>
> [1] https://lore.kernel.org/all/20260601132135.14272-1-lance.yang@linux.dev/
>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/swap_state.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 9c3a5cf99778..7adac957c2b8 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -465,7 +465,8 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
>  		return ERR_PTR(-ENOMEM);
>  	}
>
> -	if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> +	if (order > 1 && vma && vma_is_anonymous(vma) &&

A folio can be anon for a non-shmem file-backed VMA though?
E.g. MAP_PRIVATE-mapped file-backed mappings?

Not sure if that's something that'd be a factor here/meaningful though.

> +	    folio_memcg_alloc_deferred(folio)) {
>  		spin_lock(&ci->lock);
>  		__swap_cache_do_del_folio(ci, folio, entry, shadow);
>  		spin_unlock(&ci->lock);
> --
> 2.39.3 (Apple Git-146)

Cheers, Lorenzo
