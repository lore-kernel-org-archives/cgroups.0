From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] drbd: remove a bogus bdi_rw_congested call
Date: Wed,  1 Jul 2020 11:06:19 +0200
Message-ID: <20200701090622.3354860-2-hch@lst.de>
References: <20200701090622.3354860-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200701090622.3354860-1-hch@lst.de>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, linux-mm@kvack.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@tron.linbit.com, dm-devel@redhat.com, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-btrfs@vger.kernel.org

bdi_rw_congested returns congestion state, so calling it without
looking at the return value doesn't make much sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_proc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 1c41cd9982a257..3c0193de249830 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -265,7 +265,6 @@ int drbd_seq_show(struct seq_file *seq, void *v)
 			seq_printf(seq, "%2d: cs:Unconfigured\n", i);
 		} else {
 			/* reset device->congestion_reason */
-			bdi_rw_congested(device->rq_queue->backing_dev_info);
 
 			nc = rcu_dereference(first_peer_device(device)->connection->net_conf);
 			wp = nc ? nc->wire_protocol - DRBD_PROT_A + 'A' : ' ';
-- 
2.26.2
