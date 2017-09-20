From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Wed, 20 Sep 2017 14:53:41 -0700
Message-ID: <20170920215341.GA5382@castle>
References: <20170911131742.16482-1-guro@fb.com>
 <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
 <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz>
 <20170913215607.GA19259@castle>
 <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz>
 <20170914160548.GA30441@castle>
 <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz>
 <20170915152301.GA29379@castle>
 <20170918061405.pcrf5vauvul4c2nr@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=mgu+v9zzihX2znLKuJMTEUgiHNyiH/doYO5uPenq40Y=;
 b=NpYZ5hoKZmzJMbQCTi6A+opgkVQm7Za45H0XFmilolnJ+ZVHI6dRrhO2HCLs8NsFxbpj
 u2wuaQKZnlntf6reA1BiPpd+3Eve7XRikXt8QdTv6qZX39Pevo7z8Arh6tGlzB7JJd61
 3/gKvKV/4g46GvDsQRIzJmavlk5/f5iFiCU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mgu+v9zzihX2znLKuJMTEUgiHNyiH/doYO5uPenq40Y=;
 b=T3HfvaisjMVv82ZG2N4peaqp0LbuTfPH/Ujpcw7/9BSTYDfKUVVH7f4+XFkEzg+BGUpxBlsKinItUcagrg89byF7ap1j/rlO1v13dRXYiTplFTYR+a7/n6p9w+RRNB6HMTvae0JomDXs/YRfJzm8706U6jaBsq8z4U9iq4nfqHg=
Content-Disposition: inline
In-Reply-To: <20170918061405.pcrf5vauvul4c2nr-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Sep 18, 2017 at 08:14:05AM +0200, Michal Hocko wrote:
> On Fri 15-09-17 08:23:01, Roman Gushchin wrote:
> > On Fri, Sep 15, 2017 at 12:58:26PM +0200, Michal Hocko wrote:
> > > On Thu 14-09-17 09:05:48, Roman Gushchin wrote:
> > > > On Thu, Sep 14, 2017 at 03:40:14PM +0200, Michal Hocko wrote:
> > > > > On Wed 13-09-17 14:56:07, Roman Gushchin wrote:
> > > > > > On Wed, Sep 13, 2017 at 02:29:14PM +0200, Michal Hocko wrote:
> > > > > [...]
> > > > > > > I strongly believe that comparing only leaf memcgs
> > > > > > > is more straightforward and it doesn't lead to unexpected results as
> > > > > > > mentioned before (kill a small memcg which is a part of the larger
> > > > > > > sub-hierarchy).
> > > > > > 
> > > > > > One of two main goals of this patchset is to introduce cgroup-level
> > > > > > fairness: bigger cgroups should be affected more than smaller,
> > > > > > despite the size of tasks inside. I believe the same principle
> > > > > > should be used for cgroups.
> > > > > 
> > > > > Yes bigger cgroups should be preferred but I fail to see why bigger
> > > > > hierarchies should be considered as well if they are not kill-all. And
> > > > > whether non-leaf memcgs should allow kill-all is not entirely clear to
> > > > > me. What would be the usecase?
> > > > 
> > > > We definitely want to support kill-all for non-leaf cgroups.
> > > > A workload can consist of several cgroups and we want to clean up
> > > > the whole thing on OOM.
> > > 
> > > Could you be more specific about such a workload? E.g. how can be such a
> > > hierarchy handled consistently when its sub-tree gets killed due to
> > > internal memory pressure?
> > 
> > Or just system-wide OOM.
> > 
> > > Or do you expect that none of the subtree will
> > > have hard limit configured?
> > 
> > And this can also be a case: the whole workload may have hard limit
> > configured, while internal memcgs have only memory.low set for "soft"
> > prioritization.
> > 
> > > 
> > > But then you just enforce a structural restriction on your configuration
> > > because
> > > 	root
> > >         /  \
> > >        A    D
> > >       /\   
> > >      B  C
> > > 
> > > is a different thing than
> > > 	root
> > >         / | \
> > >        B  C  D
> > >
> > 
> > I actually don't have a strong argument against an approach to select
> > largest leaf or kill-all-set memcg. I think, in practice there will be
> > no much difference.

I've tried to implement this approach, and it's really arguable.
Although your example looks reasonable, the opposite example is also valid:
you might want to compare whole hierarchies, and it's a quite typical usecase.

Assume, you have several containerized workloads on a machine (probably,
each will be contained in a memcg with memory.max set), with some hierarchy
of cgroups inside. Then in case of global memory shortage we want to reclaim
some memory from the biggest workload, and the selection should not depend
on group_oom settings. It would be really strange, if setting group_oom will
higher the chances to be killed.

In other words, let's imagine processes as leaf nodes in memcg tree. We decided
to select the biggest memcg and kill one or more processes inside (depending
on group_oom setting), but the memcg selection doesn't depend on it.
We do not compare processes from different cgroups, as well as cgroups with
processes. The same should apply to cgroups: why do we want to compare cgroups
from different sub-trees?

While size-based comparison can be implemented with this approach,
the priority-based is really weird (as David mentioned).
If priorities have no hierarchical meaning at all, we lack the very important
ability to enforce hierarchy oom_priority. Otherwise we have to invent some
complex rules of oom_priority propagation (e.g. is someone is raising
the oom_priority in parent, should it be applied to children immediately, etc).

The oom_group knob meaning also becoms more complex. It affects both
the victim selection and OOM action. _ANY_ mechanism which allows to affect
OOM victim selection (either priorities, either bpf-based approach) should
not have global system-wide meaning, it breaks everything.

I do understand your point, but the same is true for other stuff, right?
E.g. cpu time distribution (and io, etc) depends on hierarchy configuration.
It's a limitation, but it's ok, as user should create a hierarchy which
reflects some logical relations between processes and groups of processes.
Otherwise we're going to the configuration hell.

In any case, OOM is a last resort mechanism. The goal is to reclaim some memory
and do not crash the system or do not leave it in totally broken state.
Any really complex mm in userspace should be applied _before_ OOM happens.
So, I don't think we have to support all possible configurations here,
if we're able to achieve the main goal (kill some processes and do not leave
broken systems/containers).
