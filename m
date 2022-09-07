From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for
 bpf map
Date: Wed, 7 Sep 2022 07:01:31 -1000
Message-ID: <YxjOawzlgE458ezL@slm.duckdns.org>
References: <20220902023003.47124-1-laoar.shao@gmail.com>
 <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <Yxi8i3eP4fDDv2+X@slm.duckdns.org>
 <CAADnVQ+ZMCeKZOsb3GL0CnnZW0pxR0oDTUjqDczvbsVAViLs-Q@mail.gmail.com>
 <YxjEQabWR/BQOzk5@slm.duckdns.org>
 <CAADnVQLe4oGE8vrAMoJZ+xAT3BefyOv3EhwY3QVGBQn5x25DkQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=TqbLb+KgxPbnQGfynSMlarvTL8mplWrZYa3AXE4SSEA=;
        b=M0aSp3XVpFQ7bWIdvytb5uhz2wbLWyKSJsDmE9iidJ8FRw/dGS/Z3jvvkleFpXTenY
         QvgPAhYJNZLM593j1hyz554JcYK8lZ17U3nLGgfYdjLbBQ9qrvhmKVafghSFKOweQsDt
         49OmiKoUXdb3cmQeHkvJODY4gw4stBvrtAKYgAcbjSZQqbBBEg3vrUP+5nqp+OAAsjUB
         1Op9sgJ3u9W1LoKbhiLq2DFuc2BbWHEHEaWGHqZ6uBfV7XfBwtUlKt7iTyXLlYJh6nmM
         tRBVFjN8unCaFVD691+iDdrGPoPjsqPsGx0qb0NHCgUXsy5Kb3jqfIaZkSNQjtbTpZ2h
         vPCQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAADnVQLe4oGE8vrAMoJZ+xAT3BefyOv3EhwY3QVGBQn5x25DkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netwo

On Wed, Sep 07, 2022 at 09:27:09AM -0700, Alexei Starovoitov wrote:
> On Wed, Sep 7, 2022 at 9:18 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > Hello,
> >
> > On Wed, Sep 07, 2022 at 09:13:09AM -0700, Alexei Starovoitov wrote:
> > > Hmm. We discussed this option already. We definitely don't want
> > > to introduce an uapi knob that will allow anyone to skip memcg
> > > accounting today and in the future.
> >
> > cgroup.memory boot parameter is how memcg provides last-resort workarounds
> > for this sort of problems / regressions while they're being addressed. It's
> > not a dynamically changeable or programmable thing. Just a boot time
> > opt-out. That said, if you don't want it, you don't want it.
> 
> ahh. boot param.
> Are you suggesting a global off switch ? Like nosocket and nokmem.
> That would be a different story.
> Need to think more about it. It could be ok.

Yeah, nobpf or sth like that. An equivalent cgroup.memory parameter.

Thanks.

-- 
tejun
