From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Thu, 25 Nov 2021 18:04:05 +0000
Message-ID: <YZ/QFWzt/XbsLCqR@casper.infradead.org>
References: <20211124151915.GA6163@haolee.io>
 <YZ5o/VmU59evp65J@dhcp22.suse.cz>
 <CA+PpKPmy-u_BxYMCQOFyz78t2+3uM6nR9mQeX+MPyH6H2tOOHA@mail.gmail.com>
 <YZ8DZHERun6Fej2P@casper.infradead.org>
 <20211125080238.GA7356@haolee.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l6gSn5dJkbwR5eJQa8fzZhyhrJULSWQHB9aANYgp6/s=; b=jdpn6IPgL/qCmFXmED9gghg6p2
        MFJD68+hWmud09MHPE3po5nbXJiHs8DkhCjlSlTrxJgVQhNU9hxP5oopJK/TRSdI+Ci+GBJFdgHj9
        B1y1BV16F0flpMBh6zWUbCkRz+qtJCAOYqzMnylwl6rirO63BRmw0Fgayh7WJCc2SmJX4iF5q6dbf
        hZxNWxQ2oxeLEIX+ypnm99o22WRjJ4b54Pxtg918D8++DhRL2G7RbmSyvVeq1BHKyrYUIjofyeQ0E
        B/aYpLCeuqLuQtXdTfC1FZXn+6XajNp/lOMdaTcSeUYsxL3Owz1fLs/iHOQoJzxNiL8p+OsO/ZfsP
        vZN1JGEw==;
Content-Disposition: inline
In-Reply-To: <20211125080238.GA7356-09FY7RZCRvthl2p70BpVqQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Nov 25, 2021 at 08:02:38AM +0000, Hao Lee wrote:
> On Thu, Nov 25, 2021 at 03:30:44AM +0000, Matthew Wilcox wrote:
> > On Thu, Nov 25, 2021 at 11:24:02AM +0800, Hao Lee wrote:
> > > On Thu, Nov 25, 2021 at 12:31 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > We do batch currently so no single task should be
> > > > able to monopolize the cpu for too long. Why this is not sufficient?
> > > 
> > > uncharge and unref indeed take advantage of the batch process, but
> > > del_from_lru needs more time to complete. Several tasks will contend
> > > spinlock in the loop if nr is very large.
> > 
> > Is SWAP_CLUSTER_MAX too large?  Or does your architecture's spinlock
> > implementation need to be fixed?
> > 
> 
> My testing server is x86_64 with 5.16-rc2. The spinlock should be normal.
> 
> I think lock_batch is not the point. lock_batch only break spinning time
> into small parts, but it doesn't reduce spinning time. The thing may get
> worse if lock_batch is very small.

OK.  So if I understand right, you've got a lot of processes all
calling exit_mmap() at the same time, which eventually becomes calls to
unmap_vmas(), unmap_single_vma(), unmap_page_range(), zap_pte_range(),
tlb_flush_mmu(), tlb_batch_pages_flush(), free_pages_and_swap_cache(),
release_pages(), and then you see high contention on the LRU lock.

Your use-case doesn't seem to mind sleeping (after all, these processes
are exiting).  So we could put a semaphore in exit_mmap() to limit the
number of simultaneous callers to unmap_vmas().  Do you want to try
that out and see if it solves your problem?  You might want to make it
a counting semaphore (eg permit two tasks to exit at once) rather than
a mutex.  But maybe a mutex is just fine.
