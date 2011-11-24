From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 7/8] mm: memcg: modify PageCgroupAcctLRU non-atomically
Date: Thu, 24 Nov 2011 09:53:57 +0100
Message-ID: <20111124085357.GA6843@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-8-git-send-email-hannes@cmpxchg.org>
 <alpine.LSU.2.00.1111231039390.2175@sister.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1111231039390.2175-T/S/X05ZC3jbmfIwyoSfiQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2011 at 10:52:39AM -0800, Hugh Dickins wrote:
> On Wed, 23 Nov 2011, Johannes Weiner wrote:
> 
> > From: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > This bit is protected by zone->lru_lock, there is no need for locked
> > operations when setting and clearing it.
> > 
> > Signed-off-by: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Unless there are special considerations which you have not mentioned at
> all in the description above, this 7/8 and the similar 8/8 are mistaken.
> 
> The atomic operation is not for guaranteeing the setting and clearing
> of the bit in question: it's for guaranteeing that you don't accidentally
> set or clear any of the other bits in the same word when you're doing so,
> if another task is updating them at the same time as you're doing this.
> 
> There are circumstances when non-atomic shortcuts can be taken, when
> you're sure the field cannot yet be visible to other tasks (we do that
> when setting PageLocked on a freshly allocated page, for example - but
> even then have to rely on others using get_page_unless_zero properly).
> But I don't think that's the case here.

I have no idea how I could oversee this.  You are, of course, right.

That said, I *think* that it is safe for PageCgroupCache because
nobody else should be modifying any pc->flags concurrently:

PCG_LOCK: by definition exclusive and held during setting and clearing
PCG_CACHE

PCG_CACHE: serialized by PCG_LOCK

PCG_USED: serialized by PCG_LOCK

PCG_MIGRATION: serialized by PCG_LOCK

PCG_MOVE_LOCK: 1. update_page_stat() is only called against file
pages, and the page lock serializes charging against mapping.  the
page is also charged before establishing a pte mapping, so an unmap
can not race with a charge.  2. split_huge_fixup runs against already
charged pages.  3. move_account is serialized both by LRU-isolation
during charging and PCG_LOCK

PCG_FILE_MAPPED: same as PCG_MOVE_LOCK's 1.

PCG_ACCT_LRU: pages are isolated from the LRU during charging

But all this is obviously anything but robust, and so I retract the
broken 7/8 and the might-actually-work 8/8.
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
