From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Date: Thu, 28 Jul 2022 10:20:46 -0700
Message-ID: <CA+khW7gfzoeHVd5coTSWXuYVfqiVMwoSjXkWsP-CeVdmOm0FqA@mail.gmail.com>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com> <YuK+eg3lgwJ2CJnJ@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VW7oYK4RqwqbJsASlxdjRV3NEVCTNvlDrSDTg61QkOg=;
        b=h8FxtRKKQHF4SZtxhuJuCSHn3CxIjnLxoANRs2Qd79XyLUdqOiqvCZ0nf/TljQOJoz
         7Uyovrfff5RQt4y3dHNonwXKvY7FZUnDtoRHS7lWjuK8E6idQMKrJMS4QFSzUEZF4m66
         TzgFuIxGVMtfqQ0hB1NxW5AKLb+TvhCtZrfm9cueT8LxtqQg9su+cN3ghlP+T2lVpLdI
         ORveshtJMkLA+6KRzWshwGMkPKwKHyh+tpsCEeMexuP4mlBxfIufMDal02TfyaOgJefJ
         /BB58eusHQOE/4dQDk/11j96eQxmE3KTRG8BmpQQQX33x3W6J0jhBI98b3UHF00rtHXj
         TKrg==
In-Reply-To: <YuK+eg3lgwJ2CJnJ-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi Tejun,

On Thu, Jul 28, 2022 at 9:51 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Fri, Jul 22, 2022 at 05:48:25PM +0000, Yosry Ahmed wrote:
> > +
> > +     /* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> > +      * ancestors of a given cgroup.
> > +      */
> > +     struct {
> > +             /* Cgroup file descriptor. This is root of the subtree if walking
> > +              * descendants; it's the starting cgroup if walking the ancestors.
> > +              * If it is left 0, the traversal starts from the default cgroup v2
> > +              * root. For walking v1 hierarchy, one should always explicitly
> > +              * specify the cgroup_fd.
> > +              */
> > +             __u32   cgroup_fd;
>
> So, we're identifying the starting point with an fd.
>
> > +             __u32   traversal_order;
> > +     } cgroup;
> >  };
> >
> >  /* BPF syscall commands, see bpf(2) man-page for more details. */
> > @@ -6136,6 +6156,16 @@ struct bpf_link_info {
> >                                       __u32 map_id;
> >                               } map;
> >                       };
> > +                     union {
> > +                             struct {
> > +                                     __u64 cgroup_id;
> > +                                     __u32 traversal_order;
> > +                             } cgroup;
>
> but iterating the IDs. IDs are the better choice for cgroup2 as there's
> nothing specific to the calling program or the fds it has, but I guess this
> is because you want to use it for cgroup1, right? Oh well, that's okay I
> guess.
>

Yes, we are identifying the starting point with FD. The cgroup_id here
is the information reported from kernel to userspace for identifying
the cgroup.

We use FD because it is a convention in BPF. Compatibility of cgroup1
is a good feature of this convention. My thoughts: It seems that ID
may be better, for two reasons. First, because ID is stateless, the
userspace doesn't have to remember closing the FD. Second, using
different identifications in two directions (userspace specifies
cgroup using FD, while kernel reports cgroup using ID) introduces a
little complexity when connecting them together.

Hao

> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks.
>
> --
> tejun
