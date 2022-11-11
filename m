From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 19/26] cgroup/misc: Expose parent_misc()
Date: Fri, 11 Nov 2022 10:35:24 -0800
Message-ID: <20221111183532.3676646-20-kristen@linux.intel.com>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191775; x=1699727775;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dQ7ZYI4WFVi0TVSU0cIX9E3CVIqNB+6yLjwlI7zqKjc=;
  b=CsngimnXo57fCXP7N4YGZ/TcdiElF/D8Igbx28tiEIMmCWwsYAvnQZ4D
   92Fcq/tEC8GYa4IzRXjSI6KFosPa13OrKdWeeCVp5MvSyRs9ziGxhvVJu
   tSvIGGTGjLUSkvK1XpFrP/3aWI7Usgz644lmBdHslrJXAc6mpJtk7IcD2
   d0mWnxocIwUW/23M/dd/umPgzyGbbp3hmtshCL4l5o4CFU5JlUD8SYpd1
   qmVFkw2naOrAEcM8CuO/S1qKVY5tY9GFA3RPfhvHd4eqeySvc0oeSxYph
   zAOjMWHfFcJmpra4q0RLM2lOl59TEwhiOZRM5VL8NSApGqM0iskFE1OS9
   g==;
In-Reply-To: <20221111183532.3676646-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

To manage the SGX EPC memory via the misc controller, the SGX
driver will need to be able to iterate over the misc cgroup
hierarchy. Make parent_misc() available for a future patch
that will utilize it.

Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/misc_cgroup.h | 6 ++++++
 kernel/cgroup/misc.c        | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index b79c78378f17..d1aeb85f2ed6 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -60,6 +60,7 @@ struct misc_cg {
 };
 
 struct misc_cg *root_misc(void);
+struct misc_cg *parent_misc(struct misc_cg *cg);
 unsigned long misc_cg_res_total_usage(enum misc_res_type type);
 int misc_cg_set_capacity(enum misc_res_type type, unsigned long capacity);
 int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
@@ -112,6 +113,11 @@ static inline struct misc_cg *root_misc(void)
 	return NULL;
 }
 
+static inline struct misc_cg *parent_misc(struct misc_cg *cg)
+{
+	return NULL;
+}
+
 static inline unsigned long misc_cg_res_total_usage(enum misc_res_type type)
 {
 	return 0;
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index 8aa994d9cd02..b22a055af9ad 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -63,10 +63,11 @@ EXPORT_SYMBOL_GPL(root_misc);
  * * struct misc_cg* - Parent of the @cgroup.
  * * %NULL - If @cgroup is null or the passed cgroup does not have a parent.
  */
-static struct misc_cg *parent_misc(struct misc_cg *cgroup)
+struct misc_cg *parent_misc(struct misc_cg *cgroup)
 {
 	return cgroup ? css_misc(cgroup->css.parent) : NULL;
 }
+EXPORT_SYMBOL_GPL(parent_misc);
 
 /**
  * valid_type() - Check if @type is valid or not.
-- 
2.37.3

