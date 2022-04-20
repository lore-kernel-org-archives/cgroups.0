From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 15/15] kthread: unexport kthread_blkcg
Date: Wed, 20 Apr 2022 06:27:23 +0200
Message-ID: <20220420042723.1010598-16-hch@lst.de>
References: <20220420042723.1010598-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FWpABD+wYsNJbTOYNRknLUaqgBYkljHxZCLKg/Ghs/k=; b=qVDpFHnA0++8zAeUACrsAqkpLM
        AsLLzUzFxeBBeMXuQaFLMtGXuAInVkXTCA6wD586JWcU1DNhi4Wz0IDIquCFWNU1GZq31ZhwXxhm3
        UlKZ/DZM7mFEA/Jnh4yriH7DlbkuQYDenS79lIVVcLMZ8X72WgqJU94629ntNN6L8AYwGIgGVbOJl
        aVJQAJX9tRZJFmC4oXSoZUyTZMhLujgu2gzr2dmrVFDcmRa+HesgW6AQ2/hpVY/k7zN+oxsV4m/Gj
        RDbVU/GqxWVwA23LhC0BO4za7A5zyut55+VywvUzTEwaCsYGaplIZ/VxF6/L/UHz8GU2dDdwxdmhN
        50p2p5pg==;
In-Reply-To: <20220420042723.1010598-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Dick Kennedy <dick.kennedy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

kthread_blkcg is only used by the built-in blk-cgroup code.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 include/linux/kthread.h | 4 ----
 kernel/kthread.c        | 1 -
 2 files changed, 5 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index de5d75bafd665..30e5bec81d2b6 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -222,9 +222,5 @@ void kthread_associate_blkcg(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *kthread_blkcg(void);
 #else
 static inline void kthread_associate_blkcg(struct cgroup_subsys_state *css) { }
-static inline struct cgroup_subsys_state *kthread_blkcg(void)
-{
-	return NULL;
-}
 #endif
 #endif /* _LINUX_KTHREAD_H */
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 50265f69a1354..544fd40974068 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -1522,5 +1522,4 @@ struct cgroup_subsys_state *kthread_blkcg(void)
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(kthread_blkcg);
 #endif
-- 
2.30.2

