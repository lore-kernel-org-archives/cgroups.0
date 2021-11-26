From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Fri, 26 Nov 2021 14:54:23 +0800
Message-ID: <CA+PpKPmHfHca07W8aO+3bGjsqpUYOid=qBzm6dNuTyMmmkEpzQ@mail.gmail.com>
References: <20211124151915.GA6163@haolee.io> <YZ5o/VmU59evp65J@dhcp22.suse.cz>
 <CA+PpKPmy-u_BxYMCQOFyz78t2+3uM6nR9mQeX+MPyH6H2tOOHA@mail.gmail.com>
 <YZ8DZHERun6Fej2P@casper.infradead.org> <20211125080238.GA7356@haolee.io> <YZ/QFWzt/XbsLCqR@casper.infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H19UTR6A3kWJJtvYx5Y6mT7M01EqlCEK84X1kiQHMws=;
        b=bqxUG9GBwRxXusR0vQDwXIKE6tmcfVDsDscQDKgRdXOuIiQDmox3u/A8r0+NArAguX
         ryOAq6uwAHZira08kD6Pu7FjfRAqNG2Lw8IkeSjlPR20UPa9uslZ6fEl85gCwOfaY2+Z
         JvMMepT01lYXH6+p4Uc9HYYV7u0SXQwJ+cyxy4xHteJGk6Q61AlBs+kNfMFNkrbhpSmc
         ugm+v0S6yqERyuaNatOq9swdrMA1oXVgA3qcsRD2bkC+DUc/bmeIIh/7UpPKWVJoGPnr
         HSyCu7ECVTvXK1zs/ZvsEXHuU4LJSFp1p/J3gouteiUm/d9gBdoMZec9azTWVnnlofkV
         8mFw==
In-Reply-To: <YZ/QFWzt/XbsLCqR-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Nov 26, 2021 at 2:04 AM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
> On Thu, Nov 25, 2021 at 08:02:38AM +0000, Hao Lee wrote:
> > On Thu, Nov 25, 2021 at 03:30:44AM +0000, Matthew Wilcox wrote:
> > > On Thu, Nov 25, 2021 at 11:24:02AM +0800, Hao Lee wrote:
> > > > On Thu, Nov 25, 2021 at 12:31 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > > We do batch currently so no single task should be
> > > > > able to monopolize the cpu for too long. Why this is not sufficient?
> > > >
> > > > uncharge and unref indeed take advantage of the batch process, but
> > > > del_from_lru needs more time to complete. Several tasks will contend
> > > > spinlock in the loop if nr is very large.
> > >
> > > Is SWAP_CLUSTER_MAX too large?  Or does your architecture's spinlock
> > > implementation need to be fixed?
> > >
> >
> > My testing server is x86_64 with 5.16-rc2. The spinlock should be normal.
> >
> > I think lock_batch is not the point. lock_batch only break spinning time
> > into small parts, but it doesn't reduce spinning time. The thing may get
> > worse if lock_batch is very small.
>
> OK.  So if I understand right, you've got a lot of processes all
> calling exit_mmap() at the same time, which eventually becomes calls to
> unmap_vmas(), unmap_single_vma(), unmap_page_range(), zap_pte_range(),
> tlb_flush_mmu(), tlb_batch_pages_flush(), free_pages_and_swap_cache(),
> release_pages(), and then you see high contention on the LRU lock.

Exactly.

>
> Your use-case doesn't seem to mind sleeping (after all, these processes
> are exiting).

Yes!

>  So we could put a semaphore in exit_mmap() to limit the
> number of simultaneous callers to unmap_vmas().  Do you want to try
> that out and see if it solves your problem?  You might want to make it
> a counting semaphore (eg permit two tasks to exit at once) rather than
> a mutex.  But maybe a mutex is just fine.

This is really a good idea. My train of thought was trapped in reducing the
lock contention. I will try to implement this idea and see if the service
stability will be improved much. Thanks for your help!
