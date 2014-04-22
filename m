From: Jianyu Zhan <nasa4836@gmail.com>
Subject: [PATCH 2/4] mm/memcontrol.c: use accessor to get id from css
Date: Tue, 22 Apr 2014 14:30:41 +0800
Message-ID: <2c63c535f8202c6b605300a834cdf1c07d1bafc3.1398147734.git.nasa4836@gmail.com>
References: <cover.1398147734.git.nasa4836@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BdLKEAEz4gCB4LyI3sz2lTMFrCa0/TvVS1KDIh8hfNg=;
        b=IZkWt+dhAv93QGMB7cONTFl6AX2al6SGBikmNvYVGdwkr/IYw0h0yxHVNg9UtNP9tL
         UYZNdWh5cZuJV2pQPE1Whk6HdVqraklipQkXdPRktKJNsMtztO+FbVVDc+WQ2QQH9W5f
         4RV8BQ4grbn2xKTqER2+/nRwyeHo9ON6KddnnvpXXX61RlLyRT+dwh3ChBzPGd/skm4h
         Y1JsSonnj8zH5V8t2Tp1pWoIRxzZZVv8nFIGYk24nwoaSsCF4Kv8uNwX/P3v6dEJ1o9v
         DpUyNs+8beaPfImtuImHQ7MrQzXmJ+xnPNAI6JVxyXviGQooIE5SWKDQ74kzZfhLU3K/
         yCow==
In-Reply-To: <cover.1398147734.git.nasa4836@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, nasa4836@gmail.com

This is a prepared patch for converting from per-cgroup id to
per-subsystem id.

We should not access per-cgroup id directly, since this is implemetation
detail. Use the accessor css_from_id() instead.

This patch has no functional change.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 mm/memcontrol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 80d9e38..46333cb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -528,10 +528,10 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
 {
 	/*
-	 * The ID of the root cgroup is 0, but memcg treat 0 as an
-	 * invalid ID, so we return (cgroup_id + 1).
+	 * The ID of css for the root cgroup is 0, but memcg treat 0 as an
+	 * invalid ID, so we return (id + 1).
 	 */
-	return memcg->css.cgroup->id + 1;
+	return css_to_id(&memcg->css) + 1;
 }
 
 static inline struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
@@ -6407,7 +6407,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(css));
 
-	if (css->cgroup->id > MEM_CGROUP_ID_MAX)
+	if (css_to_id(css) > MEM_CGROUP_ID_MAX)
 		return -ENOSPC;
 
 	if (!parent)
-- 
2.0.0-rc0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
