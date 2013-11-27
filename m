From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 02/12] cpuset: convert away from cftype->read()
Date: Wed, 27 Nov 2013 18:42:29 -0500
Message-ID: <1385595759-17656-3-git-send-email-tj@kernel.org>
References: <1385595759-17656-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rBfvI06gB4J/9H0l72vydb4mv4kYSFQhLjgyFD8eThs=;
        b=gjIqETU25L2ZVi+uZj7dxm8vREUy2Vu1GvwLtgKfsSuwjofk2OaTysPFFp1rcLj97g
         zk1ix9UeaMwQUB68ad0qPPgTS/C4oDfPEP5l2vImhv9N90pSLPoZZZvcDxIQkqsWeqr4
         9Or1QkBRCChSNZa2IGwIysJXlZxv2CUdVl0oaOfbGSSijDjVgNhQ5dhYRnyoMOXbh5Bn
         TlwPe2AumnvIo3deUqG3wdTNysICO9mvDWsStD98lbmSfup+NU4p6mil2tBxvaXVEM9L
         qKEVh51LO4qjnv0CcWVKfxrjowpXH4nUx75gyscAVRjEI7R65t4mea4FolxGD0jAIre9
         FyvQ==
In-Reply-To: <1385595759-17656-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

In preparation of conversion to kernfs, cgroup file handling is being
consolidated so that it can be easily mapped to the seq_file based
interface of kernfs.

All users of cftype->read() can be easily served, usually better, by
seq_file and other methods.  Rename cpuset_common_file_read() to
cpuset_common_read_seq_string() and convert it to use
read_seq_string() interface instead.  This not only simplifies the
code but also makes it more versatile.  Before, the file couldn't
output if the result is longer than PAGE_SIZE.  After the conversion,
seq_file automatically grows the buffer until the output can fit.

This patch doesn't make any visible behavior changes except for being
able to handle output larger than PAGE_SIZE.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cpuset.c | 71 +++++++++++++++++++--------------------------------------
 1 file changed, 24 insertions(+), 47 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4772034..032929f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1731,66 +1731,43 @@ out_unlock:
  * used, list of ranges of sequential numbers, is variable length,
  * and since these maps can change value dynamically, one could read
  * gibberish by doing partial reads while a list was changing.
- * A single large read to a buffer that crosses a page boundary is
- * ok, because the result being copied to user land is not recomputed
- * across a page fault.
  */
-
-static size_t cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
-{
-	size_t count;
-
-	mutex_lock(&callback_mutex);
-	count = cpulist_scnprintf(page, PAGE_SIZE, cs->cpus_allowed);
-	mutex_unlock(&callback_mutex);
-
-	return count;
-}
-
-static size_t cpuset_sprintf_memlist(char *page, struct cpuset *cs)
-{
-	size_t count;
-
-	mutex_lock(&callback_mutex);
-	count = nodelist_scnprintf(page, PAGE_SIZE, cs->mems_allowed);
-	mutex_unlock(&callback_mutex);
-
-	return count;
-}
-
-static ssize_t cpuset_common_file_read(struct cgroup_subsys_state *css,
-				       struct cftype *cft, struct file *file,
-				       char __user *buf, size_t nbytes,
-				       loff_t *ppos)
+static int cpuset_common_read_seq_string(struct cgroup_subsys_state *css,
+					 struct cftype *cft,
+					 struct seq_file *sf)
 {
 	struct cpuset *cs = css_cs(css);
 	cpuset_filetype_t type = cft->private;
-	char *page;
-	ssize_t retval = 0;
-	char *s;
+	ssize_t count;
+	char *buf, *s;
+	int ret = 0;
 
-	if (!(page = (char *)__get_free_page(GFP_TEMPORARY)))
-		return -ENOMEM;
+	count = seq_get_buf(sf, &buf);
+	s = buf;
 
-	s = page;
+	mutex_lock(&callback_mutex);
 
 	switch (type) {
 	case FILE_CPULIST:
-		s += cpuset_sprintf_cpulist(s, cs);
+		s += cpulist_scnprintf(s, count, cs->cpus_allowed);
 		break;
 	case FILE_MEMLIST:
-		s += cpuset_sprintf_memlist(s, cs);
+		s += nodelist_scnprintf(s, count, cs->mems_allowed);
 		break;
 	default:
-		retval = -EINVAL;
-		goto out;
+		ret = -EINVAL;
+		goto out_unlock;
 	}
-	*s++ = '\n';
 
-	retval = simple_read_from_buffer(buf, nbytes, ppos, page, s - page);
-out:
-	free_page((unsigned long)page);
-	return retval;
+	if (s < buf + count - 1) {
+		*s++ = '\n';
+		seq_commit(sf, s - buf);
+	} else {
+		seq_commit(sf, -1);
+	}
+out_unlock:
+	mutex_unlock(&callback_mutex);
+	return ret;
 }
 
 static u64 cpuset_read_u64(struct cgroup_subsys_state *css, struct cftype *cft)
@@ -1847,7 +1824,7 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 static struct cftype files[] = {
 	{
 		.name = "cpus",
-		.read = cpuset_common_file_read,
+		.read_seq_string = cpuset_common_read_seq_string,
 		.write_string = cpuset_write_resmask,
 		.max_write_len = (100U + 6 * NR_CPUS),
 		.private = FILE_CPULIST,
@@ -1855,7 +1832,7 @@ static struct cftype files[] = {
 
 	{
 		.name = "mems",
-		.read = cpuset_common_file_read,
+		.read_seq_string = cpuset_common_read_seq_string,
 		.write_string = cpuset_write_resmask,
 		.max_write_len = (100U + 6 * MAX_NUMNODES),
 		.private = FILE_MEMLIST,
-- 
1.8.4.2
