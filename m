From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: In cgroup_no_v1() check v1 controllers only
Date: Wed, 20 Sep 2023 15:55:12 +0530
Message-ID: <20230920102513.55772-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=GW/xaIA28aFiYyj+ym8GGUaoHZAoEuUh24wEEtr7hJg=;
 b=YuU26mMnldm9oF+jpINcGFsWbgWMzoVEmDmrnl4248HeBKZdaaNv9TwIf1SOEw+NDImH
 WkmqbTOPs42Yr+vlBlL4v2POcWq7G5kDI2sskRTSHmbEv8gJs1721qVcEuDWwpseR3gv
 CanVBKwbeYLfJtC/5SYeI9zAeZG9s0dhRxFc0Lc5tCvdjTv2bzROU870bxQT78adeTTY
 i+hugyILHBZlzOZiukqlgwdtUbg/wMMN4XQkpsFkP8MCxdqvk8xBZlJC8sDZ4Y8Vevar
 cvcNcSw0g4z1wkVYtJrDMY3cdm/JitkuDEbWoRPBVgpuJBdyG+ThALbpWgssefk+E/kb Mw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GW/xaIA28aFiYyj+ym8GGUaoHZAoEuUh24wEEtr7hJg=;
 b=QXR/0xDgo19ARZsy8feSqjx8s8qFTumCbJLAnWj5hxHpHSdm/ve2KpaSprpI6DE8DBN1MAoq9K3HPY2SsEi4UhM0YW+wuyGn5Np9XVTlIEtoP4/leT9bqweCqy/MUi0td+Z7cPG8EKCiX0xp+6Ia9lwm5GlKM3WJLimKO/cmQPU=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cgroup v1 or v2 or both controller names can be passed as arguments to
the 'cgroup_no_v1' kernel parameter, though most of the controller's
names are the same for both cgroup versions. This can be confusing when
both versions are used interchangeably, i.e., passing cgroup_no_v1=io

$ sudo dmesg |grep cgroup
...
cgroup: Disabling io control group subsystem in v1 mounts
cgroup: Disabled controller 'blkio'

Restrict the check to ss->legacy_name only, when parsing the controller
names passed to cgroup_no_v1 parameter and also, use ss->legacy_name in
pr_info(), that prints the controller disabling information.

Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 3 +--
 kernel/cgroup/cgroup.c    | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index c487ffef6652..942872b83bf2 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -1297,8 +1297,7 @@ static int __init cgroup_no_v1(char *str)
 		}
 
 		for_each_subsys(ss, i) {
-			if (strcmp(token, ss->name) &&
-			    strcmp(token, ss->legacy_name))
+			if (strcmp(token, ss->legacy_name))
 				continue;
 
 			cgroup_no_v1_mask |= 1 << i;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1fb7f562289d..622fb53a806b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6121,7 +6121,7 @@ int __init cgroup_init(void)
 
 		if (cgroup1_ssid_disabled(ssid))
 			pr_info("Disabling %s control group subsystem in v1 mounts\n",
-				ss->name);
+				ss->legacy_name);
 
 		cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 

base-commit: 2cf0f715623872823a72e451243bbf555d10d032
-- 
2.41.0

