From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC] [PATCH 3/7 v2] memcg: remove PCG_MOVE_LOCK flag from
 pc->flags
Date: Tue, 17 Jan 2012 09:22:03 +0900
Message-ID: <20120117092203.73d9c303.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113174019.8dff3fc1.kamezawa.hiroyu@jp.fujitsu.com>
	<20120116125526.GB25981@shutemov.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120116125526.GB25981-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, 16 Jan 2012 14:55:26 +0200
"Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org> wrote:

> On Fri, Jan 13, 2012 at 05:40:19PM +0900, KAMEZAWA Hiroyuki wrote:
> > 
> > From 1008e84d94245b1e7c4d237802ff68ff00757736 Mon Sep 17 00:00:00 2001
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > Date: Thu, 12 Jan 2012 15:53:24 +0900
> > Subject: [PATCH 3/7] memcg: remove PCG_MOVE_LOCK flag from pc->flags.
> > 
> > PCG_MOVE_LOCK bit is used for bit spinlock for avoiding race between
> > memcg's account moving and page state statistics updates.
> > 
> > Considering page-statistics update, very hot path, this lock is
> > taken only when someone is moving account (or PageTransHuge())
> > And, now, all moving-account between memcgroups (by task-move)
> > are serialized.
> > 
> > So, it seems too costly to have 1bit per page for this purpose.
> > 
> > This patch removes PCG_MOVE_LOCK and add hashed rwlock array
> > instead of it. This works well enough. Even when we need to
> > take the lock, we don't need to disable IRQ in hot path because
> > of using rwlock.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> 
> ...
> 
> > +#define NR_MOVE_ACCOUNT_LOCKS	(NR_CPUS)
> > +#define move_account_hash(page) ((page_to_pfn(page) % NR_MOVE_ACCOUNT_LOCKS))
> 
> You still tend to add too many parentheses into macros ;)
> 

Ah, yes. Maybe my bad habit..
Will be fixed in the next patch.

Thanks,
-Kame
