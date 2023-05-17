From: Azeem Shaikh <azeemshaikh38-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: Replace all non-returning strlcpy with strscpy
Date: Wed, 17 May 2023 14:49:10 +0000
Message-ID: <20230517144910.1521547-1-azeemshaikh38@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684334963; x=1686926963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f05y9R3Fl6VbAlQDanAd2cha5Cf54wSBkc374UYz9UI=;
        b=bcV6hwSN/0UMrTECo6qVNLbcumprmfyioJE1mNkB4ZvaLkYCkIocelHX5SOEgYsMXy
         4qohG/wVVQqGw+ecK8qY4Fy8IUXu264edouOtmhBZPY/71Fu3QLqaWfhSP3TcKcQF+In
         ZO0mFghri6ezRm/oh0xOPXiR7FwL2bxHsWI25CcSeWyMwi/LdiWcisGKAXw+Xnq09mvP
         8lzLtMvMEUOQm2xLIdJZdzNQJZR6D2b2F64LumxbPfun64507uFbXaDIIJPE9PDxSFNZ
         +wfoK44iT56GTZxcV4/eUadsFzr09t6Wt4aFaPfQfz655XkMQiTC6ixOHuxsCI6Vzagc
         vLQQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Azeem Shaikh <azeemshaikh38-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with strscpy().
No return values were used, so direct replacement is safe.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89

Signed-off-by: Azeem Shaikh <azeemshaikh38-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index aeef06c465ef..d55216c4cc2d 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -563,7 +563,7 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
 	if (!cgrp)
 		return -ENODEV;
 	spin_lock(&release_agent_path_lock);
-	strlcpy(cgrp->root->release_agent_path, strstrip(buf),
+	strscpy(cgrp->root->release_agent_path, strstrip(buf),
 		sizeof(cgrp->root->release_agent_path));
 	spin_unlock(&release_agent_path_lock);
 	cgroup_kn_unlock(of->kn);
@@ -797,7 +797,7 @@ void cgroup1_release_agent(struct work_struct *work)
 		goto out_free;
 
 	spin_lock(&release_agent_path_lock);
-	strlcpy(agentbuf, cgrp->root->release_agent_path, PATH_MAX);
+	strscpy(agentbuf, cgrp->root->release_agent_path, PATH_MAX);
 	spin_unlock(&release_agent_path_lock);
 	if (!agentbuf[0])
 		goto out_free;

