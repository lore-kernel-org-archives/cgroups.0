From: Weiping Zhang <zhangweiping@didiglobal.com>
Subject: [PATCH v4 4/5] genirq/affinity: allow driver's discontigous affinity
 set
Date: Tue, 28 Jan 2020 19:53:40 +0800
Message-ID: <c044e71afa25fdf65ca9abd21f8a5032e1b424eb.1580211965.git.zhangweiping@didiglobal.com>
References: <cover.1580211965.git.zhangweiping@didiglobal.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1580211965.git.zhangweiping@didiglobal.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, tj@kernel.org, hch@lst.de, bvanassche@acm.org, keith.busch@intel.com, minwoo.im.dev@gmail.com, tglx@linutronix.de, edmund.nadolski@intel.com
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org

nvme driver will add 4 sets for supporting NVMe weighted round robin,
and some of these sets may be empty(depends on user configuration),
so each particular set is assigned one static index for avoiding the
management trouble, then the empty set will be been by
irq_create_affinity_masks(). This patch make API more compatible.

Signed-off-by: Weiping Zhang <zhangweiping@didiglobal.com>
---
 kernel/irq/affinity.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index 4d89ad4fae3b..83154615cc9d 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -462,6 +462,10 @@ irq_create_affinity_masks(unsigned int nvecs, struct irq_affinity *affd)
 		unsigned int this_vecs = affd->set_size[i];
 		int ret;
 
+		/* skip empty affinity set */
+		if (this_vecs == 0)
+			continue;
+
 		ret = irq_build_affinity_masks(curvec, this_vecs,
 					       curvec, masks);
 		if (ret) {
-- 
2.14.1

