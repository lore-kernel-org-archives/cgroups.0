From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET block/for-next] blk-iocost: Implement absolute debt handling
Date: Wed,  4 Sep 2019 12:45:51 -0700
Message-ID: <20190904194556.2984857-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=PXmGfQo6neOlWgmykljZagbJmoHVSlvd5lTMWMsizwM=;
        b=QCZLciyop0aVFo7y3eUWYwt/dAOgH9EHQhPsURPxfFrz963UhondyfnfVJlm5Irs0p
         5SQHRH6fK7+gJHEIPCtM6fkDwAxAREkPGiiev0r3QCLM4aGH4PFydtMEw5T+1dm9B4Gh
         PMPBoOUkKrisr6T/O7sRUGxemAeW+Fnsqb27SoTJUkCnpcdmU4kYbysvqhe5Jlk5EuZu
         MIhCKiKHM7FYt91Ji8jdBoJTVuY1SdyTRsa6Hfyo2P1J21BaXOlpNJvO6aaOA2Osda1G
         rbhVIz380w3pu+qKBZCUNTdf/IzfHFgQaEhvrxeOf+Z4NBKswArkr+tRU6ziV5xi8b2Z
         ntfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@vger.kernel.org, cgroups@vger.kernel.org, newella@fb.com

Currently, when a given cgroup doesn't have enough budget, a forced or
merged bio will advance the cgroup's vtime by the cost calculated
according to the hierarchical weight at the time of issue.  Once vtime
is advanced, how the cgroup's weight changes doesn't matter.  It has
to wait until global vtime catches up with the cgroup's.

This means that the cost is calculated based on the hweight at the
time of issuing but may later be paid at the wrong hweight.  This, for
example, can lead to a scenario like the following.

1. A cgroup with a very low hweight runs out of budget.

2. A storm of swap-out happens on it.  All of them are scaled
   according to the current low hweight and charged to vtime pushing
   it to a far future.

3. All other cgroups go idle and now the above cgroup has access to
   the whole device.  However, because vtime is already wound using
   the past low hweight, what its current hweight is doesn't matter
   until global vtime catches up to the local vtime.

4. As a result, either vrate gets ramped up extremely or the IOs stall
   while the underlying device is idle.

This patchset fixes the behavior by accounting the cost of forced or
merged bios in absolute vtime rather than cgroup-relative.  This
allows the cgroup to pay back the debt with whatever actual budget it
has each period removing the hweight discrepancy.

Note that !forced bios' costs are already accounted in absolute vtime.
This patchset puts forced charges on the same ground.

This patchset contains the following five patches and is on top of the
current linux-block.git for-next 35e7ae82f62b ("Merge branch
'for-5.4/block' into for-next").

 0001-blk-iocost-Account-force-charged-overage-in-absolute.patch
 0002-blk-iocost-Don-t-let-merges-push-vtime-into-the-futu.patch
 0003-iocost_monitor-Always-use-strings-for-json-values.patch
 0004-iocost_monitor-Report-more-info-with-higher-accuracy.patch
 0005-iocost_monitor-Report-debt.patch

0001-0002 implement absolute debt handling.  0003-0005 improve the
monitoring script and add debt reporting.

This patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git iocost-vdebt

diffstat follows.  Thanks.

 block/blk-iocost.c             |   93 +++++++++++++++++++++++++++++++++--------
 tools/cgroup/iocost_monitor.py |   61 ++++++++++++++------------
 2 files changed, 110 insertions(+), 44 deletions(-)

--
tejun

