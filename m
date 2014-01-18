From: SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] cgroup: insert space before assignment for codingstyle
Date: Sat, 18 Jan 2014 16:56:47 +0900
Message-ID: <1390031808-31818-1-git-send-email-sj38.park@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=1wKjYGUt7SESgvcTLSGNUfdf6wSDUym+KkAcRs564xE=;
        b=RUtbvIkvgksTsDQxjeOCoiwG7phuXlw7OJv3YiC1sSloBqss8c41eK7QpJtgMtbu7R
         JFC0XNu1PngAM1szAXzYfiThb05R/7DNsKskvdHYMuDl12rjFOq2u+06Cv2N1GjoXopu
         fJ4PYcjgRPs0NQKmnTdOrAiK6IgmnIBPyKUL3FYUwB52VI0hRGtKJQYCZpVwFHN+0FBC
         RQDH5soLa/b9Vy3Vr/KkXsDzZjCpzDuKfoI6gNiqKTruHWu8XD8uEuymSeWJPSfdUPXf
         03urY7v8Ldh9Cb6+7adwNiFsrQBg6uHGD4I5BmYUSAeNW66aNotOblsLDD5Xi91emUHU
         uCJw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: SeongJae Park <sj38.park-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9ed68a3..4e47e28 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2127,7 +2127,7 @@ retry_find_task:
 		tsk = find_task_by_vpid(pid);
 		if (!tsk) {
 			rcu_read_unlock();
-			ret= -ESRCH;
+			ret = -ESRCH;
 			goto out_unlock_cgroup;
 		}
 		/*
-- 
1.8.3.2
