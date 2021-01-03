From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: Remove unnecessary call to strstrip()
Date: Sun, 3 Jan 2021 02:50:01 +0000
Message-ID: <20210103024846.GA15337@haolee.github.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=p6iRhZ/uYPqRIQIFRU+QWQNN/PsTmWN2Q1BgTb5rkC4=;
        b=kmjT0+e+DXnGVq/NU58+KkWaJnAxIdBusxYqE/mjp9QJVLIDZ8pbW6u3Jpw1yh3wLI
         WGhq9ab+bgq5iWnCOvOZaX0/Mu7XPz4CBQ5tcx2m4aLgssWPsebKfcSQKJ4A0JZIjznz
         vs7vT+Wb+6ZjaJfKoDZbWnedxzEfQ8h/ywWRq3dsqwUTfT/rvEXQgCMzb/8p5s7djCS1
         dPW8+KAMCSc4ujNuYaqMU8ykLEkl46MuYXZ8CHmZN3VQZlDJfx43aKgW4JxnXY9+ib7R
         f3oX0/MlSGCXJEocqvyriKJtYskKkjq7twPLMotJtfcD3Z2ZLPrdfe1MQ5LsIoEqGQSq
         VGyw==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

The string buf will be stripped in cgroup_procs_write_start() before it
is converted to int, so remove this unnecessary call to strstrip().

Signed-off-by: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5e9cb81c088a..8b3554c1113a 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4774,8 +4774,6 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	ssize_t ret;
 	bool locked;
 
-	buf = strstrip(buf);
-
 	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!dst_cgrp)
 		return -ENODEV;
-- 
2.24.1

