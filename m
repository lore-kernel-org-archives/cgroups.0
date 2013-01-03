From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/13] cpuset: remove unused cpuset_unlock()
Date: Thu,  3 Jan 2013 13:35:55 -0800
Message-ID: <1357248967-24959-2-git-send-email-tj@kernel.org>
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=t3aSXKS4rPGeeTCw8JKtmOh8754xJT8Me2v6xxbDXS4=;
        b=XQT5foP1LenXrcVEX5jdlVB7Et8SVeDQDkbox8/dwTdN9meNHiCaIMX5742uaGgZNu
         ORWM+EMG8TAqpR7nuLl8BVVTJ/1tQCsvrhDb3EehgeV5hmgqhszyifmfo++H1VSe5NUs
         zAE5lYHCTB5z6Al9A0DR0wJ5hm/gEvECNS4I/pn0Tl5ZeEB5r78DR4Wrx6Tjp2UHRJqx
         z+CEpmBSpZ4g9KkO49htWyqO5oFieYJbofKz908b6ZQr26LL3tZwsFXQk7HGDcIjPaW+
         BbPp6mJAGTddle/I6gme1P01e4UEfvwroDyr6uM5IdMGClxGC7WlIJ4G1zH3gTF6hNOm
         2ZkA==
In-Reply-To: <1357248967-24959-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cpuset.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 7bb63ee..854b8bf 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2412,17 +2412,6 @@ int __cpuset_node_allowed_hardwall(int node, gfp_t gfp_mask)
 }
 
 /**
- * cpuset_unlock - release lock on cpuset changes
- *
- * Undo the lock taken in a previous cpuset_lock() call.
- */
-
-void cpuset_unlock(void)
-{
-	mutex_unlock(&callback_mutex);
-}
-
-/**
  * cpuset_mem_spread_node() - On which node to begin search for a file page
  * cpuset_slab_spread_node() - On which node to begin search for a slab page
  *
-- 
1.8.0.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
