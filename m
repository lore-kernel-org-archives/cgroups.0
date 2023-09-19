From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 1/5] cgroup: Enable task_under_cgroup_hierarchy()
 on cgroup1
Date: Tue, 19 Sep 2023 13:42:57 +0800
Message-ID: <CALOAHbBD32gk5ztVBfXoM+mVWXeXre2Pma6Lvk0BZuvQQtAQ0Q@mail.gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com> <20230903142800.3870-2-laoar.shao@gmail.com>
 <ysajseo5a5dashpz4dtkdpthtdww4m6wpgtgpakbtlbqoy7cvg@53fx3pou6hrl>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695102214; x=1695707014; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjesQVNT+DryUaqUKb0b5eBDwkWp5Kc/txf22mT/W50=;
        b=ByU+hHD2ibDMiavw4fx/O70zZc6sLQPLvAG/Y8jMEeH/YjzVmYjqHLCv6/dPI5bEoT
         V6ujSVCHrP89biolx2TDZ963j60/GP3unO1c4k9MNb52z1eL+DTdXMKlFzrfcnMKUV5w
         i9Vf5QKXrmGF5/WqBOPl0BkaImpcPB+Q+/dKsh83BybcAj4crOPFlSizsxkVPCOmmL+R
         ncKE5QIyIhuc1irLwu+ugyOtv1SJYJvc0TAgkFSOqwMDQGNfPw+g/bWtpROsbc9nklNb
         OLnh5McSaqdYeMK/AxYW4LHQ+culH7ZZXPMngxc6J9doZ7aqqQkxVmop2yk7r4vli0We
         Krxw==
In-Reply-To: <ysajseo5a5dashpz4dtkdpthtdww4m6wpgtgpakbtlbqoy7cvg@53fx3pou6hrl>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Sep 18, 2023 at 10:45=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.c=
om> wrote:
>
> On Sun, Sep 03, 2023 at 02:27:56PM +0000, Yafang Shao <laoar.shao@gmail.c=
om> wrote:
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
>
> This loop were better an iteration over cset->cgrp_links to handle any
> v1 hierarchy (under css_set_lock :-/).

Agree. That is better.

>
> > +             if (!ancestor->subsys[ssid])
> > +                     continue;
> >
> > -     return cgroup_is_descendant(cset->dfl_cgrp, ancestor);
> > +             cgrp =3D task_css(task, ssid)->cgroup;
>
> Does this pass on a lockdep-enabled kernel?

Yes, the lockdep is enabled.

>
> See conditions in task_css_set_check(), it seems at least RCU read lock
> would be needed (if not going through cgrp_links mentioned above).

All the call sites of it are already under RCU protection, so we don't
need to explicitly set RCU read lock here.

--=20
Regards
Yafang
