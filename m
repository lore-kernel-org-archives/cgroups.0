From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Mon, 28 Nov 2022 11:59:52 -0500
Message-ID: <Y4TpCJ+5uCvWE6co@cmpxchg.org>
References: <20221123181838.1373440-1-hannes@cmpxchg.org>
 <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OXdDTBqVegaar+pLWmnzFVWbntmDwb7qj9MvTJ7r5tA=;
        b=SpduupwX9+hgKbJAt1uBrr8GR8cVFBKX0qw5ONERsYzdWfB/N9QQYj9qCTlogNAj9M
         kEK1FZaNNPnXmtE+uVPtkinRgEpJ1JoknUQoYwGF0Q32h29zIr9jgsAs8IBYPk+9JHOn
         Su5WwW7J6E51pqICAcNNXMFqDgpDkcudvpSBi+GuH7OKHiHtB7StrdVPvzjyKor5dNKH
         qSYxxiWRzhj/yNfWFvtLA5Lw0fHWShpuoKz07eFZ+qSags11ZrQ6yOn7HI7EsRUagcth
         y3wAQAJjBGqBze7yEFUSoIPh0PUs+jQdGn2yb51ZjJ1Qw/2m/kffiVI1MZUrJWniHcRb
         5pxA==
Content-Disposition: inline
In-Reply-To: <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Nov 23, 2022 at 10:03:00PM -0800, Hugh Dickins wrote:
> On Wed, 23 Nov 2022, Johannes Weiner wrote:
> > rmap changes (mapping and unmapping) of a page currently take
> > lock_page_memcg() to serialize 1) update of the mapcount and the
> > cgroup mapped counter with 2) cgroup moving the page and updating the
> > old cgroup and the new cgroup counters based on page_mapped().
> > 
> > Before b2052564e66d ("mm: memcontrol: continue cache reclaim from
> > offlined groups"), we used to reassign all pages that could be found
> > on a cgroup's LRU list on deletion - something that rmap didn't
> > naturally serialize against. Since that commit, however, the only
> > pages that get moved are those mapped into page tables of a task
> > that's being migrated. In that case, the pte lock is always held (and
> > we know the page is mapped), which keeps rmap changes at bay already.
> > 
> > The additional lock_page_memcg() by rmap is redundant. Remove it.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Thank you, I love it: but with sorrow and shame, NAK to this version.
> 
> I was gearing up to rush in the crash fix at the bottom, when testing
> showed that the new VM_WARN_ON_ONCE(!folio_mapped(folio)) actually hits.
> 
> So I've asked Stephen to drop this mm-unstable commit from -next for
> tonight, while we think about what more is needed.
> 
> I was disbelieving when I saw the warning, couldn't understand at all.
> But a look at get_mctgt_type() shatters my illusion: it's doesn't just
> return a page for pte_present(ptent), it goes off looking up swap
> cache and page cache; plus I've no idea whether an MC_TARGET_DEVICE
> page would appear as folio_mapped() or not.

Thanks for catching this.

A device_private pte always has a matching mapcount in the fake page
it points to, so we should be good here. Those pages migrate back and
forth between system and device memory, relying on the migration
code's unmap and restore bits. Hence they participate in regular rmap.

The swapcache/pagecache bit was a brainfart. We acquire the folio lock
in move_account(), which would lock out concurrent faults. If it's not
mapped, I don't see how it could become mapped behind our backs. But
we do need to be prepared for it to be unmapped.

> Does that mean that we just have to reinstate the folio_mapped() checks
> in mm/memcontrol.c i.e. revert all mm/memcontrol.c changes from the
> commit?  Or does it invalidate the whole project to remove
> lock_page_memcg() from mm/rmap.c?

I think we have to bring back the folio_mapped() conditional and
update the comments. But it shouldn't invalidate the whole project.

I'll triple check this, however.

Thanks
