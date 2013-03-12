From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] memcg: Don't account root memcg MEM_CGROUP_STAT_FILE_MAPPED stats
Date: Tue, 12 Mar 2013 18:10:03 +0800
Message-ID: <1363083003-3791-1-git-send-email-handai.szj@taobao.com>
References: <1363082773-3598-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=5l1StivgDOPVGaQekvRedivUd2trTZK8XJ5R/nbJAbM=;
        b=asWlb5bglDOqvalArPfyqGTb9ALQtM6gLLGNx9STbfsuaWJjKHPAiq0IErBjylKZHZ
         GpNFmxDZbrqlmjucve65UNrj5RtBDtT9pK1BT6OkzXPiAsmXbLO48LLGO243uoMyJfwv
         Zk3wTz90hCv3SL5M+bDcotuyLvolvCuQ4xuI1OjM1vgzD4i1sezjw2Yse/DZKWHGhV/Y
         rSd/WiKJxVoGwyba9WzDDpdef+keVXIzO2PMtyhvVuSbE33YSKbm4oA6amXXax8FXQw1
         klap8IgOKAeIGlpNPLN3JspbVjbcaPstqS9GaDqhrAL/gdbSRxhwkqnz6+qJnlJ03wnf
         d9bQ==
In-Reply-To: <1363082773-3598-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: mhocko-AlSwsSmVLrQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Similar with root memcg's CACHE/RSS, we don't account its stats counted
by mem_cgroup_update_page_stat() (now MEM_CGROUP_STAT_FILE_MAPPED only)
to improve performance.

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e89204f..24ce5e6d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2277,6 +2277,10 @@ void mem_cgroup_update_page_stat(struct page *page,
 		return;
 
 	memcg = pc->mem_cgroup;
+
+	if (mem_cgroup_is_root(memcg))
+		return;
+
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
 		return;
 
@@ -5446,7 +5450,8 @@ static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	struct mem_cgroup *mi;
 	unsigned int i;
-	enum zone_stat_item global_stat[] = {NR_FILE_PAGES, NR_ANON_PAGES};
+	enum zone_stat_item global_stat[] = {NR_FILE_PAGES, NR_ANON_PAGES,
+					NR_FILE_MAPPED};
 	long root_stat[MEM_CGROUP_STAT_NSTATS] = {0};
 
 	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
@@ -5455,8 +5460,7 @@ static int memcg_stat_show(struct cgroup *cont, struct cftype *cft,
 		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
 			continue;
 
-		if (mem_cgroup_is_root(memcg) && (i == MEM_CGROUP_STAT_CACHE
-					|| i == MEM_CGROUP_STAT_RSS)) {
+		if (mem_cgroup_is_root(memcg) && (i != MEM_CGROUP_STAT_SWAP)) {
 			val = global_page_state(global_stat[i]) -
 				mem_cgroup_recursive_stat(memcg, i);
 			root_stat[i] = val = val < 0 ? 0 : val;
-- 
1.7.9.5
