From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: [PATCH v2 1/2] cgroup: export list of delegatable control files using sysfs
Date: Mon, 6 Nov 2017 13:30:28 -0500
Message-ID: <20171106183029.21297-1-guro@fb.com>
References: <20171106173854.GE3252168@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=wIA+ioIxxLuh2Gct6Ho4AaqHho3sRGyehX52WPaPDqM=;
 b=d037zicqsZbHM6gEXqy1N6FPFh7MapKNQ3k0rxNhahptuWJcoby4i2f0oUXTiFSnZbAt
 S/fuGtvdypTZ5E0llLZZyHpVBD1MVa+ROqtibvvcjqgBRAUXeNT7zUor7Z1VxJNgHMEi
 x3H2x0+rPS/x5mc8Vykcg8cU8QRNFymZxQo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wIA+ioIxxLuh2Gct6Ho4AaqHho3sRGyehX52WPaPDqM=;
 b=gRLmriMleEq3+PZw5pOdHSyy+8KbtYCSckjH/9j5CnX+nlpEPCKQ5Xdb4n/69FoyOF63VN1uOcn+XUSRYChIBV0vXOxahnEI4Dw2Y/ycutsrba+xB/2w+1V17jZqbivU5CQZO6cng7KpQfNq1WQqcDinCoBvZO/O1/99EW4H8q0=
In-Reply-To: <20171106173854.GE3252168-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Delegatable cgroup v2 control files may require special handling
(e.g. chowning), and the exact list of such files varies between
kernel versions (and likely to be extended in the future).

To guarantee correctness of this list and simplify the life
of userspace (systemd, first of all), let's export the list
via /sys/kernel/cgroup/delegate pseudo-file.

Format is siple: each control file name is printed on a new line.
Example:
  $ cat /sys/kernel/cgroup/delegate
  cgroup.procs
  cgroup.subtree_control

Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kernel-team-b10kYP2dOMg@public.gmane.org
---
 kernel/cgroup/cgroup.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index d6ed725f36d9..eed92ed624e5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5832,3 +5832,64 @@ int cgroup_bpf_update(struct cgroup *cgrp, struct bpf_prog *prog,
 	return ret;
 }
 #endif /* CONFIG_CGROUP_BPF */
+
+#ifdef CONFIG_SYSFS
+static ssize_t show_delegatable_files(struct cftype *files, char *buf,
+				      ssize_t size, const char *prefix)
+{
+	struct cftype *cft;
+	ssize_t ret = 0;
+
+	for (cft = files; cft && cft->name[0] != '\0'; cft++) {
+		if (!(cft->flags & CFTYPE_NS_DELEGATABLE))
+			continue;
+
+		if (prefix)
+			ret += snprintf(buf + ret, size - ret, "%s.", prefix);
+
+		ret += snprintf(buf + ret, size - ret, "%s\n", cft->name);
+
+		if (unlikely(ret >= size)) {
+			WARN_ON(1);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static ssize_t delegate_show(struct kobject *kobj, struct kobj_attribute *attr,
+			      char *buf)
+{
+	struct cgroup_subsys *ss;
+	int ssid;
+	ssize_t ret = 0;
+
+	ret = show_delegatable_files(cgroup_base_files, buf, PAGE_SIZE - ret,
+				     NULL);
+
+	for_each_subsys(ss, ssid)
+		ret += show_delegatable_files(ss->dfl_cftypes, buf + ret,
+					      PAGE_SIZE - ret,
+					      cgroup_subsys_name[ssid]);
+
+	return ret;
+}
+static struct kobj_attribute cgroup_delegate_attr = __ATTR_RO(delegate);
+
+static struct attribute *cgroup_sysfs_attrs[] = {
+	&cgroup_delegate_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group cgroup_sysfs_attr_group = {
+	.attrs = cgroup_sysfs_attrs,
+	.name = "cgroup",
+};
+
+static int __init cgroup_sysfs_init(void)
+{
+	return sysfs_create_group(kernel_kobj, &cgroup_sysfs_attr_group);
+}
+subsys_initcall(cgroup_sysfs_init);
+#endif /* CONFIG_SYSFS */
-- 
2.13.6
