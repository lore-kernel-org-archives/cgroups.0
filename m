From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v7 4/8] bpf: Introduce cgroup iter
Date: Tue, 9 Aug 2022 11:38:32 -0700
Message-ID: <CA+khW7j0kzP+W_Qgsim52J+HeR27XJcyMk73Hq93tsmNzT7q6w@mail.gmail.com>
References: <20220805214821.1058337-1-haoluo@google.com> <20220805214821.1058337-5-haoluo@google.com>
 <CAEf4BzZHf89Ds8nQWFCH00fKs9-9GkJ0d+Hrp-LkMCDUP_td0A@mail.gmail.com>
 <CA+khW7hUVOkHBO3dhRze2_VKZuxD-LuNQdO3nHUkLCYmuuR6eg@mail.gmail.com> <20220809162325.hwgvys5n3rivuz7a@MacBook-Pro-3.local.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=W39UTjuGL/i3nw+dgDx0+fMLYroO0xsXKyyQ9sO3qfs=;
        b=Fm5fnpQkRBDixj266mJEDjoI5meQ1E60sTmfOsHyY4gHXSPI47WK21mPv188hkdsBc
         1D4TqzxCqwoLkifQFTRkJW0CYED+uXT5c8xuxNC1L52e+xaIjanzU9IqE0lbAHCb7J2/
         c4D622uQsla/OWEOaDBGBLVELPWHUKcAbfKsBMFVJzYbc7DdCkDcN30dU/x0nBfoZZqP
         qOpFVPntPIQ140a5/hXtOFv0p1SE86EJi+UCbpZPFjopffVvfr9bwa1vVrgkZXSCpQqF
         zy8+xUOGIBZuCbUaq9a9ce80kCe0wK5TguviBzveJ9mxc7tNKCMigHVnDp9JUlUoYPkh
         sAHA==
In-Reply-To: <20220809162325.hwgvys5n3rivuz7a-jF64zX8BO08BydtbVO78Drd0WIQ+yoj+OALrfG0m2K3XEBQpfjiOIg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrii Nakryiko <andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Koutny <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf@goog>

On Tue, Aug 9, 2022 at 9:23 AM Alexei Starovoitov
<alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Mon, Aug 08, 2022 at 05:56:57PM -0700, Hao Luo wrote:
> > On Mon, Aug 8, 2022 at 5:19 PM Andrii Nakryiko
> > <andrii.nakryiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > On Fri, Aug 5, 2022 at 2:49 PM Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > >
> > > > Cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> > > >
> > > >  - walking a cgroup's descendants in pre-order.
> > > >  - walking a cgroup's descendants in post-order.
> > > >  - walking a cgroup's ancestors.
> > > >  - process only the given cgroup.
> > > >
[...]
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index 59a217ca2dfd..4d758b2e70d6 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -87,10 +87,37 @@ struct bpf_cgroup_storage_key {
> > > >         __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
> > > >  };
> > > >
> > > > +enum bpf_iter_order {
> > > > +       BPF_ITER_ORDER_DEFAULT = 0,     /* default order. */
> > >
> > > why is this default order necessary? It just adds confusion (I had to
> > > look up source code to know what is default order). I might have
> > > missed some discussion, so if there is some very good reason, then
> > > please document this in commit message. But I'd rather not do some
> > > magical default order instead. We can set 0 to mean invalid and error
> > > out, or just do SELF as the very first value (and if user forgot to
> > > specify more fancy mode, they hopefully will quickly discover this in
> > > their testing).
> > >
> >
> > PRE/POST/UP are tree-specific orders. SELF applies on all iters and
> > yields only a single object. How does task_iter express a non-self
> > order? By non-self, I mean something like "I don't care about the
> > order, just scan _all_ the objects". And this "don't care" order, IMO,
> > may be the common case. I don't think everyone cares about walking
> > order for tasks. The DEFAULT is intentionally put at the first value,
> > so that if users don't care about order, they don't have to specify
> > this field.
> >
> > If that sounds valid, maybe using "UNSPEC" instead of "DEFAULT" is better?
>
> I agree with Andrii.
> This:
> +       if (order == BPF_ITER_ORDER_DEFAULT)
> +               order = BPF_ITER_DESCENDANTS_PRE;
>
> looks like an arbitrary choice.
> imo
> BPF_ITER_DESCENDANTS_PRE = 0,
> would have been more obvious. No need to dig into definition of "default".
>
> UNSPEC = 0
> is fine too if we want user to always be conscious about the order
> and the kernel will error if that field is not initialized.
> That would be my preference, since it will match the rest of uapi/bpf.h
>

Sounds good. In the next version, will use

enum bpf_iter_order {
        BPF_ITER_ORDER_UNSPEC = 0,
        BPF_ITER_SELF_ONLY,             /* process only a single object. */
        BPF_ITER_DESCENDANTS_PRE,       /* walk descendants in pre-order. */
        BPF_ITER_DESCENDANTS_POST,      /* walk descendants in post-order. */
        BPF_ITER_ANCESTORS_UP,          /* walk ancestors upward. */
};

and explicitly list the values acceptable by cgroup_iter, error out if
UNSPEC is detected.

Also, following Andrii's comments, will change BPF_ITER_SELF to
BPF_ITER_SELF_ONLY, which does seem a little bit explicit in
comparison.

> I applied the first 3 patches to ease respin.

Thanks! This helps!

> Thanks!
