From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC] [PATCH 1/7 v2] memcg: remove unnecessary check in
 mem_cgroup_update_page_stat()
Date: Wed, 18 Jan 2012 08:55:58 +0900
Message-ID: <20120118085558.6ed1a988.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113173227.df2baae3.kamezawa.hiroyu@jp.fujitsu.com>
	<20120117151619.GA21348@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120117151619.GA21348-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Tue, 17 Jan 2012 16:16:20 +0100
Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:

> On Fri 13-01-12 17:32:27, KAMEZAWA Hiroyuki wrote:
> > 
> > From 788aebf15f3fa37940e0745cab72547e20683bf2 Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > Date: Thu, 12 Jan 2012 16:08:33 +0900
> > Subject: [PATCH 1/7] memcg: remove unnecessary check in mem_cgroup_update_page_stat()
> > 
> > commit 10ea69f1182b removes move_lock_page_cgroup() in thp-split path.
> > So, this PageTransHuge() check is unnecessary, too.
> 
> I do not see commit like that in the tree. I guess you meant
> memcg: make mem_cgroup_split_huge_fixup() more efficient which is not
> merged yet, right?
> 

This commit in the linux-next.

> commit e94c8a9cbce1aee4af9e1285802785481b7f93c5
> Author: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Date:   Thu Jan 12 17:18:20 2012 -0800
> 
>     memcg: make mem_cgroup_split_huge_fixup() more efficient
> 


> > 
> > Note:
> >  - considering when mem_cgroup_update_page_stat() is called,
> >    there will be no race between split_huge_page() and update_page_stat().
> >    All required locks are held in higher level.
> 
> We should never have THP page in this path in the first place. So why
> not changing this to VM_BUG_ON(PageTransHuge).
> 

Ying Han considers to support mlock stat.

Thanks,
-Kame
