From: Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] clone3: fix cgroup argument sanity check
Date: Sun, 12 Apr 2020 22:25:33 +0200
Message-ID: <20200412202533.GA29554@asgard.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586723144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=7C3D22+bfcyONw5l0dvYrkLR9HBNKhS92euE1BouTaU=;
        b=hFzSbQYZ9xcu/+suXp8oXlH9uQ5qnYI6BNpuJdeiYVg1EAvXJ2876us3aKw9s+JjAVd3UW
        Tdy3FkW7edV/A+3iPe8s4/nNp6K6yFJhZboFdfTFDkrwXaZgm7ET9bOXXFgdA9n/ljl7ek
        v7AKqcjCAHQ4l9x3OLyFTrVtCQvWlnE=
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>

Checking that cgroup field value of struct clone_args is less than 0
is useless, as it is defined as unsigned 64-bit integer.  Moreover,
it doesn't catch the situations where its higher bits are lost during
the assignment to the cgroup field of the cgroup field of the internal
struct kernel_clone_args (where it is declared as signed 32-bit
integer), so it is still possible to pass garbage there.  A check
against INT_MAX solves both these issues.

Fixes: ef2c41cf38a7559b ("clone3: allow spawning processes into cgroups")
Signed-off-by: Eugene Syromiatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 4385f3d..b4f7775 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2631,7 +2631,7 @@ noinline static int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 		     !valid_signal(args.exit_signal)))
 		return -EINVAL;
 
-	if ((args.flags & CLONE_INTO_CGROUP) && args.cgroup < 0)
+	if ((args.flags & CLONE_INTO_CGROUP) && args.cgroup > INT_MAX)
 		return -EINVAL;
 
 	*kargs = (struct kernel_clone_args){
-- 
2.1.4

