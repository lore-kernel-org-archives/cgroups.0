From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] [PATCH 3/7 v2] memcg: remove PCG_MOVE_LOCK flag from
 pc->flags
Date: Tue, 17 Jan 2012 17:46:05 +0100
Message-ID: <20120117164605.GB22142@tiehlicka.suse.cz>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
 <20120113174019.8dff3fc1.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120113174019.8dff3fc1.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri 13-01-12 17:40:19, KAMEZAWA Hiroyuki wrote:
> 
> From 1008e84d94245b1e7c4d237802ff68ff00757736 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Date: Thu, 12 Jan 2012 15:53:24 +0900
> Subject: [PATCH 3/7] memcg: remove PCG_MOVE_LOCK flag from pc->flags.
> 
> PCG_MOVE_LOCK bit is used for bit spinlock for avoiding race between
> memcg's account moving and page state statistics updates.
> 
> Considering page-statistics update, very hot path, this lock is
> taken only when someone is moving account (or PageTransHuge())

Outdated comment? THP is not an issue here.

> And, now, all moving-account between memcgroups (by task-move)
> are serialized.
> 
> So, it seems too costly to have 1bit per page for this purpose.
> 
> This patch removes PCG_MOVE_LOCK and add hashed rwlock array
> instead of it. This works well enough. Even when we need to
> take the lock, 

Hmmm, rwlocks are not popular these days very much. 
Anyway, can we rather make it (source) memcg (bit)spinlock instead. We
would reduce false sharing this way and would penalize only pages from
the moving group.

The patch seems to be correct but I do not like the rwlock part very
much. I would replace it if possible.

[...]

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
