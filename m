From: Kemeng Shi <shikemeng@huawei.com>
Subject: [PATCH 2/4] blk-cgroup: correct comment for blk_alloc_queue and blk_exit_queue
Date: Mon, 10 Oct 2022 10:38:57 +0800
Message-ID: <20221010023859.11896-3-shikemeng@huawei.com>
References: <20221010023859.11896-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221010023859.11896-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, shikemeng@huawei.com

Since commit 1059699f87eb("block: move blkcg initialization/destroy into
disk allocation/release handler"), blk_alloc_queue and blk_exit_queue is
called directly from gendisk. Update the corresponding comment.

Signed-off-by: Kemeng Shi <shikemeng@huawei.com>
---
 block/blk-cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bc4dec705572..463c568d3e86 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1259,7 +1259,7 @@ static int blkcg_css_online(struct cgroup_subsys_state *css)
  * blkcg_init_queue - initialize blkcg part of request queue
  * @q: request_queue to initialize
  *
- * Called from blk_alloc_queue(). Responsible for initializing blkcg
+ * Called from gendisk. Responsible for initializing blkcg
  * part of new request_queue @q.
  *
  * RETURNS:
@@ -1321,7 +1321,7 @@ int blkcg_init_queue(struct request_queue *q)
  * blkcg_exit_queue - exit and release blkcg part of request_queue
  * @q: request_queue being released
  *
- * Called from blk_exit_queue().  Responsible for exiting blkcg part.
+ * Called from gendisk.  Responsible for exiting blkcg part.
  */
 void blkcg_exit_queue(struct request_queue *q)
 {
-- 
2.30.0

