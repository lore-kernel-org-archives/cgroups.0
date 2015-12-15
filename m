From: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/6] cgroup: Replace printk(KERN_INFO) with pr_info().
Date: Tue, 15 Dec 2015 13:20:44 +0100
Message-ID: <1450182045-27480-5-git-send-email-kuba.kunert@gmail.com>
References: <1450182045-27480-1-git-send-email-kuba.kunert@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CsnbhaSWASnwbEsJKhJYmVcGe3LY+Xh7JJpiBm4wwmc=;
        b=TSgxv0QmbR+1w5K+8ZY3F7fGNR8ZyEJPWt+XRP4vz9SPMsH5PhRCqlXfm85k6nNkVg
         +AjOJrIAkaIiTP/s9CweZ+6xXb5NCdoLCLJtEzuRG20GL0xF/Qm+iPGpNgXK2GI3c2BU
         zlVDjL90Mpt2OCmYGXzZfGpOB8zJdXWtRUNOSrQ1IJfcN1uMY95+2TBq5mkWONGVPove
         W68FvkjDGMhx1P5urO1Leo8j/TnZumMUYpC3criYM2adKTSWmEBRy8ToG0fGdsqkWaME
         E6gnxevde3hmhWq6i5EcHpWdl/wM0/xX3cJ7t1A/eEltZ7Dsa0oR5xSxrOmklMaruQDV
         txbA==
In-Reply-To: <1450182045-27480-1-git-send-email-kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Fix checkpatch.pl warning.

Replace printk(KERN_INFO...) with pr_info().

Signed-off-by: Jakub Kunert <kuba.kunert-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9e248bc..a6ceb61 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5207,7 +5207,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 {
 	struct cgroup_subsys_state *css;
 
-	printk(KERN_INFO "Initializing cgroup subsys %s\n", ss->name);
+	pr_info("Initializing cgroup subsys %s\n", ss->name);
 
 	mutex_lock(&cgroup_mutex);
 
@@ -5346,7 +5346,7 @@ int __init cgroup_init(void)
 		 */
 		if (cgroup_disable_mask & (1 << ssid)) {
 			static_branch_disable(cgroup_subsys_enabled_key[ssid]);
-			printk(KERN_INFO "Disabling %s control group subsystem\n",
+			pr_info("Disabling %s control group subsystem\n",
 			       ss->name);
 			continue;
 		}
-- 
2.6.2
