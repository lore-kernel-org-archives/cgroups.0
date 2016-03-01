From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: reset css on destruction
Date: Tue, 1 Mar 2016 19:56:30 +0300
Message-ID: <20160301165630.GB2426@esperanza>
References: <69629961aefc48c021b895bb0c8297b56c11a577.1456830735.git.vdavydov@virtuozzo.com>
 <92b11b89791412df49e73597b87912e8f143a3f7.1456830735.git.vdavydov@virtuozzo.com>
 <20160301163018.GE3965@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160301163018.GE3965-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 01, 2016 at 11:30:18AM -0500, Tejun Heo wrote:
> On Tue, Mar 01, 2016 at 02:13:13PM +0300, Vladimir Davydov wrote:
> > @@ -5138,6 +5138,8 @@ static void kill_css(struct cgroup_subsys_state *css)
> >  	 * See seq_css() for details.
> >  	 */
> >  	css_clear_dir(css, NULL);
> > +	if (css->ss->css_reset)
> > +		css->ss->css_reset(css);
> 
> I think the better spot for this is in offline_css() right before
> ->css_offline() is called.

Okay, here it goes.
---
From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH] cgroup: reset css on destruction

An associated css can be around for quite a while after a cgroup
directory has been removed. In general, it makes sense to reset it to
defaults so as not to worry about any remnants. For instance, memory
cgroup needs to reset memory.low, otherwise pages charged to a dead
cgroup might never get reclaimed. There's ->css_reset callback, which
would fit perfectly for the purpose. Currently, it's only called when a
subsystem is disabled in the unified hierarchy and there are other
subsystems dependant on it. Let's call it on css destruction as well.

Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index cc40463e7b69..bb1900b70b01 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4876,6 +4876,9 @@ static void offline_css(struct cgroup_subsys_state *css)
 	if (!(css->flags & CSS_ONLINE))
 		return;
 
+	if (ss->css_reset)
+		ss->css_reset(css);
+
 	if (ss->css_offline)
 		ss->css_offline(css);
 
