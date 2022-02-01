From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] mm/memcg: retrieve parent memcg from css.parent
Date: Tue,  1 Feb 2022 00:46:43 +0000
Message-ID: <20220201004643.8391-2-richard.weiyang@gmail.com>
References: <20220201004643.8391-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GYfi12SpmN0g9NqCoQ6tYL22xFi8Uo1iR/vTcnK9fck=;
        b=M8JyDPdDdfrEs1luJVidkqPn7+qgD4TNYcQAXFMm0RPY0nfJUSyFdHSYKBx3dzqcfJ
         wjDKrCKhJEa/VH4upcSnRwzq43GqdetPEPK02terNMKeobZISvpFpg+OLMKkXJIiRohZ
         RKqi01JwhYCy97rwRMiRDbzaxzb7rFt6NuXoaObwhZSU6MTauJT/320Lbr2K3otV2rLo
         Nuw4NPg3mzoRAe6gyu1kt9BqCIoF+9Xk5c/wWEfuPFviHOP6UP8XDExpwUO22re57moT
         9zqp6p8fUCanOl1R2fgrr3/wsQNlHOg0JwBcUVs2xoTaxLS7VIuHmzQwu7gj1gXlEdkW
         cIVg==
In-Reply-To: <20220201004643.8391-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The parent we get from page_counter is correct, while this is two
different hierarchy.

Let's retrieve the parent memcg from css.parent just like parent_cs(),
blkcg_parent(), etc.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0c5c403f4be6..12bf443f7b14 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -886,9 +886,7 @@ static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
  */
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
 {
-	if (!memcg->memory.parent)
-		return NULL;
-	return mem_cgroup_from_counter(memcg->memory.parent, memory);
+	return mem_cgroup_from_css(memcg->css.parent);
 }
 
 static inline bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
-- 
2.33.1

