From: Qinglang Miao <miaoqinglang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: Fix memory leak when parsing multiple source parameters
Date: Wed, 9 Dec 2020 20:13:22 +0800
Message-ID: <20201209121322.77665-1-miaoqinglang@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Qinglang Miao <miaoqinglang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

A memory leak is found in cgroup1_parse_param() when multiple source
parameters overwrite fc->source in the fs_context struct without free.

unreferenced object 0xffff888100d930e0 (size 16):
  comm "mount", pid 520, jiffies 4303326831 (age 152.783s)
  hex dump (first 16 bytes):
    74 65 73 74 6c 65 61 6b 00 00 00 00 00 00 00 00  testleak........
  backtrace:
    [<000000003e5023ec>] kmemdup_nul+0x2d/0xa0
    [<00000000377dbdaa>] vfs_parse_fs_string+0xc0/0x150
    [<00000000cb2b4882>] generic_parse_monolithic+0x15a/0x1d0
    [<000000000f750198>] path_mount+0xee1/0x1820
    [<0000000004756de2>] do_mount+0xea/0x100
    [<0000000094cafb0a>] __x64_sys_mount+0x14b/0x1f0

Fix this bug by permitting a single source parameter and rejecting with
an error all subsequent ones.

Fixes: 8d2451f4994f ("cgroup1: switch to option-by-option parsing")
Reported-by: Hulk Robot <hulkci-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Qinglang Miao <miaoqinglang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 191c329e4..1fd7d3d18 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -908,6 +908,9 @@ int cgroup1_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	opt = fs_parse(fc, cgroup1_fs_parameters, param, &result);
 	if (opt == -ENOPARAM) {
 		if (strcmp(param->key, "source") == 0) {
+			if (fc->source)
+				return invalf(fc, "Multiple sources not
+						  supported");
 			fc->source = param->string;
 			param->string = NULL;
 			return 0;
-- 
2.23.0

