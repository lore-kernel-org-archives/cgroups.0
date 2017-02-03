From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Fri, 3 Feb 2017 21:20:48 +0100
Message-ID: <20170203202048.GD6515@twins.programming.kicks-ass.net>
References: <20170202200632.13992-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170202200632.13992-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Thu, Feb 02, 2017 at 03:06:27PM -0500, Tejun Heo wrote:
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


I'm still confused. So suppose I mark my root cgroup as such, because I
run RT tasks there. Does this then mean I cannot later start a VM and
have that containered properly? That is, I think threaded controllers
very much get in the way of system level source partitioning this way.


So my proposal was to do the inverse of what you propose here. Instead
of marking special 'thread' subtrees, explicitly mark resource domains
in the tree.

So always allow arbitrary hierarchies and allow threads to be assigned
to cgroups, as long as they're all in the same resource domain.

Controllers that do not support things, fallback to mapping everything
to the nearest resource domain.
