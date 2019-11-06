From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET block/for-next] blk-cgroup: use cgroup rstat for IO stats
Date: Wed,  6 Nov 2019 13:58:33 -0800
Message-ID: <20191106215838.3973497-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=F/vADG/hnX91+J7ThLwtAYWMOuLxbrgnZjiawQ6+D0Y=;
        b=q2VSHe3BIF6UMDNGvfoCyruwPT+QTt7bIiqj/Y/OpXbDSN0H/U6rXx/s4A9GuWg6nf
         px5rMM7KojYnyD9UkV5rleMeAiTaArnzKPjm55t/uKy9bToVgsHZukBqS1WD72CIFBFZ
         zit7QP2NUwWuasFdJ09cPZjAYFv58s3yI9g6800mPgTIYB9BMUv0zz3EIuXlxFjoc0wL
         kqierf07zxhTkBXeUfX/pV0sD84YyyNrlB5QceyrGZGEa/pCMeYEySW/g9XZ3skC5+Rc
         Bs+2hGyrGuzAVsC82EL3/TMXo27JW6qboUrG9R/FURdupwEbwBrM3F1Rk/5tOvZ6SBPo
         iO9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, kernel-team@fb.com

Hello,

blk-cgroup IO stats currently use blkg_rwstat which unforutnately
requires walking all descendants recursively on read.  On systems with
a large number of cgroups (dead or alive), this can make each stat
read a substantially expensive operation.

This patch updates blk-cgroup to use cgroup rstat which makes stat
reading O(# descendants which have been active since last reading)
instead of O(# descendants).

 0001-bfq-iosched-stop-using-blkg-stat_bytes-and-stat_ios.patch
 0002-blk-throtl-stop-using-blkg-stat_bytes-and-stat_ios.patch
 0003-blk-cgroup-remove-now-unused-blkg_print_stat_-bytes-.patch
 0004-blk-cgroup-reimplement-basic-IO-stats-using-cgroup-r.patch
 0005-blk-cgroup-separate-out-blkg_rwstat-under-CONFIG_BLK.patch

0001-0002 make bfq-iosched and blk-throtl use their own blkg_rwstat to
track basic IO stats on cgroup1 instead of sharing blk-cgroup core's.
0003 is a follow-up cleanup.

0004 switches blk-cgroup to cgroup rstat.

0005 moves blkg_rwstat to its own files and gate it under a config
option as it's now only used by blk-throtl and bfq-iosched.

The patchset is on top of

  for-next/block 257855f86aa2 ("Merge branch 'for-5.4/block' into for-next")
+ [1] blkcg: make blkcg_print_stat() print stats only for online blkgs

and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-blkcg-rstat

Thanks.

 block/Kconfig              |    4 
 block/Kconfig.iosched      |    1 
 block/Makefile             |    1 
 block/bfq-cgroup.c         |   37 +++--
 block/bfq-iosched.c        |    4 
 block/bfq-iosched.h        |    6 
 block/blk-cgroup-rwstat.c  |  129 +++++++++++++++++++
 block/blk-cgroup-rwstat.h  |  149 ++++++++++++++++++++++
 block/blk-cgroup.c         |  304 ++++++++++++++-------------------------------
 block/blk-throttle.c       |   71 +++++++++-
 include/linux/blk-cgroup.h |  198 +++++------------------------
 11 files changed, 517 insertions(+), 387 deletions(-)

--
tejun

[1] http://lkml.kernel.org/r/20191105160951.GS3622521@devbig004.ftw2.facebook.com

