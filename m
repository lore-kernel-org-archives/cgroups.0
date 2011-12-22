From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: move a check to parse_cgroupfs_options()
Date: Thu, 22 Dec 2011 07:20:11 -0800
Message-ID: <20111222152011.GA17084@google.com>
References: <4EF2EDA7.4010004@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FqSfUXRVmCm3QX6bdrNAPk/7jcQa+5Sej8dR0Q4/oh0=;
        b=LxTu3h97nGFq2wnjsq7ziIKnPtZziVC5skrkM/aCBHSCjORZOQs5XZJAgM3HKU3wDU
         5ouOh7Shzn8jfo+B5zgMlskdc4UTAv0HwjSgJLweicT0GaXZ3nixB4AvH3/HfcLr45RJ
         +8eEQDAOS0d/VFWegCTOBZACDH7BEDveETnUk=
Content-Disposition: inline
In-Reply-To: <4EF2EDA7.4010004-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Thu, Dec 22, 2011 at 04:43:19PM +0800, Li Zefan wrote:
> Always check the validity of mount options in parse_cgroupfs_options().
> 
> No functional change.
> 
> Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> ---
>  kernel/cgroup.c |   15 +++++++--------
>  1 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 4936d88..bdb7994 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1218,7 +1218,6 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  	    (opts->subsys_bits & mask))
>  		return -EINVAL;
>  
> -
>  	/* Can't specify "none" and some subsystems */
>  	if (opts->subsys_bits && opts->none)
>  		return -EINVAL;
> @@ -1231,6 +1230,13 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  		return -EINVAL;
>  
>  	/*
> +	 * This can happen only when none of the subsystems is enabled
> +	 * in the system.
> +	 */
> +	if (!opts->subsys_bits && !opts->none)
> +		return -EINVAL;

The three ifs here share a lot and I think sharing the common parts
would make the logic clearer.  e.g. The first and this can be easily
combined to (bool)opts->subsys_bits != (bool)opts->none which would
explain the logic better too.

> @@ -1442,10 +1445,6 @@ static int cgroup_set_super(struct super_block *sb, void *data)
>  	int ret;
>  	struct cgroup_sb_opts *opts = data;
>  
> -	/* If we don't have a new root, we can't set up a new sb */
> -	if (!opts->new_root)
> -		return -EINVAL;
> -

And where did this one go?

Thanks.

-- 
tejun
