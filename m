From: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 linux-next] mm: memcontrol: Fix a typo in comment
Date: Mon, 15 Aug 2022 06:51:04 +0000
Message-ID: <20220815065102.74347-1-xu.panda@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=gMw/e7nL3q8loyP6pDu1lcY4dhvsIg+AhMS6bilhZas=;
        b=SIQSKrhy7gSmBOGc2IwKJZ2KWeUd3CxvB6oVpapceFGs7jdaDf2mvBy2KNPEYXeA67
         oRtotJEWrCBkFc984f9vjq77D1b+ZSxmMaot5fqUAWhq3s3xwiX6v+Da1A17HfIH/P3c
         3vVa02JZO1ainbWvo1sTC6F5v9iSJMmqEuPdwIG0RulYObUbghvid9GOgBLRwWXyXiKw
         PqFhTTnjPeWTK5TZvrvDHNPIdIeXQKOH5HzEL/zp47iY+d6pGOFQ4PMqJ5N0KEscZmeZ
         qTJlixioi05WPAGs/gt82s4MIxqv1lOMI79IADTY9Y8+GNDD134BV6XaG5u3ryahqBdS
         V00w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xupanda <xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, CGEL ZTE <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: xupanda <xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Fix a spelling mistake in comment.

Reported-by: Zeal Robot <zealci-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: xupanda <xu.panda-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
Signed-off-by: CGEL ZTE <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
Change for v2:
 - fix wrong title
---

 mm/memcontrol.c     |  2 +-
 1 files changed, 1 insertions(+), 1 deletion(-)

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

