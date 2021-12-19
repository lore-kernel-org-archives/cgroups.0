From: Qi Zheng <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] cpuset: convert 'allowed' in __cpuset_node_allowed() to be boolean
Date: Sun, 19 Dec 2021 10:41:54 +0800
Message-ID: <20211219024154.28853-1-zhengqi.arch@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1fCDnzs11QBF/HgkFGJOxPwWBFoX6qDm6eKaoQut7Fg=;
        b=u385DoqLNxdGOTSHTYc/tJNFZZ1KR5LO4JfCZc8oc2ITGuRYg01B992ZOPe2SZHECt
         ucGsrko12/gWUNGpwPEqTUnUT9i75KKR2zCkUOJv+rGJ+PkuGN3LscQYCrS6ny0HS3cu
         AuhXPWp3EcbWy2hBuND6IYJp079NG7jcZUqbYrBqdrXeIlK1WCrfi/yxi+qPOdpGIZdP
         y3B5HeRMLbJ5PBxmcSRpKglfmI0mFRuGXtjqqowILph1dorR3MABpJFveEHLlYQkykHS
         ThZB44WazlXOe/rKp2DXaFy1TUTNSpd7fwlpJqzo9KnWfcvh9YfBniBJGyJ/rPhLFHD5
         wCGQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Qi Zheng <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Convert 'allowed' in __cpuset_node_allowed() to be boolean since the
return types of node_isset() and __cpuset_node_allowed() are both
boolean.

Signed-off-by: Qi Zheng <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 0dd7d853ed17..dc653ab26e50 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3528,7 +3528,7 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
 bool __cpuset_node_allowed(int node, gfp_t gfp_mask)
 {
 	struct cpuset *cs;		/* current cpuset ancestors */
-	int allowed;			/* is allocation in zone z allowed? */
+	bool allowed;			/* is allocation in zone z allowed? */
 	unsigned long flags;
 
 	if (in_interrupt())
-- 
2.11.0

