From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-3.8] cgroup_freezer: allow migration regardless of freezer state and update locking
Date: Tue, 16 Oct 2012 15:28:39 -0700
Message-ID: <1350426526-14254-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=2jvCL5uXUneMwLkroxUElbk+tKeqSM6Y4CWays7dnG8=;
        b=zgSNBlLDAajNijOCI/xRC4mgR8B0NUkSQTNJ8SPwZLWFHpfEZ/Nh6EiuzZRFsnWhc7
         l/6dxO1uhw/d7xwdiymd159Em2HndtIk8K6uutDcV5FgI7DQ5W98KspCw20hNTiko/id
         /raxLDpaRiM3WySB33LnV3+yvrih1KaXPi0izemtjU7+/r1Hv0CnjTSAyOTG3Si2aSjl
         l0JHiEHISwudylVY9wkncjSmuOFEV2+onM2C7NV6uepDb0zl4O+nVZTeHO4xiTD32TEm
         KeFEwQb+aA9alsFmCoWGs+z7arV+JteKmKYhSk5Q2Ntrd8SJdgVhnpmks4uD0tXmP6Hd
         w2ZQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: rjw-KKrjLPT3xs0@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

This patchset updates cgroup_freezer so that

* Unfreezable kernel tasks don't prevent a cgroup from transitioning
  into FROZEN from FREEZING.  There's nothing userland can do with or
  about such tasks.

* Tasks can be moved in and out of a frozen cgroup.  Tasks are made to
  conform to the state of the new cgroup during migration.  This
  behavior makes a lot more sense and removes the use of
  ->can_attach() which makes co-mounting difficult.

* Remove use of cgroup_lock_live_group().  Grabbing cgroup_lock from
  outside cgroup proper creates a painful locking dependency and is
  being phased out.  With the above behavior change, removing
  dependency on cgroup_lock is pretty easy.  IMHO, it was simply the
  wrong behavior to implement which forced the wrong implementation.

This patchset contains the following seven patches.

 0001-cgroup-cgroup_subsys-fork-should-be-called-after-the.patch
 0002-freezer-add-missing-mb-s-to-freezer_count-and-freeze.patch
 0003-cgroup_freezer-make-it-official-that-writes-to-freez.patch
 0004-cgroup_freezer-don-t-stall-transition-to-FROZEN-for-.patch
 0005-cgroup_freezer-allow-moving-tasks-in-and-out-of-a-fr.patch
 0006-cgroup_freezer-prepare-update_if_frozen-for-locking-.patch
 0007-cgroup_freezer-don-t-use-cgroup_lock_live_group.patch

0001 is a fix for a rather embarrassing bug in cgroup core.  It does
things in the wrong order leaving a window for racing during fork.

0002 adds a missing mb() around freezing condition updates / checks.

0003-0004 make cgroup_freezer ignore unfreezable kernel tasks and
handle PF_FREEZER_SKIP correctly.

0005 allows migrating tasks in and out of a frozen cgroup.

0006-0007 remove the use of cgroup_lock_live_group().

This patchset is on top of v3.7-rc1 and available in the following git
branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup_freezer-locking

 include/linux/cgroup.h  |    1 
 include/linux/freezer.h |   50 +++++++++--
 kernel/cgroup.c         |   62 ++++++--------
 kernel/cgroup_freezer.c |  210 ++++++++++++++++--------------------------------
 kernel/fork.c           |    9 --
 5 files changed, 147 insertions(+), 185 deletions(-)

Thanks.

--
tejun
