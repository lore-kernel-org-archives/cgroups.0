From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on cgroup1
Date: Tue, 12 Sep 2023 11:30:32 +0800
Message-ID: <CALOAHbC=yxSoBR=vok2295ejDOEYQK2C8LRjDLGRruhq-rDjOQ@mail.gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com> <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
 <CALOAHbB-PF1LjSAxoCdePN6Va4D+ufkeDmq8s3b0AGtfX5E-cQ@mail.gmail.com>
 <CAADnVQL+6PsRbNMo=8kJpgw1OTbdLG9epsup0q7La5Ffqj6g6A@mail.gmail.com>
 <CALOAHbBhOL9w+rnh_xkgZZBhxMpbrmLZWhm1X+ZeDLfxxt8Nrw@mail.gmail.com> <ZP93gUwf_nLzDvM5@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf+bounces-9701-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694489468; x=1695094268; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9MZeZdeugBm4QxzIOrMKsGdKzrnk2bLq8bYUX0Gqf/Q=;
        b=eA59svIddRb5g3UiAPLSKDHjTiive/NSqInb2nNRW53/uWBgREnFN/qsoj1i5uf9Fn
         VaEa0fdUFEFg5AVdnxgtfv4arWNhp9bka2B3V9pekddbvkxBgLCECLAT6+ZbMpVIOVih
         UBvNgPUb1/FvyxKmeh7NdaoeuApfWm3aV6G4bJYZnnXHS8/qHySaa0cLERux5SycLBeI
         13pvyVH9sVOEhoNdyHRVCBDr5ri9cqx+retO7AzCNJYVgcagp79okWaMM0TXx31pk4c0
         zfdCv/cLM4UmZMFLAnYkmwDw/IMzRWIlKNsOYpkgvkQZmh6+qxQ22bM3f2bzAprFjtnF
         uWcA==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
In-Reply-To: <ZP93gUwf_nLzDvM5@mtj.duckdns.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Tue, Sep 12, 2023 at 4:24=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> On Sun, Sep 10, 2023 at 11:17:48AM +0800, Yafang Shao wrote:
> > To acquire the cgroup_id, we can resort to open coding, as exemplified =
below:
> >
> >     task =3D bpf_get_current_task_btf();
> >     cgroups =3D task->cgroups;
> >     cgroup =3D cgroups->subsys[cpu_cgrp_id]->cgroup;
> >     key =3D cgroup->kn->id;
>
> You can't hardcode it to a specific controller tree like that. You either
> stick with fd based interface or need also add something to identify the
> specifc cgroup1 tree.

As pointed out by Alexei, I think we can introduce some
cgroup_id-based kfuncs which can work for both cgroup1 and cgroup2.

Something as follows (untested),

__bpf_kfunc u64 bpf_current_cgroup_id_from_subsys(int subsys)
{
        struct cgroup *cgroup;

        cgroup =3D task_cgroup(current, subsys);
        if (!cgroup)
            return 0;
        return cgroup_id(cgroup);
}

__bpf_kfunc struct cgroup *bpf_cgroup_from_subsys_id(u64 cgid, int subsys)
{
        struct cgroup_subsys_state *css =3D init_css_set.subsys[subsys];
        struct cgroup *subsys_root =3D css->cgroup;

        // We should introduce a new helper cgroup_get_from_subsys_id()
        // in the cgroup subsystem.
        return cgroup_get_from_subsys_id(subsys_root, cgid);
}

And change task_under_cgroup_hierarchy() as follows,

 static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
                                               struct cgroup *ancestor)
 {
        struct css_set *cset =3D task_css_set(task);
-
-       return cgroup_is_descendant(cset->dfl_cgrp, ancestor);
+       struct cgroup *cgrp;
+       bool ret =3D false;
+
+       if (ancestor->root =3D=3D &cgrp_dfl_root)
+               return cgroup_is_descendant(cset->dfl_cgrp, ancestor);
+
+       cgroup_lock();
+       spin_lock_irq(&css_set_lock);
+       cgrp =3D task_cgroup_from_root(task, ancestor->root);
+       if (cgrp && cgroup_is_descendant(cgrp, ancestor))
+               ret =3D true;
+       spin_unlock_irq(&css_set_lock);
+       cgroup_unlock();
+       return ret;
 }

With the above changes, I think it can meet most use cases with BPF on cgro=
up1.
What do you think ?

--
Regards

Yafang

