From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] cgroup: rstat: use same convention to assign cgroup_base_stat
Date: Sat,  8 Jan 2022 00:38:16 +0000
Message-ID: <20220108003817.6619-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=+thfZnjVJKWIwHVQowEtHa5pcMezvSbOgv9V4uT2rnw=;
        b=beAqvpsgAzbk5EtvsevPMK/hkrF/5AyZY+Q26XM++1/QXE1h2l/9vVcEKgLFvHqEd4
         2KjHwcqOVB2PQKWyUxsc3FBsaqmSkMPAjrWC7uENY7WiNI7uYjEfF5p6AE2wCcpf3bxP
         zyvmrvK+Ou/88nasMIAtGscl52qJopK41AIPuNX4PsE1T0izPuK0f6paZCeqNpMisLch
         oG95OnSQS96BtQ+I7BhH04JxkKmD1md4tkaOtv2In1k1beorC/qPvHckSJWb1RLoLIOV
         gtcUHo0g9sASNT1XZzeJ2pcdmT0SNqf5ug/AdvdNAAoM7kiWC+JCpH9CPYs4zlgFffu9
         DP8w==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

In function cgroup_base_stat_flush(), we update cgroup_base_stat by
getting rstatc->bstat and adjust delta to related fields.

There are two convention to assign cgroup_base_stat in this function:

  * rstat2 = rstat1
  * rstat2.cputime = rstat1.cputime

The second convention may make audience think just field "cputime" is
updated, while cputime is the only field in cgroup_base_stat.

Let's use the same convention to eliminate this confusion.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/rstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index a00875375f7d..c626d5a526c4 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -324,7 +324,7 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
 	/* fetch the current per-cpu values */
 	do {
 		seq = __u64_stats_fetch_begin(&rstatc->bsync);
-		cur.cputime = rstatc->bstat.cputime;
+		cur = rstatc->bstat;
 	} while (__u64_stats_fetch_retry(&rstatc->bsync, seq));
 
 	/* propagate percpu delta to global */
-- 
2.33.1

