From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: [PATCH v2 1/2] cgroup: fix psi monitor for root cgroup
Date: Sat, 16 Jan 2021 18:36:33 +0100
Message-ID: <20210116173634.1615875-2-odin@uged.al>
References: <20210116173634.1615875-1-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mxEgYGcQCZYKbRq3K2ngs08xWDWh3dTlzcMk23rneeQ=;
        b=ONxNoEUrPCGxB6M5IFJ2CYG1sWXTpgzhj4aK4aqkMTe61PAhVJloH06apvC5JWcFYn
         qQFHhWWe9VTPKnx28O/ZleRGHikVSkzCP+e4+/cYbbLnf/wy3ZZgp0f3ph6YvtxIEksu
         yYmJZTMSpIKT7RagJYoXr1jQ7gMgsYDnSC871szh7d8+3WYjo63Y7PSk4/NsSd3eau2C
         7vGY5Y2VE/0E5rXhD9Mcklt2BcvPfgwNJR3jHrYwrfaS55ry0tWwzLm9/laqA1xawliJ
         E/XKgcnyO1OB4Nd0xu35HGQdMLTIj7k+176Ne6oy4IrSwgqxuTFyow9EZvABxykXEP16
         uS4A==
In-Reply-To: <20210116173634.1615875-1-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dschatzberg-b10kYP2dOMg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>

Fix NULL pointer dereference when adding new psi monitor to the root
cgroup. PSI files for root cgroup was introduced in df5ba5be742 by using
system wide psi struct when reading, but file write/monitor was not
properly fixed. Since the PSI config for the root cgroup isn't
initialized, the current implementation tries to lock a NULL ptr,
resulting in a crash.

Can be triggered by running this as root:
$ tee /sys/fs/cgroup/cpu.pressure <<< "some 10000 1000000"

Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Reviewed-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 613845769103..1ea995f801ec 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3564,6 +3564,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 {
 	struct psi_trigger *new;
 	struct cgroup *cgrp;
+	struct psi_group *psi;
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
@@ -3572,7 +3573,8 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 	cgroup_get(cgrp);
 	cgroup_kn_unlock(of->kn);
 
-	new = psi_trigger_create(&cgrp->psi, buf, nbytes, res);
+	psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	new = psi_trigger_create(psi, buf, nbytes, res);
 	if (IS_ERR(new)) {
 		cgroup_put(cgrp);
 		return PTR_ERR(new);
-- 
2.30.0

