Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4D549B21F;
	Mon, 28 Sep 2026 23:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790638206; cv=none; b=J+TTrBcOz621Qg5AJOKWa2tkx3ke+St5rUa074Id3k86tbi2b5Fv4ZUHPI14VuJGWGWEY4b9/yk5Y9/JmNViWMK1jK3pfZtDfDugpKlvu7t85Q8QkdQsGXDIVwjMAxIP9thTam883S+7u3CqJDCVHzT2HELyFwZj4SAsOFUBJ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790638206; c=relaxed/simple;
	bh=MUUL9U8QzlTw5KJtMkh/O68n6/WEB7aiRo1fJw3OISU=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iHb9jYjeA5WUU2N/ixPwPduWvZxgsc8LJcuIV7gOW1fs3j90IO5DDpxui1hehtj8+9u9Ut8LbE0Yo2US+Rtshs+GC0U1WgRjWrUtHHYdxbpJd5Ud/ElxJQB+/WsfUuf6OFqht+CysJJcLEFkS0u5nXmJmaclHiQUZvYOk0hkGa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mp2k2TBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mp2k2TBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C308E1F000FF;
	Mon, 28 Sep 2026 23:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790638205;
	bh=H0XE7IoMyItwyaCzzcE2PkwcpGvCdLwnkryM7cP8W2E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mp2k2TBPVaaa0oxas9pidANxg0LgDSy5BpcWNRKUDZ2xfRnQMMIHH1Qe8npsm2EwZ
	 JQvL7o+ufYOIqkwRDBmD2qLfMkSW0hBKvMr28f3rNeL3uSw/vNuK9gPPyMXPS75ITO
	 dwgzwWjZY7IfJp1M4npH9DnI3l+UKPmhlO1KI+8FASh/ZgwvfeKPI0DYvfXtqQ0GLf
	 uS4VM5KEsvr1YvvJ4k+4lYQ3eRehbzxv/1jz1tCe/IVj/FmY+H7Le3yVGYVorc5yE8
	 ypt8nmUXeDxZYuzrfESvJ8/kDeRIh+ZBI8yo2vIfJByvMHdHRNCS4IggAjf/zsEGpv
	 8Q1ZH0jViPjeg==
Date: Mon, 28 Sep 2026 13:30:04 -1000
Message-ID: <6d0542fc07639c8df7672b12f4ecd906@kernel.org>
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
Subject: Re: [PATCH v2] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io>
References: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello, Liz.

On Mon, Sep 28, 2026 at 10:12:59PM +0000, Liz Fong-Jones wrote:
> +	/* a newer wb may have taken the slot, see cgwb_create() */
> +	spin_lock_irq(&cgwb_lock);
> +	radix_tree_delete_item(&bdi->cgwb_tree, wb->memcg_css->id, wb);
> +	spin_unlock_irq(&cgwb_lock);

Maybe use scoped_guard() here and move list_del(&wb->offline_node) from
further down into the same block?

> +static bool cgwb_dying(struct bdi_writeback *wb)
> +{
> +	lockdep_assert_held(&cgwb_lock);
> +
> +	return percpu_ref_is_dying(&wb->refcnt);
> +}

Can you drop this and use wb_dying() instead? Requiring lockdep for testing
an atomic state is a bit odd.

> +/*
> + * A killed wb stays in bdi->cgwb_tree until it is released, so that foreign
> + * flushes can still find it through wb_get_lookup().  Inodes attached to it

"until it is released or replaced in cgwb_create()"?

>  	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
> -	if (wb && wb->blkcg_css != blkcg_css) {
> +	if (wb && !cgwb_dying(wb) && wb->blkcg_css != blkcg_css)
>  		cgwb_kill(wb);
> +	if (wb && cgwb_dying(wb))
>  		wb = NULL;
> -	}

Maybe filter out dying wbs right after the lookup and leave the mismatch
block as-is?

	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
	if (wb && wb_dying(wb))
		wb = NULL;
	if (wb && wb->blkcg_css != blkcg_css) {
		cgwb_kill(wb);
		wb = NULL;
	}

> +		} else if (cgwb_dying(radix_tree_deref_slot_protected(slot,
> +								      &cgwb_lock))) {
> +			radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
> +			ret = 0;

After the takeover, the old wb is out of foreign flushes' reach while its
inodes may still be dirty. Kicking writeback on it would move them over to
the new wb as they get written back. Can you add that as a separate patch
when posting the next version?

>  	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
> -		cgwb_kill(*slot);
> +		if (!cgwb_dying(*slot))
> +			cgwb_kill(*slot);

Can you add {} around the loop body?

Thanks.

-- 
tejun
