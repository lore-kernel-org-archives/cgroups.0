From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH bpf-next v1 5/5] bpf: add a selftest for cgroup
 hierarchical stats collection
Date: Fri, 3 Jun 2022 12:52:27 -0700
Message-ID: <CAJD7tkYwU5dW9Oof+pC81R9Bi-F=-EuiXpTn+HDeqbhTOTCcuw@mail.gmail.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-6-yosryahmed@google.com> <20220603162339.GA25043@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=75r9OCRaKxDbstDb8Q6rmHNx4VG7/Ol3FIsxmmQpCKE=;
        b=OFS10OD5jepWzQUQgDwqO+/YoB6ZmGdD0wKjnuqRWMntCfyc/zl6FJU7+8IfeQ28pE
         xXfqBHZknnzrk9L1ttKK0MWceb5jWsOOQGLBa0wl39d8rGlcGwBUk2ZanvmgXNAtJyZr
         60Sf9V22ufhliS6cH9dvm+s6oX7B+irq5RWBwlaMWJ4Xko5YT9bz2OEzwuwSJ7i+fw0Z
         HR7HtVHJFw3Nj/n/X/vSCH6u1nQYW0Y81pb2f61wqTFPRYwQMCGNLv7vUeDBbRKT3Ig5
         +QjBWVhxJyQFtQQtDtDUdoy97HliJNHK5A1yPoWyiD/mzBH/EmKmZkHNRagT44RS6jjS
         ZZEw==
In-Reply-To: <20220603162339.GA25043@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>

Thanks for taking a look at this!

On Fri, Jun 3, 2022 at 9:23 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> On Fri, May 20, 2022 at 01:21:33AM +0000, Yosry Ahmed <yosryahmed@google.=
com> wrote:
> > +#define CGROUP_PATH(p, n) {.name =3D #n, .path =3D #p"/"#n}
> > +
> > +static struct {
> > +     const char *name, *path;
>
> Please unify the order of path and name with the macro (slightly
> confusing ;-).

Totally agree, will do.

>
> > +SEC("tp_btf/mm_vmscan_memcg_reclaim_end")
> > +int BPF_PROG(vmscan_end, struct lruvec *lruvec, struct scan_control *s=
c)
> > +{
> > [...]
> > +     struct cgroup *cgrp =3D task_memcg(current);
> > [...]
> > +     /* cgrp may not have memory controller enabled */
> > +     if (!cgrp)
> > +             return 0;
>
> Yes, the controller may not be enabled (for a cgroup).
> Just noting that the task_memcg() implementation will fall back to
> root_mem_cgroup in such a case (or nearest ancestor), you may want to
> use cgroup_ss_mask() for proper detection.

Good catch. I get confused between cgrp->subsys and
task->cgroups->subsys sometimes because of different fallback
behavior. IIUC cgrp->subsys should have NULL if the memory controller
is not enabled (no nearest ancestor fallback), and hence I can use
memory_subsys_enabled() that I defined just above task_memcg() to test
for this (I have no idea why I am not already using it here). Is my
understanding correct?

>
> Regards,
> Michal
