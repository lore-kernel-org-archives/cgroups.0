From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2 cgroup/for-3.20] cgroup: add dummy css_put() for
 !CONFIG_CGROUPS
Date: Tue, 6 Jan 2015 11:58:15 -0500
Message-ID: <20150106165815.GJ3077@htj.dyndns.org>
References: <20150106165720.GI3077@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iA+d89D+/VAsOkw0VZSjioPIjDF410KR163YCpPYi3A=;
        b=LJ7nsZslZVUkmwv98sWeuaMM+AWTGPjxhTysLZU6xuGlqJleNi8eh6XWgwVkIck8zb
         8PTlU1WRtTsDQa+cymxOlviznFAp5Szjp+zVaLHkGWivVvtnac14EfbuqbVlx9XHgHSs
         BMgKOQwgLWe1QRvspc2yFLYTdBiRWjzamZlW9k0sKozHLENuqc3ts2DLqQox9ytnTVqy
         fg3ufRvXnETZsatBCwliwSOLnbtxVUuuhCm6eTKhM/ua2ZhmVWWVzHLre2RiYX4WdYP+
         soolINujsgCOIVNcfR5+I1zy6rjHRydpgtkhE4JodKUDkp0GP83Hz1+kctD9H5fIccYs
         LwNw==
Content-Disposition: inline
In-Reply-To: <20150106165720.GI3077@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

This will later be depended upon by the scheduled cgroup writeback
support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -943,6 +943,8 @@ struct cgroup_subsys_state *css_tryget_o
 
 #else /* !CONFIG_CGROUPS */
 
+struct cgroup_subsys_state;
+
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
@@ -955,6 +957,8 @@ static inline int cgroupstats_build(stru
 	return -EINVAL;
 }
 
+static inline void css_put(struct cgroup_subsys_state *css) {}
+
 /* No cgroups - nothing to do */
 static inline int cgroup_attach_task_all(struct task_struct *from,
 					 struct task_struct *t)
