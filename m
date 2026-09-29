Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0763154B1D3;
	Tue, 29 Sep 2026 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790704739; cv=none; b=dygbaWe9dVMpdVZGCiCTQ6+QEy5/lVxNrWL3/U8C2WcUjgHr5yrbLucIIWtaQWWUVb/oLohjQlxBB7lAbaj6lq3dwxYArU1xlCtef15lZDBE+CPX1OFH0AscjFAKv5orIiUDoqvGaV/CsajiLp01nEH4tC2A1Z8uaGLGGORMsuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790704739; c=relaxed/simple;
	bh=XyboGnsSgHeCD39ehSzEBEC7YjYR3gOQlEKhHnzGYhU=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rthYwtlZj1BhW2aR8h3oavsxNqQI3E52VOL8wlGmOW4HWgJLahcM7t0I5ov57U97Mun2mesy5E6IBjkVrZmyV5Lwf3LCIbczx4nKZn+VFcaR5ptnE2/auFeQV5a7Qam1TW/6ch1Dd5jnxLcXED4enYP5G7T/8U4R1QV9soPkXwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWIEExcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWIEExcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E7B1F000FF;
	Tue, 29 Sep 2026 17:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790704737;
	bh=D8IsblU8nmE28Btv5b/ZkJyD4K5wSxbscAgK5JZqxKw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UWIEExcfN6jUovdJmatCAMu5OMD6YHLVKZLm4cwex0sANOgJ6vPEjlkalfQRzeyk1
	 HIAuV12wZ9IO9kr8cpQEcoScoW432HEkDlXR4y5ZpNlxQaXm/jw05ouD1qd1CsVN9m
	 3Gt001PNnIvK6A0HEBpRnJ5EDl9PT4w/lSUe+3be5PkkjdYNbwA4nUkHZ3J7G6mZls
	 CUuSPXxVNpzgnTJkJyx6pcWtIwMHe0a7gvAeVwu2ddCGSxiFyMqDXJvS8qYjYDgJt9
	 1HW3sDhHDfkJPJqJ4beFmeBW+7KVeMURYf+f7sveglgtD2EZmYctQc2ubNmGnhu3D2
	 TGhaDjjZy1qTw==
Date: Tue, 29 Sep 2026 07:58:56 -1000
Message-ID: <d594ecb783f0f6838a52099fdba3de8e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Xin Yin <yinxin.x@bytedance.com>,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 ian@honeycomb.io
Subject: Re: [PATCH v3 1/2] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20260928-wb-dying-cgwb-flush-v3-1-e35374884667@honeycomb.io>
References: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
 <20260928-wb-dying-cgwb-flush-v3-1-e35374884667@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello, Liz.

On Tue, Sep 29, 2026 at 01:40:49AM +0000, Liz Fong-Jones wrote:
>  	if (test_bit(WB_registered, &bdi->wb.state) &&
>  	    blkcg_cgwb_list->next && memcg_cgwb_list->next) {
> -		/* we might have raced another instance of this function */
> -		ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
> +		/*
> +		 * We might have raced another instance of this function.  A
> +		 * dying wb keeps its slot until released; take it over.
> +		 */
> +		slot = radix_tree_lookup_slot(&bdi->cgwb_tree, memcg_css->id);
> +		if (!slot) {
> +			ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
> +		} else {
> +			old_wb = radix_tree_deref_slot_protected(slot, &cgwb_lock);
> +			if (wb_dying(old_wb)) {
> +				radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);

This can also replace the wb of a removed memcg:

1. A cgroup with io enabled is removed. Killing its io css makes
   cgroup_get_e_css() return the parent's right away, but
   memcg_cgwb_list->next stays set until wb_memcg_offline().

2. In between, wb_get_create() for the memcg, e.g. from
   __inode_attach_wb() or inode_switch_wbs(), kills the dirty wb on
   blkcg mismatch and a new wb takes over its slot.

3. wb_memcg_offline() kills the new wb. Foreign flushes for the memcg
   now find the new wb while the dirty inodes stay on the old one, as
   css_is_dying() keeps wbc_attach_and_unlock_inode() from switching
   them, so the stall comes back.

Can you also fail the link when the memcg is dying?

	if (test_bit(WB_registered, &bdi->wb.state) &&
	    blkcg_cgwb_list->next && memcg_cgwb_list->next &&
	    !css_is_dying(memcg_css)) {

CSS_DYING is set before the io css is killed. Testing it here, after
the blkcg lookup and under cgwb_lock, catches every removal that could
have made the old wb replaceable.

Thanks.

--
tejun
