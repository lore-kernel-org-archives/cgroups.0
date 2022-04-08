From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 3/4] selftests: cgroup: fix alloc_anon_noexit() instantly
 freeing memory
Date: Fri,  8 Apr 2022 04:57:42 +0000
Message-ID: <20220408045743.1432968-4-yosryahmed@google.com>
References: <20220408045743.1432968-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gA8fl4VBLSIuPoY/kPZyFR8DNphzGSE/geYX3/dgg00=;
        b=Pcpd2Rbrapa7M7Za73CnE1bEFC5wI7dwEloVVr2sNZaIVqKCy5cB4naL+d9PVU9Kq9
         o27VPMESu81Lm/IKCtpsqDvuaOrAbNZ4Z3JlkNVWBzI0rgkIQUh8AgXWl+jQU788ZJmX
         l6A6jyeZdEjndJ2j2ErDuXmLudkDIPIY2lKK43CSnl2C6npVfgu2m4i619MVJM7BRrwk
         AY/5jLUI62lflwZYHGLXDAiENTVnD5dnA32uP1ue3g0CVNMJg6oMYm2jAGzmng8hs1ih
         0Riamlr+TJ4j2W4TmwXqsgJmdKZCloPwc1OqNvr5som55EVUiCPihm0xB908z/cfbhad
         eBpQ==
In-Reply-To: <20220408045743.1432968-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Currently, alloc_anon_noexit() calls alloc_anon() which instantly frees
the allocated memory. alloc_anon_noexit() is usually used with
cg_run_nowait() to run a process in the background that allocates
memory. It makes sense for the background process to keep the memory
allocated and not instantly free it (otherwise there is no point of
running it in the background).

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 36ccf2322e21..f2ffb3a30194 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -211,13 +211,17 @@ static int alloc_pagecache_50M_noexit(const char *cgroup, void *arg)
 static int alloc_anon_noexit(const char *cgroup, void *arg)
 {
 	int ppid = getppid();
+	size_t size = (unsigned long)arg;
+	char *buf, *ptr;
 
-	if (alloc_anon(cgroup, arg))
-		return -1;
+	buf = malloc(size);
+	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
+		*ptr = 0;
 
 	while (getppid() == ppid)
 		sleep(1);
 
+	free(buf);
 	return 0;
 }
 
-- 
2.35.1.1178.g4f1659d476-goog

