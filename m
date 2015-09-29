From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET block/for-linus] writeback: cgroup writeback fixes
Date: Tue, 29 Sep 2015 12:47:49 -0400
Message-ID: <1443545274-18787-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=BYZDrtWiJG3eESIjeB9ISywHkwEP5Mvtb7x2r2TWEIk=;
        b=CYUOwTfsAhRBTc9G3rVc8vGvEeirxlpYcNQWL0fKZIPouhKc/QAtJ2Nopc8E2rJGy5
         8pGfvBo0UD4GRZBtx2ofHrj0gMsEKBvkgfjHczwzAi37Ef9YrnbrhyC0+J04Ar5atree
         BI5AK8uon/G7PGUv56JoY6shd95yHVB+zBo6RSVABkmUo0A3NXX6LJkJji2d82tTZhnC
         VxsmiY6eJP05Kxiff+7m0yJy/V5v6na4DLQd5sfiJ3nEvodsdBjac3F1w9+bGsfmhPGb
         AMEW9BbZpf+ZtYbLEBuKm6cgEBqMX49m1Qi4U7wDaS4DzcQ5owTKG2GVjIFDftQfLPuZ
         f32Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

This patchset contains the following five patches fixing bugs in
cgroup writeback support.

 0001-writeback-laptop_mode_timer_fn-needs-rcu_read_lock-a.patch
 0002-writeback-fix-bdi_writeback-iteration-in-wakeup_dirt.patch
 0003-writeback-bdi_writeback-iteration-must-not-skip-dyin.patch
 0004-writeback-memcg-dirty_throttle_control-should-be-ini.patch
 0005-writeback-fix-incorrect-calculation-of-available-mem.patch

0001 affects laptop_mode users.  0002-0005 affect users who enable
cgroup writeback support.

This patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgwb-4.3-fixes

diffstat follows.  Thanks.

 fs/fs-writeback.c                |   32 +++++++++++++------
 include/linux/backing-dev-defs.h |    3 +
 include/linux/backing-dev.h      |   63 ---------------------------------------
 include/linux/memcontrol.h       |    5 +--
 mm/backing-dev.c                 |   17 +++++++++-
 mm/memcontrol.c                  |   35 ++++++++++-----------
 mm/page-writeback.c              |   54 +++++++++++++++++++--------------
 7 files changed, 92 insertions(+), 117 deletions(-)

--
tejun
