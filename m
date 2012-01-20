From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC] [PATCH 7/7 v2] memcg: make mem_cgroup_begin_update_stat
 to use global pcpu.
Date: Fri, 20 Jan 2012 11:19:47 +0900
Message-ID: <20120120111947.400b2b15.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113174510.5e0f6131.kamezawa.hiroyu@jp.fujitsu.com>
	<20120119144712.GG13932@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120119144712.GG13932-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, 19 Jan 2012 15:47:12 +0100
Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:

> On Fri 13-01-12 17:45:10, KAMEZAWA Hiroyuki wrote:
> > From 3df71cef5757ee6547916c4952f04a263c1b8ddb Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > Date: Fri, 13 Jan 2012 17:07:35 +0900
> > Subject: [PATCH 7/7] memcg: make mem_cgroup_begin_update_stat to use global pcpu.
> > 
> > Now, a per-cpu flag to show the memcg is under account moving is
> > now implemented as per-memcg-per-cpu.
> > 
> > So, when accessing this, we need to access memcg 1st. But this
> > function is called even when status update doesn't occur. Then,
> > accessing struct memcg is an overhead in such case.
> > 
> > This patch removes per-cpu-per-memcg MEM_CGROUP_ON_MOVE and add
> > per-cpu vairable to do the same work. For per-memcg, atomic
> > counter is added. By this, mem_cgroup_begin_update_stat() will
> > just access percpu variable in usual case and don't need to find & access
> > memcg. This reduces overhead.
> 
> I agree that move_account is not a hotpath and that we don't have
> to optimize for it but I guess we can do better. If we use a cookie
> parameter for
> mem_cgroup_{begin,end}_update_stat(struct page *page, unsigned long *cookie)
> then we can stab page_cgroup inside and use the last bit for
> locked.  Then we do not have to call lookup_page_cgroup again in
> mem_cgroup_update_page_stat and just replace page by the cookie.
> What do you think?
> 

Because these routine is called as

	mem_cgroup_begin_update_stat()
	if (condition)
		set_page_flag
		mem_cgroup_update_stat()
	mem_cgroup_end_update_stat()

In earlier version(not posted), I did so. Now, I don't because of 2 reasons.

1. I wonder it's better not to have extra arguments in begin_xxx it
   will be overhead itself.
2. my work's final purpose is integrate page_cgroup to struct page.
   If I can do, lookup_page_cgroup() cost will be almost 0 and we'll revert
   the cookie, finally.

So, can't we keep this update routine simple for a while ?
If we saw it's finally impossible to integrate page_cgroup to page,
I'd like to consider 'cookie' again.

BTW, If we use spinlock and need to do irq_disable() in begin_update_stat()
we'll need to pass *flags...

Thanks,
-Kame
