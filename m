From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] cgroup: misc fixes and cleanups
Date: Mon, 22 Feb 2016 18:05:43 -0500
Message-ID: <1456182349-18156-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=V/RDAHu4jZYcv05xM55T3A/SCyaneTwm4HfGAJNso3w=;
        b=PTtn7C5UMYIEpf/13x8XOlgmxXKIcEAAV4BL1eYVurmkyH6nO9cdqG/d1azMBqs7e/
         4XNkvZVYqHZg75GgqlPsluqhbiLZ0E10fD1gDenoiMTahsX53Ld6kUtd09duxzTmqrr9
         w+0sBePZVVAbHgdeSCLHMkUP0/Pp8g7egsenJdTXEd85g4YaocjwVmuVpEE1VSNRRaNh
         PxwNwunu0piYg9ZlxbaCesTgnm+u4Lr1qqXXVhwkFBRAxs9VZdTtjSCNGoIU/jtPYetu
         y+Sz9SMTrXo7cSSAynhf2R4/6hn/JukiaRQP9Xqht8M7h5OkThFcDY1WKWt7lX+0mC64
         Mngw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

This patchset contains the following six patches.  The first one is a
fix but should be safe to route through for-4.6.  The rest are misc
cleanups and improvements which don't cause notable behavior changes.

 0001-cgroup-fix-error-return-value-of-cgroup_addrm_files.patch
 0002-Revert-cgroup-add-cgroup_subsys-css_e_css_changed.patch
 0003-cgroup-s-child_subsys_mask-subtree_ss_mask.patch
 0004-cgroup-convert-for_each_subsys_which-to-do-while-sty.patch
 0005-cgroup-use-do_each_subsys_mask-where-applicable.patch
 0006-cgroup-make-cgroup-subsystem-masks-u16.patch

The patchset based on top of cgroup/for-4.6 223ffb29f972 ("cgroup:
provide cgroup_nov1= to disable controllers in v1 mounts") and is
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-misc

diffstat follows.  I'll pull in the branch into cgroup/for-4.6
soonish.

 include/linux/cgroup-defs.h |   12 +-
 kernel/cgroup.c             |  217 +++++++++++++++++++-------------------------
 2 files changed, 102 insertions(+), 127 deletions(-)

Thanks.

--
tejun
