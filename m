From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v13 0/7] cgroup-aware OOM killer
Date: Sun, 14 Jan 2018 15:44:09 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1801141536380.131380@chino.kir.corp.google.com>
References: <20171130152824.1591-1-guro@fb.com> <20171130123930.cf3217c816fd270fa35a40cb@linux-foundation.org> <alpine.DEB.2.10.1801091556490.173445@chino.kir.corp.google.com> <20180110131143.GB26913@castle.DHCP.thefacebook.com>
 <20180110113345.54dd571967fd6e70bfba68c3@linux-foundation.org> <20180113171432.GA23484@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=WZhWYgLZ7o68XBRCuL8XgGZjn33PFOOrBEUpuSX+EZE=;
        b=tdU5xi/SlKn0jnkWAjb998OnAdVr3gSfB/NrQZLafoBLS95tz2BiEPDBcaaCAVQQte
         mH/6r3ZSWKGo84wNYmRhdhkqJ3zvtTYfrh/Eeuj4Zn4+0lPk/KY1cwoqRGhjmtQq/smf
         6gfF+MgdHBZrJ5af4rg+/vC9WMJ1XbHhvBGC285u8uv92liqQksE4xw20k008rSRCk7n
         XgndugP/sqVSmnnYklPSfiI2Oq0oibCJUEmJmaSQF0R/oNS84Xj26CtiSlm7ojVugNhT
         d4T5yG9H860+ruZMGim0IZaDSK0ZqOnuj4pOCYNGmTfQe+uGLuxdBkOS+BPN3oIqpRw3
         nOPg==
In-Reply-To: <20180113171432.GA23484-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sat, 13 Jan 2018, Johannes Weiner wrote:

> You don't have any control and no accounting of the stuff situated
> inside the root cgroup, so it doesn't make sense to leave anything in
> there while also using sophisticated containerization mechanisms like
> this group oom setting.
> 
> In fact, the laptop I'm writing this email on runs an unmodified
> mainstream Linux distribution. The only thing in the root cgroup are
> kernel threads.
> 
> The decisions are good enough for the rare cases you forget something
> in there and it explodes.
> 

It's quite trivial to allow the root mem cgroup to be compared exactly the 
same as another cgroup.  Please see 
https://marc.info/?l=linux-kernel&m=151579459920305.

> This assumes you even need one. Right now, the OOM killer picks the
> biggest MM, so you can evade selection by forking your MM. This patch
> allows picking the biggest cgroup, so you can evade by forking groups.
> 

It's quite trivial to prevent any cgroup from evading the oom killer by 
either forking their mm or attaching all their processes to subcontainers.  
Please see https://marc.info/?l=linux-kernel&m=151579459920305.

> It's not a new vector, and clearly nobody cares. This has never been
> brought up against the current design that I know of.
> 

As cgroup v2 becomes more popular, people will organize their cgroup 
hierarchies for all controllers they need to use.  We do this today, for 
example, by attaching some individual consumers to child mem cgroups 
purely for the rich statistics and vmscan stats that mem cgroup provides 
without any limitation on those cgroups.

> Note, however, that there actually *is* a way to guard against it: in
> cgroup2 there is a hierarchical limit you can configure for the number
> of cgroups that are allowed to be created in the subtree. See
> 1a926e0bbab8 ("cgroup: implement hierarchy limits").
> 

Not allowing the user to create subcontainers to track statistics to paper 
over an obvious and acknowledged shortcoming in the design of the cgroup 
aware oom killer seems like a pretty nasty shortcoming itself.

> It could be useful, but we have no concensus on the desired
> semantics. And it's not clear why we couldn't add it later as long as
> the default settings of a new knob maintain the default behavior
> (which would have to be preserved anyway, since we rely on it).
>

The active proposal is 
https://marc.info/?l=linux-kernel&m=151579459920305, which describes an 
extendable interface and one that covers all the shortcomings of this 
patchset without polluting the mem cgroup filesystem.  The default oom 
policy in that proposal would be "none", i.e. we do what we do today, 
based on process usage.  You can configure that, without the mount option 
this patchset introduces for local or hierarchical cgroup targeting.
 
> > > > I proposed a solution in 
> > > > https://marc.info/?l=linux-kernel&m=150956897302725, which was never 
> > > > responded to, for all of these issues.  The idea is to do hierarchical 
> > > > accounting of mem cgroup hierarchies so that the hierarchy is traversed 
> > > > comparing total usage at each level to select target cgroups.  Admins and 
> > > > users can use memory.oom_score_adj to influence that decisionmaking at 
> > > > each level.
> 
> We did respond repeatedly: this doesn't work for a lot of setups.
> 

We need to move this discussion to the active proposal at 
https://marc.info/?l=linux-kernel&m=151579459920305, because it does 
address your setup, so it's not good use of anyones time to further 
discuss simply memory.oom_score_adj.

Thanks.
