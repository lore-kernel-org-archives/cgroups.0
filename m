From: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/6] cgroup: Remove prohibited white spaces
Date: Tue, 15 Dec 2015 13:20:40 +0100
Message-ID: <1450182045-27480-1-git-send-email-kuba.kunert@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=h0HTv0odhMbEongzH7XGCUZX6owkJW6opv/50Ic8q1s=;
        b=XE+wlsvDRWjQS5LdC+/9UwJxijBKfO0IWoKaIgEGN54nPdLeYy6879EA8BIpph9K9n
         rX/w8298AoPyGYb9wH3hE9v4UxLpeeTUtUwGLepE5YMNBYzuU+PUPrgOhCdxOyF7oR+w
         RfWUmD5LCCMUTaGEOWbsLrJezmNnz3cfE3Nvn+EmW3jYhwhqot+PrLeWo8kNbro4NXc/
         mMFk8+Y049t7+qI4cOdcWKLrQuRuzQc7BiaBmi1DDZIclGI3QxwdmZkngqVJmwoeJbAY
         FrvCUApdAI7yjuij1ZOJMQlRJUkEnDQTYT3JJN3qPphLFqLNWOOmxXjZiWCNjewsle4o
         eV0Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This patch fixes the checkpatch.pl error:

ERROR: space prohibited before open square bracket

Signed-off-by: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 470f653..d848888 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -131,14 +131,14 @@ static struct workqueue_struct *cgroup_destroy_wq;
 static struct workqueue_struct *cgroup_pidlist_destroy_wq;
 
 /* generate an array of cgroup subsystem pointers */
-#define SUBSYS(_x) [_x ## _cgrp_id] = &_x ## _cgrp_subsys,
+#define SUBSYS(_x)[_x ## _cgrp_id] = &_x ## _cgrp_subsys,
 static struct cgroup_subsys *cgroup_subsys[] = {
 #include <linux/cgroup_subsys.h>
 };
 #undef SUBSYS
 
 /* array of cgroup subsystem names */
-#define SUBSYS(_x) [_x ## _cgrp_id] = #_x,
+#define SUBSYS(_x)[_x ## _cgrp_id] = #_x,
 static const char *cgroup_subsys_name[] = {
 #include <linux/cgroup_subsys.h>
 };
@@ -153,13 +153,13 @@ static const char *cgroup_subsys_name[] = {
 #include <linux/cgroup_subsys.h>
 #undef SUBSYS
 
-#define SUBSYS(_x) [_x ## _cgrp_id] = &_x ## _cgrp_subsys_enabled_key,
+#define SUBSYS(_x)[_x ## _cgrp_id] = &_x ## _cgrp_subsys_enabled_key,
 static struct static_key_true *cgroup_subsys_enabled_key[] = {
 #include <linux/cgroup_subsys.h>
 };
 #undef SUBSYS
 
-#define SUBSYS(_x) [_x ## _cgrp_id] = &_x ## _cgrp_subsys_on_dfl_key,
+#define SUBSYS(_x)[_x ## _cgrp_id] = &_x ## _cgrp_subsys_on_dfl_key,
 static struct static_key_true *cgroup_subsys_on_dfl_key[] = {
 #include <linux/cgroup_subsys.h>
 };
-- 
2.6.2
