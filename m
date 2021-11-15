From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: pretty format /proc/cgroups
Date: Mon, 15 Nov 2021 01:04:07 +0000
Message-ID: <20211115010407.20380-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=uejnxkT5XpebYh7AJgnAoZS2xCFi6l9f8v0QEmMOCyM=;
        b=TNGczOiR+iwHno2SJBMCOT4TunVBBZElYiMRh8BVt9VPMWc5LI+5LhIufZSsv3H88Z
         ikwlGPZnl4ZIiiXYkXUgQqYdI253+48ZCaxfV2m2bx3cBg9aU8XAy1+vghKH6Y7IP9Of
         oiJgeovnV2OyfCOYubEtrU0hmanZAFcHfKFR5FroIxAVgLQKVkj8TuNC7oTX9FxQP+0Z
         jacZe0CDY4fWA/o7Pe9MJfzApF8FgSrLp+1//UrQceZiOpaBzf9wLpzsvw71mTZXgSwe
         37NdW4Pgsql6E0fKnlDDKoszgyK7RhFB+EZqm8d4B7IHk73yo3FttJQMwuTWFXMopayH
         JhLQ==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Current /proc/cgroups looks like this:

cpuset  3       1       1
cpu     2       1       1
cpuacct 2       1       1
memory  4       71      1
freezer 5       1       1

Let's align the title and value. After this patch, it looks like this.

      cpuset            5                 1           1
         cpu            3                 1           1
     cpuacct            3                 1           1
      memory            2                71           1
     freezer            4                 1           1

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 81c9e0685948..5b177e0eca2c 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -664,7 +664,7 @@ int proc_cgroupstats_show(struct seq_file *m, void *v)
 	 */
 
 	for_each_subsys(ss, i)
-		seq_printf(m, "%s\t%d\t%d\t%d\n",
+		seq_printf(m, "%12s\t%9d\t%11d\t%7d\n",
 			   ss->legacy_name, ss->root->hierarchy_id,
 			   atomic_read(&ss->root->nr_cgrps),
 			   cgroup_ssid_enabled(i));
-- 
2.33.1

