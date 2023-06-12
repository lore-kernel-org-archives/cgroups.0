From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: Do not corrupt task iteration when rebinding
 subsystem
Date: Mon, 12 Jun 2023 07:29:33 -1000
Message-ID: <ZIdV_dDDKZazcO6p@slm.duckdns.org>
References: <20230610092643.139007-1-xiujianfeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686590971; x=1689182971;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EhcWplw0MheBHEmIkzjsW91UZcSA6RHIkXpE9/7nU90=;
        b=NKxzs0eIWy7UWWQrFowAJB+athTXNxT0R4kZFxHQbro1O9i4PXE+7x05SExYwpCPTr
         JHkzRvDOKFeRoWfQDVr/o5ha52O5DGrJO1YdD8q66+WuCwJylvtGLjo87peWA4CQd8bP
         aSUQ+9Am8E1n6lj+y3ObEjknyZTNkQ4Jl9/Eyb3psn19a8ydN+BdHGV6W76Zs5k79oc7
         gHuxRwx1OUgW/tbZD34k4j0DV+yL/TsJDF3BhaaUZhw0NQUiJ0Z1Xl3V7e1WOx7//wox
         EuUl2rPqyc6thx3A9zSsOg4E8rCUTxdhbAYscAk7NQ6vtMcl8+Q35+aYGA5jPdcdDswE
         nkMw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230610092643.139007-1-xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Xiu Jianfeng <xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat, Jun 10, 2023 at 05:26:43PM +0800, Xiu Jianfeng wrote:
> From: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> We found a refcount UAF bug as follows:
...
> To fix this issue, switch from all css_sets to only scgrp's css_sets to
> patch in-flight iterators to preserve correct iteration, and then
> update it->cset_head as well.
>=20
> Reported-by: Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gma=
ne.org>
> Link: https://www.spinics.net/lists/cgroups/msg37935.html
> Suggested-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> Link: https://lore.kernel.org/all/20230526114139.70274-1-xiujianfeng-XF6J=
lduFytWkHkcT6e4Xnw@public.gmane.org/
> Signed-off-by: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gm=
ane.org>

Applied to cgroup/for-6.14-fixes w/ stable tag added.

Thanks.

--=20
tejun
