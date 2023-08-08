From: <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: [PATCH] mm/memcontrol: add tips for kmem.slabinfo
Date: Tue, 8 Aug 2023 10:22:29 +0800
Message-ID: <20230808022229.1560559-1-xiongwei.song@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding:content-type; s=PPS06212021; bh=AIPZU
        svPanUaYFy4CGvgvEVpmAFpszDXG2gqN2PuzBQ=; b=UethCzakofiuKA7BWnceH
        IJMw0tMeWg92lPunK+L74LWxfl0WMtfPhghAZCRRiFwoczIKuk32hXjBJ9PltW+O
        Q5uGWTlAXYpdmL+klE9cZUMbh1XktSH5mbZg8Ej4LHuVgGYqRjJOAnC6MfeYtAWn
        Vt9PVtvWdYkL+uMFuLXAjuZjCo43lXVFfw1sHLeIWtsR1WFmojbIcs1tgEtnhpAs
        FbAD1gsWIvUDnwJ3ftVAZxqpW9L6IQHy7ixsYydsmQVquCTaox2xWWfPMmDpPi8W
        Jc8hd/rA8fCLaHm0yE187j5zl6Zyz1eq0rqhjn0b1+dPOPYWIqJbO/YlTZhqlthY
        A==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>

No any output from kmem.slabinfo, which is not friendly. Adding
tips for it.

Signed-off-by: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
---
 mm/memcontrol.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8ca4bdcb03c..58d3bd93890b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5002,10 +5002,8 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
 #if defined(CONFIG_MEMCG_KMEM) && (defined(CONFIG_SLAB) || defined(CONFIG_SLUB_DEBUG))
 static int mem_cgroup_slab_show(struct seq_file *m, void *p)
 {
-	/*
-	 * Deprecated.
-	 * Please, take a look at tools/cgroup/memcg_slabinfo.py .
-	 */
+	seq_puts(m, "This file is deprecated.\n"
+		"Please use tools/cgroup/memcg_slabinfo.py, which is in kernel source.\n");
 	return 0;
 }
 #endif
-- 
2.37.3

