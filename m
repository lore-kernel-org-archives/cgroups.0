From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on
 cgroup1
Date: Fri, 15 Sep 2023 07:31:43 -1000
Message-ID: <ZQSU_0RhpVw-Y0v2@mtj.duckdns.org>
References: <20230903142800.3870-1-laoar.shao@gmail.com>
 <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
 <CALOAHbB-PF1LjSAxoCdePN6Va4D+ufkeDmq8s3b0AGtfX5E-cQ@mail.gmail.com>
 <CAADnVQL+6PsRbNMo=8kJpgw1OTbdLG9epsup0q7La5Ffqj6g6A@mail.gmail.com>
 <CALOAHbBhOL9w+rnh_xkgZZBhxMpbrmLZWhm1X+ZeDLfxxt8Nrw@mail.gmail.com>
 <ZP93gUwf_nLzDvM5@mtj.duckdns.org>
 <CALOAHbC=yxSoBR=vok2295ejDOEYQK2C8LRjDLGRruhq-rDjOQ@mail.gmail.com>
 <jikppfidbxyqpsswzamsqwcj4gy4ppysvcskrw4pa2ndajtul7@pns7byug3yez>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf+bounces-10166-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694799106; x=1695403906; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uh+Svyu69yjI7IZ0hILShgFArwlpiuOCby9tFGyVqR8=;
        b=MyFJanD/JyG6CZw1jd7qaQ6kwaizla4Q1YJOLrJ6320U+9vxRF5sj8YiZLWqFEyWeX
         7zZnvN9Z35bnK6yT9iFomEmDvGhk8jExSns6B0jVI25OMfx/wLJJt3yl8UzrPmg2k/MD
         tzjzGv5tcI0GxlDU/F0h/ZNaFjHc/qi39FarDgaXhvO1McQimWDlSZR13cDfbkhv+T1p
         qMI2bi4Lo6g3Zymgy8+llGsv/BpT//gC8ph66SnX+AMyMXlossDaTJ/4CTn7MvOY4rb2
         4E4vqCHD32pyBH47F1pjGtdZeMorsRMB9a9kwU3CD8evncSd4X78k92UYjKQo46wGmVg
         S5AA==
Sender: Tejun Heo <htejun@gmail.com>
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <jikppfidbxyqpsswzamsqwcj4gy4ppysvcskrw4pa2ndajtul7@pns7byug3yez>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Fri, Sep 15, 2023 at 07:01:28PM +0200, Michal Koutn=FD wrote:
> Hello.
>=20
> On Tue, Sep 12, 2023 at 11:30:32AM +0800, Yafang Shao <laoar.shao@gmail.c=
om> wrote:
> > With the above changes, I think it can meet most use cases with BPF on =
cgroup1.
> > What do you think ?
>=20
> I think the presented use case of LSM hooks is better served by the
> default hierarchy (see also [1]).
> Relying on a chosen subsys v1 hierarchy is not systematic. And extending
> ancestry checking on named v1 hierarchies seems backwards given
> the existence of the default hierarchy.

Yeah, identifying cgroup1 hierarchies by subsys leave out pretty good chunk
of usecases - e.g. systemd used to use a named hierarchy for primary process
organization on cgroup1.

Also, you don't have to switch to cgroup2 wholesale. You can just build the
same hierarchy in cgroup2 for process organization and combine that with any
cgroup1 hierarchies.

Thanks.

--=20
tejun

