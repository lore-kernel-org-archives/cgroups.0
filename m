From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v6 1/2] mm: memcontrol: Fix missing suffix of workingset_restore
Date: Wed, 16 Sep 2020 18:00:29 +0800
Message-ID: <20200916100030.71698-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TTKM9QuKkaPGqtUV+sgdxsS+sauamtAwYDBe99O9veY=;
        b=W/CybB0aDEi03zEZMzNc5Gk8+FAroM0TOHUoMJTbHAXDeTLVq/CI+pzbtFPz8oiyIb
         +uKwz1uh8sYbDTiD17dINRgdWBvTEbFWLEksIXBysH3TCI5gGklRYR8FiG1kyfjMUEk7
         t/PHvkBeBLulci1WpfRg/+By3Cuqwaxsd6dfPXu5XtbgfeJF68mqeisCPybocTZqioFX
         oRryMf3CdmJh8mKB3HiyjsFwzicPfmYQSwXPq7AEmeEtpQNs8VLDPoWVfNRsfdwwt0X2
         mhCsaHCJoDQloVCPYW7Cv+nzSq9lejGiPtLV/qw1pNMxiOVRMAdLJxdoqNHNwuUBuJxz
         tAYA==
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, rdunlap@infradead.org
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Muchun Song <songmuchun@bytedance.com>

We forget to add the suffix to the workingset_restore string, so
fix it. And also update the documentation of cgroup-v2.rst.

Fixes: 170b04b7ae49 ("mm/workingset: prepare the workingset detection infrastructure for anon LRU")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 changelog in v6:
 1. There is no version of v1-v5.

 Documentation/admin-guide/cgroup-v2.rst | 25 ++++++++++++++++++-------
 mm/memcontrol.c                         |  4 ++--
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6be43781ec7f..baa07b30845e 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1324,15 +1324,26 @@ PAGE_SIZE multiple when read back.
 	  pgmajfault
 		Number of major page faults incurred
 
-	  workingset_refault
-		Number of refaults of previously evicted pages
+	  workingset_refault_anon
+		Number of refaults of previously evicted anonymous pages.
 
-	  workingset_activate
-		Number of refaulted pages that were immediately activated
+	  workingset_refault_file
+		Number of refaults of previously evicted file pages.
 
-	  workingset_restore
-		Number of restored pages which have been detected as an active
-		workingset before they got reclaimed.
+	  workingset_activate_anon
+		Number of refaulted anonymous pages that were immediately
+		activated.
+
+	  workingset_activate_file
+		Number of refaulted file pages that were immediately activated.
+
+	  workingset_restore_anon
+		Number of restored anonymous pages which have been detected as
+		an active workingset before they got reclaimed.
+
+	  workingset_restore_file
+		Number of restored file pages which have been detected as an
+		active workingset before they got reclaimed.
 
 	  workingset_nodereclaim
 		Number of times a shadow node has been reclaimed
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75cd1a1e66c8..0e85a054017f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1574,9 +1574,9 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 		       memcg_page_state(memcg, WORKINGSET_ACTIVATE_ANON));
 	seq_buf_printf(&s, "workingset_activate_file %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_ACTIVATE_FILE));
-	seq_buf_printf(&s, "workingset_restore %lu\n",
+	seq_buf_printf(&s, "workingset_restore_anon %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_RESTORE_ANON));
-	seq_buf_printf(&s, "workingset_restore %lu\n",
+	seq_buf_printf(&s, "workingset_restore_file %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_RESTORE_FILE));
 	seq_buf_printf(&s, "workingset_nodereclaim %lu\n",
 		       memcg_page_state(memcg, WORKINGSET_NODERECLAIM));
-- 
2.20.1

