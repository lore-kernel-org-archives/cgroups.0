From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [RFC PATCH bpf-next 0/5] bpf, cgroup: Enable cgroup_array map on
 cgroup1
Date: Fri, 15 Sep 2023 19:01:28 +0200
Message-ID: <jikppfidbxyqpsswzamsqwcj4gy4ppysvcskrw4pa2ndajtul7@pns7byug3yez>
References: <20230903142800.3870-1-laoar.shao@gmail.com>
 <qv2xdcsvb4brjsc7qx6ncxrudwusogdo4itzv4bx2perfjymwl@in7zaeymjiie>
 <CALOAHbB-PF1LjSAxoCdePN6Va4D+ufkeDmq8s3b0AGtfX5E-cQ@mail.gmail.com>
 <CAADnVQL+6PsRbNMo=8kJpgw1OTbdLG9epsup0q7La5Ffqj6g6A@mail.gmail.com>
 <CALOAHbBhOL9w+rnh_xkgZZBhxMpbrmLZWhm1X+ZeDLfxxt8Nrw@mail.gmail.com>
 <ZP93gUwf_nLzDvM5@mtj.duckdns.org>
 <CALOAHbC=yxSoBR=vok2295ejDOEYQK2C8LRjDLGRruhq-rDjOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bwbu34nvlbqq3rqp"
Return-path: <bpf+bounces-10159-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1694797290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h3dIzvlBxdfOKjCtJrhlIGa8SoPY/rHAEBMPc40WOHY=;
	b=ItWumZaKbB6MhyTFNvPvoRKIfR1BnhsSzAtHBbxB5AYaIPuuDtGocpcWkIRDqMRURhLaD1
	+dhWbASomi6ckyQwLTVQG26DQtMUWyB6LfE6IMAICGBkwWu6uiY5PIzteBQ83UBqRIkmNb
	BqnhHDqtx6ubU+pv5iOW75r1MvwugWg=
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALOAHbC=yxSoBR=vok2295ejDOEYQK2C8LRjDLGRruhq-rDjOQ@mail.gmail.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>


--bwbu34nvlbqq3rqp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

On Tue, Sep 12, 2023 at 11:30:32AM +0800, Yafang Shao <laoar.shao@gmail.com> wrote:
> With the above changes, I think it can meet most use cases with BPF on cgroup1.
> What do you think ?

I think the presented use case of LSM hooks is better served by the
default hierarchy (see also [1]).
Relying on a chosen subsys v1 hierarchy is not systematic. And extending
ancestry checking on named v1 hierarchies seems backwards given
the existence of the default hierarchy.


Michal

[1] https://docs.kernel.org/admin-guide/cgroup-v2.html#delegation-containment

--bwbu34nvlbqq3rqp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZQSN5gAKCRAGvrMr/1gc
jqoaAQDSlFTLyvMU3pnG272pXuMMF5KmhsnId0TP0peVan9QcAEAw2Zhpgzlxa7y
db4CtFmbfl/wQ7HfdVDyaYQ/I92Zowo=
=lHHe
-----END PGP SIGNATURE-----

--bwbu34nvlbqq3rqp--

