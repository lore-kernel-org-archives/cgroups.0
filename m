From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] memcg: Fix memcg_kmem_bypass() for remote memcg charging
Date: Wed, 27 May 2020 09:50:07 -0700
Message-ID: <CALvZod6hqkhECNX1gW9=bOwDhHQCV02p6zuu-qNFuiVEF1jjBg@mail.gmail.com>
References: <e6927a82-949c-bdfd-d717-0a14743c6759@huawei.com>
 <20200513090502.GV29153@dhcp22.suse.cz> <76f71776-d049-7407-8574-86b6e9d80704@huawei.com>
 <20200513112905.GX29153@dhcp22.suse.cz> <1d202a12-26fe-0012-ea14-f025ddcd044a@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1zPnuLTvgprdTVM4lyX4wiBkB+XwPNWKNu3f5Lxz02s=;
        b=eN/xrHM4bcrmGppt3VwmPF48oii8uREomXNXGJofLy/UiMHveURMD8R31PSOHxW+fx
         VCzf2zlhdE422jlGR2fETv7FS+o67Bl3zmIbl175bgQsf1+bvkaO8Fh4qEKsDHeHedyA
         AT3mvMzj3zZdlmYGhFd7kcZ34AZq1oMxcHAGYl22G8aWeicey18DykQEze99QWaVzttx
         4VH8vFuYd1U1Okb5SdQXc+EoZytk9eGTvgRumvb6QSjRouqOgzmsouN1X69gjYwftTBZ
         BkpDC3DchvTHnJvHkbVChjblgiUXDjqEt8LgGWsvzEKtHTW6wnQlsVer6XxRBzfqXcgO
         +rkQ==
In-Reply-To: <1d202a12-26fe-0012-ea14-f025ddcd044a-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Mon, May 25, 2020 at 6:25 PM Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> While trying to use remote memcg charging in an out-of-tree kernel module
> I found it's not working, because the current thread is a workqueue thread.
>
> As we will probably encounter this issue in the future as the users of
> memalloc_use_memcg() grow, and it's nothing wrong for this usage, it's
> better we fix it now.
>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
