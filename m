From: Andrii Nakryiko <andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] perf stat: Support old kernels for bperf cgroup counting
Date: Wed, 5 Oct 2022 15:36:37 -0700
Message-ID: <CAEf4Bza0dt6v8YLNvQbANH+O9E5naZZj1cc4H6j=KK9WQcym8w@mail.gmail.com>
References: <CAM9d7cjQ20a01YoZi=o-_7HT6TzR0TZgtpscKNvRrMq2yqV1Og@mail.gmail.com>
 <20220922041435.709119-1-namhyung@kernel.org> <CAEf4BzZhHYYOmNhLdrpsXSDE5kaXvgSN00X-8aAySDwAKX0RCw@mail.gmail.com>
 <CAM9d7ch8RUgf8V1hi=ccgV84XSfujuWtUKKgre8eQdGmtdiFLA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5IDa4zO8fjCrFtrwiC0X35h30/CNk4qiLrUvMAkxVAs=;
        b=bm30/cArbm6oXF4zz1/TtHAWlji0iXVLwmqbQ8S+eX+WoOj3CAuuIz6pZTPsG/T+x8
         tQuWs0gvBC5SG/yfefFxVY2DB4LqAzzAd3/kN3emfJiPT5otMXw6F8Hnsig2FHnJaswi
         xyU6sVIQ9t48MFF1pB5zpnyNuo7f/Wo9gQ06BgxfSzrZoPS2PIzQIvz5rH2Hj7CZltvw
         EE1cHiLJW3Nx55kuMDHjzlm9+iSe749VmzE7X20P54yDycBMuaOEnnipVWFVMwzetjq3
         AKlp0g8DBThkQM/uQSi27PJN7F3IdQi14TUpoO/hPCY/hN+X3QmV/7eRYIMax/s3LrUe
         Xb2g==
In-Reply-To: <CAM9d7ch8RUgf8V1hi=ccgV84XSfujuWtUKKgre8eQdGmtdiFLA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-perf-users <linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Sep 30, 2022 at 7:31 PM Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, Sep 30, 2022 at 3:48 PM Andrii Nakryiko
> <andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Wed, Sep 21, 2022 at 9:21 PM Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > The recent change in the cgroup will break the backward compatiblity in
> > > the BPF program.  It should support both old and new kernels using BPF
> > > CO-RE technique.
> > >
> > > Like the task_struct->__state handling in the offcpu analysis, we can
> > > check the field name in the cgroup struct.
> > >
> > > Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > ---
> > > Arnaldo, I think this should go through the cgroup tree since it depends
> > > on the earlier change there.  I don't think it'd conflict with other
> > > perf changes but please let me know if you see any trouble, thanks!
> > >
> > >  tools/perf/util/bpf_skel/bperf_cgroup.bpf.c | 29 ++++++++++++++++++++-
> > >  1 file changed, 28 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
> > > index 488bd398f01d..4fe61043de04 100644
> > > --- a/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
> > > +++ b/tools/perf/util/bpf_skel/bperf_cgroup.bpf.c
> > > @@ -43,12 +43,39 @@ struct {
> > >         __uint(value_size, sizeof(struct bpf_perf_event_value));
> > >  } cgrp_readings SEC(".maps");
> > >
> > > +/* new kernel cgroup definition */
> > > +struct cgroup___new {
> > > +       int level;
> > > +       struct cgroup *ancestors[];
> > > +} __attribute__((preserve_access_index));
> > > +
> > > +/* old kernel cgroup definition */
> > > +struct cgroup___old {
> > > +       int level;
> > > +       u64 ancestor_ids[];
> > > +} __attribute__((preserve_access_index));
> > > +
> > >  const volatile __u32 num_events = 1;
> > >  const volatile __u32 num_cpus = 1;
> > >
> > >  int enabled = 0;
> > >  int use_cgroup_v2 = 0;
> > >
> > > +static inline __u64 get_cgroup_v1_ancestor_id(struct cgroup *cgrp, int level)
> > > +{
> > > +       /* recast pointer to capture new type for compiler */
> > > +       struct cgroup___new *cgrp_new = (void *)cgrp;
> > > +
> > > +       if (bpf_core_field_exists(cgrp_new->ancestors)) {
> > > +               return BPF_CORE_READ(cgrp_new, ancestors[level], kn, id);
> >
> > have you checked generated BPF code for this ancestors[level] access?
> > I'd expect CO-RE relocation for finding ancestors offset and then just
> > normal + level * 8 arithmetic, but would be nice to confirm. Apart
> > from this, looks good to me:
> >
> > Acked-by: Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks for your review!
>
> How can I check the generated code?  Do you have something works with
> skeletons or do I have to save the BPF object somehow during the build?
>

skeleton is generated from ELF BPF object file. You can do
llvm-objdump -d <obj.bpf.o> to see instructions. Unfortunately you
can't see BPF CO-RE relocations this way, you'd have to use something
like my custom tool ([0]).

But anyways, I checked locally similar code pattern and I think it's
all good from BPF CO-RE perspective. I see appropriate relocations in
all the necessary places. So this should work.

Acked-by: Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

  [0] https://github.com/anakryiko/btfdump

> Thanks,
> Namhyung
