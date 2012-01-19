From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC] [PATCH 2/7 v2] memcg: add memory barrier for checking
 account move.
Date: Thu, 19 Jan 2012 11:17:27 +0900
Message-ID: <20120119111727.6337bde4.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120113173001.ee5260ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113173347.6231f510.kamezawa.hiroyu@jp.fujitsu.com>
	<20120117152635.GA22142@tiehlicka.suse.cz>
	<20120118090656.83268b3e.kamezawa.hiroyu@jp.fujitsu.com>
	<20120118123759.GB31112@tiehlicka.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120118123759.GB31112-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org" <hugh.dickins-IWqWACnzNjwqdlJmJB21zg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, 18 Jan 2012 13:37:59 +0100
Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:

> On Wed 18-01-12 09:06:56, KAMEZAWA Hiroyuki wrote:
> > On Tue, 17 Jan 2012 16:26:35 +0100
> > Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> > 
> > > On Fri 13-01-12 17:33:47, KAMEZAWA Hiroyuki wrote:
> > > > I think this bugfix is needed before going ahead. thoughts?
> > > > ==
> > > > From 2cb491a41782b39aae9f6fe7255b9159ac6c1563 Mon Sep 17 00:00:00 2001
> > > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > > > Date: Fri, 13 Jan 2012 14:27:20 +0900
> > > > Subject: [PATCH 2/7] memcg: add memory barrier for checking account move.
> > > > 
> > > > At starting move_account(), source memcg's per-cpu variable
> > > > MEM_CGROUP_ON_MOVE is set. The page status update
> > > > routine check it under rcu_read_lock(). But there is no memory
> > > > barrier. This patch adds one.
> > > 
> > > OK this would help to enforce that the CPU would see the current value
> > > but what prevents us from the race with the value update without the
> > > lock? This is as racy as it was before AFAICS.
> > > 
> > 
> > Hm, do I misunderstand ?
> > ==
> >    update                     reference
> > 
> >    CPU A                        CPU B
> >   set value                rcu_read_lock()
> >   smp_wmb()                smp_rmb()
> >                            read_value
> >                            rcu_read_unlock()
> >   synchronize_rcu().
> > ==
> > I expect
> > If synchronize_rcu() is called before rcu_read_lock() => move_lock_xxx will be held.
> > If synchronize_rcu() is called after rcu_read_lock() => update will be delayed.
> 
> Ahh, OK I can see it now. Readers are not that important because it is
> actually the updater who is delayed until all preexisting rcu read
> sections are finished.
> 
> In that case. Why do we need both barriers? spin_unlock is a full
> barrier so maybe we just need smp_rmb before we read value to make sure
> that we do not get stalled value when we start rcu_read section after
> synchronize_rcu?
> 

I doubt .... If no barrier, this case happens

==
	update			reference
	CPU A			CPU B
	set value
	synchronize_rcu()	rcu_read_lock()
				read_value <= find old value
				rcu_read_unlock()
				do no lock
==


> > Here, cpu B needs to read most recently updated value.
> 
> If it reads the old value then it would think that we are not moving and
> so we would account to the old group and move it later on, right?
>
Right. without move_lock, we're not sure which old/new pc->mem_cgroup will be. 
This will cause mis accounting.


Thanks,
-Kame




