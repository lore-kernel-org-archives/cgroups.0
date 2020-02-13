From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Thu, 13 Feb 2020 12:41:35 -0500
Message-ID: <20200213174135.GC208501@cmpxchg.org>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-4-hannes@cmpxchg.org>
 <20200130170020.GZ24244@dhcp22.suse.cz>
 <20200203215201.GD6380@cmpxchg.org>
 <20200211164753.GQ10636@dhcp22.suse.cz>
 <20200212170826.GC180867@cmpxchg.org>
 <20200213074049.GA31689@dhcp22.suse.cz>
 <20200213132317.GA208501@cmpxchg.org>
 <20200213154627.GD31689@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n7XLB3De9y8fDweg4sVo1HIei92EsSOSp6olL3m2rA0=;
        b=TXSRdQd4gB7ygGVkMnNcWH1/8H7IyjERTR0Ipv2h8SzF9HNHNqmWemY6uqbxlegg2H
         0GPulidfBFq2SQNrI3li4Ljh6VKgBeqU1akUcyqyvL+pVR2DIBtnprRLMAqyJjQu2eHt
         koXozCM9wx1/7908sXDp5Bny0Jad2riXDGqQCLx5g2H6BtUoQR09f8PDYw/B34i3sG66
         8w3++dpJWbbs6g6qQ4LXSQVI4ACjr61ES3exwLULmPh46MK+yXWZHYP7PSO67WlAVoYY
         /iQpl2g1yrDTXnGYyL0i/doSjzxWIofqOrbH3+xGu032AMpOXlP2IXQdqKgALuukdTWX
         36dw==
Content-Disposition: inline
In-Reply-To: <20200213154627.GD31689@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Feb 13, 2020 at 04:46:27PM +0100, Michal Hocko wrote:
> On Thu 13-02-20 08:23:17, Johannes Weiner wrote:
> > On Thu, Feb 13, 2020 at 08:40:49AM +0100, Michal Hocko wrote:
> > > On Wed 12-02-20 12:08:26, Johannes Weiner wrote:
> > > > On Tue, Feb 11, 2020 at 05:47:53PM +0100, Michal Hocko wrote:
> > > > > Unless I am missing something then I am afraid it doesn't. Say you have a
> > > > > default systemd cgroup deployment (aka deeper cgroup hierarchy with
> > > > > slices and scopes) and now you want to grant a reclaim protection on a
> > > > > leaf cgroup (or even a whole slice that is not really important). All the
> > > > > hierarchy up the tree has the protection set to 0 by default, right? You
> > > > > simply cannot get that protection. You would need to configure the
> > > > > protection up the hierarchy and that is really cumbersome.
> > > > 
> > > > Okay, I think I know what you mean. Let's say you have a tree like
> > > > this:
> > > > 
> > > >                           A
> > > >                          / \
> > > >                         B1  B2
> > > >                        / \   \
> > > >                       C1 C2   C3
> > > > 
> > > > and there is no actual delegation point - everything belongs to the
> > > > same user / trust domain. C1 sets memory.low to 10G, but its parents
> > > > set nothing. You're saying we should honor the 10G protection during
> > > > global and limit reclaims anywhere in the tree?
> > > 
> > > No, only in the C1 which sets the limit, because that is the woriking
> > > set we want to protect.
> > > 
> > > > Now let's consider there is a delegation point at B1: we set up and
> > > > trust B1, but not its children. What effect would the C1 protection
> > > > have then? Would we ignore it during global and A reclaim, but honor
> > > > it when there is B1 limit reclaim?
> > > 
> > > In the scheme with the inherited protection it would act as the gate
> > > and require an explicit low limit setup defaulting to 0 if none is
> > > specified.
> > > 
> > > > Doing an explicit downward propagation from the root to C1 *could* be
> > > > tedious, but I can't think of a scenario where it's completely
> > > > impossible. Especially because we allow proportional distribution when
> > > > the limit is overcommitted and you don't have to be 100% accurate.
> > > 
> > > So let's see how that works in practice, say a multi workload setup
> > > with a complex/deep cgroup hierachies (e.g. your above example). No
> > > delegation point this time.
> > > 
> > > C1 asks for low=1G while using 500M, C3 low=100M using 80M.  B1 and
> > > B2 are completely independent workloads and the same applies to C2 which
> > > doesn't ask for any protection at all? C2 uses 100M. Now the admin has
> > > to propagate protection upwards so B1 low=1G, B2 low=100M and A low=1G,
> > > right? Let's say we have a global reclaim due to external pressure that
> > > originates from outside of A hierarchy (it is not overcommited on the
> > > protection).
> > > 
> > > Unless I miss something C2 would get a protection even though nobody
> > > asked for it.
> > 
> > Good observation, but I think you spotted an unintentional side effect
> > of how I implemented the "floating protection" calculation rather than
> > a design problem.
> > 
> > My patch still allows explicit downward propagation. So if B1 sets up
> > 1G, and C1 explicitly claims those 1G (low>=1G, usage>=1G), C2 does
> > NOT get any protection. There is no "floating" protection left in B1
> > that could get to C2.
> 
> Yeah, the saturated protection works reasonably AFAICS.

Hm, Tejun raises a good point though: even if you could direct memory
protection down to one targeted leaf, you can't do the same with IO or
CPU. Those follow non-conserving weight distribution, and whatever you
allocate to a certain level is available at that level - if one child
doesn't consume it, the other children can.

And we know that controlling memory without controlling IO doesn't
really work in practice. The sibling with less memory allowance will
just page more.

So the question becomes: is this even a legit usecase? If every other
resource is distributed on a level-by-level method already, does it
buy us anything to make memory work differently?
