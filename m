From: Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next v9 1/5] bpf: Introduce cgroup iter
Date: Thu, 25 Aug 2022 13:35:01 -0700
Message-ID: <CA+khW7hHA2gjv_UhbyhU8HkFwemt4pARVw+e1SHHOteO60PF1g@mail.gmail.com>
References: <20220824030031.1013441-1-haoluo@google.com> <20220824030031.1013441-2-haoluo@google.com>
 <CAEf4BzYfA5uzSVsRXJXKnUQFSD1Wmk29VPge-iEO+Los3e2VOg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=W38//0BN+Mpi0ment/DsNSBH0AG+YpTWl5XPod3ELr0=;
        b=dGjDuNJ77b0qiF7A7XJwWcfiPoVvBgARtQyqNLS8IOmEjPKNCo+Y6HtxCvKY+Ybt9d
         NQX5ik4AKTRY2tR63EXfYAvOIY/tq+aG7/TE2kPhRsXRw9fYhpy9/0bUSsQ/5mjMU8dU
         Gb43y1FYS9WQXZeJSFo9pt1A9Rf2Ho/fK3R61GbJ9sB2+hIaAY8GIig01Rfh6+sEGLIE
         SD747ay13SeKdEJgvPwoRilBilWpdK4MRdDikVgu8HtSBq78DDXkUsrg1JyGujpPZYpI
         FheTBoQejDtki6MVt3z6RV3X0pn5U1SQ3BWgyDLLmkirlx0AYA7czdk5nKNnhh3NOsKz
         A6uQ==
In-Reply-To: <CAEf4BzYfA5uzSVsRXJXKnUQFSD1Wmk29VPge-iEO+Los3e2VOg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, KP Singh <kpsingh@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Jiri Olsa <jolsa@kernel.org>, Michal Koutny <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Shakeel Butt <shakeelb@google.com>, Yosry Ahmed <yosryahme>

On Thu, Aug 25, 2022 at 1:18 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Aug 23, 2022 at 8:01 PM Hao Luo <haoluo@google.com> wrote:
> >
[...]
> >  typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 934a2a8beb87..1c4e1c583880 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -87,10 +87,29 @@ struct bpf_cgroup_storage_key {
> >         __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
> >  };
> >
> > +enum bpf_cgroup_iter_order {
> > +       BPF_ITER_ORDER_UNSPEC = 0,
> > +       BPF_ITER_SELF_ONLY,             /* process only a single object. */
> > +       BPF_ITER_DESCENDANTS_PRE,       /* walk descendants in pre-order. */
> > +       BPF_ITER_DESCENDANTS_POST,      /* walk descendants in post-order. */
> > +       BPF_ITER_ANCESTORS_UP,          /* walk ancestors upward. */
> > +};
>
> just skimming through this, I noticed that we have "enum
> bpf_cgroup_iter_order" (good, I like) but BPF_ITER_xxx with no CGROUP
> part in it (not good, don't like :). All the enumerator names have
> global visibility, so it would probably be best for them to be
> CGROUP-specific and roughly match the enum name itself:
> BPF_CGROUP_ITER_SELF_ONLY, etc?
>

Ack. I will send a patch to fix this right now.
