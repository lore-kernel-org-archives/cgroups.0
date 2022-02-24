From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] MAINTAINERS: add myself as a memcg co-maintainer as well
Date: Wed, 23 Feb 2022 22:01:48 -0800
Message-ID: <20220224060148.4092228-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OO7dB9NTGAXAhA+gBMGfXBf6knvYeWfSe3D67/xkaoQ=;
        b=BldGrl8aFcOSbdVR4P9FzFom2hvFMTJ2CdwBc7COsLaKo1cqiF/+Gv99lsd8c1msIk
         3PD3Be4u1NT5Uq9QMkdoXYWRZOLLsqG5XPtMpaeNhTEQG8GTp9GnTdUEAPEl5akR1sNj
         WnqgtfZa3bJx8sd7/c5cCwNm9VXJZY46+8anaKY/zgT/j0wXuns5FpJFZHo2AmBLU4nu
         gf97IPxANjPSyVqDP4u7V9J64qkz7Sb+ZiAHC7iFbec6WNOV9mbmtfUGmS3TLmEr54jN
         LkVheQoAnmVvPsWELK0en87WmNFB7+QZFMwJBc10XRolneDIfLb6xZ22Hqek9MO2leHx
         14dQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I have been contributing and reviewing to the memcg codebase for last
couple of years. So, making it official.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ab8f1621d027..cb97140e7dda 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5014,6 +5014,7 @@ CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
 M:	Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
 M:	Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 M:	Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
+M:	Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
 L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 L:	linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
 S:	Maintained
-- 
2.35.1.574.g5d30c73bfb-goog

