From: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH linux-next] mm: memcontrol: Fix typos in comment Fix a spelling mistake in comment.
Date: Mon, 15 Aug 2022 06:12:08 +0000
Message-ID: <20220815061208.65945-1-xu.panda@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=LhcqDlXGfJ5WZ4pq+69nFl1/2lUamAyvk5tX89/bbLw=;
        b=josV6bMQDWFEsYVQ1ffi3TcLPOFdBK8SdUPeL+Mzpqlr0xOsCTcflSe+QLaSP8mng6
         iD1HHHxy8U6X5F4Z2LTEPDVNESg9hF/49w3fjQyV+I/CkMU3w4Ry77cG4LYOz4+CkWW6
         Y/R6z/fWx+cPV6AJ/wHyT7MvGyEBoEBDUuSihr9+apX0A+EYUN8m9sDoRnoiEV/dNTbn
         rr73ULJMhxR/cXPDfwg9swGYD2aMr1kZrtbNwk91Z532o/n1tBu549Ja/tIZsgNMC42b
         Pw+F8OY4F85MwvDW1iMF3jfwDCGbzn/iZ83FzK3zEZelye6ugWfcWjh4fcMGvmrLDrzG
         SdHQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xupanda <xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, Zeal Robot <zealic-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

From: xupanda <xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Reported-by: Zeal Robot <zealic-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: xupanda <xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Thanks-to: Yang Yang <yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b69979c9ced5..4dddd8be320a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1143,7 +1143,7 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
 	/*
-	 * When cgruop1 non-hierarchy mode is used,
+	 * When cgroup1 non-hierarchy mode is used,
 	 * parent_mem_cgroup() does not walk all the way up to the
 	 * cgroup root (root_mem_cgroup). So we have to handle
 	 * dead_memcg from cgroup root separately.
-- 
2.25.1

