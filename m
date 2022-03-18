From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] memcg: Convert mc_target.page to mc_target.folio
Date: Fri, 18 Mar 2022 03:49:27 +0000
Message-ID: <YjQBRx1+Rq7CYC4M@casper.infradead.org>
References: <YjJJIrENYb1qFHzl@casper.infradead.org>
 <YjMidqgZbieEyBuF@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=P+lmjWlX8RjtV4mSys5aX5+QRT1CeRIMXrpuZ7wboyQ=; b=jDNKNbq2aqbauFSSIrR/iLvQkl
        vrOkqrmhcjWFh9YriZGIq1lRPIe0eMDRRbbDlJR8eD+nq/l6SUNwOvk7hK6SVYZApWVJdzgRh+Aui
        cHEGJJCs/zcTRHBC/6CWE9lcreR4hvpqoWFEM9TtaBeAKeq9wwmt07ZmeHopDAfYFORwgYFvSoVAt
        ckr3uLD3/KKM+XL1JwMSTb7URzAMRyW70QzpxD451khxD3pU7qNqwx9IqJcJlPjTVZhlLczjZhQUn
        duJmerinql6KSGBddJIM1OpulEXPRNtnoFTHZ4fhmLaOpYc3jVJMVuakCmHKHsepUjl3aaHA+ReXV
        KjQDzDOA==;
Content-Disposition: inline
In-Reply-To: <YjMidqgZbieEyBuF-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Mar 17, 2022 at 12:58:46PM +0100, Michal Hocko wrote:
> On Wed 16-03-22 20:31:30, Matthew Wilcox wrote:
> > This is a fairly mechanical change to convert mc_target.page to
> > mc_target.folio.  This is a prerequisite for converting
> > find_get_incore_page() to find_get_incore_folio().  But I'm not
> > convinced it's right, and I'm not convinced the existing code is
> > quite right either.
> > 
> > In particular, the code in hunk @@ -6036,28 +6041,26 @@ needs
> > careful review.  There are also assumptions in here that a memory
> > allocation is never larger than a PMD, which is true today, but I've
> > been asked about larger allocations.
> 
> Could you be more specific about those usecases? Are they really
> interested in supporting larger pages for the memcg migration which is
> v1 only feature? Or you are interested merely to have the code more
> generic?

Ah!  I didn't realise memcg migration was a v1-only feature.  I think
that makes all of the questions much less interesting.  I've done some
more reading, and it seems like all of this is "best effort", so it
doesn't really matter if some folios get skipped.

I'm not entirely sure what the usecases are for >PMD sized folios.
I think the people who are asking for them probably overestimate how
useful / practical they'll turn out to be.  I sense it's a case of "our
hardware supports a range of sizes, and we'd like to be able to support
them all", rather than any sensible evaluation of the pros and cons.

> [...]
> > @@ -6036,28 +6041,26 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
> >  		case MC_TARGET_DEVICE:
> >  			device = true;
> >  			fallthrough;
> > -		case MC_TARGET_PAGE:
> > -			page = target.page;
> > +		case MC_TARGET_FOLIO:
> > +			folio = target.folio;
> >  			/*
> > -			 * We can have a part of the split pmd here. Moving it
> > -			 * can be done but it would be too convoluted so simply
> > -			 * ignore such a partial THP and keep it in original
> > -			 * memcg. There should be somebody mapping the head.
> > +			 * Is bailing out here with a large folio still the
> > +			 * right thing to do?  Unclear.
> >  			 */
> > -			if (PageTransCompound(page))
> > +			if (folio_test_large(folio))
> >  				goto put;
> > -			if (!device && isolate_lru_page(page))
> > +			if (!device && folio_isolate_lru(folio))
> >  				goto put;
> > -			if (!mem_cgroup_move_account(page, false,
> > +			if (!mem_cgroup_move_account(folio, false,
> >  						mc.from, mc.to)) {
> >  				mc.precharge--;
> >  				/* we uncharge from mc.from later. */
> >  				mc.moved_charge++;
> >  			}
> >  			if (!device)
> > -				putback_lru_page(page);
> > -put:			/* get_mctgt_type() gets the page */
> > -			put_page(page);
> > +				folio_putback_lru(folio);
> > +put:			/* get_mctgt_type() gets the folio */
> > +			folio_put(folio);
> >  			break;
> >  		case MC_TARGET_SWAP:
> >  			ent = target.ent;
> 
> It's been some time since I've looked at this particular code but my
> recollection and current understanding is that we are skipping over pte
> mapped huge pages for simplicity so that we do not have to recharge
> all other ptes from the same huge page. What kind of concern do you see
> there?

That makes sense.  I think the case that's currently mishandled is a
THP in tmpfs which is misaligned when mapped to userspace.  It's
skipped, even if the entire THP is mapped.  But maybe that simply
doesn't matter.

I suppose the question is: Do we care if mappings of files are not
migrated to the new memcg?  I'm getting a sense that the answer is "no",
and if we actually ended up skipping all file mappings, it wouldn't
matter.

Thanks for taking a look!
