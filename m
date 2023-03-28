From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v1 4/9] cgroup: rstat: add WARN_ON_ONCE() if flushing outside
 task context
Date: Tue, 28 Mar 2023 06:16:33 +0000
Message-ID: <20230328061638.203420-5-yosryahmed@google.com>
References: <20230328061638.203420-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679984209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+vNiceMoZ2PdzrNG/xVeRzEo7O+ovCZNHcQMp7VClk4=;
        b=FtVms547YGVdf9XAqjguoo0WST2Bomcq4pMeCW3qlg0ksZV5swPoVz0GmrxFu8vfrh
         HBzgJptVGGKy7geKpBPvC2PsWo0HmjT2F27i9dbdVA6zCF4EYemeZRNrh89DbSPqLObX
         h82tbSvZ/WCeLjLtii1Meb+k3BLVneGl+TdsHqmfTXT/vAFZIC+/S3Aw9k3ElSrpUy7X
         9xgxQRUTlE19S9rQfATi59HRnf65TEpEpviTmJbLID2U9/qvSayVfcGFQGEl03zvUEu5
         uDhGnK3XWBy1kJngfOB04Odcd1UeEO5WA33WjKyVDhleLQy8k50zMQSY0RXklX82o1Jn
         CmFQ==
In-Reply-To: <20230328061638.203420-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

rstat flushing is too expensive to perform in irq context.
The previous patch removed the only context that may invoke an rstat
flush from irq context, add a WARN_ON_ONCE() to detect future
violations, or those that we are not aware of.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/cgroup/rstat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index d3252b0416b6..c2571939139f 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -176,6 +176,8 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 {
 	int cpu;
 
+	/* rstat flushing is too expensive for irq context */
+	WARN_ON_ONCE(!in_task());
 	lockdep_assert_held(&cgroup_rstat_lock);
 
 	for_each_possible_cpu(cpu) {
-- 
2.40.0.348.gf938b09366-goog

