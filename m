From: Hao Luo <haoluo@google.com>
Subject: Re: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on cgroup1
Date: Fri, 15 Sep 2023 11:57:23 -0700
Message-ID: <CA+khW7hah317_beZ7QDA1R=sWi5q7TanRC+efMhivPKtWzbA4w@mail.gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com> <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
 <CALOAHbB-PF1LjSAxoCdePN6Va4D+ufkeDmq8s3b0AGtfX5E-cQ@mail.gmail.com>
 <CAADnVQL+6PsRbNMo=8kJpgw1OTbdLG9epsup0q7La5Ffqj6g6A@mail.gmail.com>
 <CALOAHbBhOL9w+rnh_xkgZZBhxMpbrmLZWhm1X+ZeDLfxxt8Nrw@mail.gmail.com>
 <ZP93gUwf_nLzDvM5@mtj.duckdns.org> <CALOAHbC=yxSoBR=vok2295ejDOEYQK2C8LRjDLGRruhq-rDjOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf+bounces-10178-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694804256; x=1695409056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9vEGyk9aimWeGVbqBDG5yx1Ea1IhyMQsNWatyoWMLY8=;
        b=dY9jggijZ+uU4ytjXw5vqNvsdoRFFYoR4wT+b2nYenO+ihE5BpwKiJjJ5OQggRUW+0
         0efTP4vGgelj4dko9e7ygo3nK3azUMfv698qZ730JytLdCR2zs5KocemkJ82BInsVLIr
         qvBQ2cSCND7hxwY/Ft/n4LcuWtnkaaC5RHCzbfjeqWrSV6A17ZfP9iI9R0mc4S2W1Jf3
         4pPoyDwhlKS4iFhYkcNtOF/GQLVLGZSlt2D6jKN+c7j6DPkDqgNvRf9URec/6fM5ikMf
         ZU0pCWe1Pp4GxsMMhN2U+wi4pmiyzdPwoguJaUKp8UmLDgFBr3ENlPp+cbtUPcJPNILu
         c7Nw==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
In-Reply-To: <CALOAHbC=yxSoBR=vok2295ejDOEYQK2C8LRjDLGRruhq-rDjOQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Jiri Olsa <jolsa@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Mon, Sep 11, 2023 at 8:31=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> On Tue, Sep 12, 2023 at 4:24=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
> >
> > On Sun, Sep 10, 2023 at 11:17:48AM +0800, Yafang Shao wrote:
> > > To acquire the cgroup_id, we can resort to open coding, as exemplifie=
d below:
> > >
> > >     task =3D bpf_get_current_task_btf();
> > >     cgroups =3D task->cgroups;
> > >     cgroup =3D cgroups->subsys[cpu_cgrp_id]->cgroup;
> > >     key =3D cgroup->kn->id;
> >
> > You can't hardcode it to a specific controller tree like that. You eith=
er
> > stick with fd based interface or need also add something to identify th=
e
> > specifc cgroup1 tree.
>
> As pointed out by Alexei, I think we can introduce some
> cgroup_id-based kfuncs which can work for both cgroup1 and cgroup2.
>
> Something as follows (untested),
>
> __bpf_kfunc u64 bpf_current_cgroup_id_from_subsys(int subsys)
> {
>         struct cgroup *cgroup;
>
>         cgroup =3D task_cgroup(current, subsys);
>         if (!cgroup)
>             return 0;
>         return cgroup_id(cgroup);
> }
>

Can we also support checking arbitrary tasks, instead of just current?
I find myself often needing to find the cgroup only given a
task_struct. For example, when attaching to context switch, I want to
know whether the next task is under a cgroup. Having such a kfunc
would be very useful. It can also be used in task_iter programs.

Hao

