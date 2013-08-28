From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-3.12] cgroup: factor out css creation into create_css()
Date: Wed, 28 Aug 2013 17:03:40 -0400
Message-ID: <1377723829-22814-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=XeLthkJ3miGYqlcmd/Dp5sgBFf1rs1ZQakl/2RNFz10=;
        b=bPmHF/4uLag1JPhQFq9t6+e8UmNkwWl0zY9Q9/mW2MFIYa6lRt8He0SaZOsqbQQLdc
         KxaYb/Cmt2gLW/qtlNhl4Xbh18dq4GC5idAD+WWeSYdscMX49Rh36n7Kur2fYghu+sdK
         gc2YCPmaaqHvkS78ODrqLi0l2K9w0Dt4dTvUHRnz5W26oCuFt484+GsZx7zkUf0gs2+V
         1QMbaABHSmx3rV+v2jniqALeKDcJTKAUST0F3qRGc8BNuWGu27ASMcN8liyi/tA7uUC3
         ejsTE1mLMnaUd6HKw3YQ6hC1mK+Osp2w+8RhKZ+ZG6DFmxrsqIxcTxbviwFhCt3toS4s
         1MZQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

For unified hierarchy, a css's (cgroup_subsys_state) lifetime will be
different from that of the associated cgroup.  css's may be created
and destroyed dynamically over the lifetime of a single cgroup.  The
previous changes decoupled css destruction from cgroup's.  This
patchset decouples css creation from cgroup's.

This patchset contains the following nine patches.

 0001-cgroup-fix-css-leaks-on-online_css-failure.patch
 0002-cgroup-css-iterations-and-css_from_dir-are-safe-unde.patch
 0003-cgroup-make-for_each_subsys-useable-under-cgroup_roo.patch
 0004-cgroup-move-css_id-commit-from-cgroup_populate_dir-t.patch
 0005-cgroup-reorder-operations-in-cgroup_create.patch
 0006-cgroup-combine-css-handling-loops-in-cgroup_create.patch
 0007-cgroup-factor-out-cgroup_subsys_state-creation-into-.patch
 0008-cgroup-implement-for_each_css.patch
 0009-cgroup-remove-for_each_root_subsys.patch

0001 is a fix for an existing leak issue in the creation error
handling path.

0002-0004 are prep patches.  Note that 0004 will conflict with css_id
removal patch.

0005-0007 collect css creation operations into single loop and factor
it out into create_css().

0008-0009 are somewhat tangential.  As everything is css based now and
the enabled set of css's might be differ depending on the specific
cgroup in the future, they introduce for_each_css() and replace most
uses of for_each_root_subsys() with it.  The two left overs are
opencoded and for_each_root_subsys() and the related logic are
removed.

This patchset shouldn't bring any userland noticeable behavior
changes.  It's on top of cgroup/for-3.12 d1625964da ("cgroup: fix
cgroup_css() invocation in css_from_id()") and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-create_css

diffstat follows.

 include/linux/cgroup.h |   10 -
 kernel/cgroup.c        |  348 ++++++++++++++++++++++++++-----------------------
 2 files changed, 187 insertions(+), 171 deletions(-)

Thanks.

--
tejun
