From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: [PATCH 4/4] MAINTAINERS: add corresponding kselftests to memcg entry
Date: Thu, 14 Apr 2022 17:01:33 -0700
Message-ID: <20220415000133.3955987-5-roman.gushchin@linux.dev>
References: <20220415000133.3955987-1-roman.gushchin@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1649980917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=740eiMaj1mMtgTIenrEzjJ/eAUZj68u7jwk/iuSKMgA=;
        b=w26K1SB+vI3qaqMdu0othXCQB1y7ABS7GYKBiHyjn7Oq83TXcDjd1nQYCaEtHy+xgPM2wp
        GsIYAeRN7r6m+9/Z7v8uqQDhugTRg+GPlcAUuoul5FPpn8AI9RG3IKCDqQzkdbFVSf5Awd
        sdlg8ExeisaxNfQ/UzhP7myUs0ox6Pc=
In-Reply-To: <20220415000133.3955987-1-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

List memory control and kernel memory control kselftests in the memory
resource controller entry.

Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 44dabe0145ae..0dd3d276f330 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5030,6 +5030,8 @@ L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
 S:	Maintained
 F:	mm/memcontrol.c
 F:	mm/swap_cgroup.c
+F:	tools/testing/selftests/cgroup/test_kmem.c
+F:	tools/testing/selftests/cgroup/test_memcontrol.c
 
 CORETEMP HARDWARE MONITORING DRIVER
 M:	Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
-- 
2.35.1

