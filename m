From: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/1] cgroup-v1: Grant CAP_SYS_NICE holders permission to move tasks between cgroups
Date: Thu, 17 Jun 2021 10:09:41 +0100
Message-ID: <20210617090941.340135-1-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LddN6VdqgEQMBDMe5FR55fpFlxE7qF0s8cEeKWSAjEI=;
        b=KZpHq/WPIKCp1FfdmUAv30N4kxlka+BYdq8VCOr44rPGmtN7nA81Ky30TdKCsWiaLH
         WfeW6XrSTyoae7fp2LbfK5so5gWjrQJba25FfRA/ZDltyzU1h6uaCPi6VVeFBTtuaOVN
         YvwjKpmnRcBZ+vr5GfuKOuzlgz9AxJX3Dk8M/icA84TW4K9SaB3v19hBxBQipD5i7XLy
         t1Z6Zjmx+vys6N2FZm2y1cR8tUA1E8fWzqtTxw10nx9ufCPJ8HpaCypgTpde0BjzyrIY
         IHccjezjR6A5ECS4ddSOZeuMVW9YMeNDOFUkbqS+8SkqDxFhsOUKyAURr3mr6WARAhfR
         ypWQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

It should be possible for processes with CAP_SYS_NICE capabilities
(privileges) to move lower priority tasks within the same namespace to
different cgroups.

One extremely common example of this is Android's 'system_server',
which moves processes around to different cgroups/cpusets, but should
not require any other root privileges.

Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 1f274d7fc934e..56d0d91951f02 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -510,7 +510,8 @@ static ssize_t __cgroup1_procs_write(struct kernfs_open_file *of,
 	tcred = get_task_cred(task);
 	if (!uid_eq(cred->euid, GLOBAL_ROOT_UID) &&
 	    !uid_eq(cred->euid, tcred->uid) &&
-	    !uid_eq(cred->euid, tcred->suid))
+	    !uid_eq(cred->euid, tcred->suid) &&
+	    !ns_capable(tcred->user_ns, CAP_SYS_NICE))
 		ret = -EACCES;
 	put_cred(tcred);
 	if (ret)
-- 
2.32.0

