From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 5.5 01/84] cgroup-v1: cgroup_pidlist_next should update position index
Date: Wed, 18 Mar 2020 16:51:58 -0400
Message-ID: <20200318205321.16066-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564803;
        bh=rY05YLwtbtXzyT165RkLIipQqmrwA6WUFyYk2qA7868=;
        h=From:To:Cc:Subject:Date:From;
        b=MFWj37g4/xef/y5znjvVQhQm+jTIn74eqyqUdQodP0LqvOodTKabK4H7meezvgFsL
         piZnLOYXWkJiX253JXXlDXlLSNHsB5gDLjihnS1qQ4/kiC2wlh8fJ+C1JhYoMZIkXT
         gXjHw/fQSEMz3/j3lG2h4imhV4SASba1Kb2LMRCE=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

[ Upstream commit db8dd9697238be70a6b4f9d0284cd89f59c0e070 ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

 # mount | grep cgroup
 # dd if=/mnt/cgroup.procs bs=1  # normal output
...
1294
1295
1296
1304
1382
584+0 records in
584+0 records out
584 bytes copied

dd: /mnt/cgroup.procs: cannot skip to specified offset
83  <<< generates end of last line
1383  <<< ... and whole last line once again
0+1 records in
0+1 records out
8 bytes copied

dd: /mnt/cgroup.procs: cannot skip to specified offset
1386  <<< generates last line anyway
0+1 records in
0+1 records out
5 bytes copied

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 09f3a413f6f89..84bedb87ae137 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -473,6 +473,7 @@ static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
 	 */
 	p++;
 	if (p >= end) {
+		(*pos)++;
 		return NULL;
 	} else {
 		*pos = *p;
-- 
2.20.1

