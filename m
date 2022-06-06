From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v1 0/5] bpf: rstat: cgroup hierarchical stats
Date: Mon, 6 Jun 2022 13:00:30 -0700
Message-ID: <CAJD7tkbOFHW+Z48CbpsG3O8wvh0GYjChDgNhoiVJ=_LZsND8wQ@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220603162247.GC16134@blackbody.suse.cz> <CAJD7tkbp9Tw4oGtxsnHQB+5VZHMFa4J0qvJGRyj3VuuQ4UPF=g@mail.gmail.com>
 <20220606123209.GE6928@blackbody.suse.cz> <CAJD7tkZeNhyEL4WtkEMOUeLsLX4x4roMuNCocEhz5yHm7=h4vw@mail.gmail.com>
 <20220606195454.byivqaarp6ra7dpc@apollo.legion>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W5TqJYafwftJ1q16jDwsapCbeMrbhqufuDDjVq8Z1/0=;
        b=dRai72lfgPZVIbcYWbUJgQZW62213vXNScspB3WEJ8uXaErK7Wm69WAfoUX4ybfir5
         hGG+oasznTALQNkRvzo4k3jjOa5QWG4Q7qaLY2vlMOL0HIQvV8DB/wJc4HPztmZJKHQg
         bgjw9FszVQUdeqkBcBCL7z1i3oUV4vGRLv7xGkQN+5dXsdh9YvZWGM8+UsJL45omX6bt
         OJMtAV9tYU83SJwh93SuVYmMkYMj96481RHZ/H7H9FNMPH5GSpI9UOCOvRo+0FZqUHkj
         DF/AA5b1zGXOO1kcS9aRFg/N6xzK0ao4g3Ic4hAsHSIMDrNE5Gmm9zTqm4+LahveQS/A
         nL+w==
In-Reply-To: <20220606195454.byivqaarp6ra7dpc@apollo.legion>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vge>

On Mon, Jun 6, 2022 at 12:55 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Tue, Jun 07, 2022 at 01:02:04AM IST, Yosry Ahmed wrote:
> > On Mon, Jun 6, 2022 at 5:32 AM Michal Koutn=C3=BD <mkoutny@suse.com> wr=
ote:
> > >
> > > On Fri, Jun 03, 2022 at 12:47:19PM -0700, Yosry Ahmed <yosryahmed@goo=
gle.com> wrote:
> > > > In short, think of these bpf maps as equivalents to "struct
> > > > memcg_vmstats" and "struct memcg_vmstats_percpu" in the memory
> > > > controller. They are just containers to store the stats in, they do
> > > > not have any subgraph structure and they have no use beyond storing
> > > > percpu and total stats.
> > >
> > > Thanks for the explanation.
> > >
> > > > I run small microbenchmarks that are not worth posting, they compar=
ed
> > > > the latency of bpf stats collection vs. in-kernel code that adds st=
ats
> > > > to struct memcg_vmstats[_percpu] and flushes them accordingly, the
> > > > difference was marginal.
> > >
> > > OK, that's a reasonable comparison.
> > >
> > > > The main reason for this is to provide data in a similar fashion to
> > > > cgroupfs, in text file per-cgroup. I will include this clearly in t=
he
> > > > next cover message.
> > >
> > > Thanks, it'd be great to have that use-case captured there.
> > >
> > > > AFAIK loading bpf programs requires a privileged user, so someone h=
as
> > > > to approve such a program. Am I missing something?
> > >
> > > A sysctl unprivileged_bpf_disabled somehow stuck in my head. But as I
> > > wrote, this adds a way how to call cgroup_rstat_updated() directly, i=
t's
> > > not reserved for privilged users anyhow.
> >
> > I am not sure if kfuncs have different privilege requirements or if
> > there is a way to mark a kfunc as privileged. Maybe someone with more
> > bpf knowledge can help here. But I assume if unprivileged_bpf_disabled
> > is not set then there is a certain amount of risk/trust that you are
> > taking anyway?
> >
>
> It requires CAP_BPF or CAP_SYS_ADMIN, see verifier.c:add_subprog_or_kfunc=
.

Thanks for the clarification!

>
> > >
> > > > bpf_iter_run_prog() is used to run bpf iterator programs, and it gr=
abs
> > > > rcu read lock before doing so. So AFAICT we are good on that front.
> > >
> > > Thanks for the clarification.
> > >
> > >
> > > Michal
>
> --
> Kartikeya
