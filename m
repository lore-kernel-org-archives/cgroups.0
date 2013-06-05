From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v10 12/35] shrinker: add node awareness
Date: Wed, 5 Jun 2013 16:08:10 -0700
Message-ID: <20130605160810.5b203c3368b9df7d087ee3b1@linux-foundation.org>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
	<1370287804-3481-13-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1370287804-3481-13-git-send-email-glommer@openvz.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com, Greg Thelen <gthelen@google.com>, Dave Chinner <dchinner@redhat.com>

On Mon,  3 Jun 2013 23:29:41 +0400 Glauber Costa <glommer@openvz.org> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> Pass the node of the current zone being reclaimed to shrink_slab(),
> allowing the shrinker control nodemask to be set appropriately for
> node aware shrinkers.

Again, some musings on node hotplug would be interesting.

> --- a/drivers/staging/android/ashmem.c
> +++ b/drivers/staging/android/ashmem.c
> @@ -692,6 +692,9 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  				.gfp_mask = GFP_KERNEL,
>  				.nr_to_scan = 0,
>  			};
> +
> +			nodes_setall(sc.nodes_to_scan);

hm, is there some way to do this within the initializer? ie:

				.nodes_to_scan = magic_goes_here(),

Also, it's a bit sad to set bits for not-present and not-online nodes.

>  			ret = ashmem_shrink(&ashmem_shrinker, &sc);
>  			sc.nr_to_scan = ret;
>  			ashmem_shrink(&ashmem_shrinker, &sc);
>
> ...
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
