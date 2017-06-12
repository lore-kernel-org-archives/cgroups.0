From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 07/10] cgroup: implement cgroup v2 thread support
Date: Mon, 12 Jun 2017 11:41:09 -0400
Message-ID: <6351a07a-7e88-4c89-7d62-cb71021cf580@redhat.com>
References: <20170610140351.10703-1-tj@kernel.org>
 <20170610140351.10703-8-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 8650233458C
In-Reply-To: <20170610140351.10703-8-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On 06/10/2017 10:03 AM, Tejun Heo wrote:
> This patch implements cgroup v2 thread support.  The goal of the
> thread mode is supporting hierarchical accounting and control at
> thread granularity while staying inside the resource domain model
> which allows coordination across different resource controllers and
> handling of anonymous resource consumptions.
>
> Once thread mode is enabled on a cgroup, the threads of the processes
> which are in its subtree can be placed inside the subtree without
> being restricted by process granularity or no-internal-process
> constraint.  Note that the threads aren't allowed to escape to a
> different threaded subtree.  To be used inside a threaded subtree, a
> controller should explicitly support threaded mode and be able to
> handle internal competition in the way which is appropriate for the
> resource.
>
> The root of a threaded subtree, where thread mode is enabled in the
> first place, is called the thread root and serves as the resource
> domain for the whole subtree.  This is the last cgroup where
> non-threaded controllers are operational and where all the
> domain-level resource consumptions in the subtree are accounted.  This
> allows threaded controllers to operate at thread granularity when
> requested while staying inside the scope of system-level resource
> distribution.
>
> As the root cgroup is exempt from the no-internal-process constraint,
> it can serve as both a thread root and a parent to normal cgroups.
> The root cgroup supports mixed cgroup mode which can be enabled and
> disabled anytime as long as there aren't any threaded children.  First
> level child cgroups can selectively join the mixed threaded subtree.
>
> Internally, in a threaded subtree, each css_set has its ->proc_cset
> pointing to a matching css_set which belongs to the thread root.  This
> ensures that thread root level cgroup_subsys_state for all threaded
> controllers are readily accessible for domain-level operations.

As far as I understand, the proc_cset thing is just for cgroup.procs
iteration purpose. They are not used for accessing cgroup_subsys_state
for domain-level operation.  In fact, all the relevant CSSes will be
available in the local css_set and there is no need to look elsewhere.

> This patch enables threaded mode for the pids and perf_events
> controllers.  Neither has to worry about domain-level resource
> consumptions and it's enough to simply set the flag.
>
> For more details on the interface and behavior of the thread mode,
> please refer to the section 2-2-2 in Documentation/cgroup-v2.txt added
> by this patch.  Note that the documentation update is not complete as
> the rest of the documentation needs to be updated accordingly.
> Rolling those updates into this patch can be confusing so that will be
> separate patches.
>
> v2: - After discussions with Waiman, support for mixed thread mode is
>       added.  This should address the issue that Peter pointed out
>       where any nesting should be avoided for thread subtrees while
>       coexisting with other domain cgroups.
>
>     - Enabling / disabling thread mode now piggy backs on the existing
>       control mask update mechanism.
>
>     - Bug fixes and cleanup.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/cgroup-v2.txt |  99 +++++++++++++-
>  include/linux/cgroup-defs.h |  12 ++
>  kernel/cgroup/cgroup.c      | 323 ++++++++++++++++++++++++++++++++++++++++++--
>  kernel/cgroup/pids.c        |   1 +
>  kernel/events/core.c        |   1 +
>  5 files changed, 420 insertions(+), 16 deletions(-)
>

> +/* is @cgrp root of a threaded subtree? */
> +static bool cgroup_is_thread_root(struct cgroup *cgrp)
> +{
> +	return cgrp->proc_cgrp == cgrp;
> +}
> +
> +/* if threaded, would @cgrp become root of a mixed threaded subtree? */
> +static bool cgroup_is_mixable(struct cgroup *cgrp)
> +{
> +	/*
> +	 * Root isn't under domain level resource control exempting it from
> +	 * the no-internal-process constraint, so it can serve as a thread
> +	 * root and a parent of resource domains at the same time.
> +	 */
> +	return !cgroup_parent(cgrp);
> +}

Eventually, I would like to see a container root to be regarded as
mixable so that it will look and feel like a real root to the container.
Yes, that will mean having to deal with internal process competition
with resource domain controllers. If we are going to keep the no
internal process constraint, this is the other exception that I would
like to have. We can work around that by having, for example, special
directory for resource domain controllers to manage their resources like
what I have proposed in the resource domain patch. Or we can just let
those resource domain controllers to deal with it.

Cheers,
Longman

