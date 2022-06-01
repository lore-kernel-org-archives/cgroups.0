From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5 03/11] mm: memcontrol: prepare objcg API for non-kmem
 usage
Date: Wed, 1 Jun 2022 19:34:34 +0200
Message-ID: <20220601173434.GB16134@blackbody.suse.cz>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-4-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654104875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yPxZyhx2htcqKKisRfas+7IPl/BgzIKaMSj2ZzajJIg=;
        b=Zb2LaSt9f1Tc76mutvDU037fDI5D321olqGbDaNXnmynn+N2s6atIKSkK5Y2IX9UxSE2Xj
        1xKdHDQHvzWDIBFqgn0YeqVhdD0GzVvG+BaTKCOSscjDcYv+6zWjtFhum+K2+kA6Dx5v7N
        8q+6TE1IKVeTz+g8OKmulMU9YQaPyVg=
Content-Disposition: inline
In-Reply-To: <20220530074919.46352-4-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

Hello.

On Mon, May 30, 2022 at 03:49:11PM +0800, Muchun Song <songmuchun-EC8Uxl6Np=
ydl57MIdRCFDg@public.gmane.org> wrote:
> So we also allocate an object cgroup for the root_mem_cgroup.

This change made me wary that this patch also kmem charging in the
root_mem_cgroup. Fortunately, get_obj_cgroup_from_current won't return
this objcg so all is fine.

> +}
> +#else
> +static inline void obj_cgroup_release_bytes(struct obj_cgroup *objcg)
> +{
> +}
> +#endif

This empty body is for !CONFIG_MEMCG_KMEM, however, the subsequent use for =
LRU
pages makes no use of these, so it's warranted.

Altogether, I find this correct, hence
Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
