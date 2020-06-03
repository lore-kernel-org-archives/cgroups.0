From: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH v3 2/4] pid: Use file_receive helper to copy FDs
Date: Tue,  2 Jun 2020 18:10:42 -0700
Message-ID: <20200603011044.7972-3-sargun@sargun.me>
References: <20200603011044.7972-1-sargun@sargun.me>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nhWgywlp7hGFzT3uDr0Y1hpZYhM+popoEVRUKB4VQWc=;
        b=KcuhYU82+vDQQx/DeVCMpJeN14+0ym8WxhWxeXEkaQ+3yezTYF4Ee5fw/subrNMumN
         KyeAfCGCmRn0kJMIhZMcogDXCSfT+sBBqmi7wdOtjgBK8yInPiCqMLFgrVCWXL2KYFXQ
         wAigHdmOLJYq7IXym1xyUJRMKY8oH/Rez9kpo=
In-Reply-To: <20200603011044.7972-1-sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>, Matt Denton <mpdenton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Palmer <palmer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Robert Sesek <rsesek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The code to copy file descriptors was duplicated in pidfd_getfd.
Rather than continue to duplicate it, this hoists the code out of
kernel/pid.c and uses the newly added file_receive helper.

Earlier, when this was implemented there was some back-and-forth
about how the semantics should work around copying around file
descriptors [1], and it was decided that the default behaviour
should be to not modify cgroup data. As a matter of least surprise,
this approach follows the default semantics as presented by SCM_RIGHTS.

In the future, a flag can be added to avoid manipulating the cgroup
data on copy.

[1]: https://lore.kernel.org/lkml/20200107175927.4558-1-sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org/

Signed-off-by: Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>
Suggested-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Cc: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 kernel/pid.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index c835b844aca7..1642cf940aa1 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -606,7 +606,7 @@ static int pidfd_getfd(struct pid *pid, int fd)
 {
 	struct task_struct *task;
 	struct file *file;
-	int ret;
+	int ret, err;
 
 	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task)
@@ -617,18 +617,16 @@ static int pidfd_getfd(struct pid *pid, int fd)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-	ret = security_file_receive(file);
-	if (ret) {
-		fput(file);
-		return ret;
-	}
-
 	ret = get_unused_fd_flags(O_CLOEXEC);
-	if (ret < 0)
-		fput(file);
-	else
-		fd_install(ret, file);
+	if (ret >= 0) {
+		err = file_receive(ret, file);
+		if (err) {
+			put_unused_fd(ret);
+			ret = err;
+		}
+	}
 
+	fput(file);
 	return ret;
 }
 
-- 
2.25.1

