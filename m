From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Wed, 30 Nov 2022 08:42:24 -0800
Message-ID: <CALvZod7_FjO-CjzHUpQTsCTm4-68a1eKi_qY=4XdF+g7yMLd4Q@mail.gmail.com>
References: <20221123181838.1373440-1-hannes@cmpxchg.org> <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com>
 <Y4TpCJ+5uCvWE6co@cmpxchg.org> <Y4ZYsrXLBFDIxuoO@cmpxchg.org> <3659bbe0-ccf2-7feb-5465-b287593aa421@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pjDPR5yR6DIywWszOgQ0UDhPZ4vEbh5Pko8PrUKf3pI=;
        b=K86j6VMRXYIQSYFV+KA78qEDNE9v5WU4bWnu4FRw2pC332BzaqIyvlaShvQZTviLZD
         COiqs6oMwW2dklkvQs/yh280WV+N5Q24S0VgBHZCrlfJLl/ncK8ChCEoWqv/eJYepItk
         w3TFu1AzI/YXHE0e0rGAG38/r1K85Vt9QOPLE9sGdYGtas73TUgIfS1+ZrPxAmTPeBDV
         avwm8hAtetBSQ0iCfIXlWtRuBAPQGxskP22jpMWnlLE6CT/Oc8cXnN+ArYwiZhRjHECL
         lvTKpFg9DZpUKswVxXm+tma4r66CsXSqKTzYnah7h3nBdLDzGmYTnDQ1ARpHDJe6op4r
         O+Iw==
In-Reply-To: <3659bbe0-ccf2-7feb-5465-b287593aa421-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 29, 2022 at 11:33 PM Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Tue, 29 Nov 2022, Johannes Weiner wrote:
> > On Mon, Nov 28, 2022 at 11:59:53AM -0500, Johannes Weiner wrote:
> > > On Wed, Nov 23, 2022 at 10:03:00PM -0800, Hugh Dickins wrote:
> > > The swapcache/pagecache bit was a brainfart. We acquire the folio lock
> > > in move_account(), which would lock out concurrent faults. If it's not
> > > mapped, I don't see how it could become mapped behind our backs. But
> > > we do need to be prepared for it to be unmapped.
> >
> > Welp, that doesn't protect us from the inverse, where the page is
> > mapped elsewhere and the other ptes are going away. So this won't be
> > enough, unfortunately.
> >
> > > > Does that mean that we just have to reinstate the folio_mapped() checks
> > > > in mm/memcontrol.c i.e. revert all mm/memcontrol.c changes from the
> > > > commit?  Or does it invalidate the whole project to remove
> > > > lock_page_memcg() from mm/rmap.c?
> >
> > Short of further restricting the pages that can be moved, I don't see
> > how we can get rid of the cgroup locks in rmap after all. :(
> >
> > We can try limiting move candidates to present ptes. But maybe it's
> > indeed time to deprecate the legacy charge moving altogether, and get
> > rid of the entire complication.
> >
> > Hugh, Shakeel, Michal, what do you think?
>
> I'm certainly not against deprecating it - it's a largish body of odd
> code, which poses signficant problems, yet is very seldom used; but I
> feel that we'd all like to see it gone from rmap quicker that it can
> be fully deprecated out of existence.
>
> I do wonder if any user would notice, if we quietly removed its
> operation on non-present ptes; certainly there *might* be users
> relying on that behaviour, but I doubt that many would.
>
> Alternatively (although I think Linus's objection to it in rmap is on
> both aesthetic and performance grounds, and retaining any trace of it
> in rmap.c still fails the aesthetic), can there be some static-keying
> done, to eliminate (un)lock_page_memcg() overhead for all but those few
> who actually indulge in moving memcg charge at immigrate?  (But I think
> you would have already done that if it were possible.)
>

My preference would be going with the removal of non-present ptes over
static-key in [un]lock_page_memcg().

How about the following steps:

1. Add warning in memory.move_charge_at_immigrate now (6.1/6.2) that
this is going away and also backport it to the stable kernels.

2. For 6.2 (or 6.3), remove the non-present pte migration with some
additional text in the warning and do the rmap cleanup.

3. After 3 or 4 releases (and hopefully finding no real users), we
deprecate this completely.

Step 3 can be delayed if there are some users depending on it. However
we need to be firm that this is going away irrespective.

Shakeel
