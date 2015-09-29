From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] writeback: fix bdi_writeback iteration in wakeup_dirtytime_writeback()
Date: Tue, 29 Sep 2015 12:47:51 -0400
Message-ID: <1443545274-18787-3-git-send-email-tj@kernel.org>
References: <1443545274-18787-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Kv3uFtZ9OG1bDNs6FIN+sZAuQSBaEc7ZlkJEgMFrvEc=;
        b=KnKFYR8c587yhCI473X9ZycCX4GcCIBZ3MIKWGq8Q/41RGP5S8pn6cpHl44yfNQBGK
         jcGA6KCCUjWpjQVqzZ/MuCr37SY2orZqEjH5CxgUSEgYLr6gBRcrkhOXyxkm/1rCfyxV
         f0sud5NVnQWz1yETN71UTL7ncLGpKq0R1guowEcuRluxBKzOFEUDs6078qKo5LdnJ25O
         cywb/++Z+Hsi3p+WtpRsQAB4jnh+CxW6Xnlfw0N41Ai+uKtB2AW5ok/ytmbrDChuG18O
         6/sL24qKGaxg5skTiNy1PSH879irBjNcacQZoTQqF1lhK17Pp/wJIzKtWV/w7JX0z74j
         ETxw==
In-Reply-To: <1443545274-18787-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, tytso@mit.edu, dedekind1@gmail.com, decui@microsoft.com, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

wakeup_dirtytime_writeback() walks and wakes up all wb's of all bdi's;
unfortunately, it was always waking up bdi->wb instead of the wb being
walked.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 001fe6f617b1 ("writeback: make wakeup_dirtytime_writeback() handle multiple bdi_writeback's")
---
 fs/fs-writeback.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 091a364..d0da306 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1897,8 +1897,8 @@ static void wakeup_dirtytime_writeback(struct work_struct *w)
 		struct wb_iter iter;
 
 		bdi_for_each_wb(wb, bdi, &iter, 0)
-			if (!list_empty(&bdi->wb.b_dirty_time))
-				wb_wakeup(&bdi->wb);
+			if (!list_empty(&wb->b_dirty_time))
+				wb_wakeup(wb);
 	}
 	rcu_read_unlock();
 	schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
-- 
2.4.3
