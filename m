From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC] [PATCH 3/7 v2] memcg: remove PCG_MOVE_LOCK flag from
 pc->flags
Date: Tue, 24 Jan 2012 13:47:50 +0900
Message-ID: <20120124134750.de5f31ee.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113174019.8dff3fc1.kamezawa.hiroyu@jp.fujitsu.com>
	<CALWz4izasaECifCYoRXL45x1YXYzACC=kUHQivnGZKRH+ySjuw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALWz4izasaECifCYoRXL45x1YXYzACC=kUHQivnGZKRH+ySjuw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, 23 Jan 2012 14:02:48 -0800
Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Fri, Jan 13, 2012 at 12:40 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
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
> 
> This might be a side question, can you clarify the serialization here?
> Does it mean that we only allow one task-move at a time system-wide?
> 

current implementation has that limit by mutex.

Thanks,
-Kame
