From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 0/5] bpf: rstat: cgroup hierarchical stats
Date: Mon, 6 Jun 2022 12:32:04 -0700
Message-ID: <CAJD7tkZeNhyEL4WtkEMOUeLsLX4x4roMuNCocEhz5yHm7=h4vw@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220603162247.GC16134@blackbody.suse.cz> <CAJD7tkbp9Tw4oGtxsnHQB+5VZHMFa4J0qvJGRyj3VuuQ4UPF=g@mail.gmail.com>
 <20220606123209.GE6928@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j/cPLNIZM1LCsTUDc6o0FCtYbw+beYsEKBGs5kqXcMs=;
        b=lzQFh/atdk+9YeyfEh+QiYmsQCHdhCw9He8IoqDkUDh70z79xt9WOeE69lDZxpcNjT
         bR141LudvjepsqtckXsTJExKjujhfBySeXX3lGBZdMyWw9Hj5GReFM3OKFmwi+TUoHQx
         oZsvwJKkDPX7u3JPtJIYSiEXF4g85cRoAjyT5U30WiD4Rahyvl6mTNRbQ2VRSRHhrZnc
         gLT5O+zMpFuaRqq5Q7CgrD1ALwUtROj44xO70cNoml5i78IH05nNERpThsHZQjrORuAS
         J1Hqkgqr3u7D3bTCMmD0YQ1IC4S8CknEj7+oNzqmijDOQei148Z/nshaGmchHBnxO64F
         DUFw==
In-Reply-To: <20220606123209.GE6928-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jun 6, 2022 at 5:32 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Fri, Jun 03, 2022 at 12:47:19PM -0700, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > In short, think of these bpf maps as equivalents to "struct
> > memcg_vmstats" and "struct memcg_vmstats_percpu" in the memory
> > controller. They are just containers to store the stats in, they do
> > not have any subgraph structure and they have no use beyond storing
> > percpu and total stats.
>
> Thanks for the explanation.
>
> > I run small microbenchmarks that are not worth posting, they compared
> > the latency of bpf stats collection vs. in-kernel code that adds stats
> > to struct memcg_vmstats[_percpu] and flushes them accordingly, the
> > difference was marginal.
>
> OK, that's a reasonable comparison.
>
> > The main reason for this is to provide data in a similar fashion to
> > cgroupfs, in text file per-cgroup. I will include this clearly in the
> > next cover message.
>
> Thanks, it'd be great to have that use-case captured there.
>
> > AFAIK loading bpf programs requires a privileged user, so someone has
> > to approve such a program. Am I missing something?
>
> A sysctl unprivileged_bpf_disabled somehow stuck in my head. But as I
> wrote, this adds a way how to call cgroup_rstat_updated() directly, it's
> not reserved for privilged users anyhow.

I am not sure if kfuncs have different privilege requirements or if
there is a way to mark a kfunc as privileged. Maybe someone with more
bpf knowledge can help here. But I assume if unprivileged_bpf_disabled
is not set then there is a certain amount of risk/trust that you are
taking anyway?

>
> > bpf_iter_run_prog() is used to run bpf iterator programs, and it grabs
> > rcu read lock before doing so. So AFAICT we are good on that front.
>
> Thanks for the clarification.
>
>
> Michal
