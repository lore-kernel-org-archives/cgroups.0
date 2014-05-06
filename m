From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
Date: Tue,  6 May 2014 08:44:21 -0400
Message-ID: <1399380266-3324-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=P92hPbgTKR2VH+SLwLX7r5FBSZ1HmKU2z+bcU6FTtHw=;
        b=sleiuEpVZ7hCqj3HmR/76NXt3AFT47x/p9MSPMuSEsoy5Fgmz+Kc/QlbgvHwoMrDTU
         O4Whlg0svIy2pX0Y7puuKNgO19n1BMNyElZE0tw4Nfn0m5cW3FHdPkWbTp5kHN9tNtlk
         Uhd9llY279cFc4ehiuF1ELKcHwCVthXIzrn6/l/nquDTm1ISoFiMf/aWZKMvnX9Oq15R
         uRGkvcajT7mQgAsUY3kGxkuEvpUzOJLCbcu4+h1X3ilcdeJQJwu8P3MQqsooM3md9OmG
         96tyZINv/2192/XxPCkICA2TMZhaKfF033RfLNi2Wnwb/m/1eFi0tQlCfLyJvhavVDiT
         wvyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com, axboe@kernel.dk, hannes@cmpxchg.org, mhocko@suse.cz, arozansk@redhat.com

Hello,

This patchset implements a new cftype operation ->write() and replace
->write_string() and ->trigger() with it.  ->write() is similar to
->write_string() but maps directly to the kernfs write operation and
has access to all available context information including the
associated kernfs_open_file, which will make things like implementing
kernfs active protection manipulation easier.

->write_string() becomes redundant and ->trigger() has always been
spurious.  This patch replaces all users of the two methods to
->write() and remove them.

This patchset contains the following five patches.

 0001-cgroup-implement-cftype-write.patch
 0002-cgroup-replace-cftype-write_string-with-cftype-write.patch
 0003-cgroup-replace-cftype-trigger-with-cftype-write.patch
 0004-cgroup-convert-tasks-and-cgroup.procs-handle-to-use-.patch
 0005-cgroup-remove-cgroup-control_kn.patch

0001 implements cftype->write().

0002-0003 replace cftype->write_string() and ->trigger() with it.

0004 convert "tasks" and "cgroup.procs" handler too.

0005 removes cgroup->control_kn as the kernfs_node is now directly
accessible from kernfs_open_file.

This patchset is on top of

  cgroup/for-3.16 12d3089c192c ("kernel/cpuset.c: convert printk to pr_foo()")
+ [1] [PATCHSET cgroup/for-3.16] cgroup: post unified hierarchy fixes and updates

and available on the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-unified-updates

diffstat follows.

 block/blk-throttle.c      |   32 ++++++++---------
 block/cfq-iosched.c       |   28 +++++++--------
 include/linux/cgroup.h    |   40 +++++++++++----------
 kernel/cgroup.c           |   85 +++++++++++++++++++++++-----------------------
 kernel/cgroup_freezer.c   |   20 ++++------
 kernel/cpuset.c           |   16 ++++----
 mm/hugetlb_cgroup.c       |   33 +++++++++--------
 mm/memcontrol.c           |   80 +++++++++++++++++++++++--------------------
 net/ipv4/tcp_memcontrol.c |   31 +++++++++-------
 security/device_cgroup.c  |   14 +++----
 10 files changed, 197 insertions(+), 182 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/1399377044-29873-1-git-send-email-tj@kernel.org
