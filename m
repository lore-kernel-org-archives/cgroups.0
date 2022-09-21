From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [sparc64] fails to boot, (was: Re: [PATCH memcg v6] net: set
 proper memcg for net_init hooks allocations)
Date: Wed, 21 Sep 2022 19:02:59 +0200
Message-ID: <20220921170259.GI8331@blackbody.suse.cz>
References: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
 <f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org>
 <20220918092849.GA10314@u164.east.ru>
 <CADxRZqyyHAtzaaPjcKi8AichGew2yi-_vQcKoLoxPanLvXZL0g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1663779781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CSBNW4JvmKppsNMMHKaTcBQ/8SMBBa+a7IGCYeQgCtE=;
        b=HMTzIHmeWUNV9l2wsxzfUSlYDCzoRFpj2D0Jd4idAYXKkplJwnqSsc7We8fOPTXX3mCCbs
        lq+ffxVoyltT0YQUQDkoVgNfX/WJnYakasL+RuA16GPfGeekVHOakGz3EjnLAMxmiR9e9E
        N5K9L8Lt4ptHe5BvEeMqjedNyt/Gd68=
Content-Disposition: inline
In-Reply-To: <CADxRZqyyHAtzaaPjcKi8AichGew2yi-_vQcKoLoxPanLvXZL0g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anatoly Pugachev <matorola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sparc kernel list <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello.

Thanks for the report.

On Wed, Sep 21, 2022 at 05:44:56PM +0300, Anatoly Pugachev <matorola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Sep 18, 2022 at 12:39 PM Anatoly Pugachev <matorola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >
> > I'm unable to boot my sparc64 VM anymore (5.19 still boots, 6.0-rc1 does not),
> > bisected up to this patch,
> >
> > mator@ttip:~/linux-2.6$ git bisect bad
> > 1d0403d20f6c281cb3d14c5f1db5317caeec48e9 is the first bad commit
> > commit 1d0403d20f6c281cb3d14c5f1db5317caeec48e9
> 
> reverting this patch makes my sparc64 box boot successfully.

The failed address falls into vmmemmap region (per your boot log
output). It looks like the respective page/folio (of init_net struct) is
unbacked there (and likely folio_test_slab fails dereferencing ->flags). 

Would you mind sharing your kernel's config?
(I'm most curious about CONFIG_SPARSMEM_VMEMMAP, I'm not familiar with
your arch at all though.)

Thanks,
Michal
