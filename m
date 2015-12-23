From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [OOPS] BUG_ON in cgroups on 4.4.0-rc5-next
Date: Wed, 23 Dec 2015 11:54:23 -0500
Message-ID: <20151223165423.GJ5003@mtj.duckdns.org>
References: <BLUPR0301MB200140C023EB8C2B414F6B13D8E10@BLUPR0301MB2001.namprd03.prod.outlook.com>
 <20151221215618.GB25997@mtj.duckdns.org>
 <BLUPR0301MB2001D645D9055C4DB1BF47BFD8E50@BLUPR0301MB2001.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=q9GiMWpkeEj2o58xP0Ymtp4CjTntKMZ+W6gf8v5pOZM=;
        b=wpN5EgRSOQhru0U8WF65yqFkXwCZl/zMENC1jyuB84ncZhNHo+GncOX3c01CvEddWM
         GOG8QoA1py/Wld3KkM3E0AMaFzXT/DnVDIILZq0fK1dhUIEU4ruHGqf/QWq0+m+j0JNx
         fZSXmMA+n4zzRhPV4Ey3Df8m/iup74faT/UThWo3jUwWN1tIuMLTqwuVRM4MQ25HhwlN
         djGniwRHPQ40aimMf2+NbDL0PjEhiV5OVv9+4IdBDfGrZ3dwEYtlSPSifjCwY4zru69g
         0luU62w9AEh0QKk3yxrxRKWwBVWen8bDQsPyqPheGq43WuD1kvqkbmPCu8OZPHbnTFYH
         VWOg==
Content-Disposition: inline
In-Reply-To: <BLUPR0301MB2001D645D9055C4DB1BF47BFD8E50-1/ziRz4NpW1pnNF7ophFSpwN6zqB+hSMnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: "Alex Ng (LIS)" <alexng-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello, Alex.

On Tue, Dec 22, 2015 at 07:06:41PM +0000, Alex Ng (LIS) wrote:
> > Can you please let me know the steps to reproduce the bug?
> 
> I tried this on a Hyper-V VM hosted in Windows Server 2012R2 and ran
> the attached script.  The script clones the linux-next tree in a
> random directory under /tmp in a tight loop.
>
> This panic is not always reproducible, and I have only hit it once
> after running the script about 10 times. A different kernel panic
> happens each time I run this script; and the panics always happen
> during the first iteration of the loop.

Heh, I don't get it.  The script doesn't do anything cgroup specific.
Can you please apply the attached patch, reproduce the issue and
report the kernel log?

Thanks.

-- 
tejun

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dbg

---
 kernel/cgroup.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -779,6 +779,22 @@ static inline void get_css_set(struct cs
 	atomic_inc(&cset->refcount);
 }
 
+static void dump_cset(struct css_set *cset)
+{
+	struct cgrp_cset_link *link;
+
+	printk("XXX dumping cset %p\n", cset);
+	list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
+		struct cgroup *cgrp = link->cgrp;
+		struct cgroup_root *root = cgrp->root;
+
+		printk("root %d:0x%04x:%s ",
+		       root->hierarchy_id, root->subsys_mask, root->name);
+		pr_cont_cgroup_path(cgrp);
+		pr_cont("\n");
+	}
+}
+
 /**
  * compare_css_sets - helper function for find_existing_css_set().
  * @cset: candidate css_set being tested
@@ -831,7 +847,10 @@ static bool compare_css_sets(struct css_
 		cgrp1 = link1->cgrp;
 		cgrp2 = link2->cgrp;
 		/* Hierarchies should be linked in the same order. */
-		BUG_ON(cgrp1->root != cgrp2->root);
+		if (WARN_ON(cgrp1->root != cgrp2->root)) {
+			dump_cset(cset);
+			dump_cset(old_cset);
+		}
 
 		/*
 		 * If this hierarchy is the hierarchy of the cgroup

--NzB8fVQJ5HfG6fxh--
