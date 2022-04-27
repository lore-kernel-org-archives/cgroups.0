From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] memcg: accounting for objects allocated for new netdevice
Date: Wed, 27 Apr 2022 13:37:50 +0300
Message-ID: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=jRN8XksCdAf0+x8Uj8a/DButwn5KzLonnaobSsBfglg=;
        b=DK23ya2EJ5weoMmh1t7kx/QodejkNkn8M5NyBLC6YNDDq/iyYjlsNadZ2EHYSJ5Fqg
         v6gIuXZexBcUPt7oHC2h4qRgCgC/5A3dmpZmQsJ+8GqVCb1x/lOqbf91P7uw5Ww0uqKD
         uyHVfyKv/F1Mc0YNVKPWcoHW3ohxieUlWta8+KHFA8/SQJvfuKwbBS+TFPT4bO6XlV24
         H/uUZxi93xoDkhBCqfXOOKQhO/48gVdV2wprUxrQeRwT2K32euRbJz7E7YXAoFNXApwv
         SLu4nXXcpWgbpsAiiuxu+zsOGeWaGuKPZ7cmgu84GIuIDg25iFm84RkrJJ73rKF+8/gg
         IwGA==
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Creating a new netdevice allocates at least ~50Kb of memory for various
kernel objects, but only ~5Kb of them are accounted to memcg. As a result,
creating an unlimited number of netdevice inside a memcg-limited container
does not fall within memcg restrictions, consumes a significant part
of the host's memory, can cause global OOM and lead to random kills of
host processes.

The main consumers of non-accounted memory are:
 ~10Kb   80+ kernfs nodes
 ~6Kb    ipv6_add_dev() allocations
  6Kb    __register_sysctl_table() allocations
  4Kb    neigh_sysctl_register() allocations
  4Kb    __devinet_sysctl_register() allocations
  4Kb    __addrconf_sysctl_register() allocations

Accounting of these objects allows to increase the share of memcg-related
memory up to 60-70% (~38Kb accounted vs ~54Kb total for dummy netdevice
on typical VM with default Fedora 35 kernel) and this should be enough
to somehow protect the host from misuse inside container.

Other related objects are quite small and may not be taken into account
to minimize the expected performance degradation.

It should be separately mentonied ~300 bytes of percpu allocation
of struct ipstats_mib in snmp6_alloc_dev(), on huge multi-cpu nodes
it can become the main consumer of memory.

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
RFC was discussed here:
https://lore.kernel.org/all/a5e09e93-106d-0527-5b1e-48dbf3b48b4e-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org/
---
 fs/kernfs/mount.c     | 2 +-
 fs/proc/proc_sysctl.c | 2 +-
 net/core/neighbour.c  | 2 +-
 net/ipv4/devinet.c    | 2 +-
 net/ipv6/addrconf.c   | 8 ++++----
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index cfa79715fc1a..2881aeeaa880 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -391,7 +391,7 @@ void __init kernfs_init(void)
 {
 	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
 					      sizeof(struct kernfs_node),
-					      0, SLAB_PANIC, NULL);
+					      0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	/* Creates slab cache for kernfs inode attributes */
 	kernfs_iattrs_cache  = kmem_cache_create("kernfs_iattrs_cache",
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 7d9cfc730bd4..df4604fea4f8 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1333,7 +1333,7 @@ struct ctl_table_header *__register_sysctl_table(
 		nr_entries++;
 
 	header = kzalloc(sizeof(struct ctl_table_header) +
-			 sizeof(struct ctl_node)*nr_entries, GFP_KERNEL);
+			 sizeof(struct ctl_node)*nr_entries, GFP_KERNEL_ACCOUNT);
 	if (!header)
 		return NULL;
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ec0bf737b076..3dcda2a54f86 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3728,7 +3728,7 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 	char neigh_path[ sizeof("net//neigh/") + IFNAMSIZ + IFNAMSIZ ];
 	char *p_name;
 
-	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL_ACCOUNT);
 	if (!t)
 		goto err;
 
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index fba2bffd65f7..47523fe5b891 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2566,7 +2566,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 	struct devinet_sysctl_table *t;
 	char path[sizeof("net/ipv4/conf/") + IFNAMSIZ];
 
-	t = kmemdup(&devinet_sysctl, sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&devinet_sysctl, sizeof(*t), GFP_KERNEL_ACCOUNT);
 	if (!t)
 		goto out;
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f908e2fd30b2..e79621ee4a0a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -342,7 +342,7 @@ static int snmp6_alloc_dev(struct inet6_dev *idev)
 {
 	int i;
 
-	idev->stats.ipv6 = alloc_percpu(struct ipstats_mib);
+	idev->stats.ipv6 = alloc_percpu_gfp(struct ipstats_mib, GFP_KERNEL_ACCOUNT);
 	if (!idev->stats.ipv6)
 		goto err_ip;
 
@@ -358,7 +358,7 @@ static int snmp6_alloc_dev(struct inet6_dev *idev)
 	if (!idev->stats.icmpv6dev)
 		goto err_icmp;
 	idev->stats.icmpv6msgdev = kzalloc(sizeof(struct icmpv6msg_mib_device),
-					   GFP_KERNEL);
+					   GFP_KERNEL_ACCOUNT);
 	if (!idev->stats.icmpv6msgdev)
 		goto err_icmpmsg;
 
@@ -382,7 +382,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	if (dev->mtu < IPV6_MIN_MTU)
 		return ERR_PTR(-EINVAL);
 
-	ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL);
+	ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL_ACCOUNT);
 	if (!ndev)
 		return ERR_PTR(err);
 
@@ -7029,7 +7029,7 @@ static int __addrconf_sysctl_register(struct net *net, char *dev_name,
 	struct ctl_table *table;
 	char path[sizeof("net/ipv6/conf/") + IFNAMSIZ];
 
-	table = kmemdup(addrconf_sysctl, sizeof(addrconf_sysctl), GFP_KERNEL);
+	table = kmemdup(addrconf_sysctl, sizeof(addrconf_sysctl), GFP_KERNEL_ACCOUNT);
 	if (!table)
 		goto out;
 
-- 
2.31.1

