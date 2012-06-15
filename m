From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 4/7][TRIVIAL][resend] mm: cleanup on the comments of zone_reclaim_stat
Date: Fri, 15 Jun 2012 21:17:16 +0800
Message-ID: <1339766240-7622-1-git-send-email-liwp.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=9/O8sraMOGGUzseAcyqb4Q4gRAiac/RtmwHnZzCQX8E=;
        b=nJX/hE4TT1cj3QsadHa1uc6BJj8yrNaNh3KJ8d5unoBGAw9kkrYokpqktBXMEnlDK5
         OdPJgtb0QCRMFyBISOuf4x7legQMyPWpjlIxe9E/GwcJh1ZRZYROOQvKdzjMa1VvAaSC
         S48f/fQL0s/vdNyg1l/5ZPCohzTtQu/ciYB6EdBFGAhmsprM1yfhO4cOjx3CrzxlslWD
         Z5IKu1ZjGJut8OOtjBv9npKO1O4O5ItZc6vmJn3YBDVwZ8+eI074N+KO2vOPyHaiXijI
         TjAZlg01T/cEjpgkHv4zJyedUYpZ9RNcCUxDSI8l2aR9chSPrbnifl+lR82534QeaAeL
         02JA==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Christoph Lameter <cl@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Milton Miller <miltonm@bga.com>, Nishanth Aravamudan <nacc@us.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Jason Wessel <jason.wessel@windriver.com>, Jan Kiszka <jan.kiszka@siemens.com>, David Howells <dhowells@redhat.com>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

---
 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2427706..d6a5f83 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -188,7 +188,7 @@ static inline int is_unevictable_lru(enum lru_list lru)
 struct zone_reclaim_stat {
 	/*
 	 * The pageout code in vmscan.c keeps track of how many of the
-	 * mem/swap backed and file backed pages are refeferenced.
+	 * mem/swap backed and file backed pages are referenced.
 	 * The higher the rotated/scanned ratio, the more valuable
 	 * that cache is.
 	 *
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
