From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET block/for-4.3] writeback: cgroup writeback updates
Date: Tue,  7 Jul 2015 11:10:18 -0400
Message-ID: <1436281823-1947-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=ZPrXXvUB0UFrfZSAfsnkC3d8KRvxJQd1TSkGKPd5yPU=;
        b=rW5hEW3gwtIcQtHIZlzyupPt081QBIVyaNsZ4Qq7xBEyOHAVOjdJ4lkLb/Ek24Fhqr
         3CU85g8FCAmTfkxbOPRELJY5L83Fr6ACP/4+h1TOzg03r9cwO2ceVZvEbJjddCTIBmJz
         +vVe9tPVWGj9AksFaaLZWK9r33utLlNczZ1gQ4h2Dln/6JkurQcB1+Vq/Ctq8dEbz53L
         6uKw0LLI7gBC30TsoZJeFp0gQRitt4DJXYE3rvqGwyV7cjIDQInC55FkCyEI3dwiZ7PV
         kprqVnPr6/bv0LkjlAx951/Ah7O9qbh5mpo77Hfs4v1YHUN2Dx1VeZ1qydgM1UlQbOZD
         sPWQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

This patchset contains the following updates to cgroup writeback
support

* bdi_writeback iteration fix which could lead to some wb's being
  skipped or repeated during e.g. sync under memory pressure.

* Simplification of wb work wait mechanism.

* Writeback tracepoints updated to report cgroup.

and is consisted of the following five patches.

 0001-writeback-bdi_for_each_wb-iteration-is-memcg-ID-base.patch
 0002-writeback-remove-wb_writeback_work-single_wait-done.patch
 0003-writeback-explain-why-inode-is-allowed-to-be-NULL-fo.patch
 0004-kernfs-implement-kernfs_path_len.patch
 0005-writeback-update-writeback-tracepoints-to-report-cgr.patch

The patchset is on top of d770e558e219 ("Linux 4.2-rc1") and available
in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-writeback-updates-for-4.3

diffstat follows.  Thanks.

 fs/fs-writeback.c                |  139 +++++++++---------------------
 fs/kernfs/dir.c                  |   23 ++++
 include/linux/backing-dev.h      |   24 ++---
 include/linux/kernfs.h           |    4 
 include/trace/events/writeback.h |  180 ++++++++++++++++++++++++++++++---------
 mm/page-writeback.c              |    6 -
 6 files changed, 226 insertions(+), 150 deletions(-)

--
tejun
