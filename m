From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/2] mm, memcg: Optionally disable memcg by default
 using Kconfig
Date: Wed, 20 May 2015 06:47:46 -0700
Message-ID: <1432129666.15239.22.camel@stgolabs.net>
References: <1432126245-10908-1-git-send-email-mgorman@suse.de>
	 <1432126245-10908-3-git-send-email-mgorman@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432126245-10908-3-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Linux-CGroups <cgroups@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, 2015-05-20 at 13:50 +0100, Mel Gorman wrote:
> +config MEMCG_DEFAULT_ENABLED
> +	bool "Automatically enable memory resource controller"
> +	default y
> +	depends on MEMCG
> +	help
> +	  The memory controller has some overhead even if idle as resource
> +	  usage must be tracked in case a group is created and a process
> +	  migrated. As users may not be aware of this and the cgroup_disable=
> +	  option, this config option controls whether it is enabled by
> +	  default. It is assumed that someone that requires the controller
> +	  can find the cgroup_enable= switch.
> +
> +	  Say N if unsure. This is default Y to preserve oldconfig and
> +	  historical behaviour.

Out of curiosity, how do you expect distros to handle this? I mean, this
is a pretty general functionality and customers won't want to be
changing kernels (they may or may not use memcg). iow, will this ever be
disabled?

Thanks,
Davidlohr
