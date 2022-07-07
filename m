From: Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
Date: Thu, 7 Jul 2022 16:36:23 -0700
Message-ID: <CA+khW7hqVbNWFbZcJz2QWV=c5SD1ci5KOD+t4drYt2-yqpyNTg@mail.gmail.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-5-yosryahmed@google.com> <40114462-d5e2-ab07-7af9-5e60180027f9@fb.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XH4cPztGrQqsT+SfmP8eyqdVMM+gtgpNj/VjG8VG1nM=;
        b=RFDw+QHkFGDIWwRdYchdMvdzsKCZaAPs4rT4ufLkxWlPRK1TI6fo0tjk8JODZtXKd4
         O72HgDCHviGjhjlEXZIeWeRgMHge4ii8LtPQRk1ZM82WyleakaHT/bxJQNT7uYoRE8yd
         SOGYpBPdjvDJJFdnTOaO+cMv6a2l85flA9T+BpAnhJq3g+mfulEU+5cpzBnFASy/TLUZ
         N9Cwcsd0p4otAVw0a9HYeTSCK1Sxz4CS2n9g8UPBtXsPDroiRwmeHTmafUJH0EaJcSGS
         O/nPs75YVwnKxl4fHAQR8KMDd+7m3K4UhR5DhjExN/y7NOq4kENl9IZ+KDKOPDR2/Q/9
         7jBg==
In-Reply-To: <40114462-d5e2-ab07-7af9-5e60180027f9@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs@fb.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Jun 27, 2022 at 9:14 PM Yonghong Song <yhs@fb.com> wrote:
>
> > +static int __cgroup_iter_seq_show(struct seq_file *seq,
> > +                               struct cgroup_subsys_state *css, int in_stop)
> > +{
> > +     struct cgroup_iter_priv *p = seq->private;
> > +     struct bpf_iter__cgroup ctx;
> > +     struct bpf_iter_meta meta;
> > +     struct bpf_prog *prog;
> > +     int ret = 0;
> > +
> > +     /* cgroup is dead, skip this element */
> > +     if (css && cgroup_is_dead(css->cgroup))
> > +             return 0;
> > +
> > +     ctx.meta = &meta;
> > +     ctx.cgroup = css ? css->cgroup : NULL;
> > +     meta.seq = seq;
> > +     prog = bpf_iter_get_info(&meta, in_stop);
> > +     if (prog)
> > +             ret = bpf_iter_run_prog(prog, &ctx);
>
> Do we need to do anything special to ensure bpf program gets
> up-to-date stat from ctx.cgroup?
>

Let's leave that to be handled by bpf programs. The kfunc rstat_flush
can be called to sync stats, if using rstat.

> > +
> > +     /* if prog returns > 0, terminate after this element. */
> > +     if (ret != 0)
> > +             p->terminate = true;
> > +
> > +     return 0;
> > +}
> > +
> [...]
