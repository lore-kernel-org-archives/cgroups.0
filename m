From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 14/18] mm/memcg: Convert mem_cgroup_move_account() to
 use a folio
Date: Wed, 30 Jun 2021 14:45:33 +0200
Message-ID: <YNxnbTNAeNB9Isie@dhcp22.suse.cz>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-15-willy@infradead.org>
 <YNwrrl6cn48t6w5B@dhcp22.suse.cz>
 <YNxUCLt/scn1d5jQ@casper.infradead.org>
 <YNxhlr4d7Nl0vCz0@dhcp22.suse.cz>
 <YNxkFSGUoaSzZ/36@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625057134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=95yU7azCR9vrMUUQnIiZZ2YMD6UkK2dFrLDtadQtmOU=;
        b=EOoyWKwYBEWeOZVNOd4TZb8SKU8Uz1SwSHS+ebntuPIXR0lqulrlkuIDtG/mscBaLPtlkV
        BFO4i7lcUXk9mkcrkXfKll1Rihe4cfpKKjgNfsFOjG4/Q7xuzJUtcHmS50+7ZNs56hEdJT
        TCzeB5OW/m/JCuLuS7z0Z8jsIxgEmug=
Content-Disposition: inline
In-Reply-To: <YNxkFSGUoaSzZ/36-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 30-06-21 13:31:17, Matthew Wilcox wrote:
> On Wed, Jun 30, 2021 at 02:20:38PM +0200, Michal Hocko wrote:
> > On Wed 30-06-21 12:22:48, Matthew Wilcox wrote:
> > > We need to decide what 'NR_ANON_THPS' means in a folio-based world where
> > > we have folios of all orders.  Does it count only the number of pages
> > > in folios >= HPAGE_PMD_SIZE?  Or does it count the number of pages in
> > > folios > PAGE_SIZE?
> > 
> > At this stage we only have PMD based, right? I believe it would be
> > simpler to stick with that at the moment and change that to a more
> > generic way along with other places which need updating.
> > 
> > Wrt. counters they do count pages so in this case this shouldn't be a
> > problem. But we do have counters for pmd mappings and that might need
> > some care.
> 
> Looking at how these are reported:
> 
>         show_val_kb(m, "AnonHugePages:  ",
>                     global_node_page_state(NR_ANON_THPS));
>         show_val_kb(m, "ShmemHugePages: ",
>                     global_node_page_state(NR_SHMEM_THPS));
>         show_val_kb(m, "ShmemPmdMapped: ",
>                     global_node_page_state(NR_SHMEM_PMDMAPPED));
>         show_val_kb(m, "FileHugePages:  ",
>                     global_node_page_state(NR_FILE_THPS));
>         show_val_kb(m, "FilePmdMapped:  ",
>                     global_node_page_state(NR_FILE_PMDMAPPED));
> 
> it specifically refers to 'HugePages', so I think we need to only
> count folios with order >= PMD_ORDER.

Why? The presented value is in kB. It gives us a cumulative number of
transparent large pages.  Sure breakdown to respective orders would be
impossible in general but the same would be the case if order > PMD_ORDER.

I am not really sure how useful that information is in practice but that
is a different story.

> I'll make that change to
> folio_transhuge() and use folio_transhuge() here.

Thanks!

-- 
Michal Hocko
SUSE Labs
