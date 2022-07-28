From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Date: Thu, 28 Jul 2022 06:51:06 -1000
Message-ID: <YuK+eg3lgwJ2CJnJ@slm.duckdns.org>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=g2JvEqu4lPB/13fJF7Pbh4plTZKsg+4Z5jgyLFAQt2M=;
        b=Vde+gVxL9KlBhtfP9xUCLxMLGERnDOtm6qMfUz5TxxyQX2iBoFvmbzpnli5CQPLA+U
         fflE7YnPv0y9SVveELW2O1oVzGvj8oebdlInFI/DBAp0Z+9MHqxz6DAWcSH+WUb+ddt/
         awmZOPhtYxRGWWM+b6gc8Y0q42/iKXOdATHyWtMU5oz00Wwmr1mP9eIo6zSEA90eUVnD
         buCqmiwqL01yysHQy15AatDCFXTlbY+vvyCJy4D/a97t1MZGhnG8N9KuocMStGJe2Y3s
         L9cpmldbhJlj2y9yg1BzYizbubsK+b/HJzWEeknAdptsFvxXuedLV4dDtPBysJD0v6Tc
         J0Tw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220722174829.3422466-5-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Fri, Jul 22, 2022 at 05:48:25PM +0000, Yosry Ahmed wrote:
> +
> +	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> +	 * ancestors of a given cgroup.
> +	 */
> +	struct {
> +		/* Cgroup file descriptor. This is root of the subtree if walking
> +		 * descendants; it's the starting cgroup if walking the ancestors.
> +		 * If it is left 0, the traversal starts from the default cgroup v2
> +		 * root. For walking v1 hierarchy, one should always explicitly
> +		 * specify the cgroup_fd.
> +		 */
> +		__u32	cgroup_fd;

So, we're identifying the starting point with an fd.

> +		__u32	traversal_order;
> +	} cgroup;
>  };
>  
>  /* BPF syscall commands, see bpf(2) man-page for more details. */
> @@ -6136,6 +6156,16 @@ struct bpf_link_info {
>  					__u32 map_id;
>  				} map;
>  			};
> +			union {
> +				struct {
> +					__u64 cgroup_id;
> +					__u32 traversal_order;
> +				} cgroup;

but iterating the IDs. IDs are the better choice for cgroup2 as there's
nothing specific to the calling program or the fds it has, but I guess this
is because you want to use it for cgroup1, right? Oh well, that's okay I
guess.

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
