From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
Date: Mon, 21 Nov 2011 19:44:52 +0900
Message-ID: <20111121194452.01c8e93d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
	<20111121104250.GI1770@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111121104250.GI1770-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mhocko-AlSwsSmVLrQ@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, 21 Nov 2011 11:42:50 +0100
Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> On Thu, Nov 17, 2011 at 10:33:08AM +0900, KAMEZAWA Hiroyuki wrote:
> > 
> > I'll send this again when mm is shipped.
> > I sometimes see mem_cgroup_split_huge_fixup() in perf report and noticed
> > it's very slow. This fixes it. Any comments are welcome.
> > 
> > ==
> > Subject: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
> > 
> > at split_huge_page(), mem_cgroup_split_huge_fixup() is called to
> > handle page_cgroup modifcations. It takes move_lock_page_cgroup()
> > and modify page_cgroup and LRU accounting jobs and called
> > HPAGE_PMD_SIZE - 1 times.
> > 
> > But thinking again,
> >   - compound_lock() is held at move_accout...then, it's not necessary
> >     to take move_lock_page_cgroup().
> >   - LRU is locked and all tail pages will go into the same LRU as
> >     head is now on.
> >   - page_cgroup is contiguous in huge page range.
> > 
> > This patch fixes mem_cgroup_split_huge_fixup() as to be called once per
> > hugepage and reduce costs for spliting.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> 
> I agree with the changes, but since you are resending it anyway: I
> think removing the move_lock and switching the hook to take care of
> all tail pages in one go are two logical steps.  Would you mind
> breaking it up into separate patches?
> 
> In any case,
> 
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Ok, I'll break this into 2 patches at resending.

Thanks,
-Kame


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
