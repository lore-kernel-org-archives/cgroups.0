From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v3
Date: Mon, 17 Jul 2017 10:48:44 -0400
Message-ID: <f6cdb0b7-4c73-ff4c-6693-fd1cb17015c0@redhat.com>
References: <20170717020721.3612468-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com AC0647F3F3
In-Reply-To: <20170717020721.3612468-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On 07/16/2017 10:07 PM, Tejun Heo wrote:
> Hello,
>
> This is v3 of cgroup2 thread mode patchset.  The changes from v2[L]
> are
>
> * Switched to marking each cgroup threaded instead of doing it
>   per-subtree as suggested by PeterZ.  This allows more flexibility
>   and removes certain interface quirks.
>
> * Dropped RFC tag and excluded cpu controller patches from this
>   patchset as threaded mode behaviors can easily be verified with the
>   pid controller.  Will follow up with cpu controller patchset later.
>
> It is largely based on the discussions that we had at the plumbers
> last year.  Here's the rough outline.
>
> * Thread mode is explicitly enabled on a cgroup by writing "threaded"
>   into "cgroup.type" file.  The cgroup shouldn't have any processes or
>   child cgroups.  A threaded cgroup joins the the parent's resource
>   domain and becomes a part of the threaded subtree anchored at the
>   nearest domain ancestor, which is called the threaded domain cgroup
>   of the subtree.
>
> * Threads can be put anywhere in a threaded subtree by writing TIDs
>   into "cgroup.threads" file.  Process granularity and
>   no-internal-process constraint don't apply in a threaded subtree.
>
> * To be used in a threaded subtree, controllers should explicitly
>   declare thread mode support and should be able to handle internal
>   competition in some way.
>
> * The threaded domain cgroup of a threaded subtree serves as the
>   resource domain for the whole subtree.  This is where all the
>   controllers are guaranteed to have a common ground and resource
>   consumptions in the threaded subtree which aren't tied to a specific
>   thread are charged.  Non-threaded controllers never see beyond
>   thread root and can assume that all controllers will follow the same
>   rules upto that point.
>
> * Unlike other cgroups, the system root cgroup can serve as parent to
>   domain child cgroups and threaded domains to threaded subtrees.
>
> This allows threaded controllers to implement thread granular resource
> control without getting in the way of system level resource
> partitioning.
>
> For more details on the interface and behavior, please refer to 0005.
>
> This patchset contains the following six patches.
>
>  0001-cgroup-reorganize-cgroup.procs-task-write-path.patch
>  0002-cgroup-add-flags-to-css_task_iter_start-and-implemen.patch
>  0003-cgroup-introduce-cgroup-dom_cgrp-and-threaded-css_se.patch
>  0004-cgroup-implement-CSS_TASK_ITER_THREADED.patch
>  0005-cgroup-implement-cgroup-v2-thread-support.patch
>  0006-cgroup-update-debug-controller-to-print-out-thread-m.patch
>
> 0001-0005 implement cgroup2 thread mode.  0006 enables debug
> controller on it.
>
> The patchset is based on the current cgroup/for-4.14 27f26753f8c0
> ("cgroup: replace css_set walking populated test with testing
> cgrp->nr_populated_csets") and also available in the following git
> branch.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-threads-v3

Your new patches don't seem to be pushed to your git tree yet. I
couldn't find them there.

Cheers,
Longman
