From: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: make sure that decisions in __css_put are atomic
Date: Tue, 05 Jun 2012 14:50:19 -0700
Message-ID: <20120605215019.4722.31817.stgit@dungbeetle.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=subject:to:from:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        bh=jZ61KrBSNe0IxUNtbNh8E0/VIbeXeAbh3fYzNlFFp7o=;
        b=Lop3kq1bW+XVIHvwDlw+Is67jU2uGNEOfdxDXIe9x3lEiNOjh2guyfkhdmIghImAYd
         OT3/HwS0iOQInYDwxCaH92sRD+Ztg0qFpp2hlN/5hddRJ6fQdMLTmiewG3LFPUnLGkYJ
         5aWKHgq8OPL5kIeGKMDzZajR9XWc5IzLRTSHHb5QFi5tMOIuZOqyc7kws9xddbga6KH0
         m6l0TuvEtqRb/8zYza9Mt/ESNKMvP9bNXg/4DOVhSlWtUxgezaxmnxLJj5dI+82AWBAK
         3bwVsDrmGrItIwKPAdgt2k0lfoWVH3H3G950DWML2RcYgyyMrxE8wFPLhsZFelJR/6Vh
         ohTQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

__css_put is using atomic_dec on the ref count, and then
looking at the ref count to make decisions.  This is prone
to races, as someone else may decrement ref count between
our decrement and our decision.  Instead, we should base our
decisions on the value that we decremented the ref count to.

(This results in an actual race on Google's kernel which I
haven't been able to reproduce on the upstream kernel.  Having
said that, it's still incorrect by inspection).

Signed-off-by: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0f3527d..18dc8aa 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4973,8 +4973,7 @@ void __css_put(struct cgroup_subsys_state *css)
 	struct cgroup *cgrp = css->cgroup;
 
 	rcu_read_lock();
-	atomic_dec(&css->refcnt);
-	switch (css_refcnt(css)) {
+	switch (atomic_dec_return(&css->refcnt)) {
 	case 1:
 		if (notify_on_release(cgrp)) {
 			set_bit(CGRP_RELEASABLE, &cgrp->flags);
