From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/7] res_counter: add a function
 res_counter_move_parent().
Date: Mon, 16 Apr 2012 15:19:24 -0700
Message-ID: <20120416221924.GB12421@google.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
 <4F86BA66.2010503@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=efISsRD16SpTgjTiyZU11yVAh4uUeSVZP80rwbFbSUU=;
        b=t7zpzyDvN9kaaumU647kHtsz3Q/Do76nSntpw/scIw2sQ28U8Sw21eQ62bCjdoRu1c
         SR/N6beANrgwQ8LKsmwHh4g60U3QswD3bB7qq8Y9hBY2d0hpVD0gGd3jdDxhE6Q0gs4o
         hWg2zSFbBigjX7LB7w6tK/4l9GrJ//zTs9cBj1aGgE/b7CV9GxgrTOLgLltUlZJF326u
         +tz+wGaqkb7FQLT5VZj/VtpAYQGY8adAYOAwTvsjt8zXrOXLNd4RduEZpwBFanc1NbVx
         e4s47OgIa31vRJngCmI77Zo16r0rLo1JxJO9RQ1wFAwTDb86EZhzbzBFosiGet3rsNsi
         32YQ==
Content-Disposition: inline
In-Reply-To: <4F86BA66.2010503-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Apr 12, 2012 at 08:20:06PM +0900, KAMEZAWA Hiroyuki wrote:
> 
> This function is used for moving accounting information to its
> parent in the hierarchy of res_counter.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>  include/linux/res_counter.h |    3 +++
>  kernel/res_counter.c        |   13 +++++++++++++
>  2 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
> index da81af0..8919d3c 100644
> --- a/include/linux/res_counter.h
> +++ b/include/linux/res_counter.h
> @@ -135,6 +135,9 @@ int __must_check res_counter_charge_nofail(struct res_counter *counter,
>  void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
>  void res_counter_uncharge(struct res_counter *counter, unsigned long val);
>  
> +/* move resource to parent counter...i.e. just forget accounting in a child */

Can we drop this comment and

> +void res_counter_move_parent(struct res_counter *counter, unsigned long val);
>  
> +/*
> + * In hierarchical accounting, child's usage is accounted into ancestors.
> + * To move local usage to its parent, just forget current level usage.
> + */

make this one proper docbook function comment?

> +void res_counter_move_parent(struct res_counter *counter, unsigned long val)
> +{
> +	unsigned long flags;
> +
> +	BUG_ON(!counter->parent);

And let's please do "if (WARN_ON(!counter->parent)) return;" instead.

Thanks.

-- 
tejun
