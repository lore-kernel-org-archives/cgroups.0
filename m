From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 14/18] mm/memcg: Convert mem_cgroup_move_account() to
 use a folio
Date: Wed, 30 Jun 2021 14:20:38 +0200
Message-ID: <YNxhlr4d7Nl0vCz0@dhcp22.suse.cz>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-15-willy@infradead.org>
 <YNwrrl6cn48t6w5B@dhcp22.suse.cz>
 <YNxUCLt/scn1d5jQ@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625055639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VG8ysdAphzMD48NnpUNPVRaMSFDL1AK2ELMF+Jd0hNo=;
        b=efHkcfYh+ONyJoNiNOFNljrUsYc9B8aEysxqJ9DXNNtZYSbh8HQNg7cD9QWYvD2wJZFHYt
        wUUryX8nTGzw0pKFiKWYkE3pV4rlbIAB69hi/SS+hoXvATtk79G+wOYX7XJABLR7GsMILT
        jxvj4zw+RTyOBCZtDZ7YmMeR1u+VxeE=
Content-Disposition: inline
In-Reply-To: <YNxUCLt/scn1d5jQ-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 30-06-21 12:22:48, Matthew Wilcox wrote:
> On Wed, Jun 30, 2021 at 10:30:38AM +0200, Michal Hocko wrote:
> > > -	if (PageAnon(page)) {
> > > -		if (page_mapped(page)) {
> > > +	if (folio_anon(folio)) {
> > > +		if (folio_mapped(folio)) {
> > >  			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
> > >  			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
> > > -			if (PageTransHuge(page)) {
> > > +			if (folio_multi(folio)) {
> > 
> > Shouldn't be folio_transhuge? The resulting code is the same but
> > folio_transhuge is more explicit and matches the THP aspect.
> 
> I genuinely don't know.  For the benefit of those reading along, the
> important part of the context is:
> 
>                 if (folio_mapped(folio)) {
>                         __mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
>                         __mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
>                         if (folio_multi(folio)) {
>                                 __mod_lruvec_state(from_vec, NR_ANON_THPS,
>                                                    -nr_pages);
>                                 __mod_lruvec_state(to_vec, NR_ANON_THPS,
>                                                    nr_pages);
>                         }
>                 }
> 
> We need to decide what 'NR_ANON_THPS' means in a folio-based world where
> we have folios of all orders.  Does it count only the number of pages
> in folios >= HPAGE_PMD_SIZE?  Or does it count the number of pages in
> folios > PAGE_SIZE?

At this stage we only have PMD based, right? I believe it would be
simpler to stick with that at the moment and change that to a more
generic way along with other places which need updating.

Wrt. counters they do count pages so in this case this shouldn't be a
problem. But we do have counters for pmd mappings and that might need
some care.
-- 
Michal Hocko
SUSE Labs
