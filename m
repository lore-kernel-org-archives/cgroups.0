From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] mm: memcontrol: uninitialized "ret" variables
Date: Thu, 22 Jan 2015 16:30:44 +0300
Message-ID: <20150122133044.GA23668@mwanda>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-janitors@vger.kernel.org

We recently re-arranged the code in these functions and now static
checkers complain that "ret" is uninitialized.  Oddly enough GCC is fine
with this code.

Fixes: d1ebc463cf89 ('mm: page_counter: pull "-1" handling out of page_counter_memparse()')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 323a01f..7af7834 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3422,7 +3422,7 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	unsigned long nr_pages;
-	int ret;
+	int ret = 0;
 
 	buf = strstrip(buf);
 	if (!strcmp(buf, "-1")) {
@@ -3799,7 +3799,8 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	struct mem_cgroup_threshold_ary *new;
 	unsigned long threshold;
 	unsigned long usage;
-	int i, size, ret;
+	int i, size;
+	int ret = 0;
 
 	if (!strcmp(args, "-1")) {
 		threshold = PAGE_COUNTER_MAX;

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
