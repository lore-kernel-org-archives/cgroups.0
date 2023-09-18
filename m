From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Subject: Re: [RFC PATCH bpf-next 1/5] cgroup: Enable
 task_under_cgroup_hierarchy() on cgroup1
Date: Mon, 18 Sep 2023 16:45:11 +0200
Message-ID: <ysajseo5a5dashpz4dtkdpthtdww4m6wpgtgpakbtlbqoy7cvg@53fx3pou6hrl>
References: <20230903142800.3870-1-laoar.shao@gmail.com>
 <20230903142800.3870-2-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uoq6y5kmp3pqpxzu"
Return-path: <bpf+bounces-10285-glkb-bpf=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1695048313; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m+c5MwjrU6e+eqnpeyq/gfs4XPJ67C6Tq+An5QkBSWg=;
	b=kpFMGaQSztQjUayzxgZpeMJevfzfaEbLDhJIiP1PMhvnA91PRgsjzMiZ3kQcYtUXTvhnWA
	NHNmK/Z3DHTHlj4QDK3W9B20H5pHeiB4qVBcm1ml22z85HS7EDcI3KyRUI4zgc7U2yG6hD
	Lrrhgr8yHCn6WiZPyA+sj71HWSNahy0=
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:bpf+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:bpf+unsubscribe@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20230903142800.3870-2-laoar.shao@gmail.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, yosryahmed@google.com, cgroups@vger.kernel.org, bpf@vger.kernel.org


--uoq6y5kmp3pqpxzu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 03, 2023 at 02:27:56PM +0000, Yafang Shao <laoar.shao@gmail.com=
> wrote:
>  static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
>  					       struct cgroup *ancestor)
>  {
>  	struct css_set *cset =3D task_css_set(task);
> +	struct cgroup *cgrp;
> +	bool ret =3D false;
> +	int ssid;
> +
> +	if (ancestor->root =3D=3D &cgrp_dfl_root)
> +		return cgroup_is_descendant(cset->dfl_cgrp, ancestor);
> +
> +	for (ssid =3D 0; ssid < CGROUP_SUBSYS_COUNT; ssid++) {

This loop were better an iteration over cset->cgrp_links to handle any
v1 hierarchy (under css_set_lock :-/).

> +		if (!ancestor->subsys[ssid])
> +			continue;
> =20
> -	return cgroup_is_descendant(cset->dfl_cgrp, ancestor);
> +		cgrp =3D task_css(task, ssid)->cgroup;

Does this pass on a lockdep-enabled kernel?

See conditions in task_css_set_check(), it seems at least RCU read lock
would be needed (if not going through cgrp_links mentioned above).

HTH,
Michal

--uoq6y5kmp3pqpxzu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQpEWyjXuwGT2dDBqAGvrMr/1gcjgUCZQhidQAKCRAGvrMr/1gc
jstqAQCEYHUIebapzJQGj+eNhDHfhcCyW19Sdpyn2oF07i7N+wD/QQufiDWkuqHZ
1Mzzg+E3EsbzUxHd+erYEhkctnPTtw4=
=JT1H
-----END PGP SIGNATURE-----

--uoq6y5kmp3pqpxzu--

