From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v8 1/7] cgroup/cpuset: Fix load balance state in update_partition_sd_lb()
Date: Tue,  5 Sep 2023 09:32:37 -0400
Message-ID: <20230905133243.91107-2-longman@redhat.com>
References: <20230905133243.91107-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693920775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SsMuS7PTbmTmLZ/65tzTFutVzo4Sb2uYSpo6j3AWtxQ=;
        b=RhWfLSooRklgB3gtN4+B0XtwPYgpkZ7ONRPBVzNY93WOBGLKHYiPvvG+jq0rgbQ8wU/28E
        euFy7QggSYmEwl9ED/s+GzuET6AkoGrF66HJpjMTpQWbrS4IR/1QbIQ1/vcnpj6m5Yd7Sv
        jZ5ioQIcfhxNyl/S/sfN8ZoTs8OADXU=
In-Reply-To: <20230905133243.91107-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Commit a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE
& CS_SCHED_LOAD_BALANCE handling") adds a new helper function
update_partition_sd_lb() to update the load balance state of the
cpuset. However the new load balance is determined by just looking at
whether the cpuset is a valid isolated partition root or not.  That is
not enough if the cpuset is not a valid partition root but its parent
is in the isolated state (load balance off). Update the function to
set the new state to be the same as its parent in this case like what
has been done in commit c8c926200c55 ("cgroup/cpuset: Inherit parent's
load balance state in v2").

Fixes: a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling")
Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 58ec88efa4f8..4749e0c86c62 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1304,13 +1304,23 @@ static int update_partition_exclusive(struct cpuset *cs, int new_prs)
  *
  * Changing load balance flag will automatically call
  * rebuild_sched_domains_locked().
+ * This function is for cgroup v2 only.
  */
 static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
 {
 	int new_prs = cs->partition_root_state;
-	bool new_lb = (new_prs != PRS_ISOLATED);
 	bool rebuild_domains = (new_prs > 0) || (old_prs > 0);
+	bool new_lb;
 
+	/*
+	 * If cs is not a valid partition root, the load balance state
+	 * will follow its parent.
+	 */
+	if (new_prs > 0) {
+		new_lb = (new_prs != PRS_ISOLATED);
+	} else {
+		new_lb = is_sched_load_balance(parent_cs(cs));
+	}
 	if (new_lb != !!is_sched_load_balance(cs)) {
 		rebuild_domains = true;
 		if (new_lb)
-- 
2.31.1

