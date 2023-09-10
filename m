From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on cgroup1
Date: Sun, 10 Sep 2023 11:17:48 +0800
Message-ID: <CALOAHbBhOL9w+rnh_xkgZZBhxMpbrmLZWhm1X+ZeDLfxxt8Nrw@mail.gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com> <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
 <CALOAHbB-PF1LjSAxoCdePN6Va4D+ufkeDmq8s3b0AGtfX5E-cQ@mail.gmail.com> <CAADnVQL+6PsRbNMo=8kJpgw1OTbdLG9epsup0q7La5Ffqj6g6A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf+bounces-9605-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694315904; x=1694920704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ApgFfZbO2xc5gBkfPKoQgyDazIhEPSRO3D15FUVXbcg=;
        b=dymO8/jz8Gm6xMpiLmKNgne1T1oX63DLL01ty0rhEjkxHcy6dh4pr/Ysct+TbXCUrh
         HIe0EvkO+js30kZWsSP55kycI2ex8YkuG3v1a271snWgyDkQ+U9tL9ig83FaGkKtyaeF
         14abU4X7eS4vqwsUyfSx8mAVhPljNslwY5MnnWbHIksgjEG8tkdXS2afEusExDyVZUBu
         cys4NkooP3t7KBFsK8jsjY3kMEgEPyQmQv/2dcjoYWfZmEPoCcZLg9fSjxSPOhIQ9GFX
         tB1w3AtGZJ078DXpd5rlX94UsZuthTQUpxGiDHxuUp/URH3IDOecAj+FDFAmaRNv7ydO
         HlMw==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
In-Reply-To: <CAADnVQL+6PsRbNMo=8kJpgw1OTbdLG9epsup0q7La5Ffqj6g6A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Sat, Sep 9, 2023 at 2:09=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Sep 7, 2023 at 7:54=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > On Thu, Sep 7, 2023 at 10:41=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@sus=
e.com> wrote:
> > >
> > > Hello Yafang.
> > >
> > > On Sun, Sep 03, 2023 at 02:27:55PM +0000, Yafang Shao <laoar.shao@gma=
il.com> wrote:
> > > > In our specific use case, we intend to use bpf_current_under_cgroup=
() to
> > > > audit whether the current task resides within specific containers.
> > >
> > > I wonder -- how does this work in practice?
> >
> > In our practice, the cgroup_array map serves as a shared map utilized
> > by both our LSM programs and the target pods. as follows,
> >
> >     ----------------
> >     | target pod |
> >     ----------------
> >            |
> >            |
> >           V                                      ----------------
> >  /sys/fs/bpf/cgoup_array     <--- | LSM progs|
> >                                                   ----------------
> >
> > Within the target pods, we employ a script to update its cgroup file
> > descriptor into the cgroup_array, for instance:
> >
> >     cgrp_fd =3D open("/sys/fs/cgroup/cpu");
> >     cgrp_map_fd =3D bpf_obj_get("/sys/fs/bpf/cgroup_array");
> >     bpf_map_update_elem(cgrp_map_fd, &app_idx, &cgrp_fd, 0);
> >
> > Next, we will validate the contents of the cgroup_array within our LSM
> > programs, as follows:
> >
> >      if (!bpf_current_task_under_cgroup(&cgroup_array, app_idx))
> >             return -1;
> >
> > Within our Kubernetes deployment system, we will inject this script
> > into the target pods only if specific annotations, such as
> > "bpf_audit," are present. Consequently, users do not need to manually
> > modify their code; this process will be handled automatically.
> >
> > Within our Kubernetes environment, there is only a single instance of
> > these target pods on each host. Consequently, we can conveniently
> > utilize the array index as the application ID. However, in scenarios
> > where you have multiple instances running on a single host, you will
> > need to manage the mapping of instances to array indexes
> > independently. For cases with multiple instances, a cgroup_hash may be
> > a more suitable approach, although that is a separate discussion
> > altogether.
>
> Is there a reason you cannot use bpf_get_current_cgroup_id()
> to associate task with cgroup in your lsm prog?

Using cgroup_id as the key serves as a temporary workaround;
nevertheless, employing bpf_get_current_cgroup_id() is impractical due
to its exclusive support for cgroup2.

To acquire the cgroup_id, we can resort to open coding, as exemplified belo=
w:

    task =3D bpf_get_current_task_btf();
    cgroups =3D task->cgroups;
    cgroup =3D cgroups->subsys[cpu_cgrp_id]->cgroup;
    key =3D cgroup->kn->id;

Nonetheless, creating an open-coded version of
bpf_get_current_ancestor_cgroup_id() is unfeasible since the BPF
verifier prohibits access to "cgrp->ancestors[ancestor_level]."

--
Regards

Yafang

