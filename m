From: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroups: Account for CSS_DEACT_BIAS in __css_put
Date: Thu, 14 Jun 2012 14:55:30 -0700
Message-ID: <20120614215530.12092.3543.stgit@dungbeetle.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=subject:to:from:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        bh=Soma0bOYqmSpMcdhKXgWyQgIqVLx7XaNvSdCffUdmLA=;
        b=Do24MUYkKWQRpZq09w0Ke2f2++FHmM1rcq//4xqnLU1nDiZyd7RV9O715ZQ/+5VKb4
         Bu1qP3k4X9YGHnoDGv+gK6yY3qLw049BbrME/ubgcQSIsEnghjbWAu8ktSMoic5Hv2l+
         qfRcutbrEl0DW5aYMUP1+3OVD5pEW8IQQ68haI79YLoF70+zI2ONQ5kOhgxbgsO6YqdD
         hfAhNU+W2XsyUAAe5kT3p9Skm9PSbJx6gB2IaBk7xBXLkAoeE0QxuWH8r9DFIS4C+sHx
         ugd/VY6XUWiMbhG0YmvEydzQi51h3zHVceI8sAzpDSJQAT3utLTdn226sx2nxVr7gKLi
         FKUw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

When we fixed the race between atomic_dec and css_refcnt, we missed
the fact that css_refcnt internally subtracts CSS_DEACT_BIAS to get
the actual reference count.  This can potentially cause a refcount leak
if __css_put races with cgroup_clear_css_refs.

Signed-off-by: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ceeafe8..2097684 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -255,12 +255,17 @@ int cgroup_lock_is_held(void)
 
 EXPORT_SYMBOL_GPL(cgroup_lock_is_held);
 
+static int css_unbias_refcnt(int refcnt)
+{
+	return refcnt >= 0 ? refcnt : refcnt - CSS_DEACT_BIAS;
+}
+
 /* the current nr of refs, always >= 0 whether @css is deactivated or not */
 static int css_refcnt(struct cgroup_subsys_state *css)
 {
 	int v = atomic_read(&css->refcnt);
 
-	return v >= 0 ? v : v - CSS_DEACT_BIAS;
+	return css_unbias_refcnt(v);
 }
 
 /* convenient tests for these bits */
@@ -4982,9 +4987,12 @@ EXPORT_SYMBOL_GPL(__css_tryget);
 void __css_put(struct cgroup_subsys_state *css)
 {
 	struct cgroup *cgrp = css->cgroup;
+	int v;
 
 	rcu_read_lock();
-	switch (atomic_dec_return(&css->refcnt)) {
+	v = css_unbias_refcnt(atomic_dec_return(&css->refcnt));
+
+	switch (v) {
 	case 1:
 		if (notify_on_release(cgrp)) {
 			set_bit(CGRP_RELEASABLE, &cgrp->flags);
