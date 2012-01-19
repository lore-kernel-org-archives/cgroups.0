From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [BUG] kernel BUG at mm/memcontrol.c:1074!
Date: Thu, 19 Jan 2012 13:03:53 +0900
Message-ID: <20120119130353.0ca97435.kamezawa.hiroyu@jp.fujitsu.com>
References: <1326949826.5016.5.camel@lappy>
	<20120119122354.66eb9820.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LSU.2.00.1201181932040.2287@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.00.1201181932040.2287-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hannes <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, 18 Jan 2012 19:41:44 -0800 (PST)
Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, 19 Jan 2012, KAMEZAWA Hiroyuki wrote:
> > On Thu, 19 Jan 2012 07:10:26 +0200
> > Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > 
> > > Hi all,
> > > 
> > > During testing, I have triggered the OOM killer by mmap()ing a large block of memory. The OOM kicked in and tried to kill the process:
> > > 
> > 
> > two questions.
> > 
> > 1. What is the kernel version  ?
> 
> It says 3.2.0-next-20120119-sasha #128
> 
> > 2. are you using memcg moutned ?
> 
> I notice that, unlike Linus's git, this linux-next still has
> mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch in.
> 
> I think that was well capable of oopsing in mem_cgroup_lru_del_list(),
> since it didn't always know which lru a page belongs to.
> 
> I'm going to be optimistic and assume that was the cause.
> 
Hmm, because the log hits !memcg at lru "del", the page should be added
to LRU somewhere and the lru must be determined by pc->mem_cgroup.

Once set, pc->mem_cgroup is not cleared, just overwritten. AFAIK, there is
only one chance to set pc->mem_cgroup as NULL... initalization.
I wonder why it hits lru_del() rather than lru_add()...
................

Ahhhh, ok, it seems you are right. the patch has following kinds of codes
==
+static void pagevec_putback_immediate_fn(struct page *page, void *arg)
+{
+       struct zone *zone = page_zone(page);
+
+       if (PageLRU(page)) {
+               enum lru_list lru = page_lru(page);
+               list_move(&page->lru, &zone->lru[lru].list);
+       }
+}
==
..this will bypass mem_cgroup_lru_add(), and we can see bug in lru_del()
rather than lru_add()..

Another question is who pushes pages to LRU before setting pc->mem_cgroup..
Anyway, I think we need to fix memcg to be LRU_IMMEDIATE aware.

Thanks,
-Kmae



