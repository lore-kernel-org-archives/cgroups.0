From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH -next] cgroup: fix missing unlock on error in cgroup_load_subsys()
Date: Mon, 9 Dec 2013 20:38:29 +0800
Message-ID: <CAPgLHd8s94-e2=tynt-jKKNmoSXzNFHs+vYeUS1uW3+Ohk_OVA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=wdoNrArmQK/Rr442FjAIWAhoVz1U7ZH95hEms/Ld1zI=;
        b=m++f2kcsR9zun+sUNIKfruW5/NRIYyradQI1v7aAXmJvIU0B6XUeepNTeW4iz4+cG4
         jcLgo7pH0CwRT7c4nNLjPOOvb0CGI7EnDd6D5YuL6TN7pRTKZcNuK2vnEefnJKKZNkYY
         TPpybnwQDLSShmsXgWtgO4m7YS8PyiHLQxql5PcmA9Pjd/L+LonCdQdEDN136Pw8zrqa
         sgfuyMpI8JO7cTsY9t3HwaM6BvBwkGWa4oCDuV1RIlPWXq5LmtbLUx8CG6CYBwMkEm8h
         vu6L9hvHH7z3O3hsWQYFQIkeUyK1Y3n0w3i5olHyldld1SZ+5oqZQdwohuCpAa/H5t1q
         y6Wg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Add the missing unlock before return from function cgroup_load_subsys()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 kernel/cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index fb1193b..402f7aa 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4618,6 +4618,7 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	if (IS_ERR(css)) {
 		/* failure case - need to deassign the cgroup_subsys[] slot. */
 		cgroup_subsys[ss->subsys_id] = NULL;
+		mutex_unlock(&cgroup_root_mutex);
 		mutex_unlock(&cgroup_mutex);
 		return PTR_ERR(css);
 	}
