From: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH linux-next] cgroup: use strscpy() is more robust and safer
Date: Wed, 21 Sep 2022 09:35:17 +0000
Message-ID: <20220921093517.230745-1-ye.xingchen@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=EhnBpCpoeRYQHc027CvFJhCGZMSO3kz4CSNF4MCSNW0=;
        b=kVgHRrSzTLNMS7eqZGl2QTHvGOioL1m/DacQIY37AIn5NlUE+7WtjZL2IOapjMEv7t
         9eGAUGhzhwvg5i21Sv6uCQOfBv84TV9JJ9TS3gPAyojcOFP9xMjN0t5tYEx3aQX+YxZW
         lroMzn6Go11/EeSOOR8I1wUlbnVg+bzLfK0lSOPSJXtqrTlzv/uejD03/l40ulBM/Gru
         XAObuW4umiyFXBSL9IcS/xu+RzEuAE7uZXcRZSxoODMN4CgyR95hiZGDnsBZCi8br7Wx
         10C8rUAS4X+GFPE7RbmHrNIb9uR2du0+/7Ewp8Rrho2MQq73GsDv3K8FoPrJtD0wYpRu
         zQ1A==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

From: ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

The implementation of strscpy() is more robust and safer.

That's now the recommended way to copy NUL terminated strings.

Signed-off-by: ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 829aa42e773e..48a8e8fb3e91 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2374,7 +2374,7 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
 		ret = cgroup_path_ns_locked(cgrp, buf, buflen, &init_cgroup_ns);
 	} else {
 		/* if no hierarchy exists, everyone is in "/" */
-		ret = strlcpy(buf, "/", buflen);
+		ret = strscpy(buf, "/", buflen);
 	}
 
 	spin_unlock_irq(&css_set_lock);
-- 
2.25.1
