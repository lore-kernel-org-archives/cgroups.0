From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 3/5] tests/cgroup: use cgroup.kill in cg_killall()
Date: Sat,  8 May 2021 14:15:40 +0200
Message-ID: <20210508121542.1269256-3-brauner@kernel.org>
References: <20210508121542.1269256-1-brauner@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620476157;
        bh=7eUgs0ekWyt837T6LcGkgs858Rf04B5QX6Bu8MJC1M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlWtUUcBhcUYyLTFNnIpiQz2INQqQ+j8PvRiTBdB6aT8IHclKvX+sGHML1HcJBVOx
         KnFt2ksYnEpo5M5mjRbI4fIm3Phqrgfn4muJDdt/hnP1JHX/ZzT7ItKkye3mDXYO5N
         aUYsu7S3EB4n4SkCTRgR5fvaZHHkoEmDgr8TQeFxH5l/yvIOizdB7ap9gIZiq8PPHh
         W/Q2Jir97d28xsTG7QGV5VoLS9anCsqPpmV2sCtGR9wA5/BG5B40EcA7Op4VFpVYOh
         3CTejniEES/tWhIhb+zdZaDxxwdoTxMXzEDqsfBgoHyyiCO9Uykg8dEJ1h5xYtYI92
         RXpct/e2EjaXA==
In-Reply-To: <20210508121542.1269256-1-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

If cgroup.kill file is supported make use of it.

Link: https://lore.kernel.org/r/20210503143922.3093755-3-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
/* v2 */
- Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>:
  - Fix whitespace.

/* v3 */
unchanged
---
 tools/testing/selftests/cgroup/cgroup_util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 027014662fb2..f60f7d764690 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -252,6 +252,10 @@ int cg_killall(const char *cgroup)
 	char buf[PAGE_SIZE];
 	char *ptr = buf;
 
+	/* If cgroup.kill exists use it. */
+	if (!cg_write(cgroup, "cgroup.kill", "1"))
+		return 0;
+
 	if (cg_read(cgroup, "cgroup.procs", buf, sizeof(buf)))
 		return -1;
 
-- 
2.27.0

