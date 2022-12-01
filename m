From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Thu, 1 Dec 2022 10:52:31 -0500
Message-ID: <Y4jNvzpX4g42afvP@cmpxchg.org>
References: <20221123181838.1373440-1-hannes@cmpxchg.org>
 <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com>
 <Y4TpCJ+5uCvWE6co@cmpxchg.org>
 <Y4ZYsrXLBFDIxuoO@cmpxchg.org>
 <3659bbe0-ccf2-7feb-5465-b287593aa421@google.com>
 <CALvZod7_FjO-CjzHUpQTsCTm4-68a1eKi_qY=4XdF+g7yMLd4Q@mail.gmail.com>
 <e0918c92-90cd-e3ed-f4e6-92d02062c252@google.com>
 <Y4fZbFNVckh1g4WO@cmpxchg.org>
 <33f2f836-98a0-b593-1d43-b289d645db5@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QZICexc8xsGDU62se8MLzCQs14y/akiq818luXMxAoY=;
        b=nLdF3MgZ41GcFh+AMHGP6e37c5gGALVjl1T7QxmWOXvPoDybB4EyOcncA+v8e1aQ3y
         kF43faFVT5i2ogbHi8Xh9fRkjxddevBI+Xa801fZJ6sogb5BSFkZJynRCMCnm5Hcln+z
         h6ULkbiQ8wFSdz2qqMnvaApw9XIUQJO5Lce4eaS39G3bbtx350i2m055PGe4Y/Q8k7Xk
         UGBqPrjAwCr73TCtjw2ewuQuCFGRRNKnBzkRxQrFdjLXxArH9Scphip7TWKAeFVRTA7S
         NukPVM39vrjE/Z0SjdhAePvS10HX5K8//ggATbKtCj25ubtQYITvpperZj74K9mcTju9
         lu+Q==
Content-Disposition: inline
In-Reply-To: <33f2f836-98a0-b593-1d43-b289d645db5-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 30, 2022 at 04:13:23PM -0800, Hugh Dickins wrote:
> On Wed, 30 Nov 2022, Johannes Weiner wrote:
> > 
> > Hm, I think the below should work for swap pages. Do you see anything
> > obviously wrong with it, or scenarios I haven't considered?
> > 
> 
> I think you're overcomplicating it, with the __swap_count(ent) business,
> and consequent unnecessarily detailed comments on the serialization.
> 
> Page/folio lock prevents a !page_mapped(page) becoming a page_mapped(page),
> whether it's in swap cache or in file cache; it does not stop the sharing
> count going further up, or down even to 0, but we just don't need to worry
> about that sharing count - the MC_TARGET_PAGE case does not reject pages
> with mapcount > 1, so why complicate the swap or file case in that way?
> 
> (Yes, it can be argued that all such sharing should be rejected; but we
> didn't come here to argue improvements to memcg charge moving semantics:
> just to minimize its effect on rmap, before it is fully deprecated.)
> 
> Or am I missing the point of why you add that complication?

No, it just seemed odd to move shared swap *unless* it's partially
faulted. But you're right, it's probably not worth the hassle. I'll
cut this down to the page_mapped() check.

The struggle of writing code for Schroedinger's User...

> > @@ -5637,6 +5645,46 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
> 
> Don't forget to trylock the page in the device_private case before this.

Yep, thanks!

> >          * we call find_get_page() with swapper_space directly.
> >          */
> >         page = find_get_page(swap_address_space(ent), swp_offset(ent));
> > +
> > +       /*
> > +        * Don't move shared charges. This isn't just for saner move
> > +        * semantics, it also ensures that page_mapped() is stable for
> > +        * the accounting in mem_cgroup_mapcount().
> 
> mem_cgroup_mapcount()??

mem_cgroup_move_account() of course! Will fix.

> > +        * We have to serialize against the following paths: fork
> > +        * (which may copy a page map or a swap pte), fault (which may
> > +        * change a swap pte into a page map), unmap (which may cause
> > +        * a page map or a swap pte to disappear), and reclaim (which
> > +        * may change a page map into a swap pte).
> > +        *
> > +        * - Without swapcache, we only want to move the charge if
> > +        *   there are no other swap ptes. With the pte lock, the
> > +        *   swapcount is stable against all of the above scenarios
> > +        *   when it's 1 (our pte), which is the case we care about.
> > +        *
> > +        * - When there is a page in swapcache, we only want to move
> > +        *   charges when neither the page nor the swap entry are
> > +        *   mapped elsewhere. The pte lock prevents our pte from
> > +        *   being forked or unmapped. The page lock will stop faults
> > +        *   against, and reclaim of, the swapcache page. So if the
> > +        *   page isn't mapped, and the swap count is 1 (our pte), the
> > +        *   test results are stable and the charge is exclusive.

... and edit this down accordingly.

> > +        */
> > +       if (!page && __swap_count(ent) != 1)
> > +               return NULL;
> > +
> > +       if (page) {
> > +               if (!trylock_page(page)) {
> > +                       put_page(page);
> > +                       return NULL;
> > +               }
> > +               if (page_mapped(page) || __swap_count(ent) != 1) {
> > +                       unlock_page(page);
> > +                       put_page(page);
> > +                       return NULL;
> > +               }
> > +       }
> > +
> >         entry->val = ent.val;
> >  
> >         return page;
> 
> Looks right, without the __swap_count() additions and swap count comments.
> 
> And similar code in mc_handle_file_pte() - or are you saying that only
> swap should be handled this way?  I would disagree.

Right, same rules apply there. I only pasted the swap one to make sure
we get aligned on the basic strategy.

> And matching trylock in mc_handle_present_pte() (and get_mctgt_type_thp()),
> instead of in mem_cgroup_move_account().

Yes.

> I haven't checked to see where the page then needs to be unlocked,
> probably some new places.

Yes, the callers of get_mctgt_type*() need to unlock (if target is
passed and the page is returned). It looks straight-forward, they
already have to do put_page().

> And I don't know what will be best for the preliminary precharge pass:
> doesn't really want the page lock at all, but it may be unnecessary
> complication to avoid taking it then unlocking it in that pass.

We could make it conditional on target, which precharge doesn't pass,
but I agree it's likely not worth optimizing that code at this point.

Thanks for taking a look, Hugh, that's excellent input.

I'll finish this patch, rebase the rmap patch on it, and add a new one
to issue a deprecation warning in mem_cgroup_move_charge_write().

Johannes
