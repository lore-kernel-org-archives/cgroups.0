From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3 cgroup/for-5.20] cgroup: Add "no" prefixed mount options
Date: Thu, 14 Jul 2022 18:38:43 -1000
Message-ID: <YtDvU4jRPSsarcNp@slm.duckdns.org>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to:84;0;0cto;
        bh=WtkuRfGOX+EeArsQgZ8vEJVaXdyjjyp5b+gWBk4NmN0=;
        b=F/slt/TvVHPF+qnaW1+rRFIHVrBtRqgr2uEEiB725isM2nC+d8CDUiJMdCXIchcTBr
         MEe6n5OfuvxZxd+2FjfxvBegGQZfyDqzjoVAhsxvM12DBSxi7DCSVoTqFBlEmuNvYJml
         MmoiVTqN9QTK8Sjz9/Brai1q5LcTKs+WVOKVbkMPYKRpkQzLQCC/y78Z7uGDDqPawz/g
         hVpJQgKLmUuIRHlShEgoohuVanbWRn3l2PkgAH885uIIIwHSOyB3ww4zqv7S8CIk+XuT
         5VcfpA5fxj9i/dJUPoUvcNJBpeZckFlXWnhOcdNpTc5LPkESlNFpQRZSFxrBfrL42aHJ
         G4ng==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YtDvN0wJ6CKaEPN8-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: 
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

We allow modifying these mount options via remount. Let's add "no" prefixed
variants so that they can be turned off too.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |    6 +++---
 kernel/cgroup/cgroup.c                  |   20 +++++++++++++++-----
 2 files changed, 18 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -177,14 +177,14 @@ disabling controllers in v1 and make the
=20
 cgroup v2 currently supports the following mount options.
=20
-  nsdelegate
+  [no]nsdelegate
 	Consider cgroup namespaces as delegation boundaries.  This
 	option is system wide and can only be set on mount or modified
 	through remount from the init namespace.  The mount option is
 	ignored on non-init namespace mounts.  Please refer to the
 	Delegation section for details.
=20
-  memory_localevents
+  memory_[no]localevents
         Only populate memory.events with data for the current cgroup,
         and not any subtrees. This is legacy behaviour, the default
         behaviour without this option is to include subtree counts.
@@ -192,7 +192,7 @@ cgroup v2 currently supports the followi
         modified through remount from the init namespace. The mount
         option is ignored on non-init namespace mounts.
=20
-  memory_recursiveprot
+  memory_[no]recursiveprot
         Recursively apply memory.min and memory.low protection to
         entire subtrees, without requiring explicit downward
         propagation into leaf cgroups.  This allows protecting entire
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -279,8 +279,6 @@ bool cgroup_ssid_enabled(int ssid)
  *
  * - When mounting an existing superblock, mount options should match.
  *
- * - Remount is disallowed.
- *
  * - rename(2) is disallowed.
  *
  * - "tasks" is removed.  Everything should be at process granularity.  Use
@@ -1859,16 +1857,19 @@ int cgroup_show_path(struct seq_file *sf
 }
=20
 enum cgroup2_param {
-	Opt_nsdelegate,
-	Opt_memory_localevents,
-	Opt_memory_recursiveprot,
+	Opt_nsdelegate, Opt_nonsdelegate,
+	Opt_memory_localevents, Opt_memory_nolocalevents,
+	Opt_memory_recursiveprot, Opt_memory_norecursiveprot,
 	nr__cgroup2_params
 };
=20
 static const struct fs_parameter_spec cgroup2_fs_parameters[] =3D {
 	fsparam_flag("nsdelegate",		Opt_nsdelegate),
+	fsparam_flag("nonsdelegate",		Opt_nonsdelegate),
 	fsparam_flag("memory_localevents",	Opt_memory_localevents),
+	fsparam_flag("memory_nolocalevents",	Opt_memory_nolocalevents),
 	fsparam_flag("memory_recursiveprot",	Opt_memory_recursiveprot),
+	fsparam_flag("memory_norecursiveprot",	Opt_memory_norecursiveprot),
 	{}
 };
=20
@@ -1886,12 +1887,21 @@ static int cgroup2_parse_param(struct fs
 	case Opt_nsdelegate:
 		ctx->flags |=3D CGRP_ROOT_NS_DELEGATE;
 		return 0;
+	case Opt_nonsdelegate:
+		ctx->flags &=3D ~CGRP_ROOT_NS_DELEGATE;
+		return 0;
 	case Opt_memory_localevents:
 		ctx->flags |=3D CGRP_ROOT_MEMORY_LOCAL_EVENTS;
 		return 0;
+	case Opt_memory_nolocalevents:
+		ctx->flags &=3D ~CGRP_ROOT_MEMORY_LOCAL_EVENTS;
+		return 0;
 	case Opt_memory_recursiveprot:
 		ctx->flags |=3D CGRP_ROOT_MEMORY_RECURSIVE_PROT;
 		return 0;
+	case Opt_memory_norecursiveprot:
+		ctx->flags &=3D ~CGRP_ROOT_MEMORY_RECURSIVE_PROT;
+		return 0;
 	}
 	return -EINVAL;
 }
