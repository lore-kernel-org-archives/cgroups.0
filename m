From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/3] block, bfq: minor cleanup and fix
Date: Fri, 31 Dec 2021 11:23:51 +0800
Message-ID: <20211231032354.793092-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Chagnes in v2:
 - add comment in patch 2
 - remove patch 4, since the problem do not exist.

Yu Kuai (3):
  block, bfq: cleanup bfq_bfqq_to_bfqg()
  block, bfq: avoid moving bfqq to it's parent bfqg
  block, bfq: don't move oom_bfqq

 block/bfq-cgroup.c  | 16 +++++++++++++++-
 block/bfq-iosched.c |  4 ++--
 block/bfq-iosched.h |  1 -
 block/bfq-wf2q.c    | 15 ---------------
 4 files changed, 17 insertions(+), 19 deletions(-)

-- 
2.31.1

