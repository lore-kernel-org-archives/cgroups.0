From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH memcg v6] net: set proper memcg for net_init hooks allocations
Date: Tue, 7 Jun 2022 07:10:52 -0700
Message-ID: <CALvZod5fizxoqC5cWtKFt4mkd9bvHhRhKs=H+McDtWvYz3Yq2g@mail.gmail.com>
References: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
 <f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org> <Yp4F6n2Ie32re7Ed@qian>
 <360a2672-65a7-4ad4-c8b8-cc4c1f0c02cd@openvz.org> <CALvZod7+tpgKSQpMAgNKDtcsimcSjoh4rbKmUsy3G=QcRHci+Q@mail.gmail.com>
 <183333fc-e824-5c85-7c44-270474f5473a@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SdrNomF4nhx1466F59Cs0XBm4DrFs3fSMmHF2b5d1e0=;
        b=YWdHmyRPgXwT5Qi5R4fjTlaDOegA5ZwY7kd0cNW+AniEZ9gqycaerLcysiv7Yc87yE
         2C70wH3f79NoW84qA7fZusj7t6pLZo9I8/HVY/ZYiQ7+fljY1WecjXZJrX7H0RSA1Khe
         1FTrcwTQayTr7bGlBZpLDOsKqNgr9KglwIATX+xf6dgFs92JIcXMqSfh2wdTOI39fC9y
         5eiGZ0pqhBeO8FhoE0bNopfv901Cnm/WzyIQ7K3rjxGPImJO+7L0MCpgOqdojh95CTxg
         RoOhILHg9P9RcEGMr0E/A2rQr//BDDMwkFwZOdonsdSq3T36wqQkbmUJmO8YvCEQUTw3
         78vw==
In-Reply-To: <183333fc-e824-5c85-7c44-270474f5473a-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Qian Cai <quic_qiancai-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jun 7, 2022 at 5:37 AM Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>
> On 6/7/22 08:58, Shakeel Butt wrote:
> > On Mon, Jun 6, 2022 at 11:45 AM Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> >>
> > [...]
> >>
> >> As far as I understand this report means that 'init_net' have incorrect
> >> virtual address on arm64.
> >
> > So, the two call stacks tell the addresses belong to the kernel
> > modules (nfnetlink and nf_tables) whose underlying memory is allocated
> > through vmalloc and virt_to_page() does not work on vmalloc()
> > addresses.
>
> However in both these cases get_mem_cgroup_from_obj() -> mem_cgroup_from_obj() ->
> virt_to_folio() -> virt_to_page() -> virt_to_pfn() -> __virt_to_phys()
> handles address of struct net taken from for_each_net().
> The only net namespace that exists at this stage is init_net,
> and dmesg output confirms this:
> "virt_to_phys used for non-linear address: ffffd8efe2d2fe00 (init_net)"
>
> >> Roman, Shakeel, I need your help
> >>
> >> Should we perhaps verify kaddr via virt_addr_valid() before using virt_to_page()
> >> If so, where it should be checked?
> >
> > I think virt_addr_valid() check in mem_cgroup_from_obj() should work
> > but I think it is expensive on the arm64 platform. The cheaper and a
> > bit hacky way to avoid such addresses is to directly use
> > is_vmalloc_addr() directly.
>
> I do not understand why you mean that processed address is vmalloc-specific.
> As far as I understand it is valid address of static variable, and for some reason
> arm64 does not consider them valid virtual addresses.
>

Indeed you are right as we are using the addresses of net namespaces
and the report already has the information on the address
ffffd8efe2d2fe00 which is init_net.

I don't know what is the right way to handle such addresses on arm64.
BTW there is a separate report on this issue and arm maintainers are
also CCed. Why not ask this question on that report?
