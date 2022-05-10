From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
Date: Tue, 10 May 2022 14:55:32 -0700
Message-ID: <CAJD7tkbeZPH9UJXtGeopPnTSVPYN-GzzM51SE_QNuLmiaVNpeA@mail.gmail.com>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com> <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
 <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
 <YnrEDfZs1kuB1gu5@slm.duckdns.org> <CAJD7tkahC1e-_K0xJMu-xXwd8WNVzYDRgJFua9=JhNRq7b+G8A@mail.gmail.com>
 <YnrSrKFTBn3IyUfa@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IwUgKUFNj7ibkuKWy6cspfPFQL3X6FyIq81DUZlFReI=;
        b=pvu4vmnNkxBfNPaw9v92a2w+TVqfwi+iTgvjgFvjq+ssgXnL2/XxuczeCjzFigw6Fp
         LdrwiJrm5va3fTljcIrhm2cCN2U3mHlAeGm/YCKUXs8GdTX9I68G+Bkv1+NDR1Vt5YAL
         b0Oy+hcWXfNh68+frvkkZEUFC4PBzALS5U5cfl6+gErj5JV6cqdOWZypd5vUtHNf1ZvG
         S5ld+Bo59W0iXbrlJP/mnDfnhgKqL6sJExvTb1S/4mzhTBYEDX1kSPUfTU+4U7XvOULp
         BlWx/yzcaO3KNO9uZIsiptBfq34GgjqYlMOzrHkqYyBggfOuj6Q3k2CYVGzEXWLPerlF
         PpIA==
In-Reply-To: <YnrSrKFTBn3IyUfa@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Tue, May 10, 2022 at 2:01 PM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Tue, May 10, 2022 at 01:43:46PM -0700, Yosry Ahmed wrote:
> > I assume if we do this optimization, and have separate updated lists
> > for controllers, we will still have a "core" updated list that is not
> > tied to any controller. Is this correct?
>
> Or we can create a dedicated updated list for the bpf progs, or even
> multiple for groups of them and so on.
>
> > If yes, then we can make the interface controller-agnostic (a global
> > list of BPF flushers). If we do the optimization later, we tie BPF
> > stats to the "core" updated list. We can even extend the userland
> > interface then to allow for controller-specific BPF stats if found
> > useful.
>
> We'll need that anyway as cpustats are tied to the cgroup themselves rather
> than the cpu controller.
>
> > If not, and there will only be controller-specific updated lists then,
> > then we might need to maintain a "core" updated list just for the sake
> > of BPF programs, which I don't think would be favorable.
>
> If needed, that's fine actually.
>
> > What do you think? Either-way, I will try to document our discussion
> > outcome in the commit message (and maybe the code), so that
> > if-and-when this optimization is made, we can come back to it.
>
> So, the main focus is keeping the userspace interface as simple as possible
> and solving performance issues on the rstat side. If we need however many
> updated lists to do that, that's all fine. FWIW, the experience up until now
> has been consistent with the assumptions that the current implementation
> makes and I haven't seen real any world cases where the shared updated list
> are problematic.
>

Thanks again for your insights and time!

That's great to hear. I am all in for making the userspace interface
simpler. I will rework this patch series so that the BPF programs just
attach to "rstat" and send a V1.
Any other concerns you have that you think I should address in V1?

> Thanks.
>
> --
> tejun
