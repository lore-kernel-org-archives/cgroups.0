From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on cgroup1
Date: Sun, 17 Sep 2023 15:28:46 +0800
Message-ID: <CALOAHbDspQnOCFiYPjy34narygyApRQVnM1nZ+Qt2Cyq1VGx9Q@mail.gmail.com>
References: <20230903142800.3870-1-laoar.shao@gmail.com> <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
 <CALOAHbB-PF1LjSAxoCdePN6Va4D+ufkeDmq8s3b0AGtfX5E-cQ@mail.gmail.com>
 <CAADnVQL+6PsRbNMo=8kJpgw1OTbdLG9epsup0q7La5Ffqj6g6A@mail.gmail.com>
 <CALOAHbBhOL9w+rnh_xkgZZBhxMpbrmLZWhm1X+ZeDLfxxt8Nrw@mail.gmail.com>
 <ZP93gUwf_nLzDvM5@mtj.duckdns.org> <CALOAHbC=yxSoBR=vok2295ejDOEYQK2C8LRjDLGRruhq-rDjOQ@mail.gmail.com>
 <jikppfidbxyqpsswzamsqwcj4gy4ppysvcskrw4pa2ndajtul7@pns7byug3yez> <ZQSU_0RhpVw-Y0v2@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bpf+bounces-10218-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694935764; x=1695540564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UztY6Cngw+1MjErY3AcXouGizLW2/eHL4pwNAma3V7k=;
        b=fmrtSWwijJmREUyPRnXKjTTnahY7T0PsBPd4pN2QQ7zfztk43zzkYHMbo+/TGdUvUx
         7RE8LUa2hbSISx8NexCDvZg5K3Z+mXfBlf/rchw42OlrzMk81Q8scIhU9AEKSCUXVKZb
         MDAPQEgWviK2oBlb/vQlYLLcccKm7AtTU+8HEXgKrBHxM6mDw8o5gzTsCgg+x0uUZvCa
         UEmGwJMykEYyBXQMjzKu3mJEW3xtP/pT0R4aPJLTAmszV9fRHtGFG8x+tslqFDrZVfLM
         Ca0kviDiSRWo8Rjo7f1X9L00/U+gWKfiq5FW4CDHIfB4lPobts5D7OoK6dVR5Gb7lt6u
         Yd/w==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
In-Reply-To: <ZQSU_0RhpVw-Y0v2@mtj.duckdns.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>

On Sat, Sep 16, 2023 at 1:31=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> On Fri, Sep 15, 2023 at 07:01:28PM +0200, Michal Koutn=C3=BD wrote:
> > Hello.
> >
> > On Tue, Sep 12, 2023 at 11:30:32AM +0800, Yafang Shao <laoar.shao@gmail=
.com> wrote:
> > > With the above changes, I think it can meet most use cases with BPF o=
n cgroup1.
> > > What do you think ?
> >
> > I think the presented use case of LSM hooks is better served by the
> > default hierarchy (see also [1]).
> > Relying on a chosen subsys v1 hierarchy is not systematic. And extendin=
g
> > ancestry checking on named v1 hierarchies seems backwards given
> > the existence of the default hierarchy.
>
> Yeah, identifying cgroup1 hierarchies by subsys leave out pretty good chu=
nk
> of usecases - e.g. systemd used to use a named hierarchy for primary proc=
ess
> organization on cgroup1.

Systemd-managed tasks invariably have one or more cgroup controllers
enabled, as exemplified by entries like
"/sys/fs/cgroup/cpu/{system.slice, user.slice, XXX.service}".
Consequently, the presence of a cgroup controller can be employed as
an indicator to identify a systemd-managed task.

>
> Also, you don't have to switch to cgroup2 wholesale. You can just build t=
he
> same hierarchy in cgroup2 for process organization and combine that with =
any
> cgroup1 hierarchies.

The challenge lies in the need to adapt a multitude of applications to
this system, and furthermore, not all of these applications are under
our direct management. This poses a formidable task.

--=20
Regards
Yafang

