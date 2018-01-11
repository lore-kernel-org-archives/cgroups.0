From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v13 0/7] cgroup-aware OOM killer
Date: Thu, 11 Jan 2018 13:18:53 +0000
Message-ID: <20180111131845.GA13726@castle.DHCP.thefacebook.com>
References: <20171130152824.1591-1-guro@fb.com>
 <20171130123930.cf3217c816fd270fa35a40cb@linux-foundation.org>
 <alpine.DEB.2.10.1801091556490.173445@chino.kir.corp.google.com>
 <20180110131143.GB26913@castle.DHCP.thefacebook.com>
 <20180110113345.54dd571967fd6e70bfba68c3@linux-foundation.org>
 <20180111090809.GW1732@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=BqAx+jTElK1HIvLdMyQP5Lup2gGeaSRAwV/OovfVVaE=;
 b=W0eihktAAwn7CvFCwPKNk3cSrpOmmb3JLcPKw3p42BYfLrIvbbPUbFpXGY3lryKQUu14
 0L/HTzhif3iSQTR+l9uXyP2wuODVi4s8HpEn+HJIh0Emeflc6GjPVJ0hrsFnqjBw/1yb
 lWEKheNS5KhXZkKJhNNycgcSSYGMh7iqsy4= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BqAx+jTElK1HIvLdMyQP5Lup2gGeaSRAwV/OovfVVaE=;
 b=AdcLNgTuHvm4lfEPF5TlAj3FG2bRDSfdWUTLoYau98YS2PF+WBelHGHy5HJuHZ7KtH6I/o7WAD51aw/jEufHZqPkhpt9XfaHBbqGjdRvJ2g1SmSsco5uiTS4OzRcTXxHoJje+H8VqJ4hey7rc7jI4vUT8Iplsr4irkmqs/JvXKo=
Content-Disposition: inline
In-Reply-To: <20180111090809.GW1732-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, Jan 11, 2018 at 10:08:09AM +0100, Michal Hocko wrote:
> On Wed 10-01-18 11:33:45, Andrew Morton wrote:
> > On Wed, 10 Jan 2018 05:11:44 -0800 Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> wrote:
> >
> > > The per-process oom_score_adj interface is not the nicest one, and I'm not
> > > sure we want to replicate it on cgroup level as is. If you have an idea of how
> > > it should look like, please, propose a patch; otherwise it's hard to discuss
> > > it without the code.
> > 
> > It does make sense to have some form of per-cgroup tunability.  Why is
> > the oom_score_adj approach inappropriate and what would be better?
> 
> oom_score_adj is basically unusable for any fine tuning on the process
> level for most setups except for very specialized ones. The only
> reasonable usage I've seen so far was to disable OOM killer for a
> process or make it a prime candidate. Using the same limited concept for
> cgroups sounds like repeating the same error to me.

My 2c here: current oom_score_adj semantics is really non-trivial for
cgroups. It defines an addition/substraction in 1/1000s of total memory or
OOMing cgroup's memory limit, depending on the the scope of the OOM event.
This is totally out of control for a user, because he/she can even have no
idea about the limit of an upper cgroup in the hierarchy. I've provided
an example earlier, in which one or another of two processes in the
same cgroup can be killed, depending on the scope of the OOM event.

> 
> > How hard is it to graft such a thing onto the -mm patchset?
> 
> I think this should be thought through very well before we add another
> tuning. Moreover the current usecase doesn't seem to require it so I am
> not really sure why we should implement something right away and later
> suffer from API mistakes.
>  
> > > > I proposed a solution in 
> > > > https://marc.info/?l=linux-kernel&m=150956897302725, which was never 
> > > > responded to, for all of these issues.  The idea is to do hierarchical 
> > > > accounting of mem cgroup hierarchies so that the hierarchy is traversed 
> > > > comparing total usage at each level to select target cgroups.  Admins and 
> > > > users can use memory.oom_score_adj to influence that decisionmaking at 
> > > > each level.
> > > > 
> > > > This solves #1 because mem cgroups can be compared based on the same 
> > > > classes of memory and the root mem cgroup's usage can be fairly compared 
> > > > by subtracting top-level mem cgroup usage from system usage.  All of the 
> > > > criteria used to evaluate a leaf mem cgroup has a reasonable system-wide 
> > > > counterpart that can be used to do the simple subtraction.
> > > > 
> > > > This solves #2 because evaluation is done hierarchically so that 
> > > > distributing processes over a set of child cgroups either intentionally 
> > > > or unintentionally no longer evades the oom killer.  Total usage is always 
> > > > accounted to the parent and there is no escaping this criteria for users.
> > > > 
> > > > This solves #3 because it allows admins to protect important processes in 
> > > > cgroups that are supposed to use, for example, 75% of system memory 
> > > > without it unconditionally being selected for oom kill but still oom kill 
> > > > if it exceeds a certain threshold.  In this sense, the cgroup aware oom 
> > > > killer, as currently implemented, is selling mem cgroups short by 
> > > > requiring the user to accept that the important process will be oom killed 
> > > > iff it uses mem cgroups and isn't attached to root.  It also allows users 
> > > > to actually volunteer to be oom killed first without majority usage.
> > > > 
> > > > It has come up time and time again that this support can be introduced on 
> > > > top of the cgroup oom killer as implemented.  It simply cannot.  For 
> > > > admins and users to have control over decisionmaking, it needs a 
> > > > oom_score_adj type tunable that cannot change semantics from kernel 
> > > > version to kernel version and without polluting the mem cgroup filesystem.  
> > > > That, in my suggestion, is an adjustment on the amount of total 
> > > > hierarchical usage of each mem cgroup at each level of the hierarchy.  
> > > > That requires that the heuristic uses hierarchical usage rather than 
> > > > considering each cgroup as independent consumers as it does today.  We 
> > > > need to implement that heuristic and introduce userspace influence over 
> > > > oom kill selection now rather than later because its implementation 
> > > > changes how this patchset is implemented.
> > > > 
> > > > I can implement these changes, if preferred, on top of the current 
> > > > patchset, but I do not believe we want inconsistencies between kernel 
> > > > versions that introduce user visible changes for the sole reason that this 
> > > > current implementation is incomplete and unfair.  We can implement and 
> > > > introduce it once without behavior changing later because the core 
> > > > heuristic has necessarily changed.
> > > 
> > > David, I _had_ hierarchical accounting implemented in one of the previous
> > > versions of this patchset. And there were _reasons_, why we went away from it.
> > 
> > Can you please summarize those issues for my understanding?
> 
> Because it makes the oom decision directly hardwired to the hierarchy
> structure. Just take a simple example of the cgroup structure which
> reflects a higher level organization
>          root
> 	/  |  \ 
>   admins   |   teachers
>         students
> 
> Now your students group will be most like the largest one. Why should we
> kill tasks/cgroups from that cgroup just because it is cumulatively the
> largest one. It might have been some of the teacher blowing up the
> memory usage.
> 
> Another example is when you need a mid layer cgroups for other
> controllers to better control resources.
> 	root
> 	/  \
>    cpuset1  cpuset2
>    /    \   /  |  \
>   A     B  C   D   E
> 
> You really do not want to select cpuset2 just because it has more
> subgroups and potentially larger cumulative usage. The hierarchical
> accounting works _only_ if higher level cgroups are semantically
> _comparable_ which might be true for some workloads but by no means this
> is true in general.
> 
> That all being said, I can see further improvements to happen on top of
> the current work but I also think that the current implementation works
> for the usecase which many users can use without those improvements.

Thank you, Michal, you wrote exactly what I wanted to write here!

Summarizing all this, following the hierarchy is good when it reflects
the "importance" of cgroup's memory for a user, and bad otherwise.
In generic case with unified hierarchy it's not true, so following
the hierarchy unconditionally is bad.

Current version of the patchset allows common evaluation of cgroups
by setting memory.groupoom to true. The only limitation is that it
also changes the OOM action: all belonging processes will be killed.
If we really want to preserve an option to evaluate cgroups
together without forcing "kill all processes" action, we can
convert memory.groupoom from being boolean to the multi-value knob.
For instance, "disabled" and "killall". This will allow to add
a third state ("evaluate", for example) later without breaking the API.

Re root cgroup evaluation:
I believe that it's discussed here mostly as an argument towards
hierarchical approach. The current heuristics can definitely be improved,
but it doesn't require changing the whole semantics. For example,
we can ignore oom_score_adj (except -1000) in this particular case,
that will fix David's example.

Thank you!

Roman
