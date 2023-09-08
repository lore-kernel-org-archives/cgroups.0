From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on cgroup1
Date: Fri, 8 Sep 2023 10:53:21 +0800
Message-ID: <CALOAHbB-PF1LjSAxoCdePN6Va4D+ufkeDmq8s3b0AGtfX5E-cQ@mail.gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com> <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694141638; x=1694746438; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6fop6ayCaKn3gScpGY1wXrhdJ9eTL5GofQSvvTxRa8=;
        b=YjGUp47ubnuHNEql8yabyWdBhcpWbv+5y9GaZTP3BrgXlATKK+saBPEp2ojtWcx4Wk
         MEvVITgoyrjA+BRN0JzO60IekE0WKt8OFX1+mG6L3RZTYa/yLkcviCf6jbSokf5/TfPs
         X2U3hRKTrhVnsGdFho/4EBWhRBbGkJw9Y9OJ2EgQsaxyBJcYebBNIl5D3HMd2j1SR+XO
         1hzsUqCZ8BsI7aIQdsCdUuWGXaFO9ASMdqEHknceGBQN6lciQJJgBAHCWEtGFzXS9h3J
         3xydvI9TvE2qjuGFeeF1DDUXSwP5dhD2odwYgr/Co4GO+O+pwZ/Yqavd2K2HW2ycXeHA
         4G9w==
In-Reply-To: <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 7, 2023 at 10:41=E2=80=AFPM Michal Koutn=C3=BD <mkoutny-WDPRK7U/wSs@public.gmane.org=
m> wrote:
>
> Hello Yafang.
>
> On Sun, Sep 03, 2023 at 02:27:55PM +0000, Yafang Shao <laoar.shao@gmail.c=
om> wrote:
> > In our specific use case, we intend to use bpf_current_under_cgroup() t=
o
> > audit whether the current task resides within specific containers.
>
> I wonder -- how does this work in practice?

In our practice, the cgroup_array map serves as a shared map utilized
by both our LSM programs and the target pods. as follows,

    ----------------
    | target pod |
    ----------------
           |
           |
          V                                      ----------------
 /sys/fs/bpf/cgoup_array     <--- | LSM progs|
                                                  ----------------

Within the target pods, we employ a script to update its cgroup file
descriptor into the cgroup_array, for instance:

    cgrp_fd =3D open("/sys/fs/cgroup/cpu");
    cgrp_map_fd =3D bpf_obj_get("/sys/fs/bpf/cgroup_array");
    bpf_map_update_elem(cgrp_map_fd, &app_idx, &cgrp_fd, 0);

Next, we will validate the contents of the cgroup_array within our LSM
programs, as follows:

     if (!bpf_current_task_under_cgroup(&cgroup_array, app_idx))
            return -1;

Within our Kubernetes deployment system, we will inject this script
into the target pods only if specific annotations, such as
"bpf_audit," are present. Consequently, users do not need to manually
modify their code; this process will be handled automatically.

Within our Kubernetes environment, there is only a single instance of
these target pods on each host. Consequently, we can conveniently
utilize the array index as the application ID. However, in scenarios
where you have multiple instances running on a single host, you will
need to manage the mapping of instances to array indexes
independently. For cases with multiple instances, a cgroup_hash may be
a more suitable approach, although that is a separate discussion
altogether.

>
> If it's systemd hybrid setup, you can get the information from the
> unified hierarchy which represents the container membership.
>
> If it's a setup without the unified hierarchy, you have to pick one
> hieararchy as a representation of the membership. Which one will it be?

We utilize the CPU subsystem, and all of our pods have this cgroup
subsystem enabled.

>
> > Subsequently, we can use this information to create distinct ACLs withi=
n
> > our LSM BPF programs, enabling us to control specific operations perfor=
med
> > by these tasks.
>
> If one was serious about container-based ACLs, it'd be best to have a
> dedicated and maintained hierarchy for this (I mean a named v1
> hiearchy). But your implementation omits this, so this hints to me that
> this scenario may already be better covered with querying the unified
> hierarchy.
>
> > Considering the widespread use of cgroup1 in container environments,
> > coupled with the considerable time it will take to transition to cgroup=
2,
> > implementing this change will significantly enhance the utility of BPF
> > in container scenarios.
>
> If a change like this is not accepted, will it make the transition
> period shorter? (As written above, the unified hierarchy seems a better
> fit for your use case.)

If that change is not accepted by upstream, we will need to
independently manage and maintain it within our local kernel :(

--=20
Regards
Yafang
