From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next v6 0/3] support concurrent sync io for bfq on a specail occasion
Date: Mon, 23 May 2022 21:18:15 +0800
Message-ID: <20220523131818.2798712-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Resend these patches just in case v5 end up in spam (for Paolo).
Changes in v6:
 - add reviewed-by tag for patch 1

Changes in v5:
 - rename bfq_add_busy_queues() to bfq_inc_busy_queues() in patch 1
 - fix wrong definition in patch 1
 - fix spelling mistake in patch 2: leaset -> least
 - update comments in patch 3
 - add reviewed-by tag in patch 2,3

Changes in v4:
 - split bfq_update_busy_queues() to bfq_add/dec_busy_queues(),
   suggested by Jan Kara.
 - remove unused 'in_groups_with_pending_reqs',

Changes in v3:
 - remove the cleanup patch that is irrelevant now(I'll post it
   separately).
 - instead of hacking wr queues and using weights tree insertion/removal,
   using bfq_add/del_bfqq_busy() to count the number of groups
   (suggested by Jan Kara).

Changes in v2:
 - Use a different approch to count root group, which is much simple.

Currently, bfq can't handle sync io concurrently as long as they
are not issued from root group. This is because
'bfqd->num_groups_with_pending_reqs > 0' is always true in
bfq_asymmetric_scenario().

The way that bfqg is counted into 'num_groups_with_pending_reqs':

Before this patchset:
 1) root group will never be counted.
 2) Count if bfqg or it's child bfqgs have pending requests.
 3) Don't count if bfqg and it's child bfqgs complete all the requests.

After this patchset:
 1) root group is counted.
 2) Count if bfqg have at least one bfqq that is marked busy.
 3) Don't count if bfqg doesn't have any busy bfqqs.

The main reason to use busy state of bfqq instead of 'pending requests'
is that bfqq can stay busy after dispatching the last request if idling
is needed for service guarantees.

With the above changes, concurrent sync io can be supported if only
one group is activated.

fio test script(startdelay is used to avoid queue merging):
[global]
filename=/dev/nvme0n1
allow_mounted_write=0
ioengine=psync
direct=1
ioscheduler=bfq
offset_increment=10g
group_reporting
rw=randwrite
bs=4k

[test1]
numjobs=1

[test2]
startdelay=1
numjobs=1

[test3]
startdelay=2
numjobs=1

[test4]
startdelay=3
numjobs=1

[test5]
startdelay=4
numjobs=1

[test6]
startdelay=5
numjobs=1

[test7]
startdelay=6
numjobs=1

[test8]
startdelay=7
numjobs=1

test result:
running fio on root cgroup
v5.18-rc1:	   550 Mib/s
v5.18-rc1-patched: 550 Mib/s

running fio on non-root cgroup
v5.18-rc1:	   349 Mib/s
v5.18-rc1-patched: 550 Mib/s

Note that I also test null_blk with "irqmode=2
completion_nsec=100000000(100ms) hw_queue_depth=1", and tests show
that service guarantees are still preserved.

Follow-up cleanup:
https://lore.kernel.org/all/20220521073523.3118246-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/

Previous versions:
RFC: https://lore.kernel.org/all/20211127101132.486806-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
v1: https://lore.kernel.org/all/20220305091205.4188398-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
v2: https://lore.kernel.org/all/20220416093753.3054696-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
v3: https://lore.kernel.org/all/20220427124722.48465-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
v4: https://lore.kernel.org/all/20220428111907.3635820-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
v5: https://lore.kernel.org/all/20220428120837.3737765-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/

Yu Kuai (3):
  block, bfq: record how many queues are busy in bfq_group
  block, bfq: refactor the counting of 'num_groups_with_pending_reqs'
  block, bfq: do not idle if only one group is activated

 block/bfq-cgroup.c  |  1 +
 block/bfq-iosched.c | 48 +++-----------------------------------
 block/bfq-iosched.h | 57 +++++++--------------------------------------
 block/bfq-wf2q.c    | 35 +++++++++++++++++-----------
 4 files changed, 35 insertions(+), 106 deletions(-)

-- 
2.31.1

