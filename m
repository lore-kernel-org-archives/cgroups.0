From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Tue, 7 Jun 2022 10:43:35 -0700
Message-ID: <CAJD7tkYa3u52c77cnRxZ6D_4u5fkDG545r5a9SdK3Ys9Uuorig@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com> <20220603162339.GA25043@blackbody.suse.cz>
 <CAJD7tkYwU5dW9Oof+pC81R9Bi-F=-EuiXpTn+HDeqbhTOTCcuw@mail.gmail.com>
 <20220606123222.GA4377@blackbody.suse.cz> <CAJD7tkbi7Gnnf4NiUt-J61G7185NsRcySvP6qOQsFKMou7qZJg@mail.gmail.com>
 <20220607121237.GC31717@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Avvoh8CnIiqiG7pt5w+f0B0Z6X7OPhtWirg6KypOnRk=;
        b=VJgCpuVqKSXl0XX58PrPxmWGKDkQdIE6BEthpBh1qGGSHXZS3+YISNnwTYkYarnho9
         MvxMYs2TMqZiGshTbPZ0zIzK1VVVXZpVgaziJrABATtPimx965adbeB6GqOUlTuNnyhz
         NPWJKmZexcPAKl4rzq3JtNd9/PXX0JeVvORheEEpbcyms/Ra+vjsuG5Kqeil6AQzy6/V
         KHCGQPlibPQzrK3H2wed7BEJ3UlHPtrRePVo21DyyddSbOjiJ+ttt3X/L876GbyiyvAw
         UJZAGIQaLuw88L2APyzR3tLX+5EFi65VfUbyfbBKfXfwkl++cELNNBZ8yhYU7i7NZ9fd
         954g==
In-Reply-To: <20220607121237.GC31717@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>

On Tue, Jun 7, 2022 at 5:12 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> On Mon, Jun 06, 2022 at 12:41:06PM -0700, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > I don't know if there is a standard way to handle this, but I think
> > you should know the configs of your kernel when you are loading a bpf
> > program?
>
> Isn't this one of purposes of BTF? (I don't know, I'm genuinely asking.)
>
> > If the CONFIG_CGROUPS=3D1 but CONFIG_MEMCG=3D0 I think everything will
> > work normally except that task_memcg() will always return NULL so no
> > stats will be collected, which makes sense.
>
> I was not able to track down what is the include chain to
> tools/testing/selftests/bpf/progs/cgroup_vmscan.c, i.e. how is the enum
> value memory_cgrp_id defined.

memory_cgrp_id is defined in "vmlinux.h" (generated from BTF) which is
included through "bpf_iter.h". If the kernel is not compiled with
CONFIG_MEMCG then this enum value will not be defined and the bpf prog
should not compile.

>
> (A custom kernel module build requires target kernel's header files, I
> could understand that compiling a BPF program requires them likewise and
> that's how this could work.
> Although, it goes against my undestanding of the CO-RE principle.)
>
> > There will be some overhead to running bpf programs that will always
> > do nothing, but I would argue that it's the userspace's fault here for
> > loading bpf programs on a non-compatible kernel.
>
> Yeah, running an empty program is non-issue in my eyes, I was rather
> considering whether the program uses proper offsets.
>
> Michal
>
