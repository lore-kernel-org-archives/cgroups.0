From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-4.6] cgroup: make control mask updates modular and recursive
Date: Mon, 22 Feb 2016 22:45:34 -0500
Message-ID: <1456199146-14765-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=w0Txupg5Y21WvXomzJ0KeGAxy2XE/GDP1jgdauwjC1Q=;
        b=yuEpq9pOd+AMLuKsD/Dkwafi8CnAPcd1Mg/dk5s/CmlwAIOZJZecAumA4rm38K+pof
         sVS3SKy9BqUB5CrFSHjCjn7ITxtXjxhAgZZ4K0U9ev1xU0DteVLKuZq2aDnifmIuPCtP
         f45ckAiZ4NVvo1WPA4j1S6gYRnyUpPQjDAijo0uVaoxwGTYAdaFXtKgZFHcMbac1PXy4
         Rtg0m5BnIWggbk84jlV6WEIu+niznOipcGp5aImnM9vAtYlVpSAPyvetlQFeYllJZQaF
         FQzau+MFusOkNWRZ07li1JIK06zR3upXrEosMl4S6Xa9weUyoxC/gEB7LmlPASOCWhka
         8YkQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

Currently, subsystem enabling and disabling in the default hierarchy
are implemented as a long chain of interdependent operations in
cgroup_subtree_control_write().  The function calculates what need to
be done to its children and excute the necessary operations.  The
function unfortunately ends up being a rather opaque blob of
operations which is difficult to wrap one's head around or reuse.

This patchset restructures control mask update so that it's composed
of discrete idempotent and recursive operations.  While no new
features are added by this patchset, future changes will make use of
flexible control mask updates to implement features involving more
complex controller management.

This patchset includes the following 12 patches.

 0001-cgroup-separate-out-interface-file-creation-from-css.patch
 0002-cgroup-explicitly-track-whether-a-cgroup_subsys_stat.patch
 0003-cgroup-reorder-operations-in-cgroup_mkdir.patch
 0004-cgroup-factor-out-cgroup_create-out-of-cgroup_mkdir.patch
 0005-cgroup-introduce-cgroup_control-and-cgroup_ss_mask.patch
 0006-cgroup-factor-out-cgroup_drain_offline-from-cgroup_s.patch
 0007-cgroup-factor-out-cgroup_apply_control_disable-from-.patch
 0008-cgroup-factor-out-cgroup_apply_control_enable-from-c.patch
 0009-cgroup-make-cgroup_drain_offline-and-cgroup_apply_co.patch
 0010-cgroup-introduce-cgroup_-save-propagate-restore-_con.patch
 0011-cgroup-Factor-out-cgroup_-apply-finalize-_control-fr.patch
 0012-cgroup-make-cgroup_calc_subtree_ss_mask-take-this_ss.patch

The patchset is on top of cgroup/for-4.6 6e5c830770f ("cgroup: make
cgroup subsystem masks u16") and available in the following git
branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-recursive-control

diffstat follows.  Thanks.

 include/linux/cgroup-defs.h |    3 
 kernel/cgroup.c             |  653 ++++++++++++++++++++++++++++----------------
 2 files changed, 419 insertions(+), 237 deletions(-)

--
tejun
