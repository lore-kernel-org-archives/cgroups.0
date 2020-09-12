From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] mm: memcontrol: Fix out-of-bounds on the buf returned by memory_stat_format
Date: Sat, 12 Sep 2020 23:51:00 +0800
Message-ID: <20200912155100.25578-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5MxdQf9tv8eKzDg+x6Dz/JKJDrhNk6PlqBxr5x7bwNs=;
        b=w6jbt/CYSIpBugZJMVeS5NXurkdpxIawr2/+p5QKDl9ySs+weYpHK8k+foGfrwF4Tp
         3OlxZZtGbi+3nDmKvs49wq0tcgm9aKlYhWTR3UW1f/XpTCA0ZN0qDZMrLgLDaz9VHxNj
         ZcDSWsLbsvbivWVPnacSeT37LPh5zNjNIlIOIzxFVJUJ0Fdx3y6mzxqX1c+s+u8dQSbA
         XlmPiOQeEZmWRaZs5WdzCjuHeBaNEWWN5v4HH3Skq/8Bptolk093bINUyVF1DDCcDgTk
         pf21/VIdwJvxHEGlpJmjwRF//wmPw7y7qPJ1p9FZ/xfr2LTYJpx2g6S1fnvTOGwRpLT+
         csKw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The memory_stat_format() returns a format string, but the return buf
may not including the trailing '\0'. So the users may read the buf
out of bounds.

Fixes: c8713d0b2312 ("mm: memcontrol: dump memory.stat during cgroup OOM")
Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/memcontrol.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f2ef9a770eeb..20c8a1080074 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1492,12 +1492,13 @@ static bool mem_cgroup_wait_acct_move(struct mem_cgroup *memcg)
 	return false;
 }
 
-static char *memory_stat_format(struct mem_cgroup *memcg)
+static const char *memory_stat_format(struct mem_cgroup *memcg)
 {
 	struct seq_buf s;
 	int i;
 
-	seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE);
+	/* Reserve a byte for the trailing null */
+	seq_buf_init(&s, kmalloc(PAGE_SIZE, GFP_KERNEL), PAGE_SIZE - 1);
 	if (!s.buffer)
 		return NULL;
 
@@ -1606,7 +1607,8 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	/* The above should easily fit into one page */
-	WARN_ON_ONCE(seq_buf_has_overflowed(&s));
+	if (WARN_ON_ONCE(seq_buf_putc(&s, '\0')))
+		s.buffer[PAGE_SIZE - 1] = '\0';
 
 	return s.buffer;
 }
@@ -1644,7 +1646,7 @@ void mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *
  */
 void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 {
-	char *buf;
+	const char *buf;
 
 	pr_info("memory: usage %llukB, limit %llukB, failcnt %lu\n",
 		K((u64)page_counter_read(&memcg->memory)),
@@ -6415,7 +6417,7 @@ static int memory_events_local_show(struct seq_file *m, void *v)
 static int memory_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-	char *buf;
+	const char *buf;
 
 	buf = memory_stat_format(memcg);
 	if (!buf)
-- 
2.20.1

