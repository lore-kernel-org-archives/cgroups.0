From: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: remove cgrp->kn check in css_populate_dir()
Date: Mon, 17 Jul 2023 20:09:23 +0530
Message-ID: <20230717143923.1781747-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=2gMdCwqc6k73VPCUkJoX2Jt9fijqdm0vuWMqllzxYDQ=;
 b=zcWwN9or1ZRoXzhhtMQHQo2sOCKea2rMmMpqFstVB7gG6uX4SmkBDLXr/UxYMiXA6NGx
 UHIl8r0oPtN6tksnrushNC6VKjbbQonQo4Ss45mez1Zcd+TxGWw5My0OX4ie/UqCpY/2
 Qbd+9MPE2s/ljJ7CVkk3YTUOavARvCwuKoDwKVoDH+Nc4Uxkxy41qQD6lcrRlc4/MRYz
 nWxtZcmkn0o18iPFKy/Ir6k5OWfN4AIoSB5BTGel4Q6NDjsWL3py5wgn6YL3aeqB4O+m
 dLl2NR7VnMElvXbGe/ozVqtcLwyvmBUsKudsDg48wnqySj4vGF4rSlVR7/4ui9hJohQh ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gMdCwqc6k73VPCUkJoX2Jt9fijqdm0vuWMqllzxYDQ=;
 b=hs6tMUcUIDf7u7qAGYWCj4l+MhDz7faDdS65cOfUn+/Q8y4DDQddHMu6fIcwgoMhHHm81Lgcf99462YLZ+qb7bgkpbr+MUmENX+qzSGNto7GRAaaOXgO4ArQ2SJbhDkVptIFPsoPI0hEdCZQxecBY3owQs4iFmhE22979rRpfKU=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cgroup_create() creates cgrp and assigns the kernfs_node to cgrp->kn,
then cgroup_mkdir() populates base and csses cft file by calling
css_populate_dir() and cgroup_apply_control_enable() with a valid
cgrp->kn. Check for NULL cgrp->kn, will always be false, remove it.

Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f55a40db065f..5294fbfb4bf4 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1736,7 +1736,7 @@ static int css_populate_dir(struct cgroup_subsys_state *css)
 	struct cftype *cfts, *failed_cfts;
 	int ret;
 
-	if ((css->flags & CSS_VISIBLE) || !cgrp->kn)
+	if (css->flags & CSS_VISIBLE)
 		return 0;
 
 	if (!css->ss) {

base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.34.3

