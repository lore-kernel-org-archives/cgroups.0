From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Wed, 23 Jul 2014 16:38:47 +0200
Message-ID: <20140723143847.GB16721@dhcp22.suse.cz>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715082545.GA9366@dhcp22.suse.cz>
 <20140715121935.GB9366@dhcp22.suse.cz>
 <20140718071246.GA21565@dhcp22.suse.cz>
 <20140718144554.GG29639@cmpxchg.org>
 <CAJfpegt9k+YULet3vhmG3br7zSiHy-DRL+MiEE=HRzcs+mLzbw@mail.gmail.com>
 <20140719173911.GA1725@cmpxchg.org>
 <20140722150825.GA4517@dhcp22.suse.cz>
 <CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegscT-ptQzq__uUV2TOn7Uvs6x4FdWGTQb9Fe9MEJr2KjA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue 22-07-14 17:44:43, Miklos Szeredi wrote:
> On Tue, Jul 22, 2014 at 5:08 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> > On Sat 19-07-14 13:39:11, Johannes Weiner wrote:
> >> On Fri, Jul 18, 2014 at 05:12:54PM +0200, Miklos Szeredi wrote:
> >> > On Fri, Jul 18, 2014 at 4:45 PM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >> >
> >> > > I assumed the source page would always be new, according to this part
> >> > > in fuse_try_move_page():
> >> > >
> >> > >         /*
> >> > >          * This is a new and locked page, it shouldn't be mapped or
> >> > >          * have any special flags on it
> >> > >          */
> >> > >         if (WARN_ON(page_mapped(oldpage)))
> >> > >                 goto out_fallback_unlock;
> >> > >         if (WARN_ON(page_has_private(oldpage)))
> >> > >                 goto out_fallback_unlock;
> >> > >         if (WARN_ON(PageDirty(oldpage) || PageWriteback(oldpage)))
> >> > >                 goto out_fallback_unlock;
> >> > >         if (WARN_ON(PageMlocked(oldpage)))
> >> > >                 goto out_fallback_unlock;
> >> > >
> >> > > However, it's in the page cache and I can't really convince myself
> >> > > that it's not also on the LRU.  Miklos, I have trouble pinpointing
> >> > > where oldpage is instantiated exactly and what state it might be in -
> >> > > can it already be on the LRU?
> >> >
> >> > oldpage comes from ->readpages() (*NOT* ->readpage()), i.e. readahead.
> >> >
> >> > AFAICS it is added to the LRU in read_cache_pages(), so it looks like
> >> > it is definitely on the LRU at that point.
> >
> > OK, so my understanding of the code was wrong :/ and staring at it for
> > quite a while didn't help much. The fuse code is so full of indirection
> > it makes my head spin.
> 
> Definitely needs a rewrite.  But forget the complexities for the
> moment and just consider this single case:
> 
>  ->readpages() is called to do some readahead, pages are locked, added
> to the page cache and, AFAICS, charged to a memcg (in
> add_to_page_cache_lru()).
> 
>  - fuse sends a READ request to userspace and it gets a reply with
> splice(... SPLICE_F_MOVE).  What this means that a bunch of pages of
> indefinite origin are to replace (if possible) the pages already in
> the page cache.  If not possible, for some reason, it falls back to
> copying the contents.  So, AFAICS, the oldpage and the newpage can be
> charged to a different memcg.

OK, thanks for the clarification. I had this feeling but couldn't wrap
my head around the indirection of the code.

It seems that checkig PageCgroupUsed(new) and bail out early in
mem_cgroup_migrate should just work, no?

> > How should we test this code path, Miklos?
> 
>   fusexmp_fh -osplice_write,splice_move /mnt/fuse
> 
> This will mirror / under /mnt/fuse and will use splice to move data
> from the underlying filesystem to the fuse filesystem, hopefully.
> 
> It would be useful if it had some instrumentation telling us the
> actual number of pages successfully moved, but it doesn't have that
> yet.

Thanks I will try to play with this tomorrow when I have more time.
-- 
Michal Hocko
SUSE Labs
