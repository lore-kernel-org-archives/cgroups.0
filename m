From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Date: Fri, 20 May 2022 09:08:35 -0700
Message-ID: <CAJD7tkanipJ7-9H_L6KMUjpD2qS29-YCrnMXw+8BAKfbOk5P9Q@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com> <fa3b35a6-5c3c-42a1-23f0-a8143b4eaa57@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=owOEosLojpO/D+MbDs1w2txq2unXf52lgcJaM7HE4DE=;
        b=EEFIHz2FlFU7lsrFCGyJKhaA0AOmpAqaUvkwEHbAEnLn+Cg5XlnfcmlggdBI6HsVAO
         R5wEj0YC1TWTFA8JNycuLVEidFMsd3Rv1EUZ9/cex33OgIElag3c6E2sBEbV2RfitEvB
         4fqxupSr2ksoCRo9uddCBs3yOvnd2ZDGkVLlPg5EcpaXuJRU44jmPNOYiBFc+ymg74DA
         Rq2cmeM/6sv6CbEL8alyEPmUQXstYr7dbmiAgKGI7jRAh0+VQSmuz9a07gD6tRyf1jj8
         O9nCkVUQbWQBwGNIBr12qoJhaeC847QWhVn2ebeDfdQBP69aM6lCWdr5bbYF0tGIKNG4
         dCzQ==
In-Reply-To: <fa3b35a6-5c3c-42a1-23f0-a8143b4eaa57@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yonghong Song <yhs@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Fri, May 20, 2022 at 8:15 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/19/22 6:21 PM, Yosry Ahmed wrote:
> > Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
> > tracing programs. bpf programs that make use of rstat can use these
> > functions to inform rstat when they update stats for a cgroup, and when
> > they need to flush the stats.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >   kernel/cgroup/rstat.c | 35 ++++++++++++++++++++++++++++++++++-
> >   1 file changed, 34 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> > index e7a88d2600bd..a16a851bc0a1 100644
> > --- a/kernel/cgroup/rstat.c
> > +++ b/kernel/cgroup/rstat.c
> > @@ -3,6 +3,11 @@
> >
> >   #include <linux/sched/cputime.h>
> >
> > +#include <linux/bpf.h>
> > +#include <linux/btf.h>
> > +#include <linux/btf_ids.h>
> > +
> > +
> >   static DEFINE_SPINLOCK(cgroup_rstat_lock);
> >   static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
> >
> > @@ -141,7 +146,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated=
(struct cgroup *pos,
> >       return pos;
> >   }
> >
> > -/* A hook for bpf stat collectors to attach to and flush their stats *=
/
> > +/*
> > + * A hook for bpf stat collectors to attach to and flush their stats.
> > + * Together with providing bpf kfuncs for cgroup_rstat_updated() and
> > + * cgroup_rstat_flush(), this enables a complete workflow where bpf pr=
ogs that
> > + * collect cgroup stats can integrate with rstat for efficient flushin=
g.
> > + */
> >   __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
> >                                    struct cgroup *parent, int cpu)
> >   {
> > @@ -476,3 +486,26 @@ void cgroup_base_stat_cputime_show(struct seq_file=
 *seq)
> >                  "system_usec %llu\n",
> >                  usage, utime, stime);
> >   }
> > +
> > +/* Add bpf kfuncs for cgroup_rstat_updated() and cgroup_rstat_flush() =
*/
> > +BTF_SET_START(bpf_rstat_check_kfunc_ids)
> > +BTF_ID(func, cgroup_rstat_updated)
> > +BTF_ID(func, cgroup_rstat_flush)
> > +BTF_SET_END(bpf_rstat_check_kfunc_ids)
> > +
> > +BTF_SET_START(bpf_rstat_sleepable_kfunc_ids)
> > +BTF_ID(func, cgroup_rstat_flush)
> > +BTF_SET_END(bpf_rstat_sleepable_kfunc_ids)
> > +
> > +static const struct btf_kfunc_id_set bpf_rstat_kfunc_set =3D {
> > +     .owner          =3D THIS_MODULE,
> > +     .check_set      =3D &bpf_rstat_check_kfunc_ids,
> > +     .sleepable_set  =3D &bpf_rstat_sleepable_kfunc_ids,
>
> There is a compilation error here:
>
> kernel/cgroup/rstat.c:503:3: error: =E2=80=98const struct btf_kfunc_id_se=
t=E2=80=99 has
> no member named =E2=80=98sleepable_set=E2=80=99; did you mean =E2=80=98re=
lease_set=E2=80=99?
>      503 |  .sleepable_set =3D &bpf_rstat_sleepable_kfunc_ids,
>          |   ^~~~~~~~~~~~~
>          |   release_set
>    kernel/cgroup/rstat.c:503:19: warning: excess elements in struct
> initializer
>      503 |  .sleepable_set =3D &bpf_rstat_sleepable_kfunc_ids,
>          |                   ^
>    kernel/cgroup/rstat.c:503:19: note: (near initialization for
> =E2=80=98bpf_rstat_kfunc_set=E2=80=99)
>    make[3]: *** [scripts/Makefile.build:288: kernel/cgroup/rstat.o] Error=
 1
>
> Please fix.

This patch series is rebased on top of 2 patches in the mailing list:
- bpf/btf: also allow kfunc in tracing and syscall programs
- btf: Add a new kfunc set which allows to mark a function to be
  sleepable

I specified this in the cover letter, do I need to do something else
in this situation? Re-send the patches as part of my series?



>
> > +};
> > +
> > +static int __init bpf_rstat_kfunc_init(void)
> > +{
> > +     return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
> > +                                      &bpf_rstat_kfunc_set);
> > +}
> > +late_initcall(bpf_rstat_kfunc_init);
