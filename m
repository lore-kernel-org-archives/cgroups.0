From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 4.19 10/23] cgroup: disable controllers at parse time
Date: Thu,  3 Jun 2021 13:09:46 -0400
Message-ID: <20210603170959.3169420-10-sashal@kernel.org>
References: <20210603170959.3169420-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740212;
        bh=ltkAMp0vmOJzY3BoABuav09F7Gg6qRL7Ett2gEoitts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4eVUxGkh8fsdpRFUZTnp+r87JXUJnlvrCGbif98pqXiu83YLQVNv9/mpSbs1JOjt
         ew0GPT1mA1vmX+1Aevqg0CUIaGUuii+SCCp0zacLUSEpLoDUBqRO6Ki54NApkfXQ5C
         o8OySDAf3BxHHm2H3Ajib1alTu6PJvHTCxR43Nn7rqux3dpaUGm2tK2e5MNNogjPvO
         3tBeqwLPyJ1l5BQ5vNG0wbaghQ4eoGwzoF/UbUKlK59gX4NfDq/PKGpBBJtj2+VXhC
         d5H2Z2dg8lmPR7w7WrU1AoVNt4U2iRmHpcUMxbrJnIh8AQw/luFD5OFOU7AVQuqB6I
         x06IcZg4I7zkQ==
In-Reply-To: <20210603170959.3169420-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, NOMURA JUNICHI <junichi.nomura-YMj9X0ASwKA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

[ Upstream commit 45e1ba40837ac2f6f4d4716bddb8d44bd7e4a251 ]

This patch effectively reverts the commit a3e72739b7a7 ("cgroup: fix
too early usage of static_branch_disable()"). The commit 6041186a3258
("init: initialize jump labels before command line option parsing") has
moved the jump_label_init() before parse_args() which has made the
commit a3e72739b7a7 unnecessary. On the other hand there are
consequences of disabling the controllers later as there are subsystems
doing the controller checks for different decisions. One such incident
is reported [1] regarding the memory controller and its impact on memory
reclaim code.

[1] https://lore.kernel.org/linux-mm/921e53f3-4b13-aab8-4a9e-e83ff15371e4-YMj9X0ASwKA@public.gmane.org

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reported-by: NOMURA JUNICHI(野村　淳一) <junichi.nomura-YMj9X0ASwKA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Tested-by: Jun'ichi Nomura <junichi.nomura-YMj9X0ASwKA@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 2a879d34bbe5..a74549693e7f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5347,8 +5347,6 @@ int __init cgroup_init_early(void)
 	return 0;
 }
 
-static u16 cgroup_disable_mask __initdata;
-
 /**
  * cgroup_init - cgroup initialization
  *
@@ -5408,12 +5406,8 @@ int __init cgroup_init(void)
 		 * disabled flag and cftype registration needs kmalloc,
 		 * both of which aren't available during early_init.
 		 */
-		if (cgroup_disable_mask & (1 << ssid)) {
-			static_branch_disable(cgroup_subsys_enabled_key[ssid]);
-			printk(KERN_INFO "Disabling %s control group subsystem\n",
-			       ss->name);
+		if (!cgroup_ssid_enabled(ssid))
 			continue;
-		}
 
 		if (cgroup1_ssid_disabled(ssid))
 			printk(KERN_INFO "Disabling %s control group subsystem in v1 mounts\n",
@@ -5772,7 +5766,10 @@ static int __init cgroup_disable(char *str)
 			if (strcmp(token, ss->name) &&
 			    strcmp(token, ss->legacy_name))
 				continue;
-			cgroup_disable_mask |= 1 << i;
+
+			static_branch_disable(cgroup_subsys_enabled_key[i]);
+			pr_info("Disabling %s control group subsystem\n",
+				ss->name);
 		}
 	}
 	return 1;
-- 
2.30.2

