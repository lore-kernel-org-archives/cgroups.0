From: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
Date: Mon, 9 Jul 2012 09:37:34 +0800
Message-ID: <20120709013734.GA8880@localhost>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
 <1340881525-5835-1-git-send-email-handai.szj@taobao.com>
 <4FF291BE.7030509@jp.fujitsu.com>
 <20120708144459.GA18272@localhost>
 <20120708230100.GA5340@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120708230100.GA5340-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Mon, Jul 09, 2012 at 01:01:00AM +0200, Johannes Weiner wrote:
> On Sun, Jul 08, 2012 at 10:44:59PM +0800, Fengguang Wu wrote:
> > On Tue, Jul 03, 2012 at 03:31:26PM +0900, KAMEZAWA Hiroyuki wrote:
> > > (2012/06/28 20:05), Sha Zhengju wrote:
> > > > From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> > > > 
> > > > Similar to dirty page, we add per cgroup writeback pages accounting. The lock
> > > > rule still is:
> > > > 	mem_cgroup_begin_update_page_stat()
> > > > 	modify page WRITEBACK stat
> > > > 	mem_cgroup_update_page_stat()
> > > > 	mem_cgroup_end_update_page_stat()
> > > > 
> > > > There're two writeback interface to modify: test_clear/set_page_writeback.
> > > > 
> > > > Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> > > 
> > > Seems good to me. BTW, you named macros as MEM_CGROUP_STAT_FILE_XXX
> > > but I wonder these counters will be used for accounting swap-out's dirty pages..
> > > 
> > > STAT_DIRTY, STAT_WRITEBACK ? do you have better name ?
> > 
> > Perhaps we can follow the established "enum zone_stat_item" names:
> > 
> >         NR_FILE_DIRTY,
> >         NR_WRITEBACK,
> > 
> > s/NR_/MEM_CGROUP_STAT_/
> > 
> > The names indicate that dirty pages for anonymous pages are not
> > accounted (by __set_page_dirty_no_writeback()). While the writeback
> > pages accounting include both the file/anon pages.
> > 
> > Ah then we'll need to update the document in patch 0 accordingly. This
> > may sound a bit tricky to the users..
> 
> We already report the global one as "nr_dirty", though.  Please don't
> give the memcg one a different name.
> 
> The enum naming is not too critical, but it would be nice to have it
> match the public name.

Fair enough. The public name obviously has more weight :)

Thanks,
Fengguang
