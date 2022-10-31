From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-6.1-fixes] cgroup: cgroup refcnt functions should
 be exported when CONFIG_DEBUG_CGROUP_REF
Date: Mon, 31 Oct 2022 07:41:08 -1000
Message-ID: <Y2AItI25gZ5MX6Nk@slm.duckdns.org>
References: <Y1w9EKH/CZhNGLJj@slm.duckdns.org>
 <Y1xGfJGIDIMKrMa7@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7LQXGndXpyfnn1/1I0XRemNKGO75fMj5OZBqMxSooCo=;
        b=VN0Qli60LvocYqr7xbaQSmrbSHY0rO8Eu/3MOFLouf76aeQakPt2NiDIuondE0WdVc
         HWYqaKOVvc6+UYaz2srlHEuzMgmn0yN36pfgi4tNLuVVCf99edLigZ2ISQZ4O/ZMgDhG
         nz/KqIb4d60ivDCoD5i2VU1y/gcphkIyUlM5IvZH0omBe533hsojAUc57MRnupvOYID2
         g/nVfcWSKxKgRMC6dpem/zCl1gZBbDDo7gTCL+odB+5ZdR2bUD5ltjpWx8c4N8TMufhc
         rw3sV0a67BF8nLdxK42QtBbFeCPnoIkz+wB+YRBa1jB/0cmSDLtn+6bZJnDiZxX23F58
         c46g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Y1xGfJGIDIMKrMa7-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: kernel-team-M8Ki61LpUEw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From 79a7f41f7f5ac69fd22eaf1fb3e230bea95f3399 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 31 Oct 2022 07:12:13 -1000

6ab428604f72 ("cgroup: Implement DEBUG_CGROUP_REF") added a config option
which forces cgroup refcnt functions to be not inlined so that they can be
kprobed for debugging. However, it forgot export them when the config is
enabled breaking modules which make use of css reference counting.

Fix it by adding CGROUP_REF_EXPORT() macro to cgroup_refcnt.h which is
defined to EXPORT_SYMBOL_GPL when CONFIG_DEBUG_CGROUP_REF is set.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: 6ab428604f72 ("cgroup: Implement DEBUG_CGROUP_REF")
---
The previous patch forgot to add symbol exports for modules when the refcnt
functions are forced !inline which broke module builds. Applying to
cgroup/for-6.1-fixes.

Thanks.

 include/linux/cgroup.h        | 1 +
 include/linux/cgroup_refcnt.h | 6 ++++++
 kernel/cgroup/cgroup.c        | 1 +
 3 files changed, 8 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5c9c07a44706..c8441090ca4c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -318,6 +318,7 @@ void css_put(struct cgroup_subsys_state *css);
 void css_put_many(struct cgroup_subsys_state *css, unsigned int n);
 #else
 #define CGROUP_REF_FN_ATTRS	static inline
+#define CGROUP_REF_EXPORT(fn)
 #include <linux/cgroup_refcnt.h>
 #endif
 
diff --git a/include/linux/cgroup_refcnt.h b/include/linux/cgroup_refcnt.h
index 1aa89295dac0..2eea0a69ecfc 100644
--- a/include/linux/cgroup_refcnt.h
+++ b/include/linux/cgroup_refcnt.h
@@ -10,6 +10,7 @@ void css_get(struct cgroup_subsys_state *css)
 	if (!(css->flags & CSS_NO_REF))
 		percpu_ref_get(&css->refcnt);
 }
+CGROUP_REF_EXPORT(css_get)
 
 /**
  * css_get_many - obtain references on the specified css
@@ -24,6 +25,7 @@ void css_get_many(struct cgroup_subsys_state *css, unsigned int n)
 	if (!(css->flags & CSS_NO_REF))
 		percpu_ref_get_many(&css->refcnt, n);
 }
+CGROUP_REF_EXPORT(css_get_many)
 
 /**
  * css_tryget - try to obtain a reference on the specified css
@@ -43,6 +45,7 @@ bool css_tryget(struct cgroup_subsys_state *css)
 		return percpu_ref_tryget(&css->refcnt);
 	return true;
 }
+CGROUP_REF_EXPORT(css_tryget)
 
 /**
  * css_tryget_online - try to obtain a reference on the specified css if online
@@ -61,6 +64,7 @@ bool css_tryget_online(struct cgroup_subsys_state *css)
 		return percpu_ref_tryget_live(&css->refcnt);
 	return true;
 }
+CGROUP_REF_EXPORT(css_tryget_online)
 
 /**
  * css_put - put a css reference
@@ -74,6 +78,7 @@ void css_put(struct cgroup_subsys_state *css)
 	if (!(css->flags & CSS_NO_REF))
 		percpu_ref_put(&css->refcnt);
 }
+CGROUP_REF_EXPORT(css_put)
 
 /**
  * css_put_many - put css references
@@ -88,3 +93,4 @@ void css_put_many(struct cgroup_subsys_state *css, unsigned int n)
 	if (!(css->flags & CSS_NO_REF))
 		percpu_ref_put_many(&css->refcnt, n);
 }
+CGROUP_REF_EXPORT(css_put_many)
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f786c4c973a0..f2743a476190 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -250,6 +250,7 @@ static int cgroup_addrm_files(struct cgroup_subsys_state *css,
 
 #ifdef CONFIG_DEBUG_CGROUP_REF
 #define CGROUP_REF_FN_ATTRS	noinline
+#define CGROUP_REF_EXPORT(fn)	EXPORT_SYMBOL_GPL(fn);
 #include <linux/cgroup_refcnt.h>
 #endif
 
-- 
2.38.0

