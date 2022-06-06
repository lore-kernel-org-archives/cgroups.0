From: Kumar Kartikeya Dwivedi <memxor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 0/5] bpf: rstat: cgroup hierarchical stats
Date: Tue, 7 Jun 2022 01:24:54 +0530
Message-ID: <20220606195454.byivqaarp6ra7dpc@apollo.legion>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220603162247.GC16134@blackbody.suse.cz>
 <CAJD7tkbp9Tw4oGtxsnHQB+5VZHMFa4J0qvJGRyj3VuuQ4UPF=g@mail.gmail.com>
 <20220606123209.GE6928@blackbody.suse.cz>
 <CAJD7tkZeNhyEL4WtkEMOUeLsLX4x4roMuNCocEhz5yHm7=h4vw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZAOjVHfWgWEtrCEowhgivo44hpW2jfshzvmdXVjn21k=;
        b=hlrnD/oOe2EaUICZU22+CtvzqiQwTRCk1hZt5dfuUZKWQ6TnntWxIpLy3UzelFS9cM
         JqUXuzLlQHNmUQbBq97na+4N61izImNM97gDNc2FCskjjgz32K3ULMCGs8aMi90i3BgX
         NGicAWUt/wYwrj2Umubv6/Esa/8mctbzH1bx29u2gFPCRKV26ybyDmMYjT0kkiHBBp0p
         NNBjjcS6+pxgvs7Vz72WrCGOC9+DJ7NMwlaDYX3T96ClSIv9MH+tIQ++FCDiu3HJyDKp
         n2WHQTgEEuz7soyrV9UG0cOEhSqOI1BeKDboBDONuPGRxkSCKgohal7cNrEXqCsqn5b+
         5r/g==
Content-Disposition: inline
In-Reply-To: <CAJD7tkZeNhyEL4WtkEMOUeLsLX4x4roMuNCocEhz5yHm7=h4vw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel@vge>

On Tue, Jun 07, 2022 at 01:02:04AM IST, Yosry Ahmed wrote:
> On Mon, Jun 6, 2022 at 5:32 AM Michal Koutn=FD <mkoutny-IBi9RG/b67k@publi=
c.gmane.org> wrote:
> >
> > On Fri, Jun 03, 2022 at 12:47:19PM -0700, Yosry Ahmed <yosryahmed-hpIqs=
D4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > In short, think of these bpf maps as equivalents to "struct
> > > memcg_vmstats" and "struct memcg_vmstats_percpu" in the memory
> > > controller. They are just containers to store the stats in, they do
> > > not have any subgraph structure and they have no use beyond storing
> > > percpu and total stats.
> >
> > Thanks for the explanation.
> >
> > > I run small microbenchmarks that are not worth posting, they compared
> > > the latency of bpf stats collection vs. in-kernel code that adds stats
> > > to struct memcg_vmstats[_percpu] and flushes them accordingly, the
> > > difference was marginal.
> >
> > OK, that's a reasonable comparison.
> >
> > > The main reason for this is to provide data in a similar fashion to
> > > cgroupfs, in text file per-cgroup. I will include this clearly in the
> > > next cover message.
> >
> > Thanks, it'd be great to have that use-case captured there.
> >
> > > AFAIK loading bpf programs requires a privileged user, so someone has
> > > to approve such a program. Am I missing something?
> >
> > A sysctl unprivileged_bpf_disabled somehow stuck in my head. But as I
> > wrote, this adds a way how to call cgroup_rstat_updated() directly, it's
> > not reserved for privilged users anyhow.
>
> I am not sure if kfuncs have different privilege requirements or if
> there is a way to mark a kfunc as privileged. Maybe someone with more
> bpf knowledge can help here. But I assume if unprivileged_bpf_disabled
> is not set then there is a certain amount of risk/trust that you are
> taking anyway?
>

It requires CAP_BPF or CAP_SYS_ADMIN, see verifier.c:add_subprog_or_kfunc.

> >
> > > bpf_iter_run_prog() is used to run bpf iterator programs, and it grabs
> > > rcu read lock before doing so. So AFAICT we are good on that front.
> >
> > Thanks for the clarification.
> >
> >
> > Michal
