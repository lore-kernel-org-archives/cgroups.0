From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v7 5/8] selftests/bpf: Test cgroup_iter.
Date: Mon, 8 Aug 2022 18:18:33 -0700
Message-ID: <CA+khW7gJS2pjc2eHXCkHirdHMqcmzZM_a4VPUvw9RAicgH9Q=A@mail.gmail.com>
References: <20220805214821.1058337-1-haoluo@google.com> <20220805214821.1058337-6-haoluo@google.com>
 <CAEf4BzarAHuR7mOeHToNiNMc03QnR=74cxt_h5LRymf1U6HevQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=YEeewL7u26t5xnjYAteTsi6uBftnEQWFJtji4zMngLI=;
        b=QM7K5PRSL41dOjkkhbr12boFvR549hO04dJ6wroBBRID09Qd38NtGUxr6+hJ5liFdh
         XADmeBQIhVFJtuCVXUkjFuwfdSvnHuxmLN1qDsStbSuWm4xjUEeppWn/O3X1TViF2Jfb
         vzG4LoMdmvy0fDsZvNLXes7sfmqTrmRozESBVcgJqVQJctpZogvFqk03nnLd9G2FE85j
         mvgIFtviM/gLC7idiwlUZ2Pm40O2ikuhBVo93f4phvXVe1dd5yEIxb7hUSbrH1BtaAKO
         6iyDof7WrBiuDe4ojNt5E4BwSCWP9fqef4pqYecQOrw1nt5uU4QtWucqjT597i1qxEwi
         J1Tw==
In-Reply-To: <CAEf4BzarAHuR7mOeHToNiNMc03QnR=74cxt_h5LRymf1U6HevQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrii Nakryiko <andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Koutny <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Aug 8, 2022 at 5:20 PM Andrii Nakryiko
<andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Fri, Aug 5, 2022 at 2:49 PM Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
> > of the following structure:
> >
> >     ROOT (working cgroup)
> >      |
> >    PARENT
> >   /      \
> > CHILD1  CHILD2
> >
> > and tests the following scenarios:
> >
> >  - invalid cgroup fd.
> >  - pre-order walk over descendants from PARENT.
> >  - post-order walk over descendants from PARENT.
> >  - walk of ancestors from PARENT.
> >  - walk from PARENT in the default order, which is pre-order.
> >  - process only a single object (i.e. PARENT).
> >  - early termination.
> >
> > Acked-by: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
> > Signed-off-by: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
>
> LGTM.
>
> Acked-by: Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>

Thanks!

> >  .../selftests/bpf/prog_tests/cgroup_iter.c    | 237 ++++++++++++++++++
> >  tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
> >  .../testing/selftests/bpf/progs/cgroup_iter.c |  39 +++
> >  3 files changed, 283 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
> >
>
> [...]
