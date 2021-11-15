From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Patch v2] cgroup: pretty format /proc/cgroups
Date: Mon, 15 Nov 2021 01:12:53 +0000
Message-ID: <20211115011253.20778-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=8dSDliGOTbrCRTDPXM+yPCUeDQ1veUO4KLyhLzS8ruY=;
        b=apxFVYMKfx0nm/y0nIvv+SpIAJNFXAG1Oq4gGtfxk6xwJbv6V9aWCrObLHXv9MuOgY
         oY2QbT34qrEJbKJSQsk1BnakQSjFI5o4kqPfJaWC7+WPLPNcH5khOR2dB3soh8iH9/jd
         mdauPJeQx8gXmbkv8eu0h9UaZh8/OBb9F5b96CC7nmqfpWuVQUHxsDOT0bacEngndFxa
         3bcoflvH4ETZq0pJUmmhd2igUsG40UE37H6MoujEHW8/Cq0ecMTB4vukz+eLYtWE29jn
         VO1r8nVs/HXgpVzG9zVH/7p4+ciCmdJcftCEy4sxFt7T8tAfSfTwKcosNMaeNAhWa9nz
         cjNA==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Current /proc/cgroups looks like this:

 subsys_name    hierarchy       num_cgroups     enabled
cpuset  3       1       1
cpu     2       1       1
cpuacct 2       1       1
memory  4       71      1
freezer 5       1       1

Let's align the title and value. After this patch, it looks like this.

 subsys_name    hierarchy       num_cgroups     enabled
      cpuset            5                 1           1
         cpu            3                 1           1
     cpuacct            3                 1           1
      memory            2                71           1
     freezer            4                 1           1

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

---
v2: the title line is omitted for the start "#"

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

