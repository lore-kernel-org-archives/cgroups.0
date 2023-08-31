From: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
Subject: [PATH] cgroup: add cgroup_favordynmods= command-line option
Date: Thu, 31 Aug 2023 10:20:46 -0400
Message-ID: <20230831142046.37177-1-luizcap@amazon.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1693491695; x=1725027695;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TvFwiqQmFGnflqPwsI4vDJJirbAMWg8+sAoZoOii/Mg=;
  b=Y74DhUqJqngXa4ZQ3x76K4gp3EkWdFvoVBl9FgJyTp5vHB3IDZ01jrEu
   jhsxBaLwLnoI8WXZjSr5u9zEAHr/aRCU2muXxqLqUjat6OwVY3zW/QGfG
   Qk+a1n4ivcaq5rV6Ze1Cjx+E4xk5NiuvZY7IpxvY9uRzHbuNzHDdGQwn5
   U=;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: lcapitulino-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

We have a need of using favordynmods with cgroup v1, which doesn't support
changing mount flags during remount. Enabling CONFIG_FAVOR_DYNMODS at
build-time is not an option because we want to be able to selectively
enable it for certain systems.

This commit addresses this by introducing the cgroup_favordynmods=
command-line option. This option works for both cgroup v1 and v2 and
also allows for disabling favorynmods when the kernel built with
CONFIG_FAVOR_DYNMODS=y.

Signed-off-by: Luiz Capitulino <luizcap-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  4 ++++
 kernel/cgroup/cgroup.c                          | 14 +++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0c38a8af95ce..672f76a3c002 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -580,6 +580,10 @@
 			named mounts. Specifying both "all" and "named" disables
 			all v1 hierarchies.
 
+	cgroup_favordynmods= [KNL] Enable or Disable favordynmods.
+			Format: { "true" | "false" }
+			Defaults to the value of CONFIG_CGROUP_FAVOR_DYNMODS.
+
 	cgroup.memory=	[KNL] Pass options to the cgroup memory controller.
 			Format: <string>
 			nosocket -- Disable socket memory accounting.
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5fa95f86cb4d..b625825e270b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -207,6 +207,8 @@ static u16 have_exit_callback __read_mostly;
 static u16 have_release_callback __read_mostly;
 static u16 have_canfork_callback __read_mostly;
 
+static bool have_favordynmods __read_mostly = IS_ENABLED(CONFIG_CGROUP_FAVOR_DYNMODS);
+
 /* cgroup namespace for init task */
 struct cgroup_namespace init_cgroup_ns = {
 	.ns.count	= REFCOUNT_INIT(2),
@@ -2265,9 +2267,9 @@ static int cgroup_init_fs_context(struct fs_context *fc)
 	fc->user_ns = get_user_ns(ctx->ns->user_ns);
 	fc->global = true;
 
-#ifdef CONFIG_CGROUP_FAVOR_DYNMODS
-	ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
-#endif
+	if (have_favordynmods)
+		ctx->flags |= CGRP_ROOT_FAVOR_DYNMODS;
+
 	return 0;
 }
 
@@ -6767,6 +6769,12 @@ static int __init enable_cgroup_debug(char *str)
 }
 __setup("cgroup_debug", enable_cgroup_debug);
 
+static int __init cgroup_favordynmods_setup(char *str)
+{
+	return (kstrtobool(str, &have_favordynmods) == 0);
+}
+__setup("cgroup_favordynmods=", cgroup_favordynmods_setup);
+
 /**
  * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
  * @dentry: directory dentry of interest
-- 
2.40.1

