From: "Pratik R. Sampat" <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: [RFC 4/5] cpu/cpuns: Make sysfs CPU namespace aware
Date: Sat,  9 Oct 2021 20:42:42 +0530
Message-ID: <20211009151243.8825-5-psampat@linux.ibm.com>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=H8oRUsAit0rbQ+tvsmlBm/55SJ3NXZybEbA2lrRQqhU=;
 b=pb7/HlUaF/JN7XGr75/+++4CjYbe3MJeWEoGzVfTzPzo3PNuUgkART0iGDnw9A+MBcQu
 kyOoFASIZxKOKT8+xGE3DAZfHWbfZ6GNErJsW9l4fZLbJJh9oqe8CHYl5krLnMuhjmuV
 nlaS+p5LDcFmx51dsoeRcRa9wRShJy0sTYvxvmstc/mbYwjnbnhtUhGm2vjQqi87QSiR
 e8dJEV97wAQ43my2/t9Kw3gBEtCG3eeQO713kICmlhxFvIQKE2UAgZ6DZGl2KOlBOC3Z
 uBcXbX6NKNSvqysLOfoR9/I3OkgVLFT53bmcO89OyCgq3dIcHfPGO/RIvPxuWVkPxYi9 +Q== 
In-Reply-To: <20211009151243.8825-1-psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, pratik.r.sampat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

The commit adds support to sysfs files like online, offline, present to
be CPU namespace context aware. It presents virtualized CPU information
which is coherent to the cgroup cpuset restrictions that are set upon
the tasks.

Signed-off-by: Pratik R. Sampat <psampat-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
---
 drivers/base/cpu.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 5ef14db97904..1487b23e5472 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -20,6 +20,7 @@
 #include <linux/tick.h>
 #include <linux/pm_qos.h>
 #include <linux/sched/isolation.h>
+#include <linux/cpu_namespace.h>
 
 #include "base.h"
 
@@ -203,6 +204,24 @@ struct cpu_attr {
 	const struct cpumask *const map;
 };
 
+#ifdef CONFIG_CPU_NS
+static ssize_t show_cpuns_cpus_attr(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct cpu_attr *ca = container_of(attr, struct cpu_attr, attr);
+
+	if (current->nsproxy->cpu_ns == &init_cpu_ns)
+		return cpumap_print_to_pagebuf(true, buf, ca->map);
+
+	return cpumap_print_to_pagebuf(true, buf,
+				       &current->nsproxy->cpu_ns->v_cpuset_cpus);
+}
+
+#define _CPU_CPUNS_ATTR(name, map) \
+	{ __ATTR(name, 0444, show_cpuns_cpus_attr, NULL), map }
+#endif
+
 static ssize_t show_cpus_attr(struct device *dev,
 			      struct device_attribute *attr,
 			      char *buf)
@@ -217,9 +236,14 @@ static ssize_t show_cpus_attr(struct device *dev,
 
 /* Keep in sync with cpu_subsys_attrs */
 static struct cpu_attr cpu_attrs[] = {
+#ifdef CONFIG_CPU_NS
+	_CPU_CPUNS_ATTR(online, &__cpu_online_mask),
+	_CPU_CPUNS_ATTR(present, &__cpu_present_mask),
+#else
 	_CPU_ATTR(online, &__cpu_online_mask),
-	_CPU_ATTR(possible, &__cpu_possible_mask),
 	_CPU_ATTR(present, &__cpu_present_mask),
+#endif
+	_CPU_ATTR(possible, &__cpu_possible_mask),
 };
 
 /*
@@ -244,7 +268,16 @@ static ssize_t print_cpus_offline(struct device *dev,
 	/* display offline cpus < nr_cpu_ids */
 	if (!alloc_cpumask_var(&offline, GFP_KERNEL))
 		return -ENOMEM;
+#ifdef CONFIG_CPU_NS
+	if (current->nsproxy->cpu_ns == &init_cpu_ns) {
+		cpumask_andnot(offline, cpu_possible_mask, cpu_online_mask);
+	} else {
+		cpumask_andnot(offline, cpu_possible_mask,
+			       &current->nsproxy->cpu_ns->v_cpuset_cpus);
+	}
+#else
 	cpumask_andnot(offline, cpu_possible_mask, cpu_online_mask);
+#endif
 	len += sysfs_emit_at(buf, len, "%*pbl", cpumask_pr_args(offline));
 	free_cpumask_var(offline);
 
-- 
2.31.1

