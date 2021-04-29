From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/5] tests/cgroup: use cgroup.kill in cg_killall()
Date: Thu, 29 Apr 2021 14:01:11 +0200
Message-ID: <20210429120113.2238065-3-brauner@kernel.org>
References: <20210429120113.2238065-1-brauner@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619697708;
        bh=5qld4YO5g4c9lOG9SwrBFf2p2zt+KhTuIbqd0h3aft0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXFDhV5fgITuYrlpH8KhcGC1nqJVV1hGIgJeKqyV8vK6/egmgfYmcKud+VC0XtESJ
         abxErzL4B2CmueBckjTo7dBmjFgydPYJg21bXileReGdEUusXc0BEGx7ygbyMxotef
         5mP3ytJnMZjfvXL/3Sy2Eo3eQ2JL9/l91441oboG5fAyBfeXVhJxAZ3hp5gBtk1kPL
         gNayyHq2r7+IwkdN1meD8Mf2xgh9wZ58vRZnwiynWykJMyWqbJ3hC382qHOpIkB7Z9
         8zRkivzyOiCdBBl4o0DORuSDBamA6fD/OMVc4Zp/Vme51FkWYyZXsczEtG3mr5uonP
         dfmWJprABZosQ==
In-Reply-To: <20210429120113.2238065-1-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

If cgroup.kill file is supported make use of it.

Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/cgroup/cgroup_util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 027014662fb2..3e27cd9bda75 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -252,6 +252,10 @@ int cg_killall(const char *cgroup)
 	char buf[PAGE_SIZE];
 	char *ptr = buf;
 
+	/* If cgroup.kill exists use it. */
+        if (!cg_write(cgroup, "cgroup.kill", "1"))
+		return 0;
+
 	if (cg_read(cgroup, "cgroup.procs", buf, sizeof(buf)))
 		return -1;
 
-- 
2.27.0

