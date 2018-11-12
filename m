From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH 12/12] doc, bfq-iosched: make it consistent with the new cgroup interface
Date: Mon, 12 Nov 2018 10:56:32 +0100
Message-ID: <20181112095632.69114-13-paolo.valente@linaro.org>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MpOWBJhYX62m+dv0e4xXNBLs0Dhr3TZXbDUpfWqj7Ic=;
        b=VFGD5aONmJPgDKVWuSsADhnuupo20davPrcXxMNwaQMZewp7EC2pNfPmhVeF7QXgpS
         akGJu9VK0L9wXDLo3UCtHJXHfph1HyHmjiXaGZ/dtlh85gW/caRxP0MJp6ZsuOqy8afm
         oR3leMzaETYNT3djwxxEJi91rWG0izRRGxgJ0=
In-Reply-To: <20181112095632.69114-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Paolo Valente <paolo.valente@linaro.org>

BFQ now shares interface files with CFQ, for the proportional-share
policy. Make documentation consistent with that.

Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
---
 Documentation/block/bfq-iosched.txt | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/Documentation/block/bfq-iosched.txt b/Documentation/block/bfq-iosched.txt
index 6d7dd5ab8554..b1faf091266e 100644
--- a/Documentation/block/bfq-iosched.txt
+++ b/Documentation/block/bfq-iosched.txt
@@ -508,12 +508,11 @@ process.
 To get proportional sharing of bandwidth with BFQ for a given device,
 BFQ must of course be the active scheduler for that device.
 
-Within each group directory, the names of the files associated with
-BFQ-specific cgroup parameters and stats begin with the "bfq."
-prefix. So, with cgroups-v1 or cgroups-v2, the full prefix for
-BFQ-specific files is "blkio.bfq." or "io.bfq." For example, the group
-parameter to set the weight of a group with BFQ is blkio.bfq.weight
-or io.bfq.weight.
+BFQ shares interface files with CFQ. So, if one reads/writes a file
+provided by the proportional share policy for a group, then the
+associated operation is performed by/on BFQ for each device where BFQ
+is the active scheduler, and by/on CFQ for each device where CFQ is
+the active scheduler.
 
 As for cgroups-v1 (blkio controller), the exact set of stat files
 created, and kept up-to-date by bfq, depends on whether
@@ -521,13 +520,13 @@ CONFIG_DEBUG_BLK_CGROUP is set. If it is set, then bfq creates all
 the stat files documented in
 Documentation/cgroup-v1/blkio-controller.txt. If, instead,
 CONFIG_DEBUG_BLK_CGROUP is not set, then bfq creates only the files
-blkio.bfq.io_service_bytes
-blkio.bfq.io_service_bytes_recursive
-blkio.bfq.io_serviced
-blkio.bfq.io_serviced_recursive
+blkio.io_service_bytes
+blkio.io_service_bytes_recursive
+blkio.io_serviced
+blkio.io_serviced_recursive
 
 The value of CONFIG_DEBUG_BLK_CGROUP greatly influences the maximum
-throughput sustainable with bfq, because updating the blkio.bfq.*
+throughput sustainable with BFQ, because updating the blkio.*
 stats is rather costly, especially for some of the stats enabled by
 CONFIG_DEBUG_BLK_CGROUP.
 
@@ -536,8 +535,8 @@ Parameters to set
 
 For each group, there is only the following parameter to set.
 
-weight (namely blkio.bfq.weight or io.bfq-weight): the weight of the
-group inside its parent. Available values: 1..10000 (default 100). The
+weight (namely blkio.weight or io.weight): the weight of the group
+inside its parent. Available values: 1..10000 (default 100). The
 linear mapping between ioprio and weights, described at the beginning
 of the tunable section, is still valid, but all weights higher than
 IOPRIO_BE_NR*10 are mapped to ioprio 0.
-- 
2.16.1

