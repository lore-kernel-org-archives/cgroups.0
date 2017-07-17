From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: update outdated cgroup.procs documentation
Date: Sun, 16 Jul 2017 21:36:44 -0400
Message-ID: <20170717013644.GG2969123@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=OW2Pm+PqY99vd89Kq7z87qv8+rqtj3mALzHK6AGas/4=;
        b=M5QAtsQ45mkLq/AeJd2iBVxdsPPN/dlTvhyBYicyRSDnpsis2X+TnAuN2kybRNxYPs
         CbWeGCa8Ar7VTt4mBdbPwDeCdsy218mB+COIvkwFyjQx0qAwdtr2sDIKjxbMYQy+WgYr
         InavBFWvmagbKtRDnXrVSAtjuO28fk2e3Dgu7gyvxGyYiHF9Dwkrxi9eX0+GabWwNtLZ
         4+tfLURqlK1H+kg9n3dyFqABIVZJIrgPR5LKzTllSKiAC+xEt6hIZ/+cgCHHV0LazYff
         xK3agrb9aw7mnTJekMvXTRB7IZkcaL27Bl9C4Uj7Gd/l7n+qOMRrWOFe/F6XnT5uU2tW
         VybQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

576dd464505f ("cgroup: drop the matching uid requirement on migration
for cgroup v2") dropped the uid match requirement from "cgroup.procs"
perm check but forgot to update the matching entry in the
documentation.  Update it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Applying to cgroup/vor-4.14.

Thanks.

 Documentation/cgroup-v2.txt | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index bde1771..f01f831 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -658,9 +658,6 @@ All cgroup core files are prefixed with "cgroup."
 	the PID to the cgroup.  The writer should match all of the
 	following conditions.
 
-	- Its euid is either root or must match either uid or suid of
-          the target process.
-
 	- It must have write access to the "cgroup.procs" file.
 
 	- It must have write access to the "cgroup.procs" file of the
-- 
2.9.3
