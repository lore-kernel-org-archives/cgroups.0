From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cgroup: Avoid extra dereference in css_populate_dir()
Date: Tue, 12 Sep 2023 12:34:35 +0530
Message-ID: <5870fc2459d97b2e47c5a8dc47f1a2a3837c5e03.1694501024.git.kamalesh.babulal@oracle.com>
References: <96694dfc5f4caf4d84a740c3b18b0a456c9ff522.1694501024.git.kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=1b8I90tAdz+bE6JZJ/5tIQJobWNFIwRGJFQzIURIWZ8=;
 b=mu8EXXGXnMounHiTfobQeETY3J9A6KgAubU6jPqiBGRyDNnyQmmC6esXq18xPQDnG/KU
 KS9R+g6N9HrKnHECuz1Z7cnZb/f7vSo+PzoY697afD0H7vavh0Nb/jV9igoth/Eta/c5
 yPvDa+dx6mkq2M23YtALEZPydH9NX6qnwY7CRz66T1z3Rxs/w/392CbLLS+oFaT52YYz
 vBkX5Cfl7xYSYuWRq02Esc0oV/7KK673qRCP0cpZfjswDF1BCJX1SWLB1+jE46WJUg4O
 oT1ekhRNQFik9aSaBMKll0XhgHuRCOKAXbSY4cnRE5omDyGXzXdEtZcDXRt+E5McRmmY qQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1b8I90tAdz+bE6JZJ/5tIQJobWNFIwRGJFQzIURIWZ8=;
 b=D8Ei0jItgRhTL5P/z7Crw9FRkx7JUTOE1ZXS+LUwxenHAfTuqfND0na1pEGImEejob9zjRuUuJHZRpUXw2/2ey2aARDvZOs9X4VWNlQecQuvrFCBLKNRrauwz7Nn8D8Bs0oD8CTKRLC1vEZxvNGxbYLHqONJv0mgTAZJT3NGDFM=
In-Reply-To: <96694dfc5f4caf4d84a740c3b18b0a456c9ff522.1694501024.git.kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Use css directly instead of dereferencing it from &cgroup->self, while
adding the cgroup v2 cft base and psi files in css_populate_dir(). Both
points to the same css, when css->ss is NULL, this avoids extra deferences
and makes code consistent in usage across the function.

Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a6b1ea324b0e..f8ff85033e5a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1719,13 +1719,13 @@ static int css_populate_dir(struct cgroup_subsys_state *css)
 
 	if (!css->ss) {
 		if (cgroup_on_dfl(cgrp)) {
-			ret = cgroup_addrm_files(&cgrp->self, cgrp,
+			ret = cgroup_addrm_files(css, cgrp,
 						 cgroup_base_files, true);
 			if (ret < 0)
 				return ret;
 
 			if (cgroup_psi_enabled()) {
-				ret = cgroup_addrm_files(&cgrp->self, cgrp,
+				ret = cgroup_addrm_files(css, cgrp,
 							 cgroup_psi_files, true);
 				if (ret < 0)
 					return ret;
-- 
2.41.0

