From: Sergey Dyasly <dserrg@gmail.com>
Subject: [PATCH][trivial] memcg: Kconfig info update
Date: Mon, 27 May 2013 19:36:24 +0400
Message-ID: <1369668984-2787-1-git-send-email-dserrg@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=xmQxw7QP8NCRe0DPG9c1bka4+myyVq0wEB2n2dwQPoE=;
        b=cPtPOe5TDtLWa/KGY/QnGoSRoRxTrRedRmS4MI1kYXc62sS/pKcVPBOFd9Fkua8mze
         rNs5f+8KtgYtBUtOb7qRXSZSJRb22aJdqyhw4r/jWy3tC6EPxXSLWzkixseHBS8R2led
         9IGbNUEVqu3onj9h2w4TlfYbRaDoDa73EVrljZwL2KcJsCngGzXD+EbzyFclPh6MR8V+
         p2xJLssMWubCBxrer4dTU1v7nNyxC1Q2faYnQDvv3L34ytoqgmjUTVX6m5OrT5wuAz3T
         sJO14dr+QMVMo6sNy1B3/1fW1ouAcmiYqaxBQtW+tVQz5Kr3X80SW97vi2X342bVlncX
         5/SQ==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, Sergey Dyasly <dserrg@gmail.com>

Now there are only 2 members in struct page_cgroup.
Update config MEMCG description accordingly.

Signed-off-by: Sergey Dyasly <dserrg@gmail.com>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 9d3a788..16d1502 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -876,7 +876,7 @@ config MEMCG
 
 	  Note that setting this option increases fixed memory overhead
 	  associated with each page of memory in the system. By this,
-	  20(40)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
+	  8(16)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
 	  usage tracking struct at boot. Total amount of this is printed out
 	  at boot.
 
-- 
1.8.1.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
