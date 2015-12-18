From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: clean up the kernel configuration menu
 nomenclature
Date: Fri, 18 Dec 2015 11:19:03 -0500
Message-ID: <20151218161903.GB4201@cmpxchg.org>
References: <1450390797-4748-1-git-send-email-hannes@cmpxchg.org>
 <1450390797-4748-2-git-send-email-hannes@cmpxchg.org>
 <56736E07.4000300@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56736E07.4000300-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Dec 18, 2015 at 10:23:03AM +0800, Zefan Li wrote:
> On 2015/12/18 6:19, Johannes Weiner wrote:
> >The config options for the different cgroup controllers use various
> >terms: resource controller, cgroup subsystem, etc. Simplify this to
> >"controller", which is clear enough in the cgroup context.
> >
> >Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> >---
> >  init/Kconfig | 65 ++++++++++++++++++++++++------------------------------------
> >  1 file changed, 26 insertions(+), 39 deletions(-)
> >
> >diff --git a/init/Kconfig b/init/Kconfig
> >index 16840b4..ed324f5 100644
> >--- a/init/Kconfig
> >+++ b/init/Kconfig
> >@@ -958,23 +958,22 @@ menuconfig CGROUPS
> >  if CGROUPS
> >
> >  config CGROUP_DEBUG
> >-	bool "Example debug cgroup subsystem"
> >+	bool "Example controller"
> 
> But not all cgroup subsystems are controllers, which are debug, perf and
> cpuacct. I'm fine the other changes.

Hm, I basically use the term controller to denote any modular
component of cgroup that is not part of the cgroup core.

Do we need to be more specific/accurate than that? Especially because
there won't be any purely informational modules in cgroup2 anymore,
they'll all actually control some resource or behavior.
