From: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup-v1: add disabled controller check in cgroup1_parse_param()
Date: Mon, 12 Oct 2020 18:27:57 +0800
Message-ID: <20201012102757.83192-1-chenzhou10@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yangyingliang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

When mounting a cgroup hierarchy with disabled controller in cgroup v1,
all available controllers will be attached.

Add disabled controller check in cgroup1_parse_param() and return directly
if the specified controller is disabled.

Signed-off-by: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 191c329e482a..7427d47ad26f 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -915,6 +915,8 @@ int cgroup1_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		for_each_subsys(ss, i) {
 			if (strcmp(param->key, ss->legacy_name))
 				continue;
+			if (!cgroup_ssid_enabled(i) || cgroup1_ssid_disabled(i))
+				return invalfc(fc, "Disabled controller '%s'", param->key);
 			ctx->subsys_mask |= (1 << i);
 			return 0;
 		}
-- 
2.20.1

