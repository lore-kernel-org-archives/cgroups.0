From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] memcg: Don't account root memcg swap stats
Date: Tue, 12 Mar 2013 18:10:39 +0800
Message-ID: <1363083039-3830-1-git-send-email-handai.szj@taobao.com>
References: <1363082773-3598-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=QBYU/pdmH5eW9Q1+BH9t1ynCsP38n0xcgh7TpfZXJ1g=;
        b=YFU0spq/maREvoMP+32pQjzSww35qIzDVonOz/hEOW1hiuLpwlwiBGSQK1CTbHGzvB
         tWsW3Ew98PgJRTebfnUVsiTQcDlblBkyxe0D+wtaMyxdIQ1Od8YMhtGkbZdXS1ApbcxJ
         +zGZHJH/tCXyrUUxdMQvc+gAHPFhFrSSCX9XrQZiNSj4J6y2WV/6m6pvA12GZoT3FqhO
         CSbLI6FdPp1okACVnystcYeJQbqW11xbug28E4j0hJQl279c7P7qrDTJ7Qg2JHTrvBzg
         V+itTTgmgLHqWtZXVqZngx+xKmK7KSrzQFKXDgBAzh2F1t6lmyP/sV4IH+N5WA3p01Z0
         Jt4Q==
In-Reply-To: <1363082773-3598-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Similar with root memcg's CACHE/RSS, we don't account its swap stats
to improve performance.

And for root memcg memcg_stat_show():
	nr(MEM_CGROUP_STAT_SWAP) = total_swap_pages - nr_swap_pages
				- sum_of_all_memcg(MEM_CGROUP_STAT_SWAP);

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 24ce5e6d..b73758e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -934,7 +934,9 @@ static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
 					 bool charge)
 {
 	int val = (charge) ? 1 : -1;
-	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAP], val);
+
+	if (!mem_cgroup_is_root(memcg))
+		this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAP], val);
 }
 
 static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
@@ -5460,10 +5462,13 @@ static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
 		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
 			continue;
 
-		if (mem_cgroup_is_root(memcg) && (i != MEM_CGROUP_STAT_SWAP)) {
-			val = global_page_state(global_stat[i]) -
-				mem_cgroup_recursive_stat(memcg, i);
-			root_stat[i] = val = val < 0 ? 0 : val;
+		if (mem_cgroup_is_root(memcg)) {
+			if (i == MEM_CGROUP_STAT_SWAP)
+				val = total_swap_pages -
+					atomic_long_read(&nr_swap_pages);
+			else
+				val = global_page_state(global_stat[i]);
+			val = val - mem_cgroup_recursive_stat(memcg, i);
 		} else
 			val = mem_cgroup_read_stat(memcg, i);
 		seq_printf(m, "%s %ld\n", mem_cgroup_stat_names[i],
-- 
1.7.9.5
