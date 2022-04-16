From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next v2 0/5] support concurrent sync io for bfq on a specail occasion
Date: Sat, 16 Apr 2022 17:37:48 +0800
Message-ID: <20220416093753.3054696-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Changes in v2:
 - Use a different aporch to count root group, which is much simple.

Currently, bfq can't handle sync io concurrently as long as they
are not issued from root group. This is because
'bfqd->num_groups_with_pending_reqs > 0' is always true in
bfq_asymmetric_scenario().

The way that bfqg is counted to 'num_groups_with_pending_reqs':

Before this patchset:
 1) root group will never be counted.
 2) Count if bfqg or it's child bfqgs have pending requests.
 3) Don't count if bfqg and it's child bfqgs complete all the requests.

After this patchset:
 1) root group is counted.
 2) Count if bfqg have pending requests.
This is because, for example:
if sync ios are issued from cgroup /root/c1/c2, root, c1 and c2 will all
be counted into 'num_groups_with_pending_reqs', which makes it impossible
to handle sync ios concurrently.

 3) Don't count if bfqg complete all the requests.
This is because, for example:
t1 issue sync io on root group, t2 and t3 issue sync io on the same child
group. num_groups_with_pending_reqs is 2 now. After t1 stopped,
num_groups_with_pending_reqs is still 2. sync io from t2 and t3 still can't
be handled concurrently.

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
v5.18-rc1:	   550 Mib/s
v5.18-rc1-patched: 550 Mib/s

running fio on non-root cgroup
v5.18-rc1:	   349 Mib/s
v5.18-rc1-patched: 550 Mib/s

Yu Kuai (5):
  block, bfq: cleanup bfq_weights_tree add/remove apis
  block, bfq: add fake weight_counter for weight-raised queue
  bfq, block: record how many queues have pending requests in bfq_group
  block, bfq: refactor the counting of 'num_groups_with_pending_reqs'
  block, bfq: do not idle if only one cgroup is activated

 block/bfq-cgroup.c  |  1 +
 block/bfq-iosched.c | 90 +++++++++++++++++++--------------------------
 block/bfq-iosched.h | 26 ++++++-------
 block/bfq-wf2q.c    | 30 +++------------
 4 files changed, 56 insertions(+), 91 deletions(-)

-- 
2.31.1

