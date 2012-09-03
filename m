From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
Date: Mon, 3 Sep 2012 17:41:48 +0100
Message-ID: <20120903164148.GS29217@decadent.org.uk>
References: <1346687211-31848-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1346687211-31848-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Mon, Sep 03, 2012 at 07:46:51PM +0400, Glauber Costa wrote:
> Here is a new attempt to lay down a path that will allow us to deprecate
> the non-hierarchical mode of operation from memcg.  Unlike what I posted
> before, I am making this behavior conditional on a Kconfig option.
> Vanilla users will see no change in behavior unless they don't
> explicitly set this option to on.

There are too many negatives in this sentence - it is not only
unclear, but appears to be incorrect.  I think you should delete
'don't'.

[...]
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -726,6 +726,24 @@ config MEMCG_SWAP
>  	  if boot option "swapaccount=0" is set, swap will not be accounted.
>  	  Now, memory usage of swap_cgroup is 2 bytes per entry. If swap page
>  	  size is 4096bytes, 512k per 1Gbytes of swap.
> +
> +config MEMCG_HIERARCHY_DEFAULT
> +	bool "Hierarchical memcg"
> +	depends on MEMCG
> +	default n
> +	help
> +	  The memory controller has two modes of accounting: hierarchical and
> +	  flat. Hierarchical accounting will charge pages all the way towards a
> +	  group's parent while flat hierarchy will threat all groups as children

typo: 'threat' should be 'treat'

> +	  of the root memcg, regardless of their positioning in the tree.
> +
> +	  Use of flat hierarchies is highly discouraged, but has been the
> +	  default for performance reasons for quite some time. Setting this flag
> +	  to on will make hierarchical accounting the default. It is still
> +	  possible to set it back to flat by writing 0 to the file
> +	  memory.use_hierarchy, albeit discouraged. Distributors are encouraged
> +	  to set this option.
[...]

I don't think that 'default n' is effective encouragement!

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
