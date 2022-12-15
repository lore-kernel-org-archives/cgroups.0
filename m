From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/2] blk-cgroup: Fix potential UAF & flush rstat at blkgs destruction path
Date: Wed, 14 Dec 2022 22:31:30 -0500
Message-ID: <20221215033132.230023-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671075117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=veCyvm43EvJLg9G9hhu4AmM7THRxqVqHEQtr8ufuCSo=;
        b=iJoJqwZ+7thbe+rwo3QNBWbueHh9VCFIGkejROPzRkVSbsPAojqqecLxoH6F6mSEZzjqXr
        TxeFq9SpJQnlbIYxgBQczKUi9MpqTKxuLiLK4Hab5L4Egukt+WXlLHkq8m4n9XuB4vAhK2
        wgm9OY5q3R2ztYNeHN1nLVTdSQKjk1c=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "Dennis Zhou (Facebook)" <dennisszhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v4:
  - Update comment and commit logs for both patches.

 v3:
  - Drop v2 patch 2 as it may not be needed.
  - Replace css_tryget() with percpu_ref_is_zero() in patch 1 as
    suggested by Tejun.
  - Expand comment on patch 2 to elaborate the reason for this patch.

 v2:
  - Remove unnecessary rcu_read_{lock|unlock} from
    cgroup_rstat_css_cpu_flush() in patch 3.

It was found that blkcg_destroy_blkgs() may be called with all blkcg
references gone. This may potentially cause user-after-free and so should
be fixed. The second patch flushes rstat when calling blkcg_destroy_blkgs().

Waiman Long (2):
  bdi, blk-cgroup: Fix potential UAF of blkcg
  blk-cgroup: Flush stats at blkgs destruction path

 block/blk-cgroup.c     | 23 +++++++++++++++++++++++
 include/linux/cgroup.h |  1 +
 kernel/cgroup/rstat.c  | 18 ++++++++++++++++++
 mm/backing-dev.c       |  8 ++++++--
 4 files changed, 48 insertions(+), 2 deletions(-)

-- 
2.31.1

