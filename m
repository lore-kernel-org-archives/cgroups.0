From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] cgroup: rstat: explicitly put loop variant in while
Date: Sat, 25 Dec 2021 00:09:31 +0000
Message-ID: <20211225000932.7253-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=sT/KIGohhkLRHjE3wm2QpMED803gmT90EUceteaiTMI=;
        b=Veny7lRRrWZ6cPaqOR1uySyz7YnyTWPGVAUtA23S03w2GGa/Sj2f9sCm89ozYiU3Qo
         hUhntjifTiyQxfwN7y5vW6QdTtXlhqM6U7RhP3cWSxfNm0ZfhwbUrJB/jjVdtE7jD29t
         lnPiuzVjMwD5PPwFFYR6jxA/Dijs21s2jg7TWGNf43364LTSwWT5O/A4hZRfvT2UTQgN
         PO9bf4FnsSzdsu1kM9AxU8XHitS2y1rnXZp9FL1mxEJEENOSoGuHhjCgh/+yURhmQKuW
         aEFoqMqwvq6hmOnomkBSchjGntX73QCZ86RhRytOX4U1+A8UkOh/84oejldtuLZKDRgt
         Zl2Q==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Instead of do while unconditionally, let's put the loop variant in
while.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/rstat.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 1486768f2318..a9d344e0521d 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -124,12 +124,10 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 
 			prstatc = cgroup_rstat_cpu(parent, cpu);
 			nextp = &prstatc->updated_children;
-			while (true) {
+			while (*nextp != pos) {
 				struct cgroup_rstat_cpu *nrstatc;
 
 				nrstatc = cgroup_rstat_cpu(*nextp, cpu);
-				if (*nextp == pos)
-					break;
 				WARN_ON_ONCE(*nextp == parent);
 				nextp = &nrstatc->updated_next;
 			}
-- 
2.33.1

