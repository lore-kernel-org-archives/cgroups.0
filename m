From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] mm/memcontrol: fix typo in comment
Date: Mon, 22 May 2023 09:52:32 +0000
Message-ID: <20230522095233.4246-1-haifeng.xu@shopee.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1684749169; x=1687341169;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NppiYUjLfZGAuzUVZ8J+F3/te0H7WwC9yNWRHxqdAXU=;
        b=mAHXhjnr4B10Di+HRXfOvHd45RH1ZC09M2i5WRiSBgtjO1iMvJbys9NM7W/AsSE3Tf
         aNzA/ntPMdNMpF9baZBpdG+WGvf3d3LHjeGVj8FC53cvq4OayvPxKsyVFEJs6ynw0r+Z
         Ipz3a9Xb0xy3+SGT7XoswuCsUz2YDYSwTZeuY9geRJKeEZIz7V91Dpr3ruuDuXH0oi0h
         NpOKVdG9nLLXup+8gM28O/BgZ2GOTDRIedKyPuGXDKcsagJFgU9D2Zxe5zT+kl5jzZKn
         fYBaJ/ZIjtxbGjjF3EuQcJTBbAXvT963tZNucsj7Y9FEjX4HPt9NdBqyHWvwYXztyor2
         95Iw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>

Replace 'then' with 'than'.

Signed-off-by: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4b27e245a055..ee78d3870edd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6896,7 +6896,7 @@ static unsigned long effective_protection(unsigned long usage,
 	protected = min(usage, setting);
 	/*
 	 * If all cgroups at this level combined claim and use more
-	 * protection then what the parent affords them, distribute
+	 * protection than what the parent affords them, distribute
 	 * shares in proportion to utilization.
 	 *
 	 * We are using actual utilization rather than the statically
-- 
2.25.1

