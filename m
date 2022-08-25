From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RESEND PATCH bpf-next v9 5/5] selftests/bpf: add a selftest for
 cgroup hierarchical stats collection
Date: Thu, 25 Aug 2022 11:43:04 -0700
Message-ID: <CAADnVQLD+PcyO1qmxaBxdK1_tLRfBEqth8kzxts_8f+nSqu+hA@mail.gmail.com>
References: <20220824233117.1312810-1-haoluo@google.com> <20220824233117.1312810-6-haoluo@google.com>
 <CAADnVQKC_USyXe1RyWL+EY0q=x=c88opvPW-rWZ5znGJOq63CQ@mail.gmail.com> <CAJD7tkZGxkV8_3qNy_Q=k-DT2=aGknzT08WiVtESpzur1JxCwA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=q7xP9HYksRjqLoxLlP1cb34no2b9u1Ll2vr0oi+McwQ=;
        b=XOqJ3TBYRzFpP+cMJKmEBu0B3npy15NaAGmcCArco/3+wGTzzIiiCAu2ZCVZDdFR9G
         /LMjc8Xj9mfBtDxzji8MR4S9z++LHemj90jLEHc+ywrrwlDQs9K56aq6TIMYz7K72xk8
         9TBgT0yobN6qqk9EuDPMxJ2RNd4cioI4dyqqz+ZDXTuNzFU1Y2VNEeO0MEhByoNDKJCJ
         hNvMVU0tVwtDPZlwEG16x3nI4oup6mgWYZpJMin3M/ZvzFz+JmaOQyiUp9Z018nspDcJ
         gs42e1ddt1tlRkHk0f6MPowAyq5PD6qxY9/IFDH5awt2uPRo+TOB8yOhVxqt7U6phjd8
         hPQw==
In-Reply-To: <CAJD7tkZGxkV8_3qNy_Q=k-DT2=aGknzT08WiVtESpzur1JxCwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Koutny <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Aug 24, 2022 at 7:41 PM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Aug 24, 2022 at 7:09 PM Alexei Starovoitov
> <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Wed, Aug 24, 2022 at 4:31 PM Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > +
> > > +       for (i = 0; i < N_CGROUPS; i++) {
> > > +               fd = create_and_get_cgroup(cgroups[i].path);
> > > +               if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
> > > +                       return fd;
> > > +
> > > +               cgroups[i].fd = fd;
> > > +               cgroups[i].id = get_cgroup_id(cgroups[i].path);
> > > +
> > > +               /*
> > > +                * Enable memcg controller for the entire hierarchy.
> > > +                * Note that stats are collected for all cgroups in a hierarchy
> > > +                * with memcg enabled anyway, but are only exposed for cgroups
> > > +                * that have memcg enabled.
> > > +                */
> > > +               if (i < N_NON_LEAF_CGROUPS) {
> > > +                       err = enable_controllers(cgroups[i].path, "memory");
> > > +                       if (!ASSERT_OK(err, "enable_controllers"))
> > > +                               return err;
> > > +               }
> > > +       }
> >
> > It passes BPF CI, but fails in my setup with:
> >
> > # ./test_progs -t cgroup_hier -vv
> > bpf_testmod.ko is already unloaded.
> > Loading bpf_testmod.ko...
> > Successfully loaded bpf_testmod.ko.
> > setup_bpffs:PASS:mount 0 nsec
> > setup_cgroups:PASS:setup_cgroup_environment 0 nsec
> > setup_cgroups:PASS:get_root_cgroup 0 nsec
> > setup_cgroups:PASS:create_and_get_cgroup 0 nsec
> > (cgroup_helpers.c:92: errno: No such file or directory) Enabling
> > controller memory:
> > /mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control
> > setup_cgroups:FAIL:enable_controllers unexpected error: 1 (errno 2)
> > cleanup_bpffs:FAIL:rmdir /sys/fs/bpf/vmscan/ unexpected error: -1 (errno 2)
> > #36      cgroup_hierarchical_stats:FAIL
> > Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
> >
> > How do I debug it?
>
> The failure with ENOENT happens when we try to write "+memory" to
> /mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control, not when
> we try to open it. So the file is there. AFAICT, ENOENT can be
> returned from this write if the memory controller is not enabled on
> this cgroup.
>
> In setup_cgroup_environment(), we should be enabling all available
> controllers on /mnt and /mnt/cgroup-test-work-dir6526 by this line:
>
>         if (__enable_controllers(CGROUP_MOUNT_PATH, NULL) ||
>               __enable_controllers(cgroup_workdir, NULL))
>                   return 1;
>
> The first thing that comes to mind is that maybe the memory controller
> is not enabled on your setup at all? Can you check
> /sys/fs/cgroup/cgroup.controllers (or wherever your global cgroup
> mount is)?

Indeed. I didn't have a memory controller in cgroup2.
My system booted with cgroup v1 and it had cgroup1 memory
controller enabled which prevented cgroup2 to enable it.
Without Tejun's help I would have been able to figure this out.

Anyway, pushed the set to bpf-next. Thanks everyone.
