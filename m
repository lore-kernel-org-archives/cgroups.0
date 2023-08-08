From: Xiongwei Song <sxwjean-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: add tips for kmem.slabinfo
Date: Tue, 8 Aug 2023 20:10:19 +0800
Message-ID: <CAEVVKH8yxY7bbSS4i10rFBT6uq1x99n+R2=SEs73uvWr0zMXyw@mail.gmail.com>
References: <20230808022229.1560559-1-xiongwei.song@windriver.com> <ZNGsz3FC6q/jJ0+Z@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691511672; x=1692116472;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQjuyyNTy33tUChendA12c1wzE5rL9uSYQp+xAh/JHk=;
        b=oWVgu9FnRlZjuS3BL5oIvNY6f7zFl1L1NND+TyyByiDK7tpbp4Qa55TbCQ5IO/iv85
         ILSMg6DUOmdq3uhQ9fkfbLvPbh1L9ShW7sv89RVJN+9k8M179GvyEFtr38vI1lr+99lp
         YnUdXM5NmleR0BBhqaD3VGDv+T+8zho3LyfvZOKkJRFa0gibQl2gxZWbLZ69K3AKNlZ9
         82FhqBz9KXn53zaxFT7A2kvaYb9n4h2k57ZPmfa3aye5CHMPpGiIY/8DzwEq3KUKX9+8
         HWB0y8l8WWaw7z0NOMEukwZPp2xV/9eQ/VXuGU2s3zM1vpDQVe0xcTElMcWOd6WOGJlt
         fA0A==
In-Reply-To: <ZNGsz3FC6q/jJ0+Z-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 8, 2023 at 10:47=E2=80=AFAM Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org=
> wrote:
>
> On Tue, Aug 08, 2023 at 10:22:29AM +0800, xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org wro=
te:
> > From: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> >
> > No any output from kmem.slabinfo, which is not friendly. Adding
> > tips for it.
>
> What happens to tools which look in this file?

I thought the mem_cgroup_slab_show() function should be removed or
provide some useful info.

Thanks.
>
