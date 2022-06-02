From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 0/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Thu,  2 Jun 2022 15:20:17 -0400
Message-ID: <20220602192020.166940-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654197647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sUxMFBKWaF9vGh8gLEcG6jV1Ek/oQgsX0FVxKot2COA=;
        b=W/ezvFq0h7i/L/uv/u5qGwgOwwGMX9OkHr/gDQ/uIUiOrnf3bRaN7ThhT8MiLhN0HMHPMk
        Uaxlj3FtnpLPsqyTykEDWnXQXMOP3xJjFXbjPwLcvrih+WM/q5uUk5eeh7R/SjQ1GgkAQ3
        qYVBOxMVG0C/jhWkbsxU1MjzBJahtYk=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v6:
  - Add a missing free_percpu() into blkcg_css_free() in patch 3.
  - Integrating the documentation patch 4 back into patch 3.

 v5:
  - Add a new patch 2 to eliminate the use of intermediate "ret"
    variable in blkcg_css_alloc() to fix compilation warning reported
    by kernel test robot.

 v4:
  - Update comment and eliminate "inline" keywords as suggested by TJ.

 v3:
  - Update comments in patch 2.
  - Put rcu_read_lock/unlock() in blkcg_rstat_flush().
  - Use READ_ONCE/WRITE_ONCE() to access lnode->next to reduce data
    races.
  - Get a blkg reference when putting into the lockless list and put it
    back when removed.
 
This patch series improves blkcg_rstat_flush() performance by eliminating
unnecessary blkg enumeration and flush operations for those blkg's and
blkg_iostat_set's that haven't been updated since the last flush.

Waiman Long (3):
  blk-cgroup: Correctly free percpu iostat_cpu in blkg on error exit
  blk-cgroup: Return -ENOMEM directly in blkcg_css_alloc() error path
  blk-cgroup: Optimize blkcg_rstat_flush()

 block/blk-cgroup.c | 119 +++++++++++++++++++++++++++++++++++++++------
 block/blk-cgroup.h |   9 ++++
 2 files changed, 112 insertions(+), 16 deletions(-)

-- 
2.31.1

