From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v6 09/31] dcache: convert to use new lru list
 infrastructure
Date: Tue, 14 May 2013 16:59:02 +1000
Message-ID: <20130514065902.GG29466@dastard>
References: <1368382432-25462-1-git-send-email-glommer@openvz.org>
 <1368382432-25462-10-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1368382432-25462-10-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sun, May 12, 2013 at 10:13:30PM +0400, Glauber Costa wrote:
> From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> [ glommer: don't reintroduce double decrement of nr_unused_dentries,
>   adapted for new LRU return codes ]
> Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---

I'm seeing a panic on startup in d_kill() with an invalid d_child
list entry with this patch. I haven't got to the bottom of it yet.

.....

>  void shrink_dcache_sb(struct super_block *sb)
>  {
> -	LIST_HEAD(tmp);
> -
> -	spin_lock(&sb->s_dentry_lru_lock);
> -	while (!list_empty(&sb->s_dentry_lru)) {
> -		list_splice_init(&sb->s_dentry_lru, &tmp);
> -
> -		/*
> -		 * account for removal here so we don't need to handle it later
> -		 * even though the dentry is no longer on the lru list.
> -		 */
> -		this_cpu_sub(nr_dentry_unused, sb->s_nr_dentry_unused);
> -		sb->s_nr_dentry_unused = 0;
> -
> -		spin_unlock(&sb->s_dentry_lru_lock);
> -		shrink_dcache_list(&tmp);
> -		spin_lock(&sb->s_dentry_lru_lock);
> -	}
> -	spin_unlock(&sb->s_dentry_lru_lock);
> +	list_lru_dispose_all(&sb->s_dentry_lru, shrink_dcache_list);
>  }
>  EXPORT_SYMBOL(shrink_dcache_sb);

And here comes the fun part. This doesn't account for the
dentries that are freed from the superblock here.

So, it needs to be something like:

void shrink_dcache_sb(struct super_block *sb)
{
	unsigned long disposed;

	disposed = list_lru_dispose_all(&sb->s_dentry_lru,
					shrink_dcache_list);

	this_cpu_sub(nr_dentry_unused, disposed);
}

But, therein lies a problem. nr_dentry_unused is a 32 bit counter,
and we can return a 64 bit value here. So that means we have to bump
nr_dentry_unused to a long, not an int for these per-cpu counters to
work.

And then there's the problem that the sum of these counters only
uses an int. Which means if we get large numbers of negative values
on different CPU from unmounts, the summation will end up
overflowing and it'll all suck.

So, Glauber, what do you reckon? I've never likes this stupid
hand-rolled per-cpu counter stuff, and it's causing issues. Should
we just convert them to generic per-cpu counters because they are
64bit clean and just handle out-of-range sums in the /proc update
code?

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
