From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 14/31] cgroup: disable controllers at parse time
Date: Thu,  3 Jun 2021 13:09:02 -0400
Message-ID: <20210603170919.3169112-14-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740177;
        bh=qpzCxJU6gGdp8PmXCeRvdS+WsY4pcy0YsDZTgRqQe5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rik/ZsmIIMp7b0UNWsmPpVb2Z+YqJGRlcb+p4TbkqETS0zzGpipR+o6DHeiMS4njG
         s0s47Y5cPO0XzqEDfrLyZRicSFJIF/yOlMB0+ihmWoCC36h3fugpqOm1gsNoE/MoO+
         wTc2zgR3TtZcj8C+GzzTZ8Ts8Lj1CnZikjnWG4BGeDUKpMDYT4+q4awRhRDJzMtkft
         OJ8Remx1afQ2xqbp/KzBwSYbPiJfsJMraGcTW0N0Im5CrYkX34aMGrJ9WFFYeKEpGa
         aAHySyoZ+F0BcyrNv/IYliUpfRDzBYF/KX2a4msUq3n+2VO2hvOrJH9ZBjobtTq5he
         6ppAQBsTv3Gzw==
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Shakeel Butt <shakeelb@google.com>, NOMURA JUNICHI <junichi.nomura@nec.com>, Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

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

[1] https://lore.kernel.org/linux-mm/921e53f3-4b13-aab8-4a9e-e83ff15371e4@nec.com

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: NOMURA JUNICHI(野村　淳一) <junichi.nomura@nec.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Jun'ichi Nomura <junichi.nomura@nec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 37db8eba149a..ede370ec245d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5721,8 +5721,6 @@ int __init cgroup_init_early(void)
 	return 0;
 }
 
-static u16 cgroup_disable_mask __initdata;
-
 /**
  * cgroup_init - cgroup initialization
  *
@@ -5781,12 +5779,8 @@ int __init cgroup_init(void)
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
@@ -6173,7 +6167,10 @@ static int __init cgroup_disable(char *str)
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

