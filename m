From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next 00/11] support concurrent sync io for bfq on a specail occasion
Date: Sat, 5 Mar 2022 17:11:54 +0800
Message-ID: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Currently, bfq can't handle sync io concurrently as long as they
are not issued from root group. This is because
'bfqd->num_groups_with_pending_reqs > 0' is always true in
bfq_asymmetric_scenario().

This patchset tries to support concurrent sync io if all the sync ios
are issued from the same cgroup:

1) Count root_group into 'num_groups_with_pending_reqs', patch 1-5;

2) Don't idle if 'num_groups_with_pending_reqs' is 1, patch 6;

3) Don't count the group if the group doesn't have pending requests,
while it's child groups may have pending requests, patch 7;

This is because, for example:
if sync ios are issued from cgroup /root/c1/c2, root, c1 and c2
will all be counted into 'num_groups_with_pending_reqs',
which makes it impossible to handle sync ios concurrently.

4) Decrease 'num_groups_with_pending_reqs' when the last queue completes
all the requests, while child groups may still have pending
requests, patch 8-10;

This is because, for example:
t1 issue sync io on root group, t2 and t3 issue sync io on the same
child group. num_groups_with_pending_reqs is 2 now.
After t1 stopped, num_groups_with_pending_reqs is still 2. sync io from
t2 and t3 still can't be handled concurrently.

fio test script: startdelay is used to avoid queue merging
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
v5.17-rc6:	   550 Mib/s
v5.17-rc6-patched: 550 Mib/s

running fio on non-root cgroup
v5.17-rc6:	   349 Mib/s
v5.17-rc6-patched: 550 Mib/s

Yu Kuai (11):
  block, bfq: add new apis to iterate bfq entities
  block, bfq: apply news apis where root group is not expected
  block, bfq: cleanup for __bfq_activate_requeue_entity()
  block, bfq: move the increasement of 'num_groups_with_pending_reqs' to
    it's caller
  block, bfq: count root group into 'num_groups_with_pending_reqs'
  block, bfq: do not idle if only one cgroup is activated
  block, bfq: only count parent bfqg when bfqq is activated
  block, bfq: record how many queues have pending requests in bfq_group
  block, bfq: move forward __bfq_weights_tree_remove()
  block, bfq: decrease 'num_groups_with_pending_reqs' earlier
  block, bfq: cleanup bfqq_group()

 block/bfq-cgroup.c  | 13 +++----
 block/bfq-iosched.c | 87 +++++++++++++++++++++++----------------------
 block/bfq-iosched.h | 41 +++++++++++++--------
 block/bfq-wf2q.c    | 56 +++++++++++++++--------------
 4 files changed, 106 insertions(+), 91 deletions(-)

-- 
2.31.1

