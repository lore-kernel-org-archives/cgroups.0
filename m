From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.9] cpuset: fix error error handling regression
 in proc_cpuset_show()
Date: Thu, 29 Sep 2016 11:58:36 +0200
Message-ID: <20160929095836.GB24034@mtj.duckdns.org>
References: <20160929092722.GA5513@mwanda>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=taLB+d4cPDybDhkmFfkv87/IwmXuiPUr/nDjNhGQopk=;
        b=PQfYQwIVe/kmueqMcd6yULRsVbBII//RTq/iLJSPG3X7ZXUFHHbV2+snNXIpdmgilP
         3/6DB2pWIQMLtVUTCuF9crwoBOpIAG/6dkvExotwXwSA5pv1hy7Hzy5Ji06H71YJstH/
         wYqck2Yh6EfXAZ5Jy1LZh//OR5KKep54/+LFhRJ7leSxcbzbxbW+FcC6LzXSWBo+4LBS
         J7mOHVY1WzOGF9feUy4Z0/0dfWsts1LuLKQgotL+zZh11IwVIDfZh5O4jPUMHV1gaAE/
         cMqfzK7b2Wb+OB2qSkP6jpDdilszqt+u8TxF0It7Rk8FoSbG2/YrjFn/MfCt5dUHwB6T
         LVPg==
Content-Disposition: inline
In-Reply-To: <20160929092722.GA5513@mwanda>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

4c737b41de7f ("cgroup: make cgroup_path() and friends behave in the
style of strlcpy()") botched the conversion of proc_cpuset_show() and
broke its error handling.  It made the function return 0 on failures
and fail to handle error returns from cgroup_path_ns().  Fix it.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Hello, Dan.

Does this make the warning go away?

Thanks.

 kernel/cpuset.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 793ae6f..97dd8e1 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2698,12 +2698,13 @@ int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
 	if (!buf)
 		goto out;
 
-	retval = -ENAMETOOLONG;
 	css = task_get_css(tsk, cpuset_cgrp_id);
 	retval = cgroup_path_ns(css->cgroup, buf, PATH_MAX,
 				current->nsproxy->cgroup_ns);
 	css_put(css);
 	if (retval >= PATH_MAX)
+		retval = -ENAMETOOLONG;
+	if (retval < 0)
 		goto out_free;
 	seq_puts(m, buf);
 	seq_putc(m, '\n');
@@ -2711,7 +2712,7 @@ int proc_cpuset_show(struct seq_file *m, struct pid_namespace *ns,
 out_free:
 	kfree(buf);
 out:
-	return 0;
+	return retval;
 }
 #endif /* CONFIG_PROC_PID_CPUSET */
 
