From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Thu, 30 Jan 2020 18:00:20 +0100
Message-ID: <20200130170020.GZ24244@dhcp22.suse.cz>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20191219200718.15696-4-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 19-12-19 15:07:18, Johannes Weiner wrote:
> Right now, the effective protection of any given cgroup is capped by
> its own explicit memory.low setting, regardless of what the parent
> says. The reasons for this are mostly historical and ease of
> implementation: to make delegation of memory.low safe, effective
> protection is the min() of all memory.low up the tree.
> 
> Unfortunately, this limitation makes it impossible to protect an
> entire subtree from another without forcing the user to make explicit
> protection allocations all the way to the leaf cgroups - something
> that is highly undesirable in real life scenarios.
> 
> Consider memory in a data center host. At the cgroup top level, we
> have a distinction between system management software and the actual
> workload the system is executing. Both branches are further subdivided
> into individual services, job components etc.
> 
> We want to protect the workload as a whole from the system management
> software, but that doesn't mean we want to protect and prioritize
> individual workload wrt each other. Their memory demand can vary over
> time, and we'd want the VM to simply cache the hottest data within the
> workload subtree. Yet, the current memory.low limitations force us to
> allocate a fixed amount of protection to each workload component in
> order to get protection from system management software in
> general. This results in very inefficient resource distribution.

I do agree that configuring the reclaim protection is not an easy task.
Especially in a deeper reclaim hierarchy. systemd tends to create a deep
and commonly shared subtrees. So having a protected workload really
requires to be put directly into a new first level cgroup in practice
AFAICT. That is a simpler example though. Just imagine you want to
protect a certain user slice.

You seem to be facing a different problem though IIUC. You know how much
memory you want to protect and you do not have to care about the cgroup
hierarchy up but you do not know/care how to distribute that protection
among workloads running under that protection. I agree that this is a
reasonable usecase.

Those both problems however show that we have a more general
configurability problem for both leaf and intermediate nodes. They are
both a result of strong requirements imposed by delegation as you have
noted above. I am thinking didn't we just go too rigid here?

Delegation points are certainly a security boundary and they should
be treated like that but do we really need a strong containment when
the reclaim protection is under admin full control? Does the admin
really have to reconfigure a large part of the hierarchy to protect a
particular subtree?

I do not have a great answer on how to implement this unfortunately. The
best I could come up with was to add a "$inherited_protection" magic
value to distinguish from an explicit >=0 protection. What's the
difference? $inherited_protection would be a default and it would always
refer to the closest explicit protection up the hierarchy (with 0 as a
default if there is none defined).
        A
       / \
      B   C (low=10G)
         / \
        D   E (low = 5G)

A, B don't get any protection (low=0). C gets protection (10G) and
distributes the pressure to D, E when in excess. D inherits (low=10G)
and E overrides the protection to 5G.

That would help both usecases AFAICS while the delegation should be
still possible (configure the delegation point with an explicit
value). I have very likely not thought that through completely.  Does
that sound like a completely insane idea?

Or do you think that the two usecases are simply impossible to handle
at the same time?
[...]
-- 
Michal Hocko
SUSE Labs
