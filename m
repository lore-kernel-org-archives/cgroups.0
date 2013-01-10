From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH] memcg: modify swap accounting function to support THP
Date: Thu, 10 Jan 2013 19:43:58 +0800
Message-ID: <1357818238-11455-1-git-send-email-handai.szj@taobao.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=RhvdnwGitVzGkYGWiyIa73keqYA+Lylq5oDXxz5aHf4=;
        b=M8ygtUNy6Vkd9WBMCfaiv5a1wTOxrWviY76P9LxoZTrjsgtjv40dLRtU0H4M/6V6o6
         O35cLfrOi92EiD8MhHqEvDvtxa52ZODaiyApVLufQ8Qr0P7hbbKs+Nf/LZp7tkIUUK6L
         yVql+kv6uGUULmlcDDJ5qXyICiGk93/D70leHxil8vwq3CmSkoCNdOUYj5BJI8c4RNAB
         eH9pT7G/a3oVT5Tb/BTZ/7IIO4MM6QUnZHE13ABLgkspWbWKZH+D7LaHHnLuQUHTurNz
         lFcqWY1XGy/bo9VwDQ7tpfqVEQGEQ7Qc50C3M+8NfafTr/tfeomLl351YBeoPQanjHYY
         eyQw==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org
Cc: mhocko@suse.cz, akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 mm/memcontrol.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3817460..674cf21 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -914,10 +914,9 @@ static long mem_cgroup_read_stat(struct mem_cgroup *memcg,
 }
 
 static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
-					 bool charge)
+					 int nr_pages)
 {
-	int val = (charge) ? 1 : -1;
-	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAP], val);
+	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAP], nr_pages);
 }
 
 static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
@@ -4107,7 +4106,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype,
 	 */
 	memcg_check_events(memcg, page);
 	if (do_swap_account && ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT) {
-		mem_cgroup_swap_statistics(memcg, true);
+		mem_cgroup_swap_statistics(memcg, nr_pages);
 		mem_cgroup_get(memcg);
 	}
 	/*
@@ -4238,7 +4237,7 @@ void mem_cgroup_uncharge_swap(swp_entry_t ent)
 		 */
 		if (!mem_cgroup_is_root(memcg))
 			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
-		mem_cgroup_swap_statistics(memcg, false);
+		mem_cgroup_swap_statistics(memcg, -1);
 		mem_cgroup_put(memcg);
 	}
 	rcu_read_unlock();
@@ -4267,8 +4266,8 @@ static int mem_cgroup_move_swap_account(swp_entry_t entry,
 	new_id = css_id(&to->css);
 
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
-		mem_cgroup_swap_statistics(from, false);
-		mem_cgroup_swap_statistics(to, true);
+		mem_cgroup_swap_statistics(from, -1);
+		mem_cgroup_swap_statistics(to, 1);
 		/*
 		 * This function is only called from task migration context now.
 		 * It postpones res_counter and refcount handling till the end
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
