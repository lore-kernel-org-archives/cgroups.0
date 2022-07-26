From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-5.20] cgroup: remove "no" prefixed mount options
 options
Date: Tue, 26 Jul 2022 13:48:17 -1000
Message-ID: <YuB9QXapVUy1t8TZ@slm.duckdns.org>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <20220726143246.GA23794@blackbody.suse.cz>
 <YuBIACfZDk72yjI3@slm.duckdns.org>
 <YuB5ICv3bXsy5Xuh@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=yY9aRjMSrl3E8MLV9o3v7Jic3NwUOJ4OPWNoEH9R3G8=;
        b=iipoFRSFuacCTvG/hBlkKdzj7RgSpYh5GhiKNSBenYInTcpP45AEJiqCoHNPQ0Ovzn
         jEwxW8dfwiqO9S+mgdFnj+VRvmtr21ggmyIVMg34YUtmLWcgnEMk85j3OnqupYDJmxw0
         8jPYxI/J+1nesQ2FdFpavvq/Kr6iEl6WWET/Hd1VY6prHDwieRQD/jQy5tFbEXOk0k7/
         HP16312p2nDTd7uow6CWiVgNfSSUNZ0ztCwFiOHn0dox20oL9fmUexamI2Yt54/I1ElJ
         MYKPTKMY8agPE3xkx6oLLPYQpgZYJaSSicdpQ5j9NLRfEDKxUc3Iqzolvm4p/SZPXMQi
         MTVg==
Sender: htejun <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YuB5ICv3bXsy5Xuh-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

30312730bd02 ("cgroup: Add "no" prefixed mount options") added "no" prefixed
mount options to allow turning them off and 6a010a49b63a ("cgroup: Make
!percpu threadgroup_rwsem operations optional") added one more "no" prefixed
mount option. However, Michal pointed out that the "no" prefixed options
aren't necessary in allowing mount options to be turned off:

  # grep group /proc/mounts
  cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,relatime,nsdelegate,memory=
_recursiveprot 0 0
  # mount -o remount,nsdelegate,memory_recursiveprot none /sys/fs/cgroup
  # grep cgroup /proc/mounts
  cgroup2 /sys/fs/cgroup cgroup2 rw,relatime,nsdelegate,memory_recursivepro=
t 0 0

Note that this is different from the remount behavior when the mount(1) is
invoked without the device argument - "none":

 # grep cgroup /proc/mounts
 cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate,=
memory_recursiveprot 0 0
 # mount -o remount,nsdelegate,memory_recursiveprot /sys/fs/cgroup
 # grep cgroup /proc/mounts
 cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate,=
memory_recursiveprot 0 0

While a bit confusing, given that there is a way to turn off the options,
there's no reason to have the explicit "no" prefixed options. Let's remove
them.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst |    8 ++++----
 kernel/cgroup/cgroup.c                  |   24 ++++--------------------
 2 files changed, 8 insertions(+), 24 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -177,14 +177,14 @@ disabling controllers in v1 and make the
=20
 cgroup v2 currently supports the following mount options.
=20
-  [no]nsdelegate
+  nsdelegate
 	Consider cgroup namespaces as delegation boundaries.  This
 	option is system wide and can only be set on mount or modified
 	through remount from the init namespace.  The mount option is
 	ignored on non-init namespace mounts.  Please refer to the
 	Delegation section for details.
=20
-  [no]favordynmods
+  favordynmods
         Reduce the latencies of dynamic cgroup modifications such as
         task migrations and controller on/offs at the cost of making
         hot path operations such as forks and exits more expensive.
@@ -192,7 +192,7 @@ cgroup v2 currently supports the followi
         controllers, and then seeding it with CLONE_INTO_CGROUP is
         not affected by this option.
=20
-  memory_[no]localevents
+  memory_localevents
         Only populate memory.events with data for the current cgroup,
         and not any subtrees. This is legacy behaviour, the default
         behaviour without this option is to include subtree counts.
@@ -200,7 +200,7 @@ cgroup v2 currently supports the followi
         modified through remount from the init namespace. The mount
         option is ignored on non-init namespace mounts.
=20
-  memory_[no]recursiveprot
+  memory_recursiveprot
         Recursively apply memory.min and memory.low protection to
         entire subtrees, without requiring explicit downward
         propagation into leaf cgroups.  This allows protecting entire
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1872,22 +1872,18 @@ int cgroup_show_path(struct seq_file *sf
 }
=20
 enum cgroup2_param {
-	Opt_nsdelegate, Opt_nonsdelegate,
-	Opt_favordynmods, Opt_nofavordynmods,
-	Opt_memory_localevents, Opt_memory_nolocalevents,
-	Opt_memory_recursiveprot, Opt_memory_norecursiveprot,
+	Opt_nsdelegate,
+	Opt_favordynmods,
+	Opt_memory_localevents,
+	Opt_memory_recursiveprot,
 	nr__cgroup2_params
 };
=20
 static const struct fs_parameter_spec cgroup2_fs_parameters[] =3D {
 	fsparam_flag("nsdelegate",		Opt_nsdelegate),
-	fsparam_flag("nonsdelegate",		Opt_nonsdelegate),
 	fsparam_flag("favordynmods",		Opt_favordynmods),
-	fsparam_flag("nofavordynmods",		Opt_nofavordynmods),
 	fsparam_flag("memory_localevents",	Opt_memory_localevents),
-	fsparam_flag("memory_nolocalevents",	Opt_memory_nolocalevents),
 	fsparam_flag("memory_recursiveprot",	Opt_memory_recursiveprot),
-	fsparam_flag("memory_norecursiveprot",	Opt_memory_norecursiveprot),
 	{}
 };
=20
@@ -1905,27 +1901,15 @@ static int cgroup2_parse_param(struct fs
 	case Opt_nsdelegate:
 		ctx->flags |=3D CGRP_ROOT_NS_DELEGATE;
 		return 0;
-	case Opt_nonsdelegate:
-		ctx->flags &=3D ~CGRP_ROOT_NS_DELEGATE;
-		return 0;
 	case Opt_favordynmods:
 		ctx->flags |=3D CGRP_ROOT_FAVOR_DYNMODS;
 		return 0;
-	case Opt_nofavordynmods:
-		ctx->flags &=3D ~CGRP_ROOT_FAVOR_DYNMODS;
-		return 0;
 	case Opt_memory_localevents:
 		ctx->flags |=3D CGRP_ROOT_MEMORY_LOCAL_EVENTS;
 		return 0;
-	case Opt_memory_nolocalevents:
-		ctx->flags &=3D ~CGRP_ROOT_MEMORY_LOCAL_EVENTS;
-		return 0;
 	case Opt_memory_recursiveprot:
 		ctx->flags |=3D CGRP_ROOT_MEMORY_RECURSIVE_PROT;
 		return 0;
-	case Opt_memory_norecursiveprot:
-		ctx->flags &=3D ~CGRP_ROOT_MEMORY_RECURSIVE_PROT;
-		return 0;
 	}
 	return -EINVAL;
 }
