From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/3] mm: migrate: do not touch page->mem_cgroup of live
 pages
Date: Sun, 28 Feb 2016 15:57:05 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1602281552160.2997@eggly.anvils>
References: <1454109573-29235-1-git-send-email-hannes@cmpxchg.org> <1454109573-29235-2-git-send-email-hannes@cmpxchg.org> <20160203131748.GB15520@mguzik> <20160203140824.GJ21016@esperanza> <20160203183547.GA4007@cmpxchg.org> <alpine.LSU.2.11.1602031648050.1497@eggly.anvils>
 <20160204195324.GA8208@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=7MDeT2jOXdXgMD8pZC7cB6DY9/e0EJhWC7uNCVr4E8U=;
        b=kde7tvS2W/BRXCQC8+Twe0q8vosT3MBx4igKPAaLGhCoIw19VrIGJt3VrXNfURyki3
         MPzRE0gN56cb/PQ34hPZXr5CYzLVsnst0qXsVd1JxSaOFUsB+ipmf7guKsO5i0tjs7re
         bembSYAJQhsFcGriyVq3BX/zfWxAnCkJ/twc6TkxPempGZqci7kjnv5lpy9708OVrFV9
         wJKHFAVjx7O+rgXTzrQgVAsj7idMXrSWguE2zXvoFLbtpJMAgftB9J1NaTjivy+bqkhZ
         mc8nvzMKTwr4QgUFgfZ+zNCx+yt6rQBiV+DLRoiof9rDyL19Z4AXQ17XtqG/dBKgeLvg
         Nj9w==
In-Reply-To: <20160204195324.GA8208@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>, Vladimir Davydov <vdavydov@virtuozzo.com>, Mateusz Guzik <mguzik@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Greg Thelen <gthelen@google.com>

On Thu, 4 Feb 2016, Johannes Weiner wrote:
> On Wed, Feb 03, 2016 at 05:39:08PM -0800, Hugh Dickins wrote:
> 
> > And (even more off-topic), I'm slightly sad to see that the lrucare
> > arg which mem_cgroup_migrate() used to have (before I renamed it and
> > you renamed it back!) has gone, so mem_cgroup_migrate() now always
> > demands lrucare of commit_charge().  I'd hoped that with your
> > separation of new from old charge, mem_cgroup_migrate() would never
> > need lrucare; but that's not true for the fuse case, though true
> > for everyone else.  Maybe just not worth bothering about?  Or the
> > reintroduction of some unnecessary zone->lru_lock-ing in page
> > migration, which we ought to try to avoid?
> > 
> > Or am I wrong, and even fuse doesn't need it?  That early return
> > "if (newpage->mem_cgroup)": isn't mem_cgroup_migrate() a no-op for
> > fuse, or is there some corner case by which newpage can be on LRU
> > but its mem_cgroup unset?
> 
> That should be impossible nowadays.
> 
> I went through the git log to find out why we used to do the LRU
> handling for newpage, and the clue is in this patch and the way
> charging used to work at that time:
> 
> commit 5a6475a4e162200f43855e2d42bbf55bcca1a9f2
> Author: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date:   Wed Mar 23 16:42:42 2011 -0700
> 
>     memcg: fix leak on wrong LRU with FUSE
>     
>     fs/fuse/dev.c::fuse_try_move_page() does
>     
>        (1) remove a page by ->steal()
>        (2) re-add the page to page cache
>        (3) link the page to LRU if it was not on LRU at (1)
>     
>     This implies the page is _on_ LRU when it's added to radix-tree.  So, the
>     page is added to memory cgroup while it's on LRU.  because LRU is lazy and
>     no one flushs it.
> 
> We used to uncharge the page when deleting it from the page cache, not
> on the final put. So when fuse replaced a page in cache, it would
> uncharge the stolen page while it was on the LRU and then re-charge.
> 
> Nowadays this doesn't happen, and if newpage is a stolen page cache
> page it just remains charged and we bail out of the transfer.
> 
> I don't see a sceniaro where newpage would be uncharged yet on LRU.
> 
> Thanks for your insights, Hugh. I'll send patches to clean this up.

And thank you for following up and identifying that commit, which
explained why it was needed, and now is not.  Not a big deal, but
it is satisfying to be able to eliminate that piece of lrucruft,
as your patch then did: thank you.

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
