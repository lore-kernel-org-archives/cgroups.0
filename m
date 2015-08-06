From: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cpuset: use trialcs->mems_allowed as a temp variable
Date: Thu,  6 Aug 2015 16:21:05 +0200
Message-ID: <1438870865-25468-1-git-send-email-alban@endocode.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:mime-version:content-type
         :content-transfer-encoding;
        bh=PfQ5UaoRbJG45IeJnbLuXTXcNrWOyDqB/faaSWTG7OM=;
        b=RPz4cOh1Fwf7KuxPfiALg56sv5gTshEBJrUTdmP/YkteY3MBpGS1Ezi/+7htOgGsq1
         uSNKi0pZc+vopSPji3ZNjufZKMkZLyypBX5IUGVNiTWsgMiGh4AX7JT9nTzgHXnqjQuQ
         XFSHC4ZCqodqAE6yErEEGrQrRmK2kkIdqzmeBExqt4ZCIRf1rh9Eql67sRXUD9d//Tb5
         TQUOdwoCh7p4qLvtUnUjxR2vYADW8JM9eszyKKT5iEff/Cb/JGRmLolHyDJpTnyPDc8w
         ReiZwhEVY29/gI3b9kg/gJ3YNi0uASEjOnelGjQzjJJG8tIaKTiq+gg+W44IWobPnYD/
         96eA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Iago Lopez Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

The comment says it's using trialcs->mems_allowed as a temp variable bu=
t
it didn't match the code. Change the code to match the comment.

This fixes an issue when writing in cpuset.mems when a sub-directory
exists: we need to write several times for the information to persist:

| root@alban:/sys/fs/cgroup/cpuset# mkdir footest9
| root@alban:/sys/fs/cgroup/cpuset# cd footest9
| root@alban:/sys/fs/cgroup/cpuset/footest9# mkdir aa
| root@alban:/sys/fs/cgroup/cpuset/footest9# cat cpuset.mems
|
| root@alban:/sys/fs/cgroup/cpuset/footest9# echo 0 > cpuset.mems
| root@alban:/sys/fs/cgroup/cpuset/footest9# cat cpuset.mems
|
| root@alban:/sys/fs/cgroup/cpuset/footest9# echo 0 > cpuset.mems
| root@alban:/sys/fs/cgroup/cpuset/footest9# cat cpuset.mems
| 0
| root@alban:/sys/fs/cgroup/cpuset/footest9# cat aa/cpuset.mems
|
| root@alban:/sys/fs/cgroup/cpuset/footest9# echo 0 > aa/cpuset.mems
| root@alban:/sys/fs/cgroup/cpuset/footest9# cat aa/cpuset.mems
| 0
| root@alban:/sys/fs/cgroup/cpuset/footest9#

This should help to fix the following issue in Docker:
https://github.com/opencontainers/runc/issues/133
In some conditions, a Docker container needs to be started twice in
order to work.

Signed-off-by: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Tested-by: Iago L=C3=B3pez Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
---
 kernel/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ee14e3a..f0acff0 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1223,7 +1223,7 @@ static int update_nodemask(struct cpuset *cs, str=
uct cpuset *trialcs,
 	spin_unlock_irq(&callback_lock);
=20
 	/* use trialcs->mems_allowed as a temp variable */
-	update_nodemasks_hier(cs, &cs->mems_allowed);
+	update_nodemasks_hier(cs, &trialcs->mems_allowed);
 done:
 	return retval;
 }
--=20
2.1.4
