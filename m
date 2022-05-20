From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 00:58:52 -0700
Message-ID: <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ea7uCWmZvVi7x8pZXNpq32JNdBnZG/d3z6FlMpmBFbQ=;
        b=aEdYT6oI+uAOu9UjBKXVmQR4Vqb7G4k23KZ5L2K3v79YnkqWwIWGGGpsdip/no9LKF
         OX6p+BYYQM+OElnkM9nMH0jOpS1lznXRg3lJ6uwuxhXtFofh4fsrAfY8PoByvVgIOv14
         TnBJGNIAxOy63rP8B+4+4uWMpcRLRAsdAJDUbp+llYUTUriz6jRPAyL4AWOccmuIKhOI
         69qZZCmel4W+VjPG+18N18R/0StDr7wRnLfT06tb+/NpzgX2jn1EsTpE4Ls55bXco/k/
         wIf7IpYqEmW72htmBiltvUNLA/eOWjZyVZAxP36v1WUwj5Mh1B+IcLpkSxewV90tvTLs
         HEGg==
In-Reply-To: <YodGI73xq8aIBrNM@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Fri, May 20, 2022 at 12:41 AM Tejun Heo <tj@kernel.org> wrote:
>
> On Fri, May 20, 2022 at 01:21:31AM +0000, Yosry Ahmed wrote:
> > From: Hao Luo <haoluo@google.com>
> >
> > Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
> > iter doesn't iterate a set of kernel objects. Instead, it is supposed to
> > be parameterized by a cgroup id and prints only that cgroup. So one
> > needs to specify a target cgroup id when attaching this iter. The target
> > cgroup's state can be read out via a link of this iter.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>
> This could be me not understanding why it's structured this way but it keeps
> bothering me that this is adding a cgroup iterator which doesn't iterate
> cgroups. If all that's needed is extracting information from a specific
> cgroup, why does this need to be an iterator? e.g. why can't I use
> BPF_PROG_TEST_RUN which looks up the cgroup with the provided ID, flushes
> rstat, retrieves whatever information necessary and returns that as the
> result?

I will let Hao and Yonghong reply here as they have a lot more
context, and they had previous discussions about cgroup_iter. I just
want to say that exposing the stats in a file is extremely convenient
for userspace apps. It becomes very similar to reading stats from
cgroupfs. It also makes migrating cgroup stats that we have
implemented in the kernel to BPF a lot easier.

AFAIK there are also discussions about using overlayfs to have links
to the bpffs files in cgroupfs, which makes it even better. So I would
really prefer keeping the approach we have here of reading stats
through a file from userspace. As for how we go about this (and why a
cgroup iterator doesn't iterate cgroups) I will leave this for Hao and
Yonghong to explain the rationale behind it. Ideally we can keep the
same functionality under a more descriptive name/type.

>
> Thanks.
>
> --
> tejun
