From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC 0/9] support concurrent sync io for bfq on a specail occasion
Date: Sat, 27 Nov 2021 18:11:23 +0800
Message-ID: <20211127101132.486806-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Bfq can't handle sync io concurrently as long as the io are not issued
from root group currently.

Previous patch set:
https://lore.kernel.org/lkml/20211014014556.3597008-2-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/t/

During implemting the method mentioned by the above patch set, I found
more problems that will block implemting concurrent sync io. The
modifications of this patch set are as follows:

1) count root group into 'num_groups_with_pending_reqs';
2) don't idle if 'num_groups_with_pending_reqs' is 1;
3) If the group doesn't have pending requests while it's child groups
have pending requests, don't count the group.
4) Once the group doesn't have pending requests, decrease
'num_groups_with_pending_reqs' immediately. Don't delay to when all
it's child groups don't have pending requests.

Noted that I just tested basic functionality of this patchset, and I
think it's better to see if anyone have suggestions or better
solutions.

Yu Kuai (9):
  block, bfq: add new apis to iterate bfq entities
  block, bfq: apply news apis where root group is not expected
  block, bfq: handle the case when for_each_entity() access root group
  block, bfq: count root group into 'num_groups_with_pending_reqs'
  block, bfq: do not idle if only one cgroup is activated
  block, bfq: only count group that the bfq_queue belongs to
  block, bfq: record how many queues have pending requests in bfq_group
  block, bfq: move forward __bfq_weights_tree_remove()
  block, bfq: decrease 'num_groups_with_pending_reqs' earlier

 block/bfq-cgroup.c  |  3 +-
 block/bfq-iosched.c | 92 +++++++++++++++++++++++----------------------
 block/bfq-iosched.h | 41 +++++++++++++-------
 block/bfq-wf2q.c    | 44 +++++++++++++++-------
 4 files changed, 106 insertions(+), 74 deletions(-)

-- 
2.31.1

