From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] mm/memcg: retrieve parent memcg from css.parent
Date: Tue, 11 Jan 2022 01:03:01 +0000
Message-ID: <20220111010302.8864-3-richard.weiyang@gmail.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jn9HpCa6G4upWAzqy9L2iSMpMRASsTNp9iLWrRF7M4U=;
        b=KnHpqKaf4bNL9UoWb2i9eRaXV2Ftcl/MbpDJtelOe1wEeOH/D/nh89jJcbfwg4oH+0
         g2jPXX1T8MpZTmQ+tmWaj4HEEwm7x/rHOWOaM0l6jzdQtSYxHnlmJB+jPT3xio5EKIYk
         Y8YjJ54LxCRf/YrbmV5yZCMFyTWDsgKF4NYUg80ytXHbjc0jcmwcHVL5ozQbucW9qL0e
         qLXgAMlMTlo5mVmPryAwe5Nfw1KcbnY0mJrlJZbjm7z1KrdVcxVMIIrqwh0WbS9A5ZPm
         NFyEUea7SjrAU4JkCZ750sDihBugarUnqrZ7t4MPy4XyWTzkw6sARu7MPD/1eaziPnfI
         7bBQ==
In-Reply-To: <20220111010302.8864-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The parent we get from page_counter is correct, while this is two
different hierarchy.

Let's retrieve the parent memcg from css.parent just like parent_cs(),
blkcg_parent(), etc.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

