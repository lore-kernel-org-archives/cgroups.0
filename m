From: Hao Luo <haoluo@google.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 14:49:45 -0700
Message-ID: <CA+khW7iDDkO3h5WQixEA=nUL-tBmCTh7fMAf3iwNy98UfM-k9g@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com> <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org> <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org> <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p5lqA4V2Z2dTb6TSdgJsb3QItFMtbNECXgovUnmle3Y=;
        b=kS4vFnX94EFG9U4QcDfkpXRrX2RNEKg6t5fFXIM1d4BF31cv67BKOWBC2/lKKWdWbn
         eAiIo+bdJTHT1tFbHYiYmgVpOrVsoU4ftSDk7vordIX8o06a1mV0wVr6JDtOc50c47Y+
         0GLRmWg6ZMMrDP/lrewoqr2ZIF//PQqiqRIMWoBfc+gkgSVLmF7StWfErdeSzc8IStzs
         Dpqt3hNNZFs1UiH/n2pe0dgtzveVE5rAsr/WcqdlXXfiGC9hLiZaINDKyifpLvdtlCUs
         BuqqQ6VdPyyv9LSKYr3Orpz88v4ptMLSyEV3N8jFFGfKGlpEvQiPEU6RQs+WPn2sulTo
         CTKg==
In-Reply-To: <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Yonghong Song <yhs@fb.com>, Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@v>

Hi Tejun and Yonghong,

On Fri, May 20, 2022 at 12:42 PM Hao Luo <haoluo@google.com> wrote:
>
> Hi Tejun and Yonghong,
>
> On Fri, May 20, 2022 at 9:45 AM Tejun Heo <tj@kernel.org> wrote:
> > On Fri, May 20, 2022 at 09:29:43AM -0700, Yonghong Song wrote:
> > >    <various stats interested by the user>
> > >
> > > This way, user space can easily construct the cgroup hierarchy stat like
> > >                            cpu   mem   cpu pressure   mem pressure ...
> > >    cgroup1                 ...
> > >       child1               ...
> > >         grandchild1        ...
> > >       child2               ...
> > >    cgroup 2                ...
> > >       child 3              ...
> > >         ...                ...
> > >
> > > the bpf iterator can have additional parameter like
> > > cgroup_id = ... to only call bpf program once with that
> > > cgroup_id if specified.
>
> Yep, this should work. We just need to make the cgroup_id parameter
> optional. If it is specified when creating bpf_iter_link, we print for
> that cgroup only. If it is not specified, we iterate over all cgroups.
> If I understand correctly, sounds doable.
>

Yonghong, I realized that seek() which Tejun has been calling out, can
be used to specify the target cgroup, rather than adding a new
parameter. Maybe, we can pass cgroup_id to seek() on cgroup bpf_iter,
which will instruct read() to return the corresponding cgroup's stats.
On the other hand, reading without calling seek() beforehand will
return all the cgroups.

WDYT?
