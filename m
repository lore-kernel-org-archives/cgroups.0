From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on cgroup1
Date: Fri, 8 Sep 2023 11:09:03 -0700
Message-ID: <CAADnVQL+6PsRbNMo=8kJpgw1OTbdLG9epsup0q7La5Ffqj6g6A@mail.gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com> <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
 <CALOAHbB-PF1LjSAxoCdePN6Va4D+ufkeDmq8s3b0AGtfX5E-cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694196555; x=1694801355; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyPYK0w69+g1akkDzeNAWRhnsMpPNgkPja8VOvx5ZAo=;
        b=d9JRdGQ58w6J1Evf2LP9ayMZ5BPwN+ugHJ9lnGTSwuI+upsMZbzs1H2IR4WqYXGNMA
         QGPJR47Vbi8FUwH/OLfINGOr/8T69Jh6Lou3iBsYkKKeFB7i5DH8xdHG7JXhDBu26tQ5
         GFbgqUahoRrEz+w3amIR4kPiuIZ1gHimAnycSKkTBlbIsvdmGYilyG5V7E+zao+wYmBU
         fLkJANKX1ivtnNRWXxdz0tMai6CLJw4j/vELzREzL2m96myB+Mqw0XxF3LaWQJ4qQ3Xp
         hmYqhdS2dk+eO2l8Hy81GM7rPD6MXt8ex/crEwCWeAd4PkwXEQODLmhWUsTKg5B945wp
         j2xA==
In-Reply-To: <CALOAHbB-PF1LjSAxoCdePN6Va4D+ufkeDmq8s3b0AGtfX5E-cQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Song Liu <song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonghong Song <yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jiri Olsa <jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 7, 2023 at 7:54=E2=80=AFPM Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>
> On Thu, Sep 7, 2023 at 10:41=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.=
com> wrote:
> >
> > Hello Yafang.
> >
> > On Sun, Sep 03, 2023 at 02:27:55PM +0000, Yafang Shao <laoar.shao@gmail=
.com> wrote:
> > > In our specific use case, we intend to use bpf_current_under_cgroup()=
 to
> > > audit whether the current task resides within specific containers.
> >
> > I wonder -- how does this work in practice?
>
> In our practice, the cgroup_array map serves as a shared map utilized
> by both our LSM programs and the target pods. as follows,
>
>     ----------------
>     | target pod |
>     ----------------
>            |
>            |
>           V                                      ----------------
>  /sys/fs/bpf/cgoup_array     <--- | LSM progs|
>                                                   ----------------
>
> Within the target pods, we employ a script to update its cgroup file
> descriptor into the cgroup_array, for instance:
>
>     cgrp_fd =3D open("/sys/fs/cgroup/cpu");
>     cgrp_map_fd =3D bpf_obj_get("/sys/fs/bpf/cgroup_array");
>     bpf_map_update_elem(cgrp_map_fd, &app_idx, &cgrp_fd, 0);
>
> Next, we will validate the contents of the cgroup_array within our LSM
> programs, as follows:
>
>      if (!bpf_current_task_under_cgroup(&cgroup_array, app_idx))
>             return -1;
>
> Within our Kubernetes deployment system, we will inject this script
> into the target pods only if specific annotations, such as
> "bpf_audit," are present. Consequently, users do not need to manually
> modify their code; this process will be handled automatically.
>
> Within our Kubernetes environment, there is only a single instance of
> these target pods on each host. Consequently, we can conveniently
> utilize the array index as the application ID. However, in scenarios
> where you have multiple instances running on a single host, you will
> need to manage the mapping of instances to array indexes
> independently. For cases with multiple instances, a cgroup_hash may be
> a more suitable approach, although that is a separate discussion
> altogether.

Is there a reason you cannot use bpf_get_current_cgroup_id()
to associate task with cgroup in your lsm prog?
