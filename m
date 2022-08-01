From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v6 8/8] selftests/bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Mon, 1 Aug 2022 15:59:54 -0700
Message-ID: <CA+khW7iQiK0nqtpyc4CRjLkoaL5-w_mPqJ19mn6+7tHDMz4gew@mail.gmail.com>
References: <20220801175407.2647869-1-haoluo@google.com> <20220801175407.2647869-9-haoluo@google.com>
 <CAEf4Bza0BzW1urrDghOw2oynftOQ6jP7_k4VvEq-UgyBHp6D8g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OxoisoQrWhay6j5BeHUyCyZC1z5Zrwne8z9v746EFLw=;
        b=Td76G3pnsEYGodHWDyS8pYp3VYOSNNolQqHodrjcKrfGuCz09VlTpgXFTBJ88tTB5f
         ooUAyTdMrZP0qqPKFs23MUPcBr/KK9rAy+yax8oE/jpzxL3HVqO4PUqEQMAp9Ef0U1ii
         eysLCB+yXBbieXnwtHXatx31+diSavqEdO79TY3G+dzuIDL3YA8z5CLCt07mBy4AuMYh
         G+yUHSggy2s8+1Z09ocdEQyAAuS/nZQCjPa2WRf8OJtCtiXr3uQH18iaUPtBHwuAJ/U6
         1CopX5v6ID0F4wsjpl5MfehLuOjiW67kbhz3V1frJGh4jduTU6ARRbr12hIqyWPSm5jH
         fizw==
In-Reply-To: <CAEf4Bza0BzW1urrDghOw2oynftOQ6jP7_k4VvEq-UgyBHp6D8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrii Nakryiko <andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Koutny <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Aug 1, 2022 at 3:00 PM Andrii Nakryiko
<andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Mon, Aug 1, 2022 at 10:54 AM Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
[...]
> > ---
> >  .../prog_tests/cgroup_hierarchical_stats.c    | 358 ++++++++++++++++++
> >  .../bpf/progs/cgroup_hierarchical_stats.c     | 218 +++++++++++
> >  2 files changed, 576 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
> >
>
> [...]
>
> > +extern void cgroup_rstat_updated(struct cgroup *cgrp, int cpu) __ksym;
> > +extern void cgroup_rstat_flush(struct cgroup *cgrp) __ksym;
> > +
> > +static struct cgroup *task_memcg(struct task_struct *task)
> > +{
> > +       return task->cgroups->subsys[memory_cgrp_id]->cgroup;
>
> memory_cgrp_id is kernel-defined internal enum which actually can
> change based on kernel configuration (i.e., which cgroup subsystems
> are enabled or not), is that right?
>
> In practice you wouldn't hard-code it, it's better to use
> bpf_core_enum_value() to capture enum's value in CO-RE-relocatable
> way.
>
> So it might be a good idea to demonstrate that here.
>

Makes sense. Will use bpf_core_enum_value. Thanks!

> > +}
> > +
> > +static uint64_t cgroup_id(struct cgroup *cgrp)
> > +{
> > +       return cgrp->kn->id;
> > +}
> > +
>
> [...]
