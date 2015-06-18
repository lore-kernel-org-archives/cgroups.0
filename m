From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/4] cgroup: require write perm on common ancestor
 when moving processes on the default hierarchy
Date: Thu, 18 Jun 2015 15:04:25 -0400
Message-ID: <20150618190425.GB2182@cmpxchg.org>
References: <1434481817-32001-1-git-send-email-tj@kernel.org>
 <1434481817-32001-4-git-send-email-tj@kernel.org>
 <20150618175927.GD12934@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150618175927.GD12934-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Jun 18, 2015 at 01:59:27PM -0400, Tejun Heo wrote:
> On traditional hierarchies, if a task has write access to "tasks" or
> "cgroup.procs" file of a cgroup and its euid agrees with the target,
> it can move the target to the cgroup; however, consider the following
> scenario.  The owner of each cgroup is in the parentheses.
> 
>  R (root) - 0 (root) - 00 (user1) - 000 (user1)
>           |                       \ 001 (user1)
>           \ 1 (root) - 10 (user1)
> 
> The subtrees of 00 and 10 are delegated to user1; however, while both
> subtrees may belong to the same user, it is clear that the two
> subtrees are to be isolated - they're under completely separate
> resource limits imposed by 0 and 1, respectively.  Note that 0 and 1
> aren't strictly necessary but added to ease illustrating the issue.
> 
> If user1 is allowed to move processes between the two subtrees, the
> intention of the hierarchy - keeping a given group of processes under
> a subtree with certain resource restrictions while delegating
> management of the subtree - can be circumvented by user1.
> 
> This happens because migration permission check doesn't consider the
> hierarchical nature of cgroups.  To fix the issue, this patch adds an
> extra permission requirement when userland tries to migrate a process
> in the default hierarchy - the issuing task must have write access to
> the common ancestor of "cgroup.procs" file of the ancestor in addition
> to the destination's.
> 
> Conceptually, the issuer must be able to move the target process from
> the source cgroup to the common ancestor of source and destination
> cgroups and then to the destination.  As long as delegation is done in
> a proper top-down way, this guarantees that a delegatee can't smuggle
> processes across disjoint delegation domains.
> 
> The next patch will add documentation on the delegation model on the
> default hierarchy.
> 
> v2: Fixed missing !ret test.  Spotted by Li Zefan.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
