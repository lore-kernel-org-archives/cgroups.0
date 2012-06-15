From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH 7/7] mm/memory.c : cleanup the coding style issue
Date: Fri, 15 Jun 2012 21:20:47 +0800
Message-ID: <1339766449-7835-1-git-send-email-liwp.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=DO76zEDFOPbUUWOYT8+e+VNrrtZmbbSN16bn9yUv8FA=;
        b=YDxKo9bULR1Y0Ee2npVC5zHyKSl8VXeIgVjEyQzkUEEbpOe1Tzwm1YePx7sR1ly0JU
         UraKPx3QluzfaFdUE+H+SrQtHhTPH8rSI9v7XgsbUFn3O0PZYO49Rl4skvLMjldaYBuc
         z+i2Es4jBoXgHojCllKZ7RafqNduQI92IPn4XsMej2uwOaJMAtAYh6xKnMGcXEw+6USC
         yNqkmgrO96XPp6OFcZaUibCPw7p/8PNEHVtbSYMp4MYtywhLmuA4Osoo0RuLeGyK3TQ4
         7BCFhnSgKvtI4TmhtKDTUPzLd0eAiDnih7oRD1qbW40wDQSdNreLHco6xcu8QSxuRT7D
         gWxA==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trivial@kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Christoph Lameter <cl@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, Milton Miller <miltonm@bga.com>, Nishanth Aravamudan <nacc@us.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Jason Wessel <jason.wessel@windriver.com>, Jan Kiszka <jan.kiszka@siemens.com>, David Howells <dhowells@redhat.com>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>

---
 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 1b7dc66..195d6e1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2447,7 +2447,8 @@ static inline int pte_unmap_same(struct mm_struct *mm, pmd_t *pmd,
 	return same;
 }
 
-static inline void cow_user_page(struct page *dst, struct page *src, unsigned long va, struct vm_area_struct *vma)
+static inline void cow_user_page(struct page *dst, struct page *src,
+		unsigned long va, struct vm_area_struct *vma)
 {
 	/*
 	 * If the source page was a PFN mapping, we don't have
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
