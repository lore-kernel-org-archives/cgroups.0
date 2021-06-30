From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 14/18] mm/memcg: Convert mem_cgroup_move_account() to
 use a folio
Date: Wed, 30 Jun 2021 12:22:48 +0100
Message-ID: <YNxUCLt/scn1d5jQ@casper.infradead.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-15-willy@infradead.org>
 <YNwrrl6cn48t6w5B@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Qrj5IivtqnPita8/luPfOpstNFxH4Y1PmGJb28I+4HM=; b=KHSWYVNSEXqE+hAvHoVc7fT9bk
        hEybG4f2y4gDErI3lZGWGyRNBBc53Ku52AfOJoulx9w4gTCsMkQ+3bGHXBE2JOEatBYRHS3IJr9JL
        6+rTND0YLsSmh03mf3yZ0oQ+jh82oH2VQHuleOnYsautd7SvnBZwI2bP6mH9y6MuVXC4FQiktIiuu
        XyD1Y1MBxT47ouppzTDbwLRgwl+l9R/q/R5oPklGzbUk/i0pR76NXykDMtOLW+uZhVwAMrPCqt/+4
        OdfWsZURDjCZb5RqwPjqVb6kyHbKAcDsZw4XTXxktL+cvrOJslMxGkz0ofUkqerejMB25uOv+Gcw6
        OEq9VJTg==;
Content-Disposition: inline
In-Reply-To: <YNwrrl6cn48t6w5B-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 30, 2021 at 10:30:38AM +0200, Michal Hocko wrote:
> > -	if (PageAnon(page)) {
> > -		if (page_mapped(page)) {
> > +	if (folio_anon(folio)) {
> > +		if (folio_mapped(folio)) {
> >  			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
> >  			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
> > -			if (PageTransHuge(page)) {
> > +			if (folio_multi(folio)) {
> 
> Shouldn't be folio_transhuge? The resulting code is the same but
> folio_transhuge is more explicit and matches the THP aspect.

I genuinely don't know.  For the benefit of those reading along, the
important part of the context is:

                if (folio_mapped(folio)) {
                        __mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
                        __mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
                        if (folio_multi(folio)) {
                                __mod_lruvec_state(from_vec, NR_ANON_THPS,
                                                   -nr_pages);
                                __mod_lruvec_state(to_vec, NR_ANON_THPS,
                                                   nr_pages);
                        }
                }

We need to decide what 'NR_ANON_THPS' means in a folio-based world where
we have folios of all orders.  Does it count only the number of pages
in folios >= HPAGE_PMD_SIZE?  Or does it count the number of pages in
folios > PAGE_SIZE?

Similar question (and I suspect the same answer) for NR_SHMEM_THPS and
NR_FILE_THPS.  Right now, I've been accounting any multi-page folio as
a THP, but I don't have a good sense of what the answer should be.
