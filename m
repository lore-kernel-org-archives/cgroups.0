From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v5 03/11] mm: memcontrol: prepare objcg API for non-kmem
 usage
Date: Thu, 2 Jun 2022 11:06:35 +0800
Message-ID: <YpgpOxzxNzbN26mr@FVFYT0MHHV2J.googleapis.com>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-4-songmuchun@bytedance.com>
 <20220601173434.GB16134@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2wNLI+UiPxMD8gpYb8X0rEwvSxrz6cSA2s7fFzdJJpo=;
        b=U7mxsOuX6jlRQc/N2wDNPLldG8N8Q//HPEH8MZkAnJQTYBblNNDA6fvJcYZa2+ajhu
         r7v8owfFW4WH9wCmj4KA9V7eXigowV+GwmRcRsY/bmS96PzTs2Y4LN+gvpOvNDeyWh6g
         GXxB6XFIimI5GljV7sKZpmyYYoAHvuFXHsvc5wRHpAnt/h4J44rLOBoDqGvTKwjXY9lN
         lA8WlNUJq4AZRgtThcD+jnB/opVPFJ1f7MmsBfaOgQu1AJyDo5hFyWPpGqzd6wvSo2PF
         14kSrZTDwtXro5yUWNjjwaUt5ut8ETmbwzfNA0W6I4LXQ0KDtbjiiWhgeGQqHGOw8UOM
         KM4g==
Content-Disposition: inline
In-Reply-To: <20220601173434.GB16134-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, Jun 01, 2022 at 07:34:34PM +0200, Michal Koutn=FD wrote:
> Hello.
>=20
> On Mon, May 30, 2022 at 03:49:11PM +0800, Muchun Song <songmuchun-EC8Uxl6=
Npydl57MIdRCFDg@public.gmane.org> wrote:
> > So we also allocate an object cgroup for the root_mem_cgroup.
>=20
> This change made me wary that this patch also kmem charging in the
> root_mem_cgroup. Fortunately, get_obj_cgroup_from_current won't return

Sorry for the confusing.  Right, we don't charge kmem to the root objcg.

> this objcg so all is fine.
>=20
> > +}
> > +#else
> > +static inline void obj_cgroup_release_bytes(struct obj_cgroup *objcg)
> > +{
> > +}
> > +#endif
>=20
> This empty body is for !CONFIG_MEMCG_KMEM, however, the subsequent use fo=
r LRU
> pages makes no use of these, so it's warranted.
>=20
> Altogether, I find this correct, hence
> Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
>

Thanks Michal.

