From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 6/7][TRIVIAL][resend] mm: cleanup page reclaim comment error
Date: Fri, 15 Jun 2012 21:19:45 +0800
Message-ID: <1339766387-7740-1-git-send-email-liwp.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=0/bTixQ/iPv1uQayUR7dw+SWYPQgWW1qnB1S4FO1e/o=;
        b=g+HuGF5hvzRpYDqRhIB2KtyhoCRRh7qnyNqGD3jpk/As94rc7d4/sNRq0Bo6JsZ0Xm
         VMbqIsVyijVyB9/FuqdDKsRMXBDeIZuQLpyyhfzFCeGOAYQ1SqKYm+p3MpYp97fMbzxz
         UHLPYngFsIC7jOllPm8gl7cYxGWMJu7ZBBJA0S2WMwLacbx589pe5MIS7yC5zBLPBP7h
         nD+0mTcas6mvqL21neSxe0q3+lOBLG2sAS1KrLP+8l+g0m0jDhAmhGVYtZ7MMdx6zltb
         0CpxoOhLcpO4OG0VNbM4miKmv/Rzdco1N9Wr1Zw0KlCppUE7VUeuq+IL5erLjXpLvAFF
         HXtA==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Christoph Lameter <cl@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Milton Miller <miltonm@bga.com>, Nishanth Aravamudan <nacc@us.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Jason Wessel <jason.wessel@windriver.com>, Jan Kiszka <jan.kiszka@siemens.com>, David Howells <dhowells@redhat.com>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since there are five lists in LRU cache, the array nr in get_scan_count
should be:

nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
nr[2] = file inactive pages to scan; nr[3] = file active pages to scan

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>

---
 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eeb3bc9..ed823df 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1567,7 +1567,8 @@ static int vmscan_swappiness(struct scan_control *sc)
  * by looking at the fraction of the pages scanned we did rotate back
  * onto the active list instead of evict.
  *
- * nr[0] = anon pages to scan; nr[1] = file pages to scan
+ * nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
+ * nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
  */
 static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			   unsigned long *nr)
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
