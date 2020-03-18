From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 01/37] cgroup-v1: cgroup_pidlist_next should update position index
Date: Wed, 18 Mar 2020 16:54:33 -0400
Message-ID: <20200318205509.17053-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564911;
        bh=V4XcCi4zI+m4Y89ggKKf+m+BzhB6paEjnpHJR1dUQbY=;
        h=From:To:Cc:Subject:Date:From;
        b=CZLyyrZdXbnBL0Ra4FUCOyjQjnDP85Yv0Ct8ndGon4Y2wEmDEklb7RZjVR0L6vOsi
         bwL+NcsUzl/x0eeaXefvxoxPP8ecs37DH35KNx85h3pKWRsqCo/p1DgKi9yIXKOMKS
         OojtKtS/rB8fRygMUml+rZtpOrf5kHsyVKbAsfDM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vasily Averin <vvs@virtuozzo.com>, Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

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
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup-v1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 51063e7a93c28..c9628b9a41d23 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -501,6 +501,7 @@ static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
 	 */
 	p++;
 	if (p >= end) {
+		(*pos)++;
 		return NULL;
 	} else {
 		*pos = *p;
-- 
2.20.1

