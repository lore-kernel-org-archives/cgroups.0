From: David Rientjes <rientjes@google.com>
Subject: Re: [v5 4/4] mm, oom, docs: describe the cgroup-aware OOM killer
Date: Tue, 15 Aug 2017 13:56:24 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708151349280.104516@chino.kir.corp.google.com>
References: <20170814183213.12319-1-guro@fb.com> <20170814183213.12319-5-guro@fb.com> <alpine.DEB.2.10.1708141544280.63207@chino.kir.corp.google.com> <20170815141350.GA4510@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=k4YNt0B07SHdVBmci5Z7chbLSeiraqZTUNtDTC0e21k=;
        b=SapcluYrIkUX1XfhtyweFknj1cGRGoOEoBXQaICK1ttPnTzwxCPsxjPC5nBlvN6suG
         jbOzqkC43stpxovx8hIhI2TZZ702eSBDu4CCY0aUC3CXkKDyidwa+CXB49W9ZYD4N50q
         EEyhdndmx34FOrkiCndxliuDcGDynHagtxp7ZOIsmFXG3lrPkfZEaR0lIT+SgnZFIuQc
         pZPMpVYgq/jkWKs8COKwMOD7ZL7BF0jmU0S6Y/R559yNLKbIxedhMCH3XEzUIrN6+0cV
         7IBN8DsKZ44mZzOlJzfwFWLK5omxmJ29vZWamcaGQ3NVeLWSzWhc6tqQa+wJbxB3aLy6
         kLlA==
In-Reply-To: <20170815141350.GA4510@castle.DHCP.thefacebook.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 15 Aug 2017, Roman Gushchin wrote:

> > > diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
> > > index dec5afdaa36d..22108f31e09d 100644
> > > --- a/Documentation/cgroup-v2.txt
> > > +++ b/Documentation/cgroup-v2.txt
> > > @@ -48,6 +48,7 @@ v1 is available under Documentation/cgroup-v1/.
> > >         5-2-1. Memory Interface Files
> > >         5-2-2. Usage Guidelines
> > >         5-2-3. Memory Ownership
> > > +       5-2-4. Cgroup-aware OOM Killer
> > 
> > Random curiousness, why cgroup-aware oom killer and not memcg-aware oom 
> > killer?
> 
> I don't think we use the term "memcg" somewhere in v2 docs.
> Do you think that "Memory cgroup-aware OOM killer" is better?
> 

I think it would be better to not describe it as its own entity, but 
rather a part of how the memory cgroup works, so simply describing it in 
section 5-2, perhaps as its own subsection, as how the oom killer works 
when using the memory cgroup is sufficient.  I wouldn't separate it out as 
a distinct cgroup feature in the documentation.

> > > +	cgroups.  The default is "0".
> > > +
> > > +	Defines whether the OOM killer should treat the cgroup
> > > +	as a single entity during the victim selection.
> > 
> > Isn't this true independent of the memory.oom_kill_all_tasks setting?  
> > The cgroup aware oom killer will consider memcg's as logical units when 
> > deciding what to kill with or without memory.oom_kill_all_tasks, right?
> > 
> > I think you cover this fact in the cgroup aware oom killer section below 
> > so this might result in confusion if described alongside a setting of
> > memory.oom_kill_all_tasks.
> > 

I assume this is fixed so that it's documented that memory cgroups are 
considered logical units by the oom killer and that 
memory.oom_kill_all_tasks is separate?  The former defines the policy on 
how a memory cgroup is targeted and the latter defines the mechanism it 
uses to free memory.

> > > +	If set, OOM killer will kill all belonging tasks in
> > > +	corresponding cgroup is selected as an OOM victim.
> > 
> > Maybe
> > 
> > "If set, the OOM killer will kill all threads attached to the memcg if 
> > selected as an OOM victim."
> > 
> > is better?
> 
> Fixed to the following (to conform with core v2 concepts):
>   If set, OOM killer will kill all processes attached to the cgroup
>   if selected as an OOM victim.
> 

Thanks.

> > > +Cgroup-aware OOM Killer
> > > +~~~~~~~~~~~~~~~~~~~~~~~
> > > +
> > > +Cgroup v2 memory controller implements a cgroup-aware OOM killer.
> > > +It means that it treats memory cgroups as first class OOM entities.
> > > +
> > > +Under OOM conditions the memory controller tries to make the best
> > > +choise of a victim, hierarchically looking for the largest memory
> > > +consumer. By default, it will look for the biggest task in the
> > > +biggest leaf cgroup.
> > > +
> > > +Be default, all cgroups have oom_priority 0, and OOM killer will
> > > +chose the largest cgroup recursively on each level. For non-root
> > > +cgroups it's possible to change the oom_priority, and it will cause
> > > +the OOM killer to look athe the priority value first, and compare
> > > +sizes only of cgroups with equal priority.
> > 
> > Maybe some description of "largest" would be helpful here?  I think you 
> > could briefly describe what is accounted for in the decisionmaking.
> 
> I'm afraid that it's too implementation-defined to be described.
> Do you have an idea, how to describe it without going too much into details?
> 

The point is that "largest cgroup" is ambiguous here: largest in what 
sense?  The cgroup with the largest number of processes attached?  Using 
the largest amount of memory?

I think the documentation should clearly define that the oom killer 
selects the memory cgroup that has the most memory managed at each level.
