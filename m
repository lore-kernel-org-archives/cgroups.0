From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 1/9] mm: vmstat: fix stat_threshold for NR_KERNEL_STACK_KB
Date: Sun,  6 Dec 2020 16:22:59 +0800
Message-ID: <20201206082318.11532-3-songmuchun@bytedance.com>
References: <20201206082318.11532-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CowKSBe21ybUCNZpbXy3BdqlRA0xnHhkE4QdTXQDr3k=;
        b=obgOqCMK9+gBEKH0ZvJObENCVSKcLtZyP4KoLqIoxqPr/HdB61VmQjSHVWVSI7Qy5H
         AUu5OHHRJzf0XtpZxFOi1Bi9pBoHz+y93p+W661gxc/7RyCbUU1hSTrnLiQdLzFWJSno
         YpNeLWL/tcbr57Vy1kaEHryGoS0DqPhRjiQizNC4yn2RNn7W1cTbgBLykdfOl0fGQnQX
         W6+EeIPIRYrz4GG9YL6ZdMRNVehGKGns5ox0eKwKWcsr9JjbNGMLy6uIfVNsxJ2Tt01W
         XY1cZtdYbAt+McNrsKL56VxC/b3pPKmdAe+2EPhEoxoYsXFHL31rlk/DVp5Ecnz4/ZAz
         xI4A==
In-Reply-To: <20201206082318.11532-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The kernel stack is being accounted in KiB not page, so the
stat_threshold should also adjust to byte.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/vmstat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8d77ee426e22..f7857a7052e4 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -353,6 +353,8 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 	x = delta + __this_cpu_read(*p);
 
 	t = __this_cpu_read(pcp->stat_threshold);
+	if (unlikely(item == NR_KERNEL_STACK_KB))
+		t <<= PAGE_SHIFT;
 
 	if (unlikely(abs(x) > t)) {
 		node_page_state_add(x, pgdat, item);
@@ -573,6 +575,8 @@ static inline void mod_node_state(struct pglist_data *pgdat,
 		 * for all cpus in a node.
 		 */
 		t = this_cpu_read(pcp->stat_threshold);
+		if (unlikely(item == NR_KERNEL_STACK_KB))
+			t <<= PAGE_SHIFT;
 
 		o = this_cpu_read(*p);
 		n = delta + o;
-- 
2.11.0

