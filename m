From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cgroup: Check for ret during cgroup1_base_files cft addition
Date: Tue, 12 Sep 2023 12:34:34 +0530
Message-ID: <96694dfc5f4caf4d84a740c3b18b0a456c9ff522.1694501024.git.kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=IbtARqtEJtnIVj732ScqBaTY+yhWlXka1stGRULn0WE=;
 b=oTpm8pNo5rQ94xix2FhjyHu0uQx+3AEeddCPk21mhA5rDJloPLjL+BE73cTSvk3hVUwp
 Ef24r8BErllHf1t1PK80ALCXUzPQ3LALoIUrLDQW1awNsJecDyo04EGlgB4j7dOMRvdW
 vOearD+gJrQc9O2xng3JRe2Ab0ri6mqyrGgK60IQfVPtcXpU1Aow4tM7Ds71xOZk/EZF
 Y5P9wV6TEhvNMD9RS05eOEVhuuG6uMu0DZOpLtJOuL7WrpWDv9MqlsK2BFZEA2z/j0Rn
 R1qXYM/za6ELjJwltaFpFXRB5qXb3gYEJg3pgmFxLcsZz5S1R1l6Jx3i/L+seuBu/LID 5w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbtARqtEJtnIVj732ScqBaTY+yhWlXka1stGRULn0WE=;
 b=EqOPPeqW1mnQ70nNOw0HQbZTh8p9Wx8QAHcmm7/iNmcgWRw/UxH43zbr1I4Td1RaEH9VTD4Vz992OU05OXx7sgthc+uQNqgKXi7Jh21JVYFtMWtU3E/kAmw+TZNnkSUexTTC1DkUW6wcwiyAVDtqaoz1xSaPVv/LeT2y/RYaeTI=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

There is no check for possible failure while populating
cgroup1_base_files cft in css_populate_dir(), like its cgroup v2 counter
parts cgroup_{base,psi}_files.  In case of failure, the cgroup might not
be set up right.  Add ret value check to return on failure.

Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1fb7f562289d..a6b1ea324b0e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1731,8 +1731,10 @@ static int css_populate_dir(struct cgroup_subsys_state *css)
 					return ret;
 			}
 		} else {
-			cgroup_addrm_files(css, cgrp,
-					   cgroup1_base_files, true);
+			ret  =  cgroup_addrm_files(css, cgrp,
+						   cgroup1_base_files, true);
+			if  (ret  < 0)
+				return ret;
 		}
 	} else {
 		list_for_each_entry(cfts, &css->ss->cfts, node) {

base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
2.41.0

