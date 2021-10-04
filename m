From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/4] cgroup: a u16 is enough for cgroup_subsys.depends_on
Date: Mon,  4 Oct 2021 08:49:25 +0000
Message-ID: <20211004084928.17622-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=mmeALFBSPw0ccXZyVUb3H3QtIHQV9aFgUitnFK9ucbw=;
        b=aHIWKedFODKrrTaJmBh4aOi/2LrXkyffWQb4L//E58fQFjBxgGnLl1ZR3xMzUMrGsp
         IINsD7Va/yh1OeAcM0Hv8dhy1f8zx6RwM4jg8oQd3H8d2ayx4kKD04dSuW4hrRR5Psav
         uVS/OI0IUD296TDCRqEFWLocB7DOp4ANoK/eABRwTpklFc5op/fopgWjEAvRQOSuFSj7
         uiOzRX5EEHruPKVUPtMquNZM0PuUbb0Qxt8rfSrAunjw0FQicKuogGlHD8Yn9okOcDFh
         J40nrYO+O6BHfT1Nl6jxO2kVwuYBvIBCGuMP1EDMTSAP8BkaYBhwJ2kgMBKkz01zrseZ
         2W9A==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

After commit 6e5c830770f9 ("cgroup: make cgroup subsystem masks u16"),
we limit the number of subsystem to be less then 16. This applies to
cgroup_subsys.depends_on too.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup-defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index db2e147e069f..f6d80896daab 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -705,7 +705,7 @@ struct cgroup_subsys {
 	 * not visible to userland until explicitly enabled.  The following
 	 * specifies the mask of subsystems that this one depends on.
 	 */
-	unsigned int depends_on;
+	u16 depends_on;
 };
 
 extern struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
-- 
2.23.0

