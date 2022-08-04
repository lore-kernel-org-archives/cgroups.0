From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v6 4/8] bpf: Introduce cgroup iter
Date: Wed, 3 Aug 2022 17:18:25 -0700
Message-ID: <CA+khW7hSFU2YL+jNw2F2qsuYEW0E6r8kJkg1BoBukAqR_sk+6Q@mail.gmail.com>
References: <20220801175407.2647869-1-haoluo@google.com> <20220801175407.2647869-5-haoluo@google.com>
 <c018a834-e834-270c-24b1-2c726b38b729@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3To6LMVxoqoKzRmQbA8Jez/sB+9ti+KFrFIpcpqC5DU=;
        b=jaFMYrAr15hi7try/jB5s91PiWR8kMLB484AM76aPEsChXhIBD+lTzzNWQs7YTYffC
         63bFlVKk/ZG9whwY4EzkRsgp56VkFoRTAi46PNFdqCIVS5abYmdTkqyYEfi6IXTHpx52
         NzZEmvnFruMTy2bQtwEpsrjGHOS+HJw3v24rafEiQbLO2WCtUWMg1dTnDoa/wPK7bpPA
         ZDpkYHp29JtKjxj0PdUJYC1hknjlPP/1LBYX8EFh+xET+Qa4YK4rmKgX3RZdhGdwntmC
         Dog0Dn1Z1X7nq0Ponu0M/n1lUbjjAv/lXEId6u+zqwop41RL4jilX4EHM1/wUWqYwks2
         lHug==
In-Reply-To: <c018a834-e834-270c-24b1-2c726b38b729-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Koutny <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yosry Ahmed <yosryahme>

On Wed, Aug 3, 2022 at 12:44 AM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
>
>
>
> On 8/1/22 10:54 AM, Hao Luo wrote:
> > Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
> >
> >   - walking a cgroup's descendants in pre-order.
> >   - walking a cgroup's descendants in post-order.
> >   - walking a cgroup's ancestors.
> >
> > When attaching cgroup_iter, one can set a cgroup to the iter_link
> > created from attaching. This cgroup is passed as a file descriptor and
> > serves as the starting point of the walk. If no cgroup is specified,
> > the starting point will be the root cgroup.
> >
> > For walking descendants, one can specify the order: either pre-order or
> > post-order. For walking ancestors, the walk starts at the specified
> > cgroup and ends at the root.
> >
> > One can also terminate the walk early by returning 1 from the iter
> > program.
> >
> > Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> > program is called with cgroup_mutex held.
> >
> > Currently only one session is supported, which means, depending on the
> > volume of data bpf program intends to send to user space, the number
> > of cgroups that can be walked is limited. For example, given the current
> > buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> > cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> > be walked is 512. This is a limitation of cgroup_iter. If the output
> > data is larger than the buffer size, the second read() will signal
> > EOPNOTSUPP. In order to work around, the user may have to update their
>
> 'the second read() will signal EOPNOTSUPP' is not true. for bpf_iter,
> we have user buffer from read() syscall and kernel buffer. The above
> buffer size like 8 * PAGE_SIZE refers to the kernel buffer size.
>
> If read() syscall buffer size is less than kernel buffer size,
> the second read() will not signal EOPNOTSUPP. So to make it precise,
> we can say
>    If the output data is larger than the kernel buffer size, after
>    all data in the kernel buffer is consumed by user space, the
>    subsequent read() syscall will signal EOPNOTSUPP.
>

Thanks Yonghong. Will update.

> > program to reduce the volume of data sent to output. For example, skip
> > some uninteresting cgroups. In future, we may extend bpf_iter flags to
> > allow customizing buffer size.
> >
> > Acked-by: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
> > Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Signed-off-by: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
[...]
> > + *
> > + * Currently only one session is supported, which means, depending on the
> > + * volume of data bpf program intends to send to user space, the number
> > + * of cgroups that can be walked is limited. For example, given the current
> > + * buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> > + * cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> > + * be walked is 512. This is a limitation of cgroup_iter. If the output data
> > + * is larger than the buffer size, the second read() will signal EOPNOTSUPP.
> > + * In order to work around, the user may have to update their program to
>
> same here as above for better description.
>

SG. Will update.

> > + * reduce the volume of data sent to output. For example, skip some
> > + * uninteresting cgroups.
> > + */
> > +
> > +struct bpf_iter__cgroup {
> > +     __bpf_md_ptr(struct bpf_iter_meta *, meta);
> > +     __bpf_md_ptr(struct cgroup *, cgroup);
> > +};
> > +
> > +struct cgroup_iter_priv {
> > +     struct cgroup_subsys_state *start_css;
> > +     bool visited_all;
> > +     bool terminate;
> > +     int order;
> > +};
> > +
> > +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> > +{
> > +     struct cgroup_iter_priv *p = seq->private;
> > +
> > +     mutex_lock(&cgroup_mutex);
> > +
> > +     /* cgroup_iter doesn't support read across multiple sessions. */
> > +     if (*pos > 0) {
> > +             if (p->visited_all)
> > +                     return NULL;
>
> This looks good. thanks!
>
> > +
> > +             /* Haven't visited all, but because cgroup_mutex has dropped,
> > +              * return -EOPNOTSUPP to indicate incomplete iteration.
> > +              */
> > +             return ERR_PTR(-EOPNOTSUPP);
> > +     }
> > +
> > +     ++*pos;
> > +     p->terminate = false;
> > +     p->visited_all = false;
> > +     if (p->order == BPF_ITER_CGROUP_PRE)
> > +             return css_next_descendant_pre(NULL, p->start_css);
> > +     else if (p->order == BPF_ITER_CGROUP_POST)
> > +             return css_next_descendant_post(NULL, p->start_css);
> > +     else /* BPF_ITER_CGROUP_PARENT_UP */
> > +             return p->start_css;
> > +}
> > +
> [...]
