From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 2/2] mm, memcg: Optionally disable memcg by default using
 Kconfig
Date: Wed, 20 May 2015 15:13:52 +0100
Message-ID: <20150520141352.GQ2462@suse.de>
References: <1432126245-10908-1-git-send-email-mgorman@suse.de>
 <1432126245-10908-3-git-send-email-mgorman@suse.de>
 <1432129666.15239.22.camel@stgolabs.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432129666.15239.22.camel@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Linux-CGroups <cgroups@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, May 20, 2015 at 06:47:46AM -0700, Davidlohr Bueso wrote:
> On Wed, 2015-05-20 at 13:50 +0100, Mel Gorman wrote:
> > +config MEMCG_DEFAULT_ENABLED
> > +	bool "Automatically enable memory resource controller"
> > +	default y
> > +	depends on MEMCG
> > +	help
> > +	  The memory controller has some overhead even if idle as resource
> > +	  usage must be tracked in case a group is created and a process
> > +	  migrated. As users may not be aware of this and the cgroup_disable=
> > +	  option, this config option controls whether it is enabled by
> > +	  default. It is assumed that someone that requires the controller
> > +	  can find the cgroup_enable= switch.
> > +
> > +	  Say N if unsure. This is default Y to preserve oldconfig and
> > +	  historical behaviour.
> 
> Out of curiosity, how do you expect distros to handle this?

Ideally, distros would have been able to leave this disabled by default and
have the user explicitly enable it if it was required. This would have made
a lot of sense when memcg had unconditional memory overhead to go with it.

For distros that wanted to make the change, it would be fine to leave it
disabled on fresh installs. However, if upgrading then the installer would
have to also add the kernel parameter to prevent any possible regressions
for the user.

> I mean, this
> is a pretty general functionality and customers won't want to be
> changing kernels (they may or may not use memcg). iow, will this ever be
> disabled?
> 

It's not that general. It takes explicit user or sysadmin action before
it's used AFAIK.

-- 
Mel Gorman
SUSE Labs
