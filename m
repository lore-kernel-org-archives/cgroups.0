From: Raghavendra KT <raghavendra.kt.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement unified hierarchy, v2
Date: Wed, 30 Apr 2014 16:22:13 +0530
Message-ID: <CAC4Lta22tg2Kw82=m5_axB3sfY-bEiP8N==tSOAehgAqw46KGQ@mail.gmail.com>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=g2+2taJUfGpnLOaPYr+CHSMeIbDRxnirt3g7qRv1/ss=;
        b=PLOAIIjNPP4r7mx+8E3qeniyzdRw+5NiG6vDrkpo6uwHJj25//EhyBk+oaJnRxwuma
         MA0brWgYJQjHceWkjPNruPdoTaVw6sPWik0z7XqUygryM5gFMrAEq/WDiaa/Fky0QX3n
         J3NM5GHFyzr1boM9m/w1sDxRjbS2ss+rZPp+qvkFhZcSHKsDKo6swIA7RzRT5oZsBnem
         ob+hr87d/WTxnUPEEuURI5SynLHY4Y5oxzyln9/gl3a+EXaKbVr0e0Lj9FAbRFp4/WqC
         9GW2LoDi2PeLWpJbz44cCMUxb583l+NOXkQXtsXDZsG5cr+e6yr3+yeeA3gwbhXQh1z0
         UuaA==
In-Reply-To: <1397511430-2673-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Apr 15, 2014 at 3:06 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> This is v2 of the unified hierarchy patchset.  Changes from v1[1] are,
>
> * Rebased on top of v3.15-rc1
>
> * Interface file "cgroup.controllers" which was only available in the
>   root is now available in all cgroups.  This allows, e.g., a
>   sub-manager in charge of a subtree to tell which controllers are
>   available to it.
>
> cgroup currently allows creating arbitrary number of hierarchies and
> any number of controllers may be associated with a given tree.  This
> allows for huge amount of variance how tasks are associated with
> various cgroups and controllers; unfortunately, the variance is
> extreme to the extent that it unnecessarily complicates capabilities
> which can otherwise be straight-forward and hinders implementation of
> features which can benefit from coordination among different
> controllers.
>
> Here are some of the issues which we're facing with the current
> multiple hierarchies.
>
> * cgroup membership of a task can't be described in finite number of
>   paths.  As there can be arbitrary number of hierarchies, the key
>   describing a task's cgroup membership can be arbitrarily long.  This
>   is painful when userland or other parts of the kernel needs to take
>   cgroup membership into account and leads to proliferation of
>   controllers which are just there to identify membership rather than
>   actually control resources, which in turn exacerbates the problem.
>
> * Different controllers may or may not reside on the same hierarchy.
>   Features or optimizations which can benefit from sharing the
>   hierarchical organization either can't be implemented or becomes
>   overly complicated.
>
> * Tasks of a process may belong to different cgroups, which doesn't
>   make any sense for some controllers.  Those controllers end up
>   ignoring such configurations in their own ways leading to
>   inconsistent behavior.  In addition, in-process resource control
>   fundamentally isn't something which belongs to cgroup.  As it has to
>   be visible to the binary for the process, it must be part of the
>   stable programming interface which is easily accessible to the
>   process proper in an easy race-free way.
>
> * The current cgroup allows cgroups which have child cgroups to have
>   tasks in it.  This means that the child cgroups end up competing
>   against the internal tasks.  This introduces inherent ambiguity as
>   the two are separate types of entities and the latter doesn't have
>   the same control knobs assigned to them.
>
>   Different controllers are dealing with the issue in different ways.
>   cpu treats internal tasks and child cgroups as equivalents, which
>   makes giving a child cgroup a given ratio of the parent's cpu time
>   difficult as the number of competing entities may fluctuate without
>   any indication.  blkio, in my misguided attempt to deal with the
>   issue, introduced a whole duplicate set of knobs for internal tasks
>   and deal with them as if they belong to a separate child cgroup
>   making the interface and implementation a mess.  memcg seems
>   somewhat ambiguous on the issue but there are attempts to introduce
>   ad-hoc modifications to tilt the way it's handled to suit specific
>   use cases.
>
>   This is an inherent problem.  All of the solutions that different
>   controllers came up with are unsatisfactory, the different behaviors
>   greatly increases the level of inconsistency and complicates the
>   controller implementations.
>
> This patchset finally implements the default unified hierarchy.  The
> goal is providing enough flexibility while enforcing stricter common
> structure where appropriate to address the above listed issues.
>
> Controllers which aren't bound to other hierarchies are
> automatically attached to the unified hierarchy, which is different in
> that controllers are enabled explicitly for each subtree.
> "cgroup.subtree_control" controls which controllers are enabled on the
> child cgroups.  Let's assume a hierarchy like the following.
>
>   root - A - B - C
>                \ D
>
> root's "cgroup.subtree_control" determines which controllers are
> enabled on A.  A's on B.  B's on C and D.  This coincides with the
> fact that controllers on the immediate sub-level are used to
> distribute the resources of the parent.  In fact, it's natural to
> assume that resource control knobs of a child belong to its parent.
> Enabling a controller in "cgroup.subtree_control" declares that
> distribution of the respective resources of the cgroup will be
> controlled.  Note that this means that controller enable states are
> shared among siblings.
>
> The default hierarchy has an extra restriction - only cgroups which
> don't contain any task may have controllers enabled in
> "cgroup.subtree_control".  Combined with the other properties of the
> default hierarchy, this guarantees that, from the view point of
> controllers, tasks are only on the leaf cgroups.  In other words, only
> leaf csses may contain tasks.  This rules out situations where child
> cgroups compete against internal tasks of the parent.
>
> This patchset contains the following twelve patches.
>
>  0001-cgroup-update-cgroup-subsys_mask-to-child_subsys_mas.patch
>  0002-cgroup-introduce-effective-cgroup_subsys_state.patch
>  0003-cgroup-implement-cgroup-e_csets.patch
>  0004-cgroup-make-css_next_child-skip-missing-csses.patch
>  0005-cgroup-reorganize-css_task_iter.patch
>  0006-cgroup-teach-css_task_iter-about-effective-csses.patch
>  0007-cgroup-cgroup-subsys-should-be-cleared-after-the-css.patch
>  0008-cgroup-allow-cgroup-creation-and-suppress-automatic-.patch
>  0009-cgroup-add-css_set-dfl_cgrp.patch
>  0010-cgroup-update-subsystem-rebind-restrictions.patch
>  0011-cgroup-prepare-migration-path-for-unified-hierarchy.patch
>  0012-cgroup-implement-dynamic-subtree-controller-enable-d.patch
>
> 0001 updates subsys_mask handling again to morph cgrp->subsys_mask to
> cgrp->child_subsys_mask.
>
> 0002-0003 introduce effective cgroup.  The cgroup on the unified
> hierarchy a task belongs to when viewed from a controller.
>
> 0004-0007 update iterators to handle effective cgroup correctly.
>
> 0008-0011 prepare various paths for explicit controller
> enable/disable.
>
> 0012 implements explicit controller enable/disable.
>
> The patchset is on top of cgroup/for-3.15 01a971406177 ("cgroup: Use
> RCU_INIT_POINTER(x, NULL) in cgroup.c") and also available in the
> following git branch.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-unified-v2
>

I have done the functional verification of above branch.  unified hierarchy
changes works as per mentioned above (and documentation patch posted later).

(thought better to report formally than never though it is late to report :) )
