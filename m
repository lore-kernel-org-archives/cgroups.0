From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET RESEND v2] cgroup: simplify cgroup removal path
Date: Wed, 31 Oct 2012 12:44:02 -0700
Message-ID: <1351712650-23709-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=X6dsZ+UeOV8HbcainSIPEMd++WpC0IJHcwr9BWYzQ2I=;
        b=ayGR5SHPRCoW/S+gr0Sbtz1sL6y1mvdsQYPBRmdcJDXOLYuNt2Z0uVZsGpb30JSRfD
         EWssa66nB6ydLdHDzeUCd9qxMDyT0tDLvATsyCysRoeQ0EAYHMmUxckmpiKYs0VeHOD5
         7DdoMiZJbRoo2S/IyYRYtRI4mRiwFOvtVxQuiXGknGLhvmx63rMzar4/cmJOLkpjsAun
         yKVnPt66SyE31seqmS5gLvjsFKMeuGmPJF8qDy0g4EzBtbShYflJP5LEyM7VicEXMePk
         A6FE9ypQRmY7/hhVzlwxFOnD5mvmwDF6Iv/dFNnHlgOQ+5oK2eh1b04bRY7Io4tIKome
         K9yg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(Resending because the previous posting went out with patches from v1)

Hello, guys.

Changes from the last posting[L] are,

* cgroup_call_pre_destroy() removal moved from 0001 to 0004 per
  Michal.

* Comment and commit message updates per Glauber and Michal.

Original head message follows.

cgroup removal path is quite ugly.  A lot of the ugliness comes from
the weird design which allows ->pre_destroy() to fail and the feature
to drain existing CSS reference counts before committing to removal.
Both mean that it should be possible to roll-back cgroup destruction
after some or all ->pre_destroy() invocations.

This weird design has never really worked.  To list a couple examples.

 * Some ->pre_destroy() implementations aren't side-effect free.
   Roll-back happens after a lot of state is already lost.

 * Some ->pre_destroy() implementations (naturally) assume that the
   cgroup being destroyed would stay quiescent between successful
   ->pre_destroy() and its destruction.  Unfortunately, any operation
   can happen inbetween and the cgroup could be in a very different
   state by the time it actually gets destroyed.

It's just such an unusual design which unnecessarily contains weird
code path combinations which are tricky to hit, reproduce and expect.
Moreover, the design's deficiencies attracts kludges on top as
workarounds and we end up with stuff like cgroup_exclude_rmdir() and
cgroup_release_and_wakeup_rmdir() which really make me want to cry.

Now that memcg has moved away from failable ->pre_destroy(), we can do
away with all these.  I tested some basic operations and some corner
cases but am still a bit scared.  Would love to get acks from Li and
memcg people.

This patchset contains the following eight patches.

 0001-cgroup-kill-cgroup_subsys-__DEPRECATED_clear_css_ref.patch
 0002-cgroup-kill-CSS_REMOVED.patch
 0003-cgroup-use-cgroup_lock_live_group-parent-in-cgroup_c.patch
 0004-cgroup-deactivate-CSS-s-and-mark-cgroup-dead-before-.patch
 0005-cgroup-remove-CGRP_WAIT_ON_RMDIR-cgroup_exclude_rmdi.patch
 0006-memcg-make-mem_cgroup_reparent_charges-non-failing.patch
 0007-hugetlb-do-not-fail-in-hugetlb_cgroup_pre_destroy.patch
 0008-cgroup-make-pre_destroy-return-void.patch

0001-0002 remove now unused ->pre_destroy() failure handling and do
follow-up simplification.

0003-0004 update removal path such that each ->pre_destroy() is
guaranteed to be invoked once per removal and the cgroup being
destroyed stays quiescent until destruction is complete.

0005 removes the scary CGRP_WAIT_ON_RMDIR mechanism.

0006-0008 are follow-up clean-ups.  0006 and 0007 are from Michal's
patchset[1].

This patchset is on top of

  v3.6 (a0d271cbfe)
+ [1] the first three patches of
      "memcg/cgroup: do not fail fail on pre_destroy callbacks" patchset

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-rmdir-updates

Thanks.

 block/blk-cgroup.c     |    3 
 include/linux/cgroup.h |   41 -------
 kernel/cgroup.c        |  256 +++++++++++--------------------------------------
 mm/hugetlb_cgroup.c    |   11 --
 mm/memcontrol.c        |   51 +--------
 5 files changed, 75 insertions(+), 287 deletions(-)

--
tejun

[L] http://www.spinics.net/lists/linux-containers/msg26157.html
[1] http://thread.gmane.org/gmane.linux.kernel.cgroups/4757
