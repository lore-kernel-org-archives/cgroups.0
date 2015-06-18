From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 4/4] cgroup: add delegation section to unified hierarchy
 documentation
Date: Thu, 18 Jun 2015 15:01:12 -0400
Message-ID: <20150618190112.GA2182@cmpxchg.org>
References: <1434481817-32001-1-git-send-email-tj@kernel.org>
 <1434481817-32001-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434481817-32001-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Jun 16, 2015 at 03:10:17PM -0400, Tejun Heo wrote:
> +4-2. Common ancestor rule
> +
> +Let's say cgroups C0 and C1 have been delegated to user U0 who created
> +C00, C01 under C0 and C10 under C1 as follows.
> +
> + ~~~~~~~~~~~~~ - C0 - C00
> + ~ cgroup    ~      \ C01
> + ~ hierarchy ~
> + ~~~~~~~~~~~~~ - C1 - C10
> +
> +C0 and C1 are separate entities in terms of resource distribution
> +regardless of their relative positions in the hierarchy.  The
> +resources the processes under C0 are entitled to are controlled by
> +C0's ancestors and may be completely different from C1.  It's clear
> +that the intention of delegating C0 to U0 is allowing U0 to organize
> +the processes under C0 and further control the distribution of C0's
> +resources.
> +
> +On traditional hierarchies, if a task has write access to "tasks" or
> +"cgroup.procs" file of a cgroup and its uid agrees with the target, it
> +can move the target to the cgroup.  In the above example, U0 will not
> +only be able to move processes in each sub-hierarchy but also across
> +the two sub-hierarchies, effectively allowing it to violate the
> +organizational and resource restrictions implied by the hierarchical
> +structure above C0 and C1.
> +
> +On the unified hierarchy, to write to a "cgroup.procs" file, in
> +addition to the usual write permission to the file and uid match, the
> +writer must also have write acess to the "cgroup.procs" file of the
> +common ancestor of the source and destination cgroups.  This prevents
> +delegatees from smuggling processes across disjoint sub-hierarchies.

I think this would be better as the first paragraph in 4.2, because it
nicely explains and summarizes the rule and its reasoning; then follow
up with detailed explanations and examples that corroborate the design
choice.

Otherwise, the patch looks good to me.
