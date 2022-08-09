From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v7 5/8] selftests/bpf: Test cgroup_iter.
Date: Mon, 8 Aug 2022 17:20:25 -0700
Message-ID: <CAEf4BzarAHuR7mOeHToNiNMc03QnR=74cxt_h5LRymf1U6HevQ@mail.gmail.com>
References: <20220805214821.1058337-1-haoluo@google.com> <20220805214821.1058337-6-haoluo@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=nIlY/B2wpUmWSlONORtqotpuUOicf3PK4NcK3e+GsKw=;
        b=pVVUE/R4uaOiN+usJ5CgWlkbEXNcClHan/YNXEPQ45K7vuwJoOACk+2hUJacb5TGP4
         90nRnnsAEtIYt77hdhjrD5auMoEJUTOID6+tRdgR2VglgFBDhmoBbW+9kj4RyIMBJ2oW
         c4UKjvE0JJPZhfp/C1DfGPXeq4geRk+tWz35S6nyhtOc/wfKG7DtVg/lwBtvpU8Mp2oV
         3LQeuxK5aIVA5zDri8hUqz7oL2JwUeS7LCcTRUwtgbUFldrcP2vhn4+3ByKwStosQj6P
         uiACrsbCdP+rMGdPtAm/IIxEao8A+AP4t8hUgWnIGv6Ftdt/C7e0edmbJQzOhyUNTtp1
         dA+A==
In-Reply-To: <20220805214821.1058337-6-haoluo@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Luo <haoluo@google.com>
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, KP Singh <kpsingh@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, Michal Koutny <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Shakeel Butt <shakeelb@google.com>

On Fri, Aug 5, 2022 at 2:49 PM Hao Luo <haoluo@google.com> wrote:
>
> Add a selftest for cgroup_iter. The selftest creates a mini cgroup tree
> of the following structure:
>
>     ROOT (working cgroup)
>      |
>    PARENT
>   /      \
> CHILD1  CHILD2
>
> and tests the following scenarios:
>
>  - invalid cgroup fd.
>  - pre-order walk over descendants from PARENT.
>  - post-order walk over descendants from PARENT.
>  - walk of ancestors from PARENT.
>  - walk from PARENT in the default order, which is pre-order.
>  - process only a single object (i.e. PARENT).
>  - early termination.
>
> Acked-by: Yonghong Song <yhs@fb.com>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../selftests/bpf/prog_tests/cgroup_iter.c    | 237 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bpf_iter.h  |   7 +
>  .../testing/selftests/bpf/progs/cgroup_iter.c |  39 +++
>  3 files changed, 283 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
>

[...]
