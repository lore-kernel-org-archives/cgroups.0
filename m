From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 05/10] slab: allow enable_cpu_cache to use preset values
 for its tunables
Date: Thu, 26 Jul 2012 18:02:45 +0400
Message-ID: <50114E05.1040201@parallels.com>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <1343227101-14217-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1207251204450.3543@router.home> <501039F9.7040309@parallels.com> <alpine.DEB.2.00.1207251331480.4995@router.home>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------010800000600070305040105"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1207251331480.4995-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

--------------010800000600070305040105
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 07/25/2012 10:33 PM, Christoph Lameter wrote:
> On Wed, 25 Jul 2012, Glauber Costa wrote:
> 
>> It is certainly not through does the same method as SLAB, right ?
>> Writing to /proc/slabinfo gives me an I/O error
>> I assume it is something through sysfs, but schiming through the code
>> now, I can't find any per-cache tunables. Would you mind pointing me to
>> them?
> 
> The slab attributes in /sys/kernel/slab/<slabname>/<attr> can be modified
> for some values. I think that could be the default method for the future
> since it allows easy addition of new tunables as needed.
> 

Christoph, would the following PoC patch be enough?



--------------010800000600070305040105
Content-Type: text/x-patch; name="0001-slub-propagation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="0001-slub-propagation.patch"

From 7c582c5c6321cbde93c5e73c6c2096b4432a2a04 Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Date: Thu, 26 Jul 2012 15:19:08 +0400
Subject: [PATCH] slub propagation

---
 mm/slub.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 55946c3..a136a75 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5130,6 +5130,10 @@ static ssize_t slab_attr_store(struct kobject *kobj,
 	struct slab_attribute *attribute;
 	struct kmem_cache *s;
 	int err;
+#ifdef CONFIG_MEMCG_KMEM
+	struct kmem_cache *c;
+	struct mem_cgroup_cache_params *p;
+#endif
 
 	attribute = to_slab_attr(attr);
 	s = to_slab(kobj);
@@ -5138,7 +5142,19 @@ static ssize_t slab_attr_store(struct kobject *kobj,
 		return -EIO;
 
 	err = attribute->store(s, buf, len);
+#ifdef CONFIG_MEMCG_KMEM
+	if (slab_state < FULL)
+		return err;
 
+	if ((err < 0) || (s->memcg_params.id == -1))
+		return err;
+
+	list_for_each_entry(p, &s->memcg_params.sibling_list, sibling_list) {
+		c = container_of(p, struct kmem_cache, memcg_params);
+		/* return value determined by the parent cache only */
+		attribute->store(c, buf, len);
+	}
+#endif
 	return err;
 }
 
-- 
1.7.10.4


--------------010800000600070305040105--
