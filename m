From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.7-fixes] cgroup: set css->id to -1 during init
Date: Thu, 26 May 2016 15:42:13 -0400
Message-ID: <20160526194213.GD23194@mtj.duckdns.org>
References: <1463151560-5224-1-git-send-email-wwtao0320@163.com>
 <20160526191358.GB23194@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dZJQ0hC6AIDXwyYlxVxRf9ZUk/oR3bOUOEozrOAuE04=;
        b=G6P2LjcQ3Ho3RwK3Qrd4zo3ozFIvi/6rzfzwJ40N92QLNkKCCxi1sf7C4OCvrqzmYA
         Ts+qMPR6K6yr31bxCYCFTnbRM9kB2H71tUwWEMxJsS5O5V5XaWdxexHqzfuDSA0agrsO
         +OyYH6E6BpbDilGUZnLTe9cjp9zS782jyUAaiu5Hoi1gyj6OXFU4wmXPCGx3aHRpBCcA
         pudBNMUgnXADr4owupi3tMbpPIVQHe/yxNuG8THRSIiBreKCq5zoiBKeTFCKilWNVY/z
         Lc7OYqwUFkcUIiUAIzPe8HTB1Szm0MHnHcWAIyMy0addLGZtYGnBpg2la8kEsreFERjx
         Lv1A==
Content-Disposition: inline
In-Reply-To: <20160526191358.GB23194-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wenwei Tao <wwtao0320-9Onoh4P/yGk@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ww.tao0320-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

A follow-up patch.  Will queue in cgroup/for-4.7-fixes.

Thanks.
------ 8< ------
If percpu_ref initialization fails during css_create(), the free path
can end up trying to free css->id of zero.  As ID 0 is unused, it
doesn't cause a critical breakage but it does trigger a warning
message.  Fix it by setting css->id to -1 from init_and_link_css().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Wenwei Tao <ww.tao0320-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Fixes: 01e586598b22 ("cgroup: release css->id after css_free")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v4.0+
---
 kernel/cgroup.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 789b84f..688eb0c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5063,6 +5063,7 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 	memset(css, 0, sizeof(*css));
 	css->cgroup = cgrp;
 	css->ss = ss;
+	css->id = -1;
 	INIT_LIST_HEAD(&css->sibling);
 	INIT_LIST_HEAD(&css->children);
 	css->serial_nr = css_serial_nr_next++;
