From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 16/16] cgroup: allocate 2x cgrp_cset_links when setting up a new root
Date: Wed, 24 Feb 2016 17:02:48 -0500
Message-ID: <1456351368-786-17-git-send-email-tj@kernel.org>
References: <1456351368-786-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j4qYs3Y1IXkhi3HAJDYfM/7CjAyf5EYLxoKKIfeO4g4=;
        b=lDpgHHxpeyYxbtrimLylushjUkKsKHF+oc/PmY8BXUi+SuSf9EmNfewvp/bFdX3pYj
         dmULabRTBczSu9jKkk8qBpkbe1NbT6VRa3eHX9VRIZ8kvnTVsvpThW/I4R/CQUqDvJKh
         D1OgfBRprleDGJHv3AovdVi0KjYcfM8FSEfuvlX1kJZKIHLCmv7llfXHtf0C2TYC4/OH
         cVEKMtFKAzWUH5Jwabm2NH/HaTAoPTU/wNMXifV+7wZKTbADpBP+BufMAFg94RTgWr92
         IJlkES3SPFHfYrmVXtf2moKvPLuUxz7gjtXoVpzuHysnK+Mt/gOlImEbEQ2arMAXomX0
         w3CQ==
In-Reply-To: <1456351368-786-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

During prep, cgroup_setup_root() allocates cgrp_cset_links matching
the number of existing css_sets to later link the new root.  This is
fine for now as the only operation which can happen inbetween is
rebind_subsystems() and rebinding of empty subsystems doesn't create
new css_sets.

However, while not yet allowed, with the recent reimplementation,
rebind_subsystems() can rebind subsystems with descendant csses and
thus can create new css_sets.  This patch makes cgroup_setup_root()
allocate 2x of the existing css_sets so that later use of live
subsystem rebinding doesn't blow up.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 744e1c6..a44c123 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1914,10 +1914,11 @@ static int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	/*
 	 * We're accessing css_set_count without locking css_set_lock here,
 	 * but that's OK - it can only be increased by someone holding
-	 * cgroup_lock, and that's us. The worst that can happen is that we
-	 * have some link structures left over
+	 * cgroup_lock, and that's us.  Later rebinding may disable
+	 * controllers on the default hierarchy and thus create new csets,
+	 * which can't be more than the existing ones.  Allocate 2x.
 	 */
-	ret = allocate_cgrp_cset_links(css_set_count, &tmp_links);
+	ret = allocate_cgrp_cset_links(2 * css_set_count, &tmp_links);
 	if (ret)
 		goto cancel_ref;
 
-- 
2.5.0
