From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET cgroup/for-4.6] cgroup: update migration destination cgroup handling
Date: Thu,  3 Mar 2016 12:19:58 -0500
Message-ID: <1457025602-4193-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=vWS7dPfANFRcHK7qyWlvs2vokhBrdKLDyX2Dc1D01OM=;
        b=KwokVBjXgNuBt+UMBVxxrqFNG9xtA4pvMV6rQOZGilkY5uddOqk0Uof8IvvR68IVtV
         PMGCwiXMTmiZm+nkVn9ZNdaPrzGcUDjdTV9S44WMAh5+/oZB5jZnUUXtMpKj191kmql2
         n13Uil17+hoSlv2gPDod39ub4EL9fCU2mBwhC3IUJWCM3GrC3dbgAJxdwZtfsXpGU0pf
         drjiAPpe+IIQMZ5zr6ekSQdfIqA75+w5lbNbpYWOsconehs7kvvO6OK+6CP2RxZ2L0Ez
         Mxxpb933moD8uyxBlYM1x+ITYrJOnbM8fCsiH7Y9CTwiy8nfxgyt8rQougFgq+pbs3NY
         jE1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello,

cgroup migrations used to always be single destination.  There could
be multiple sources but there was only one destination cgroup.  This
changed with default hierarchy as enabling a controller would move
processes in child cgroups into separate csses.  This was developed
over time and is working correctly now but the way multiple
destinations are handled is hacky and fragile.  This patchset updates
migration logic so that multi-destination handling is integral.

This patchset contains the following four patches.

 0001-cgroup-fix-incorrect-destination-cgroup-in-cgroup_up.patch
 0002-cgroup-move-migration-destination-verification-out-o.patch
 0003-cgroup-make-cgroup-_taskset-_migrate-take-cgroup_roo.patch
 0004-cgroup-use-css_set-mg_dst_cgrp-for-the-migration-tar.patch

It's based on cgroup/for-4.6 549626047df9 ("cgroup: update css
iteration in cgroup_update_dfl_csses()") and available on the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-dst-updates

diffstat follows.

 include/linux/cgroup-defs.h |    9 +--
 kernel/cgroup.c             |  126 ++++++++++++++++++++++++--------------------
 2 files changed, 74 insertions(+), 61 deletions(-)

Thanks.
