From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next v3 00/13] bpf: Introduce selectable memcg for bpf map
Date: Thu, 8 Sep 2022 10:44:18 +0800
Message-ID: <CALOAHbBEtehfx1NhXKAoqTS+3ZzX4niWV-aWT5joqDhXOO_G1w@mail.gmail.com>
References: <20220902023003.47124-1-laoar.shao@gmail.com> <Yxi8I4fXXSCi6z9T@slm.duckdns.org>
 <Yxi8i3eP4fDDv2+X@slm.duckdns.org> <CAADnVQ+ZMCeKZOsb3GL0CnnZW0pxR0oDTUjqDczvbsVAViLs-Q@mail.gmail.com>
 <YxjEQabWR/BQOzk5@slm.duckdns.org> <CAADnVQLe4oGE8vrAMoJZ+xAT3BefyOv3EhwY3QVGBQn5x25DkQ@mail.gmail.com>
 <YxjOawzlgE458ezL@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=2pHEsap3RFdinHeELihIMRhGO2rHiXvCucqCEo2lx64=;
        b=HerJ8zNIlx4KHJmo5rkripn6dc0/uLP0bHlCb3Ir6cVFH2m4xHRDlcFANr9WVi00R9
         6sJRUd0ROsz/B/WSxkeZRjGIOA0+IWKXv0AaopO3oXVpMylWb92xH5Zi/ylwhUAX2aU1
         +QWG4XSp3f4CMhHjeK7NTMO2hhUPkkgJRlED8qh40XzSnOQBzhSZyU2Rivt4Djs/bDdV
         snK5PCrW2MLxj4H4ARaumC9esLTEeZoAF4eMMgVENnqOaXNULsFmjrUJN+P3BuUyWJzr
         OuXKoUOpXIAZjZqhSlAnD0YZDCO3M7rz2i7xybd/WXS3EceSfNGZzLZ3Ako9A4AFYU7U
         Vlvg==
In-Reply-To: <YxjOawzlgE458ezL-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 8, 2022 at 1:01 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Wed, Sep 07, 2022 at 09:27:09AM -0700, Alexei Starovoitov wrote:
> > On Wed, Sep 7, 2022 at 9:18 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > Hello,
> > >
> > > On Wed, Sep 07, 2022 at 09:13:09AM -0700, Alexei Starovoitov wrote:
> > > > Hmm. We discussed this option already. We definitely don't want
> > > > to introduce an uapi knob that will allow anyone to skip memcg
> > > > accounting today and in the future.
> > >
> > > cgroup.memory boot parameter is how memcg provides last-resort workarounds
> > > for this sort of problems / regressions while they're being addressed. It's
> > > not a dynamically changeable or programmable thing. Just a boot time
> > > opt-out. That said, if you don't want it, you don't want it.
> >
> > ahh. boot param.
> > Are you suggesting a global off switch ? Like nosocket and nokmem.
> > That would be a different story.
> > Need to think more about it. It could be ok.
>
> Yeah, nobpf or sth like that. An equivalent cgroup.memory parameter.
>

It may be a useful feature for some cases, but it can't help container users.
The memcg works well to limit the non-pinned bpf-map, that's the
reason why we, a container user, switch to memcg-based bpf charging.
Our goal is to make it also work for pinned bpf-map.

That said,  your proposal may be a useful feature,  but it should be
another different patchset.

-- 
Regards
Yafang
