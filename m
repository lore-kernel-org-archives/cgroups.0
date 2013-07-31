From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v4 2/8] cgroup: document how cgroup IDs are assigned
Date: Wed, 31 Jul 2013 09:51:06 +0800
Message-ID: <51F86D8A.4060201@huawei.com>
References: <51F86D69.2030907@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <51F86D69.2030907@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

As cgroup id has been used in netprio cgroup and will be used in memcg,
it's important to make it clear how a cgroup id is allocated.

For example, in netprio cgroup, the id is used as index of anarray.

Signed-off-by: Li Zefan <lizefan@huwei.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/cgroup.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2bd052d..8c107e9 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -161,7 +161,13 @@ struct cgroup_name {
 struct cgroup {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
-	int id;				/* idr allocated in-hierarchy ID */
+	/*
+	 * idr allocated in-hierarchy ID.
+	 *
+	 * The ID of the root cgroup is always 0, and a new cgroup
+	 * will be assigned with a smallest available ID.
+	 */
+	int id;
 
 	/*
 	 * We link our 'sibling' struct into our parent's 'children'.
-- 
1.8.0.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
