From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/memcg: add BUG() to mem_cgroup_reset
Date: Fri,  6 Jul 2012 11:44:57 +0800
Message-ID: <1341546297-6223-1-git-send-email-liwp.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=fdw6PmMyDltchoAoJJwk3bwfLSHMd++8asW1RQ9aABM=;
        b=izMWzGOg/2VkHSMhewqTT2VMMII4pj8e8S9x7BUC9HDSy6+0svyU+wZIhKTayS+v/I
         o5u1ImwfyJDL28iuC8pHxSspaMWoUxmNXn4pj+fz2I/+FcFZLTWwLSZPS0eYc/LYlIBA
         VHgMw5t3w0IKfhgYJYvET4Hz8dFRllf4BK1xwyLlJQU4KUMm32oFNMeByrtYtbWJkFhr
         VHAuTCKdwzWdRvW40ctpPUnw4dBMtzb5gsZZV2Awekoi9oRRDUUHgJ75DY9cnPPVlJcB
         9M/bMw7eXnnEgGX3RUc7lDj8sfuFWnumWji8WDHsX9NOuYV9tnmC92OBnuSDVi+x3Sqb
         n4Ng==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Branch in mem_cgroup_reset only can be RES_MAX_USAGE, RES_FAILCNT.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a501660..5e4d1ab 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3976,6 +3976,8 @@ static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 		else
 			res_counter_reset_failcnt(&memcg->memsw);
 		break;
+	default:
+		BUG();
 	}
 
 	return 0;
-- 
1.7.5.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
