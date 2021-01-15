From: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3] cgroup-v1: add disabled controller check in cgroup1_parse_param()
Date: Fri, 15 Jan 2021 17:37:17 +0800
Message-ID: <20210115093717.79474-1-chenzhou10@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, huawei.libin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

When mounting a cgroup hierarchy with disabled controller in cgroup v1,
all available controllers will be attached.
For example, boot with cgroup_no_v1=cpu or cgroup_disable=cpu, and then
mount with "mount -t cgroup -ocpu cpu /sys/fs/cgroup/cpu", then all
enabled controllers will be attached except cpu.

Fix this by adding disabled controller check in cgroup1_parse_param().
If the specified controller is disabled, just return error with information
"Disabled controller xx" rather than attaching all the other enabled
controllers.

Fixes: f5dfb5315d34 ("cgroup: take options parsing into ->parse_monolithic()")
Signed-off-by: Chen Zhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
Changes in v3:
- Update the description of commit message.
- Add Reviewed-by from Zefan.

Changes in v2:
- Fix line over 80 characters warning.
---
 kernel/cgroup/cgroup-v1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 32596fdbcd5b..a5751784ad74 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -917,6 +917,9 @@ int cgroup1_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		for_each_subsys(ss, i) {
 			if (strcmp(param->key, ss->legacy_name))
 				continue;
+			if (!cgroup_ssid_enabled(i) || cgroup1_ssid_disabled(i))
+				return invalfc(fc, "Disabled controller '%s'",
+					       param->key);
 			ctx->subsys_mask |= (1 << i);
 			return 0;
 		}
-- 
2.20.1

