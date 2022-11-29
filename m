From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Tue, 29 Nov 2022 14:08:34 -0500
Message-ID: <Y4ZYsrXLBFDIxuoO@cmpxchg.org>
References: <20221123181838.1373440-1-hannes@cmpxchg.org>
 <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com>
 <Y4TpCJ+5uCvWE6co@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QmXXccF6gcyyJcn8xYpOax7l00RlE3WtMYxosINrpmo=;
        b=1kG96GwDm4z4tl5X58tMTSiaw3DnpfdCF/rv7UlXbsY8+W8PnZuGywUo6KHIprE3/m
         C3/GaQpilxnGQceURvNXTO1ziGUJq4Vc2aq7zP10STkI1U+qpHo7fv8DPSjq5nmE6ZDr
         C650xqNqffQvPC+Elo1PQXQrtus8NaS/ki4zN58D+ZaxSNRC+Vtxehlx8iQIVmXaEnyn
         dXr1dJoOKIVqUhDcSoGHaKX3y65ZqZegji+EglMCsAv+k1m5HXwK3Hflzhq4HrxtID2A
         PruXnlCS3Ni2PLeN/PPbY1Pqv87aHsLGz+Av6nyMfMl+F8m8jTAKXsXDZ+jBt1Cs+Aaf
         UU7g==
Content-Disposition: inline
In-Reply-To: <Y4TpCJ+5uCvWE6co-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 28, 2022 at 11:59:53AM -0500, Johannes Weiner wrote:
> On Wed, Nov 23, 2022 at 10:03:00PM -0800, Hugh Dickins wrote:
> The swapcache/pagecache bit was a brainfart. We acquire the folio lock
> in move_account(), which would lock out concurrent faults. If it's not
> mapped, I don't see how it could become mapped behind our backs. But
> we do need to be prepared for it to be unmapped.

Welp, that doesn't protect us from the inverse, where the page is
mapped elsewhere and the other ptes are going away. So this won't be
enough, unfortunately.

> > Does that mean that we just have to reinstate the folio_mapped() checks
> > in mm/memcontrol.c i.e. revert all mm/memcontrol.c changes from the
> > commit?  Or does it invalidate the whole project to remove
> > lock_page_memcg() from mm/rmap.c?

Short of further restricting the pages that can be moved, I don't see
how we can get rid of the cgroup locks in rmap after all. :(

We can try limiting move candidates to present ptes. But maybe it's
indeed time to deprecate the legacy charge moving altogether, and get
rid of the entire complication.

Hugh, Shakeel, Michal, what do you think?
