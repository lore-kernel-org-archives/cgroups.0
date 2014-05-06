From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] cgroup: replace cftype->trigger() with cftype->write()
Date: Tue,  6 May 2014 08:44:24 -0400
Message-ID: <1399380266-3324-4-git-send-email-tj@kernel.org>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MD9THadJbtlRjMnWVLWRo2/3Mn0Rn0nFo3CmRl70N+4=;
        b=HAOlZ2ATCM7wbih79Dr3M71Q1I4ijDWp6Z895MxHUiuU18CxfA+zKnWNHjr0rD5AAS
         q+bQe4jsqssLv7Htsbg5aZF6S0ppsg/QrqSrps7wfr+iEVhkcClRQK++GBo4+OWbRa/m
         dlMWyGbMBITmq/bT7Vf7ka4PWuL4HqRLuaLgezkU5fLWM+uV/ozz0vpFfp5e/tbMGOBt
         NxbQ8/0Yv7iygmF4hHp8BCHbLqmHQlUe7gwKGncgLoVS96YQaQLJasJfmefg8WITBu6c
         lAu5+yiZqF0JNN6faDa7fwBcdrXbsZp/hvXG3+KBavH+RmEahEVWpL4hVmDBSRDmVEDr
         w1jw==
In-Reply-To: <1399380266-3324-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com, axboe@kernel.dk, hannes@cmpxchg.org, mhocko@suse.cz, arozansk@redhat.com, Tejun Heo <tj@kernel.org>

cftype->trigger() is pointless.  It's trivial to ignore the input
buffer from a regular ->write() operation.  Convert all ->trigger()
users to ->write() and remove ->trigger().

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
---
 include/linux/cgroup.h    |  8 --------
 kernel/cgroup.c           |  5 +----
 mm/hugetlb_cgroup.c       | 16 ++++++++--------
 mm/memcontrol.c           | 34 ++++++++++++++++++----------------
 net/ipv4/tcp_memcontrol.c | 15 ++++++++-------
 5 files changed, 35 insertions(+), 43 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5f717d7..f8cfadb 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -502,14 +502,6 @@ struct cftype {
 			 s64 val);
 
 	/*
-	 * trigger() callback can be used to get some kick from the
-	 * userspace, when the actual string written is not important
-	 * at all. The private field can be used to determine the
-	 * kick type for multiplexing.
-	 */
-	int (*trigger)(struct cgroup_subsys_state *css, unsigned int event);
-
-	/*
 	 * write() is the generic write callback which maps directly to
 	 * kernfs write operation and overrides all other operations.
 	 * Maximum write size is determined by ->max_write_len.  Use
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8939fe4..4b340c3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1034,8 +1034,7 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 	if (cft->read_u64 || cft->read_s64 || cft->seq_show)
 		mode |= S_IRUGO;
 
-	if (cft->write_u64 || cft->write_s64 || cft->write ||
-	    cft->trigger)
+	if (cft->write_u64 || cft->write_s64 || cft->write)
 		mode |= S_IWUSR;
 
 	return mode;
@@ -2748,8 +2747,6 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 		ret = kstrtoll(buf, 0, &v);
 		if (!ret)
 			ret = cft->write_s64(css, cft, v);
-	} else if (cft->trigger) {
-		ret = cft->trigger(css, (unsigned int)cft->private);
 	} else {
 		ret = -EINVAL;
 	}
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index faea871..8597daa 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -284,14 +284,14 @@ static ssize_t hugetlb_cgroup_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
-static int hugetlb_cgroup_reset(struct cgroup_subsys_state *css,
-				unsigned int event)
+static ssize_t hugetlb_cgroup_reset(struct kernfs_open_file *of,
+				    char *buf, size_t nbytes, loff_t off)
 {
 	int idx, name, ret = 0;
-	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(css);
+	struct hugetlb_cgroup *h_cg = hugetlb_cgroup_from_css(of_css(of));
 
-	idx = MEMFILE_IDX(event);
-	name = MEMFILE_ATTR(event);
+	idx = MEMFILE_IDX(of_cft(of)->private);
+	name = MEMFILE_ATTR(of_cft(of)->private);
 
 	switch (name) {
 	case RES_MAX_USAGE:
@@ -304,7 +304,7 @@ static int hugetlb_cgroup_reset(struct cgroup_subsys_state *css,
 		ret = -EINVAL;
 		break;
 	}
-	return ret;
+	return ret ?: nbytes;
 }
 
 static char *mem_fmt(char *buf, int size, unsigned long hsize)
@@ -344,14 +344,14 @@ static void __init __hugetlb_cgroup_file_init(int idx)
 	cft = &h->cgroup_files[2];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.max_usage_in_bytes", buf);
 	cft->private = MEMFILE_PRIVATE(idx, RES_MAX_USAGE);
-	cft->trigger = hugetlb_cgroup_reset;
+	cft->write = hugetlb_cgroup_reset;
 	cft->read_u64 = hugetlb_cgroup_read_u64;
 
 	/* Add the failcntfile */
 	cft = &h->cgroup_files[3];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.failcnt", buf);
 	cft->private  = MEMFILE_PRIVATE(idx, RES_FAILCNT);
-	cft->trigger  = hugetlb_cgroup_reset;
+	cft->write = hugetlb_cgroup_reset;
 	cft->read_u64 = hugetlb_cgroup_read_u64;
 
 	/* NULL terminate the last cft */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0258419..0845097 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4885,14 +4885,15 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 	return 0;
 }
 
-static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
-					unsigned int event)
+static ssize_t mem_cgroup_force_empty_write(struct kernfs_open_file *of,
+					    char *buf, size_t nbytes,
+					    loff_t off)
 {
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 
 	if (mem_cgroup_is_root(memcg))
 		return -EINVAL;
-	return mem_cgroup_force_empty(memcg);
+	return mem_cgroup_force_empty(memcg) ?: nbytes;
 }
 
 static u64 mem_cgroup_hierarchy_read(struct cgroup_subsys_state *css,
@@ -5218,14 +5219,15 @@ out:
 	*memsw_limit = min_memsw_limit;
 }
 
-static int mem_cgroup_reset(struct cgroup_subsys_state *css, unsigned int event)
+static ssize_t mem_cgroup_reset(struct kernfs_open_file *of, char *buf,
+				size_t nbytes, loff_t off)
 {
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	int name;
 	enum res_type type;
 
-	type = MEMFILE_TYPE(event);
-	name = MEMFILE_ATTR(event);
+	type = MEMFILE_TYPE(of_cft(of)->private);
+	name = MEMFILE_ATTR(of_cft(of)->private);
 
 	switch (name) {
 	case RES_MAX_USAGE:
@@ -5250,7 +5252,7 @@ static int mem_cgroup_reset(struct cgroup_subsys_state *css, unsigned int event)
 		break;
 	}
 
-	return 0;
+	return nbytes;
 }
 
 static u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
@@ -6103,7 +6105,7 @@ static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "max_usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_MAX_USAGE),
-		.trigger = mem_cgroup_reset,
+		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
@@ -6121,7 +6123,7 @@ static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "failcnt",
 		.private = MEMFILE_PRIVATE(_MEM, RES_FAILCNT),
-		.trigger = mem_cgroup_reset,
+		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
@@ -6130,7 +6132,7 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "force_empty",
-		.trigger = mem_cgroup_force_empty_write,
+		.write = mem_cgroup_force_empty_write,
 	},
 	{
 		.name = "use_hierarchy",
@@ -6184,13 +6186,13 @@ static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "kmem.failcnt",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_FAILCNT),
-		.trigger = mem_cgroup_reset,
+		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
 		.name = "kmem.max_usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_MAX_USAGE),
-		.trigger = mem_cgroup_reset,
+		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 #ifdef CONFIG_SLABINFO
@@ -6213,7 +6215,7 @@ static struct cftype memsw_cgroup_files[] = {
 	{
 		.name = "memsw.max_usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_MAX_USAGE),
-		.trigger = mem_cgroup_reset,
+		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{
@@ -6225,7 +6227,7 @@ static struct cftype memsw_cgroup_files[] = {
 	{
 		.name = "memsw.failcnt",
 		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_FAILCNT),
-		.trigger = mem_cgroup_reset,
+		.write = mem_cgroup_reset,
 		.read_u64 = mem_cgroup_read_u64,
 	},
 	{ },	/* terminate */
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index 841fd3f..f7a2ec3 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -170,17 +170,18 @@ static u64 tcp_cgroup_read(struct cgroup_subsys_state *css, struct cftype *cft)
 	return val;
 }
 
-static int tcp_cgroup_reset(struct cgroup_subsys_state *css, unsigned int event)
+static ssize_t tcp_cgroup_reset(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg;
 	struct cg_proto *cg_proto;
 
-	memcg = mem_cgroup_from_css(css);
+	memcg = mem_cgroup_from_css(of_css(of));
 	cg_proto = tcp_prot.proto_cgroup(memcg);
 	if (!cg_proto)
-		return 0;
+		return nbytes;
 
-	switch (event) {
+	switch (of_cft(of)->private) {
 	case RES_MAX_USAGE:
 		res_counter_reset_max(&cg_proto->memory_allocated);
 		break;
@@ -189,7 +190,7 @@ static int tcp_cgroup_reset(struct cgroup_subsys_state *css, unsigned int event)
 		break;
 	}
 
-	return 0;
+	return nbytes;
 }
 
 static struct cftype tcp_files[] = {
@@ -207,13 +208,13 @@ static struct cftype tcp_files[] = {
 	{
 		.name = "kmem.tcp.failcnt",
 		.private = RES_FAILCNT,
-		.trigger = tcp_cgroup_reset,
+		.write = tcp_cgroup_reset,
 		.read_u64 = tcp_cgroup_read,
 	},
 	{
 		.name = "kmem.tcp.max_usage_in_bytes",
 		.private = RES_MAX_USAGE,
-		.trigger = tcp_cgroup_reset,
+		.write = tcp_cgroup_reset,
 		.read_u64 = tcp_cgroup_read,
 	},
 	{ }	/* terminate */
-- 
1.9.0
