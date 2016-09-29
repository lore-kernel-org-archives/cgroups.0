From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.6] cgroup: fix error handling regressions in
 proc_cgroup_show() and cgroup_release_agent()
Date: Thu, 29 Sep 2016 15:54:02 +0200
Message-ID: <20160929135402.GA32490@mtj.duckdns.org>
References: <20160929092722.GA5513@mwanda>
 <20160929095836.GB24034@mtj.duckdns.org>
 <20160929132641.GP26713@mwanda>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uu1y9FOQudltFEf+CjyNNFDjXF3Xe+IQufkd6G6ZWNw=;
        b=VGsPfIIY0XrpUTu6Xrt1KBuDAsgJsGLAuZlMLDXF6OaI7qjSHagxwg7iIt8Ygx1MCS
         GBvBhjzcvJct84Oq4XYBIM4/mSzzJ4ImSHc/KMaTch+/KiSxN6AJnzQgpPfS3YJMFPVl
         OsPaxdaoGMbRIZiuHPcDaznp6TivXdvMXFZRUAu1IJk7PyAPeYvsxaZo23bhfmSoBu2i
         cdvzQfiJL3qrgoOjq64xXZyIYZ4UQlwJUxcGNHNTWYh7rDph/i0cWFF5SoO3MxaY4N2e
         VJEE6ZU3ny7inIEy4OzVSgbnYYiIKWdhuWwthsj/EbmSyqH3bsNoxMQJTLaZGddX31YC
         uPYw==
Content-Disposition: inline
In-Reply-To: <20160929132641.GP26713@mwanda>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

4c737b41de7f ("cgroup: make cgroup_path() and friends behave in the
style of strlcpy()") broke error handling in proc_cgroup_show() and
cgroup_release_agent() by not handling negative return values from
cgroup_path_ns_locked().  Fix it.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5e2e81a..a7f9fb4 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5781,10 +5781,10 @@ int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		if (cgroup_on_dfl(cgrp) || !(tsk->flags & PF_EXITING)) {
 			retval = cgroup_path_ns_locked(cgrp, buf, PATH_MAX,
 						current->nsproxy->cgroup_ns);
-			if (retval >= PATH_MAX) {
+			if (retval >= PATH_MAX)
 				retval = -ENAMETOOLONG;
+			if (retval < 0)
 				goto out_unlock;
-			}
 
 			seq_puts(m, buf);
 		} else {
@@ -6069,7 +6069,7 @@ static void cgroup_release_agent(struct work_struct *work)
 	spin_lock_irq(&css_set_lock);
 	ret = cgroup_path_ns_locked(cgrp, pathbuf, PATH_MAX, &init_cgroup_ns);
 	spin_unlock_irq(&css_set_lock);
-	if (ret >= PATH_MAX)
+	if (ret < 0 || ret >= PATH_MAX)
 		goto out;
 
 	argv[0] = agentbuf;
-- 
2.7.4
