From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [RESEND PATCH bpf-next v9 5/5] selftests/bpf: add a selftest for
 cgroup hierarchical stats collection
Date: Wed, 24 Aug 2022 19:41:21 -0700
Message-ID: <CAJD7tkZGxkV8_3qNy_Q=k-DT2=aGknzT08WiVtESpzur1JxCwA@mail.gmail.com>
References: <20220824233117.1312810-1-haoluo@google.com> <20220824233117.1312810-6-haoluo@google.com>
 <CAADnVQKC_USyXe1RyWL+EY0q=x=c88opvPW-rWZ5znGJOq63CQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=doFUHdVPTABkZsDuf0MJLhPZVm+o4dycrmtaBb1zaGg=;
        b=ljEZc6yMBm22SLRA96eNiZ8zgNwa6AiCs/mIj4MH8Lu0ITLXCDbw1rPAThOIFT6Hls
         ospWapMqLKqRDIfRiC+dCGUxBR5sBvXQ26YTcthtauabE4uJitMLdbltOEAcI4UYmaD8
         j1f06IYOrOaeiFBdUe+UDv9Lah3WVcDkkdi7vs8AauhaW43RVxrNEy24rmWtaAHHHM+u
         h7B3HLp+8WRyddXXmzTHtWjnkO1iV1aa6u2vo0XFu1N8LA90hsMIcwYJkyIP72cSCzHn
         Oy6w8nNGH41msDEU6rjbzxVYJQG80prf38WQ/d2GRWv/I5OlSZFlOdPtahy7/ehSx+7F
         8fAg==
In-Reply-To: <CAADnVQKC_USyXe1RyWL+EY0q=x=c88opvPW-rWZ5znGJOq63CQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Hao Luo <haoluo@google.com>, LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, KP Singh <kpsingh@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Jiri Olsa <jolsa@kernel.org>, Michal Koutny <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>

On Wed, Aug 24, 2022 at 7:09 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 24, 2022 at 4:31 PM Hao Luo <haoluo@google.com> wrote:
> > +
> > +       for (i = 0; i < N_CGROUPS; i++) {
> > +               fd = create_and_get_cgroup(cgroups[i].path);
> > +               if (!ASSERT_GE(fd, 0, "create_and_get_cgroup"))
> > +                       return fd;
> > +
> > +               cgroups[i].fd = fd;
> > +               cgroups[i].id = get_cgroup_id(cgroups[i].path);
> > +
> > +               /*
> > +                * Enable memcg controller for the entire hierarchy.
> > +                * Note that stats are collected for all cgroups in a hierarchy
> > +                * with memcg enabled anyway, but are only exposed for cgroups
> > +                * that have memcg enabled.
> > +                */
> > +               if (i < N_NON_LEAF_CGROUPS) {
> > +                       err = enable_controllers(cgroups[i].path, "memory");
> > +                       if (!ASSERT_OK(err, "enable_controllers"))
> > +                               return err;
> > +               }
> > +       }
>
> It passes BPF CI, but fails in my setup with:
>
> # ./test_progs -t cgroup_hier -vv
> bpf_testmod.ko is already unloaded.
> Loading bpf_testmod.ko...
> Successfully loaded bpf_testmod.ko.
> setup_bpffs:PASS:mount 0 nsec
> setup_cgroups:PASS:setup_cgroup_environment 0 nsec
> setup_cgroups:PASS:get_root_cgroup 0 nsec
> setup_cgroups:PASS:create_and_get_cgroup 0 nsec
> (cgroup_helpers.c:92: errno: No such file or directory) Enabling
> controller memory:
> /mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control
> setup_cgroups:FAIL:enable_controllers unexpected error: 1 (errno 2)
> cleanup_bpffs:FAIL:rmdir /sys/fs/bpf/vmscan/ unexpected error: -1 (errno 2)
> #36      cgroup_hierarchical_stats:FAIL
> Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>
> How do I debug it?

The failure with ENOENT happens when we try to write "+memory" to
/mnt/cgroup-test-work-dir6526//test/cgroup.subtree_control, not when
we try to open it. So the file is there. AFAICT, ENOENT can be
returned from this write if the memory controller is not enabled on
this cgroup.

In setup_cgroup_environment(), we should be enabling all available
controllers on /mnt and /mnt/cgroup-test-work-dir6526 by this line:

        if (__enable_controllers(CGROUP_MOUNT_PATH, NULL) ||
              __enable_controllers(cgroup_workdir, NULL))
                  return 1;

The first thing that comes to mind is that maybe the memory controller
is not enabled on your setup at all? Can you check
/sys/fs/cgroup/cgroup.controllers (or wherever your global cgroup
mount is)?

I don't know much about namespaces, so I am not sure if the privately
mounted /mnt directory here would be the same as the cgroup root or
not. Maybe we can add a pause() somewhere and check
/mnt/cgroup.controllers as well?
