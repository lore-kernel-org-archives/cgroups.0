From: Paul Turner <pjt@google.com>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Thu, 9 Feb 2017 05:07:16 -0800
Message-ID: <CAPM31RKHsM1-iWb5B6jkOtLomLhiOARtgMOTWZ8p1yjEn-ZK0A@mail.gmail.com>
References: <20170202200632.13992-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=FNv5jWPNAF4u4PWBBzMl233mMnqXXKrfvhhyyL+rnQM=;
        b=mheDiQs6ioYib0Jx/HqtTA5W6QcK0u2lPAiQUYhHWk8lBed3p4EpuVoIm/rlzPDR0I
         JZDVeO7Sb/QNJhzJqN3Q9FeU8iB5a5CCiBh73SKoP1BPh2cSB9EFG+30IAjp2HpU6H/L
         TrBIyuINQRTSfmja4ynZ/s17fBHO6Bay3wRgVJWNYeo3hEcxBohPMzHT2Q+FtXGlGv2X
         BTP2KRZhNuUnGSrB1Fr9pj7Y47MKzUyaN6IfottvPhBY0m7Z5RZg33acv18SuRqPrJ6i
         xDddiwlNw4SsjSVi/mTz16aZQ53BdR7p2l5D9aRzSd/kqktaJg2bmzc1Tr+FR23Mym2J
         MggQ==
In-Reply-To: <20170202200632.13992-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Mike Galbraith <efault@gmx.de>, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, lvenanci@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Feb 2, 2017 at 12:06 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> This patchset implements cgroup v2 thread mode.  It is largely based
> on the discussions that we had at the plumbers last year.  Here's the
> rough outline.
>
> * Thread mode is explicitly enabled on a cgroup by writing "enable"
>   into "cgroup.threads" file.  The cgroup shouldn't have any child
>   cgroups or enabled controllers.
>
> * Once enabled, arbitrary sub-hierarchy can be created and threads can
>   be put anywhere in the subtree by writing TIDs into "cgroup.threads"
>   file.  Process granularity and no-internal-process constraint don't
>   apply in a threaded subtree.
>
> * To be used in a threaded subtree, controllers should explicitly
>   declare thread mode support and should be able to handle internal
>   competition in some way.
>
> * The root of a threaded subtree serves as the resource domain for the
>   whole subtree.  This is where all the controllers are guaranteed to
>   have a common ground and resource consumptions in the threaded
>   subtree which aren't tied to a specific thread are charged.
>   Non-threaded controllers never see beyond thread root and can assume
>   that all controllers will follow the same rules upto that point.
>
> This allows threaded controllers to implement thread granular resource
> control without getting in the way of system level resource
> partitioning.
>

I think that this is definitely a step in the right direction versus
previous proposals.
However, as proposed it feels like the API is conflating the
process/thread distinction with the core process hierarchy.  While
this does previous use-cases to be re-enabled, it seems to do so at an
unnecessary API cost.

As proposed, the cgroup.threads file means that threads are always
anchored in the tree by their process parent.  They may never move
past it.  I.e.
  If I have cgroups root/A/B
With B allowing sub-thread moves and the parent belonging to A, or B.
it is clear that the child cannot be moved beyond the parent.

Now this, in itself, is a natural restriction.  However, with this in
hand, it means that we are effectively co-mingling two hierarchies
onto the same tree: one that applies to processes, and per-process
sub-trees.

This introduces the following costs/restrictions:

1) We lose the ability to reasonably move a process.  This puts us
back to the existing challenge of the V1 API in which a thread is the
unit we can move atomically.  Hierarchies must be externally managed
and synchronized.

2) This retains all of the problems of the existing V1 API for a
process which wants to use these sub-groups to coordinate its threads.
It must coordinate its operations on these groups with the global
hierarchy (which is not consistently mounted) as well as potential
migration -- (1) above.

With the split as proposed, I fundamentally do not see the advantage
of exposing these as the same hierarchy.  By definition these .thread
files are essentially introducing independent, process level,
sub-hierarchies.

It seems greatly preferable to expose the sub-process level
hierarchies via separate path, e.g.:
  /proc/{pid, self}/thread_cgroups/

Any controllers enabled on the hierarchy that the process belonged to,
which support thread level operations would appear within.  This fully
addresses (1) and (2) while allowing us to keep the unified
process-granular v2-cgroup mounts as is.

The only case that this does not support vs ".threads" would be some
hybrid where we co-mingle threads from different processes (with the
processes belonging to the same node in the hierarchy).  I'm not aware
of any usage that looks like this.

What are the motivations that you see for forcing this all onto one
mount-point via .threads sub-tree tags?


> This patchset contains the following five patches.  For more details
> on the interface and behavior, please refer to the last patch.
>
>  0001-cgroup-reorganize-cgroup.procs-task-write-path.patch
>  0002-cgroup-add-flags-to-css_task_iter_start-and-implemen.patch
>  0003-cgroup-introduce-cgroup-proc_cgrp-and-threaded-css_s.patch
>  0004-cgroup-implement-CSS_TASK_ITER_THREADED.patch
>  0005-cgroup-implement-cgroup-v2-thread-support.patch
>
> This patchset is on top of cgroup/for-4.11 63f1ca59453a ("Merge branch
> 'cgroup/for-4.11-rdmacg' into cgroup/for-4.11") and available in the
> following git branch.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-threads
>
> diffstat follows.  Thanks.
>
>  Documentation/cgroup-v2.txt     |   75 ++++-
>  include/linux/cgroup-defs.h     |   38 ++
>  include/linux/cgroup.h          |   12
>  kernel/cgroup/cgroup-internal.h |    8
>  kernel/cgroup/cgroup-v1.c       |   64 +++-
>  kernel/cgroup/cgroup.c          |  589 ++++++++++++++++++++++++++++++++--------
>  kernel/cgroup/cpuset.c          |    6
>  kernel/cgroup/freezer.c         |    6
>  kernel/cgroup/pids.c            |    1
>  kernel/events/core.c            |    1
>  mm/memcontrol.c                 |    2
>  net/core/netclassid_cgroup.c    |    2
>  12 files changed, 671 insertions(+), 133 deletions(-)
>
> --
> tejun
