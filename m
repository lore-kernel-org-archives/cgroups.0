From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] mm: memcontrol: fix get_active_memcg return value
Date: Tue, 23 Feb 2021 17:11:01 +0800
Message-ID: <20210223091101.42150-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1n7Y9GM24hDTWc1FsL/bOM/drrMT62OKuzLMW2dMgNM=;
        b=e3jX2u6s3VNO9Cw7VBXkZbV2bsB7SfRMzFYUTKkWHJyx573pYFk9e8bA850LLGy1zU
         sp9XRciHMY1IdpiRsOzlRUZ9nKvsWvDEkV3wB2HEM/Uc7kdr7iWHWNgpqjdlWZtvqCS/
         esiRkQUaNnPh/g21Q5v+dXrNKO6O03WlCnLF67aMATaS5GHhxM+Vd+AHzSOLqP2iuMnm
         fFCC+VhlzWuktUIDIJlSgC+hRXgCyYrb/8EmjqrzjRA5vK/zO/fpEekigNKBtBDNq7tc
         rYc8vQB8fu0wD6/63bilnvLuMe0nbRDGKaScMwX6SBmpHfncr1UNLUuvHEpAoy3I6Vo6
         qRwg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

We use a global percpu int_active_memcg variable to store the remote
memcg when we are in the interrupt context. But get_active_memcg always
return the current->active_memcg or root_mem_cgroup. The remote memcg
(set in the interrupt context) is ignored. This is not what we want.
So fix it.

Fixes: 37d5985c003d ("mm: kmem: prepare remote memcg charging infra for interrupt contexts")
Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/memcontrol.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index be6bc5044150..bbe25655f7eb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1061,13 +1061,9 @@ static __always_inline struct mem_cgroup *get_active_memcg(void)
 
 	rcu_read_lock();
 	memcg = active_memcg();
-	if (memcg) {
-		/* current->active_memcg must hold a ref. */
-		if (WARN_ON_ONCE(!css_tryget(&memcg->css)))
-			memcg = root_mem_cgroup;
-		else
-			memcg = current->active_memcg;
-	}
+	/* remote memcg must hold a ref. */
+	if (memcg && WARN_ON_ONCE(!css_tryget(&memcg->css)))
+		memcg = root_mem_cgroup;
 	rcu_read_unlock();
 
 	return memcg;
-- 
2.11.0

