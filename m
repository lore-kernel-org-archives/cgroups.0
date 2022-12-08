From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH-block 0/3] blk-cgroup: Fix potential UAF & miscellaneous cleanup
Date: Thu,  8 Dec 2022 17:01:38 -0500
Message-ID: <20221208220141.2625775-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=l3gdci1jA2BCwxv28dvvVRPMpXIO7QcJKVqY3sRM16E=;
        b=Q1066CIWzlYmcW3VKBr40mwrmMDQHAQGAsIZXva3ejHMy+gIkwBpsA8Chact6yuAjlNDSi
        bKPDk66vYuItIogdyP2Obdk+DtPDdLQ+W5eCtNSlszCyIv3OIz7gjvzgSBdnB5aavO7UoB
        tN8mh1uxWRe4iyPzktCFZljS0ewddHo=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "Dennis Zhou (Facebook)" <dennisszhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It was found that blkcg_destroy_blkgs() may be called with all blkcg
references gone. This may potentially cause user-after-free and so
should be fixed. The last 2 patches are miscellaneous cleanups of
commit 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()").

Waiman Long (3):
  bdi, blk-cgroup: Fix potential UAF of blkcg
  blk-cgroup: Don't flush a blkg if destroyed
  blk-cgroup: Flush stats at blkgs destruction path

 block/blk-cgroup.c     | 26 ++++++++++++++++++++++++++
 include/linux/cgroup.h |  1 +
 kernel/cgroup/rstat.c  | 20 ++++++++++++++++++++
 mm/backing-dev.c       |  8 ++++++--
 4 files changed, 53 insertions(+), 2 deletions(-)

-- 
2.31.1

