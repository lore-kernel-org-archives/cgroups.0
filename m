From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] cgroup: provide cgroup_nov1= to disable controllers in
 v1 mounts
Date: Tue, 16 Feb 2016 13:21:14 -0500
Message-ID: <20160216182114.GA30548@cmpxchg.org>
References: <1455145195-7553-1-git-send-email-hannes@cmpxchg.org>
 <20160211151707.GY3741@mtj.duckdns.org>
 <20160211183449.GA399@cmpxchg.org>
 <20160212200334.GA3965@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160212200334.GA3965-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Feb 12, 2016 at 03:03:34PM -0500, Tejun Heo wrote:
> On Thu, Feb 11, 2016 at 01:34:49PM -0500, Johannes Weiner wrote:
> > From 89e581ca54bdca37d6c464334d2217d14a229540 Mon Sep 17 00:00:00 2001
> > From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Date: Wed, 10 Feb 2016 17:29:31 -0500
> > Subject: [PATCH] cgroup: provide cgroup_no_v1= to disable controllers in v1
> >  mounts
> 
> Applied to cgroup/for-4.6.  Can you please send another patch to
> update Documentation/kernel-parameters.txt and cgroup.txt for the new
> knob?

How about this?

From 95ae2ca2211e0db4db63d2dd1b187e299d9490fb Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date: Tue, 16 Feb 2016 13:19:11 -0500
Subject: [PATCH] cgroup: document cgroup_no_v1=

Add cgroup_no_v1= to kernel-parameters.txt, and a small blurb to
cgroup-v2.txt section about transitioning from cgroup to cgroup2.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 Documentation/cgroup-v2.txt         | 6 ++++++
 Documentation/kernel-parameters.txt | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index e2f4e7948a66..e892c7ab39ef 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -132,6 +132,12 @@ strongly discouraged for production use.  It is recommended to decide
 the hierarchies and controller associations before starting using the
 controllers after system boot.
 
+During transition to v2, system management software might still
+automount the v1 cgroup filesystem and so hijack all controllers
+during boot, before manual intervention is possible. To make testing
+and experimenting easier, the kernel parameter cgroup_no_v1= allows
+disabling controllers in v1 and make them always available in v2.
+
 
 2-2. Organizing Processes
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 444bff30e1cf..150173f47115 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -608,6 +608,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			cut the overhead, others just disable the usage. So
 			only cgroup_disable=memory is actually worthy}
 
+	cgroup_no_v1=	[KNL] Disable one, multiple, all cgroup controllers in v1
+			Format: { controller[,controller...] | "all" }
+			Like cgroup_disable, but only applies to cgroup v1;
+			the blacklisted controllers remain available in cgroup2.
+
 	cgroup.memory=	[KNL] Pass options to the cgroup memory controller.
 			Format: <string>
 			nosocket -- Disable socket memory accounting.
-- 
2.7.1
