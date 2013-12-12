From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
Date: Thu, 12 Dec 2013 22:37:32 +0400
Message-ID: <52AA026C.3040605@parallels.com>
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com> <20131212153536.GD32683@htj.dyndns.org> <20131212155523.GF32683@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131212155523.GF32683-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On 12/12/2013 07:55 PM, Tejun Heo wrote:
> On Thu, Dec 12, 2013 at 10:35:36AM -0500, Tejun Heo wrote:
>> On Sat, Dec 07, 2013 at 11:58:05AM +0400, Vladimir Davydov wrote:
>>> We should not call cgroup_unload_subsys() if online_css() fails, because
>>> online_css() does not assign css to cgroup on failure, while
>>> offline_css() called from cgroup_unload_subsys() expects it is assigned.
>>> So let's call everything we need to rollback inline without involving
>>> cgroup_unload_subsys().
>>>
>>> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>>> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> Applied to cgroup/for-3.13-fixes.
> Scrap that.  I don't think we can fail css_online for the root css in
> 3.13-fixes and this would cause conflict with 3.14, so let's not
> commit it to 3.13-fixes.  Vladimir, can you please respin the patch on
> top of cgroup/for-3.14

No problem.

> but make cgroup_unload_subsys() check whether
> css is actually there before calling offline so that it matches the
> usual offline path better?

You want me to add something like this to the patch, don't you?

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 402f7aa..bc03b97 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4680,6 +4680,7 @@ EXPORT_SYMBOL_GPL(cgroup_load_subsys);
 void cgroup_unload_subsys(struct cgroup_subsys *ss)
 {
     struct cgrp_cset_link *link;
+    struct cgroup_subsys_state *css;
 
     BUG_ON(ss->module == NULL);
 
@@ -4693,7 +4694,9 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
     mutex_lock(&cgroup_mutex);
     mutex_lock(&cgroup_root_mutex);
 
-    offline_css(cgroup_css(cgroup_dummy_top, ss));
+    css = cgroup_css(cgroup_dummy_top, ss);
+    if (css)
+        offline_css(css);
 
     /* deassign the subsys_id */
     cgroup_subsys[ss->subsys_id] = NULL;


If so, I don't mind, but why? cgroup_unload_subsys() should never be
called without properly initialized css.

Thanks.
