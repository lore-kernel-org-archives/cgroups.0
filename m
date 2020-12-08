From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: [PATCH] psi: fix monitor for root cgroup
Date: Tue,  8 Dec 2020 09:35:10 +0100
Message-ID: <20201208083510.14344-1-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DVjmHtFolxRAfV2C2U9GLiRolrXJrnLIEB5X5ihubDs=;
        b=qAmjandBuTe8qafIuAhL+TRlTjWYdwJtv4pxvO3A91BFSWYQ2m5Dhc5xXfQ86i45P4
         E3fIfNW8Zyzttr/rUcthF0L0R46DB055NYg4IpBbRNoHX8L+c6pT9AlSyhHwt6L5MEGK
         IrcIIo7NM2/irS7jnXbifBZN+fNdTFHhYIKvh7/ychq6B8PNveguCXhAVaXvWRqSAFJm
         f4nOYltGvJKemURDUDlTLofhy8UHwaVdDv1ttvzDvudAGIwAy1Wzpz+oBT0P52Gqw7tz
         0b3B0QChyVPVQ0uyTybj0ii9Zisy884SfXaCGt7AK8RnwZHNPfF3P+L+T4pkausUhqXG
         JkKw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dschatzberg-b10kYP2dOMg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>

Fix NULL pointer dereference when adding new psi monitor to the root
cgroup. PSI files for root cgroup was introduced in df5ba5be742 by using
system wide psi struct when reading, but file write/monitor was not
properly fixed. Since the PSI config for the root cgroup isn't
initialized, the current implementation tries to lock a NULL ptr,
resulting in a crash.

Can be triggered by running this as root:
$ tee /sys/fs/cgroup/cpu.pressure <<< "some 10000 1000000"


Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e41c21819ba0..5d1fdf7c3ec6 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3567,6 +3567,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 {
 	struct psi_trigger *new;
 	struct cgroup *cgrp;
+	struct psi_group *psi;
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
@@ -3575,7 +3576,8 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 	cgroup_get(cgrp);
 	cgroup_kn_unlock(of->kn);
 
-	new = psi_trigger_create(&cgrp->psi, buf, nbytes, res);
+	psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	new = psi_trigger_create(psi, buf, nbytes, res);
 	if (IS_ERR(new)) {
 		cgroup_put(cgrp);
 		return PTR_ERR(new);
-- 
2.29.2

