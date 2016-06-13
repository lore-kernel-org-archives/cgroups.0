From: Topi Miettinen <toiwoton@gmail.com>
Subject: [RFC 03/18] memcontrol: present maximum used memory also for cgroup-v2
Date: Mon, 13 Jun 2016 22:44:10 +0300
Message-ID: <1465847065-3577-4-git-send-email-toiwoton@gmail.com>
References: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/COKQaq7zTP+LlrmEfgUB5Z/PkzMk0IE1gsd0DQBr8I=;
        b=aa3bbkenGPO75MwhcurmXjuFwZ0R87PX3t4KTQ9lXhzhzbCkIWwMSVUoeimWTlIeGt
         wX/Jy5gF1yc5HAatcuyl8/Ob04nXfml1PTwI/ARU3zymAyTUzpka560mGg5eVCgeuJpr
         52OUalcK/8FFO6t+jFYW03JurUf+o9u24ruN9ERChW5slAKFZtZR7HB7WQycviouJqDR
         V2BDF+5evTcvTPsxjVDcmWcJZcth3lhD+F8iuUsPa0dTWrOEdkMMqVSf5a9sOUUvsADY
         j8NxgP+AkrUKH5Ksg4sY9dstcj6y/DXBzOrI08LyYT+cysG1ZzrUWGnY24PJJdQejXvx
         rXIA==
In-Reply-To: <1465847065-3577-1-git-send-email-toiwoton@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Topi Miettinen <toiwoton@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER MEMCG" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER MEMCG" <linux-mm@kvack.org>

Present maximum used memory in cgroup memory.current_max.

Signed-off-by: Topi Miettinen <toiwoton@gmail.com>
---
 include/linux/page_counter.h |  7 ++++++-
 mm/memcontrol.c              | 13 +++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 7e62920..be4de17 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -9,9 +9,9 @@ struct page_counter {
 	atomic_long_t count;
 	unsigned long limit;
 	struct page_counter *parent;
+	unsigned long watermark;
 
 	/* legacy */
-	unsigned long watermark;
 	unsigned long failcnt;
 };
 
@@ -34,6 +34,11 @@ static inline unsigned long page_counter_read(struct page_counter *counter)
 	return atomic_long_read(&counter->count);
 }
 
+static inline unsigned long page_counter_read_watermark(struct page_counter *counter)
+{
+	return counter->watermark;
+}
+
 void page_counter_cancel(struct page_counter *counter, unsigned long nr_pages);
 void page_counter_charge(struct page_counter *counter, unsigned long nr_pages);
 bool page_counter_try_charge(struct page_counter *counter,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75e7440..5513771 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4966,6 +4966,14 @@ static u64 memory_current_read(struct cgroup_subsys_state *css,
 	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
 }
 
+static u64 memory_current_max_read(struct cgroup_subsys_state *css,
+				   struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return (u64)page_counter_read_watermark(&memcg->memory) * PAGE_SIZE;
+}
+
 static int memory_low_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
@@ -5179,6 +5187,11 @@ static struct cftype memory_files[] = {
 		.read_u64 = memory_current_read,
 	},
 	{
+		.name = "current_max",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = memory_current_max_read,
+	},
+	{
 		.name = "low",
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = memory_low_show,
-- 
2.8.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
