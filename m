From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch -mm 3/4] mm, memcg: replace memory.oom_group with policy
 tunable
Date: Thu, 25 Jan 2018 09:05:42 +0100
Message-ID: <20180125080542.GK28465@dhcp22.suse.cz>
References: <alpine.DEB.2.10.1801161814130.28198@chino.kir.corp.google.com>
 <20180117154155.GU3460072@devbig577.frc2.facebook.com>
 <alpine.DEB.2.10.1801171348190.86895@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801191251080.177541@chino.kir.corp.google.com>
 <20180120123251.GB1096857@devbig577.frc2.facebook.com>
 <alpine.DEB.2.10.1801221420120.16871@chino.kir.corp.google.com>
 <20180123155301.GS1526@dhcp22.suse.cz>
 <alpine.DEB.2.10.1801231416330.254281@chino.kir.corp.google.com>
 <20180124082041.GD1526@dhcp22.suse.cz>
 <alpine.DEB.2.10.1801241340310.24330@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1801241340310.24330-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 24-01-18 13:44:02, David Rientjes wrote:
> On Wed, 24 Jan 2018, Michal Hocko wrote:
> 
> > > The current implementation of memory.oom_group is based on top of a 
> > > selection implementation that is broken in three ways I have listed for 
> > > months:
> > 
> > This doesn't lead to anywhere. You are not presenting any new arguments
> > and you are ignoring feedback you have received so far. We have tried
> > really hard. Considering different _independent_ people presented more or
> > less consistent view on these points I think you should deeply
> > reconsider how you take that feedback.
> > 
> 
> I've responded to each email providing useful feedback on this patchset.  
> I agreed with Tejun about not embedding the oom mechanism into 
> memory.oom_policy.  I was trying to avoid having two files in the mem 
> cgroup v2 filesystem for oom policy and mechanism.  I agreed that 
> delegating the mechanism to the workload would be useful in some cases.  
> I've solicited feedback on any other opinions on how that can be done 
> better, but it appears another tunable is the most convenient way of 
> allowing this behavior to be specified.

It is not about convenince. Those two things are simply orthogonal. And
that's what I've been saying for quite some time. Dunno, why it has been
ignored previously.

> As a result, this would remove patch 3/4 from the series.  Do you have any 
> other feedback regarding the remainder of this patch series before I 
> rebase it?

Yes, and I have provided it already. What you are proposing is
incomplete at best and needs much better consideration and much more
time to settle.

> I will address the unfair root mem cgroup vs leaf mem cgroup comparison in 
> a separate patchset to fix an issue where any user of oom_score_adj on a 
> system that is not fully containerized gets very unusual, unexpected, and 
> undocumented results.

I will not oppose but as it has been mentioned several times, this is by
no means a blocker issue. It can be added on top.

Thanks!
-- 
Michal Hocko
SUSE Labs
