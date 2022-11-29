From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Tue, 29 Nov 2022 11:42:54 -0800
Message-ID: <CALvZod6PCmbA1cNVueuJL=njL+ZMez_rFK74GEmRZpNy_k=AUA@mail.gmail.com>
References: <20221123181838.1373440-1-hannes@cmpxchg.org> <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com>
 <Y4TpCJ+5uCvWE6co@cmpxchg.org> <Y4ZYsrXLBFDIxuoO@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rGTIG8x4KsRIPh4QmKAiIuwOVCN06VOhOfE/clNYHVU=;
        b=iCbO4c3ISsWAsryVLUOqcvzYLYwMoYxQScIi5QhG+vvlujDo7VmIfHe0IA52ZQutMK
         amwKaZjJTL6PsYXcJVsqFVkIuQuyfovT0EWhapOAzn55PBiHbsC7HdJwIyN7CT9cHI8x
         VVZ7qVmQsKNXg3E+ebb0Guqg0H9F0i7pEexuw4OPdde3Ed8SN8zyNmPjSnSHOukHyEji
         kacPnsnMaugQ7P40hIuhkUOARS0JEquiN/xd2Hs8T1HKzZZSa7CNXyUSZaMrgWMBJVZL
         w7tgyMF7w6NMxVOxYy7wSc/DUJxU6gOhmqnNLv9/F87H2osfOzzasLTlcfRsHXVbcWTx
         9MaQ==
In-Reply-To: <Y4ZYsrXLBFDIxuoO-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 29, 2022 at 11:08 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Mon, Nov 28, 2022 at 11:59:53AM -0500, Johannes Weiner wrote:
> > On Wed, Nov 23, 2022 at 10:03:00PM -0800, Hugh Dickins wrote:
> > The swapcache/pagecache bit was a brainfart. We acquire the folio lock
> > in move_account(), which would lock out concurrent faults. If it's not
> > mapped, I don't see how it could become mapped behind our backs. But
> > we do need to be prepared for it to be unmapped.
>
> Welp, that doesn't protect us from the inverse, where the page is
> mapped elsewhere and the other ptes are going away. So this won't be
> enough, unfortunately.
>
> > > Does that mean that we just have to reinstate the folio_mapped() checks
> > > in mm/memcontrol.c i.e. revert all mm/memcontrol.c changes from the
> > > commit?  Or does it invalidate the whole project to remove
> > > lock_page_memcg() from mm/rmap.c?
>
> Short of further restricting the pages that can be moved, I don't see
> how we can get rid of the cgroup locks in rmap after all. :(
>
> We can try limiting move candidates to present ptes. But maybe it's
> indeed time to deprecate the legacy charge moving altogether, and get
> rid of the entire complication.
>
> Hugh, Shakeel, Michal, what do you think?

I am on-board.
