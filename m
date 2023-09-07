From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 1/5] cgroup: Enable task_under_cgroup_hierarchy()
 on cgroup1
Date: Thu, 7 Sep 2023 11:05:07 +0800
Message-ID: <CALOAHbA7gDFh5Bsr_99-rBa3h9dZw6ntF_+RxTjfK3yQXpYEFA@mail.gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com> <20230903142800.3870-2-laoar.shao@gmail.com>
 <ZPjdc3IwX9gjXk_F@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694055944; x=1694660744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q5MIjMQMX2WC54VYKndKY8gzL7KZXv1MaBOxpFihvKs=;
        b=MUYRNsvkgRvNLbNezytyfB57g8aQ/7Wj3l8H3BncrFl4yqp58NciPyzd/ezHwXtfHh
         AaJ0x7ZvrDbUoAZN6edODI8ko1sksufQ5v8DzA0PU2b2j3+oIW4v+5DQBZZHrqSDv/yX
         MVpVh4zbSHcq6iAva5Zn2r1Ih+Cxqk6YD20zBJaNR1+AOqwsHkfjrotJDfoQU4caiMsr
         7yvRbkI+LnSWK8ISsm1z2DVe0icdZoCyM9phYV7Y14+AUx9Q3GtCrF6eRmlEtm9yfgHB
         tzbZlncAimHKYP1yiLwWCNZ9GKEwLmKSYz3wIeowG8Pv/Xst2FXnzDqBTQmoVkD7vqXD
         XTKw==
In-Reply-To: <ZPjdc3IwX9gjXk_F-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 7, 2023 at 4:13=E2=80=AFAM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Sun, Sep 03, 2023 at 02:27:56PM +0000, Yafang Shao wrote:
> >  static inline bool task_under_cgroup_hierarchy(struct task_struct *tas=
k,
> >                                              struct cgroup *ancestor)
> >  {
> >       struct css_set *cset =3D task_css_set(task);
> > +     struct cgroup *cgrp;
> > +     bool ret =3D false;
> > +     int ssid;
> > +
> > +     if (ancestor->root =3D=3D &cgrp_dfl_root)
> > +             return cgroup_is_descendant(cset->dfl_cgrp, ancestor);
> > +
> > +     for (ssid =3D 0; ssid < CGROUP_SUBSYS_COUNT; ssid++) {
> > +             if (!ancestor->subsys[ssid])
> > +                     continue;
> >
> > -     return cgroup_is_descendant(cset->dfl_cgrp, ancestor);
> > +             cgrp =3D task_css(task, ssid)->cgroup;
> > +             if (!cgrp)
> > +                     continue;
> > +
> > +             if (!cgroup_is_descendant(cgrp, ancestor))
> > +                     return false;
> > +             if (!ret)
> > +                     ret =3D true;
> > +     }
> > +     return ret;
>
> I feel ambivalent about adding support for this in cgroup1 especially giv=
en
> that this can only work for fd based interface which is worse than the ID
> based ones.

The fd-based cgroup interface plays a crucial role in BPF programs,
particularly in components such as cgroup_iter, bpf_cgrp_storage, and
cgroup_array maps, as well as in the attachment and detachment of
cgroups.

However, it's important to note that as far as my knowledge goes,
bpf_cgrp_storage, cgroup_array, and the attachment/detachment of
cgroups are exclusively compatible with the cgroup fd-based interface.
Unfortunately, all these functionalities are limited to cgroup2, which
poses challenges in containerized environments.

In our pursuit of enabling seamless BPF integration within our
Kubernetes environment, we've been exploring the possibility of
transitioning from cgroup1 to cgroup2. This transition, while
desirable for its future-forward nature, presents complexities due to
the need for numerous applications to adapt.

We acknowledge that cgroup2 represents the future, but we also
understand that such transitions require time and effort.
Consequently, we are considering an alternative approach. Rather than
migrating to cgroup2, we are contemplating modifications to the BPF
kernel code to ensure compatibility with cgroup1. Moreover, it appears
that these modifications may entail only minor adjustments, making
this option more palatable.

> Even if we're doing this, the above is definitely not what we
> want to do as it won't work for controller-less hierarchies like the one
> that systemd used to use.

Right. It can't work for /sys/fs/cgroup/systemd/.

> You'd have to lock css_set_lock and walk the
> cgpr_cset_links.

That seems better. Will investigate it.  Thanks for your suggestion.
