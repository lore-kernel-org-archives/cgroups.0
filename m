From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH cgroup] cgroup: set the correct return code if hierarchy
 limits are reached
Date: Mon, 27 Jun 2022 17:44:36 -0700
Message-ID: <YrpO9CUDt8hpUprr@castle>
References: <186d5b5b-a082-3814-9963-bf57dfe08511@openvz.org>
 <d8a9e9c6-856e-1502-95ac-abf9700ff568@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656377082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BJKVsQcWiOvVBIN6ILcbyfHw9khWxf41DSkNpqOzqMc=;
        b=ekLEYclUAddgPYXUB6/jK1M8WfV2S0/heY/TFpzAhtwr3G+vhsRzcHjs9s+ifHpSzWUAqL
        jr4/DX/9M4qhweBKLppSaFBWG5fa2YfNHNnQHouWd9QaAgcvuzQ23Gjt7a5lnJ0n8AFDGE
        E0SFxI5Vz0fibcZLH5Jsrvu8APe9lyY=
Content-Disposition: inline
In-Reply-To: <d8a9e9c6-856e-1502-95ac-abf9700ff568-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jun 27, 2022 at 05:12:55AM +0300, Vasily Averin wrote:
> When cgroup_mkdir reaches the limits of the cgroup hierarchy, it should
> not return -EAGAIN, but instead react similarly to reaching the global
> limit.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  kernel/cgroup/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 1be0f81fe8e1..243239553ea3 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5495,7 +5495,7 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
>  		return -ENODEV;
>  
>  	if (!cgroup_check_hierarchy_limits(parent)) {
> -		ret = -EAGAIN;
> +		ret = -ENOSPC;

I'd not argue whether ENOSPC is better or worse here, but I don't think we need
to change it now. It's been in this state for a long time and is a part of ABI.
EAGAIN is pretty unique as a mkdir() result, so systemd can handle it well.

Thanks!
