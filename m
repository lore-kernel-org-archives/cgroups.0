From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC] memcg: Convert mc_target.page to mc_target.folio
Date: Thu, 17 Mar 2022 12:58:46 +0100
Message-ID: <YjMidqgZbieEyBuF@dhcp22.suse.cz>
References: <YjJJIrENYb1qFHzl@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647518330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wChL9XS63MYTCqGru1PZgU6kXfV3LAvy/qvsXt5I990=;
        b=h3+TM1ZrSfGxCkXKnqPsDUbK+eHEVAXknuif+p/x7hAdQHZFNK1NeAZO4y21h3OblEiA9R
        OqYeRMTMbn+OoLUt2baZDoi4ptha3Yma20C64NsqA0ksLVxffDpaNs1UsQwQNeOMV1jFk+
        q05bG4BaY7leR0xAACBdJcsddQyxbMk=
Content-Disposition: inline
In-Reply-To: <YjJJIrENYb1qFHzl-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 16-03-22 20:31:30, Matthew Wilcox wrote:
> This is a fairly mechanical change to convert mc_target.page to
> mc_target.folio.  This is a prerequisite for converting
> find_get_incore_page() to find_get_incore_folio().  But I'm not
> convinced it's right, and I'm not convinced the existing code is
> quite right either.
> 
> In particular, the code in hunk @@ -6036,28 +6041,26 @@ needs
> careful review.  There are also assumptions in here that a memory
> allocation is never larger than a PMD, which is true today, but I've
> been asked about larger allocations.

Could you be more specific about those usecases? Are they really
interested in supporting larger pages for the memcg migration which is
v1 only feature? Or you are interested merely to have the code more
generic?

[...]
> @@ -6036,28 +6041,26 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
>  		case MC_TARGET_DEVICE:
>  			device = true;
>  			fallthrough;
> -		case MC_TARGET_PAGE:
> -			page = target.page;
> +		case MC_TARGET_FOLIO:
> +			folio = target.folio;
>  			/*
> -			 * We can have a part of the split pmd here. Moving it
> -			 * can be done but it would be too convoluted so simply
> -			 * ignore such a partial THP and keep it in original
> -			 * memcg. There should be somebody mapping the head.
> +			 * Is bailing out here with a large folio still the
> +			 * right thing to do?  Unclear.
>  			 */
> -			if (PageTransCompound(page))
> +			if (folio_test_large(folio))
>  				goto put;
> -			if (!device && isolate_lru_page(page))
> +			if (!device && folio_isolate_lru(folio))
>  				goto put;
> -			if (!mem_cgroup_move_account(page, false,
> +			if (!mem_cgroup_move_account(folio, false,
>  						mc.from, mc.to)) {
>  				mc.precharge--;
>  				/* we uncharge from mc.from later. */
>  				mc.moved_charge++;
>  			}
>  			if (!device)
> -				putback_lru_page(page);
> -put:			/* get_mctgt_type() gets the page */
> -			put_page(page);
> +				folio_putback_lru(folio);
> +put:			/* get_mctgt_type() gets the folio */
> +			folio_put(folio);
>  			break;
>  		case MC_TARGET_SWAP:
>  			ent = target.ent;

It's been some time since I've looked at this particular code but my
recollection and current understanding is that we are skipping over pte
mapped huge pages for simplicity so that we do not have to recharge
all other ptes from the same huge page. What kind of concern do you see
there?

-- 
Michal Hocko
SUSE Labs
