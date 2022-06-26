From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH RFC] memcg: notify about global mem_cgroup_id space
 depletion
Date: Sat, 25 Jun 2022 18:56:04 -0700
Message-ID: <Yre8tNUY8vBrO0yl@castle>
References: <YrXDV7uPpmDigh3G@dhcp22.suse.cz>
 <c53e1df0-5174-66de-23cc-18797f0b512d@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656208570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bjZI8DTIvucVtX5WQZE5x3xoKYG/ekTnBVDG7567Nww=;
        b=vBWYqIw/oxs4LrYOucwfyC44hX5VSaebHW971hVyDMn4SEhSuSadnHtg1E+KN4TGyCzs+z
        F3S9YtDszUv1h9nslGbXgumAJzW5MRY9w5oYa8exaPjre30t7l24VyPOJ07n3IC4FsnYVH
        qgisoDutY8/3V8XvFjIsNgz7E4Ru4eU=
Content-Disposition: inline
In-Reply-To: <c53e1df0-5174-66de-23cc-18797f0b512d-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 25, 2022 at 05:04:27PM +0300, Vasily Averin wrote:
> Currently host owner is not informed about the exhaustion of the
> global mem_cgroup_id space. When this happens, systemd cannot
> start a new service, but nothing points to the real cause of
> this failure.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  mm/memcontrol.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d4c606a06bcd..5229321636f2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5317,6 +5317,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>  				 1, MEM_CGROUP_ID_MAX + 1, GFP_KERNEL);
>  	if (memcg->id.id < 0) {
>  		error = memcg->id.id;
> +		pr_notice_ratelimited("mem_cgroup_id space is exhausted\n");
>  		goto fail;
>  	}

Hm, in this case it should return -ENOSPC and it's a very unique return code.
If it's not returned from the mkdir() call, we should fix this.
Otherwise it's up to systemd to handle it properly.

I'm not opposing for adding a warning, but parsing dmesg is not how
the error handling should be done.

Thanks!
