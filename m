Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795010139;
	b=w5bK+Cr27b79CnR+svjlZSj3oWhKHaOlcg4jjdoSXwfSenNKsWmrngW4LJrgF4xZir2X
	 tbS1nLM0an+G8GB52Ridb15pwACKEFcBM6TWcnPxrUht7CTbe31op6JnINtL8p5pckesc
	 Pm1Q7i65UIBgcOcLsUfjNZX8MGyaLu912Gn6al+NYhQiT1APVFNQ0qpnxahuNYN77tHGa
	 Mi3PV5nHcWKKBGqYKOZIBWBngFu7uZGLjcULR66SqVYypB8JaeKe6J0V7gyDDTvhuA+Cp
	 iwVnIIq8lUanNNmYcNgUpaVUUtlmO73q6no5+PhIwuRi5VKwJUYBpVCTBcNQs81rRcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795010139;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=Q93IOK+81L655tUS3XT9KzQ8Uws4KOL15ej2huBrpiw=;
	b=gGUQRAOcUG5ULttutXSEmexpJeHlW79aSX1IJ33812YjA45Pp5I/UtJwhABgKQbuAzfW
	 LLewjZ/hk+YKpudZMkXHtaTagiYgolTx8yB53oowFxrpOANxo2oo0l7Ywc0ncfzZZ+Iq7
	 2aLB7uddua6lx3kO81CvPK5z1ObAo6qHFclRst3p17zXUBnZTh9AnLlFPV/lqCr6cNRUV
	 hDiTd6+D+Xp2ut/kwbY6KxAv4R3VMqPMaUq08pNIKurMzQdKG2yvudzngkfVxOXSDZWSC
	 FNEFzmH3GgatYemiRtbiewNuleYpzKDkQD3/yGDXjR6A8QyWTd1Ld0LX34CPN4Uiumg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OjstRZPU;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b="YdeGXNs/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11510606A333
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 13:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11510606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OjstRZPU;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=YdeGXNs/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795010138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q93IOK+81L655tUS3XT9KzQ8Uws4KOL15ej2huBrpiw=;
	b=OjstRZPUuPltanCOyBQ3iOpkd+I/auuTftInDAc3XyC7QkBVfo25wgy74zhvwHCBAUH7Ew
	eAQdNh6sx1x9HqJibyHv3XJFIzSQYy5zFNumBW8ghGiJwaZZS2YCwPCmJxq9MYVsZd56bA
	CJhgz/hSStRP4LzHMBHxfcT46SQy4Qg=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-XY8WqVUsNwGG--MnaqpFpg-1; Wed, 18 Nov 2026 08:55:36 -0500
X-MC-Unique: XY8WqVUsNwGG--MnaqpFpg-1
X-Mimecast-MFC-AGG-ID: XY8WqVUsNwGG--MnaqpFpg_1795010136
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-67bec5d62ebso1419879d50.1
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 05:55:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795010136; cv=none;
        d=google.com; s=arc-20260327;
        b=JuJho9yS9fCOOnpO56LDfNEodMOjBaXAbZGz5TgAtD+N5babZeZESDflB0Aqb7E6N7
         UfxWr9VutfvQoh6Ky6UnUeyODsPWPwG0qy55DWqS3J9+Evdd+Hj55ktIPifwC5Tu6tiz
         coWHZ3v/dvcCuMw5KlrqI4oOifrTDwV59K6P8Iv4gKGlrA5Kc9o/xjatuQ/nikXju1QU
         XaStVoA8orRHes4Q9l1tQSiJ3alVNm2M7MgWgNvH8cFnuocePxmVnz2FeG1+fsOhxqAH
         9KS2WshaBo4V2uK5j9LkKM4BQ4gVU7z8Ao8uusHU8nB9PwCBtOcvGprDP0NP2F5PbWfy
         pVxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q93IOK+81L655tUS3XT9KzQ8Uws4KOL15ej2huBrpiw=;
        fh=FvZWwX1zS31m6cyAKyrb0gwGSrFs0e7Ei0l3NZxcRs4=;
        b=M04NJf0nsCNpWS04K1TtYVE/+SpP3AWtSaasvCXcKCGi961CchDAXeD67IuUaPvFo8
         qsK1LhAwPt+6x/OmKX790j2FZyJWaEURr4iQOmRRMFSywvx7KSzDX0paW2Y1Ig2b8DPe
         AJ+zTPa7zWNg7jS7LnxKGLPVg6mS1BeRRNrOha0JL3mzA6DQ8DyezH3lrMnJ/5whAYhv
         lOMfazt+ttkwILwJEShLhC550iG6o7XQ3OU6YUMzzrAouzWFAxOMg2glgL8zOD96F+wK
         TLcpxKHehbHZybbv9bUAztORNT4ukQFwEfsQyWL4YAq9YeLVDiL30x2p3UCfL2yr2nX1
         raeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795010136; x=1795614936; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q93IOK+81L655tUS3XT9KzQ8Uws4KOL15ej2huBrpiw=;
        b=YdeGXNs/g+hxp03HRbQSUUfYwpG+Q463Psgnm5pI6nowFTE0GT/AT+9Eba8UqJXu2F
         Rjm7s6KZtfcTE+jLnJqY9Yha9DiDRbhjBVk9n/zG7Tl/p4QVD4cOVryiVPrvuioWjJ2V
         kC4s94SucOy//FSYm1394CoCF5UK5zXU1gxH2PfPcfRIkd2mTJdDSJhVy7FSL4lT5EZc
         m+HBczANYjijzYP43BM9ZWyF2lkON43QQgIwWQhgllRW+41fvFVuY2rQaXLV1H9y0Dqo
         Sq+5Nt2E0oRySNF5RHc6s28Fs0dEBL+ug6DeSjIEnvBqVwZGg+FdASv6oArpfSCSBBSS
         kWvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795010136; x=1795614936;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q93IOK+81L655tUS3XT9KzQ8Uws4KOL15ej2huBrpiw=;
        b=jPsHlkVL5A7Q2cPyApM7kbzJwf9svLM+5FzSVPiwFNXkEtyyoudlJlkOsfMKL0ivvt
         m1oMrPMhu19RjCLReFBkKE7NIzckIM6OkDqLy3CrXHw7VunsIWshY65I0rcnApwKQtzW
         lo1HFQkuMDFkbNWK9zO1+RbzvKG6N9Lxgen12y5MM1XPY8LPMvvjmxOIS/qIflFc+aZM
         3sTCFt460FXpNVuPVJzuSICTuVJnqMzJzM2OUjMDesTKCwFkavHO2QvAM3wnHJ6I8sag
         ABiuNq1CCYkqtdQwgsYR7OZQw7Ko6S0VmvIWp/mJTMnjnsnAmWSU424DzrPvJ3vvdlXR
         I0Hw==
X-Forwarded-Encrypted: i=1; AL+hErHUg5CNfY1IQ4GMsc945ktvbRwmVHPI73c9Pfj/wy7mPrQrVpIWe8NxnRRfCzobmjDv3AA6oCAr@vger.kernel.org
X-Gm-Message-State: APuU4Z9jQAxiLCLq7dgRvBxhCQBYOIGFWdmxU/haC4pueurko4YsmerN
	sADz9+BgDgZjtfVsLBK+Qh8dtBno4qck++rjWO34OBZmHpShruNx0T+vr2aW0UvlPvPP+bGAl3e
	ncgiTbLKR66OUwkrv8p9mgpMtvwultNjBk9q6jnMCeSB8IizAW/bU4ZLpgwiiJ6zfW4ZnfLMGw6
	t63I6UkNjpPzIog8LzQptRr5H9P8k+G2PUyA==
X-Gm-Gg: AZFdTZeCU3qrqw2KdvRmUV12K1souHkznZEse+o5cXiT+DDLhympxK7CtJG5cU/gZRo
	6C10r9RxUOreCzOfLyBdyxBtoYRfIARTunAooKDQJvCRc0yapb8qugKfdmtTeqB6nGjW203gD1t
	AFay0N0QGyN2Fm0/q17JQmFxaqfgT4eB4JiowRBlRYiTniHmX5tseyn/Kx
X-Received: by 2002:a05:690e:1387:b0:67b:f249:5b16 with SMTP id 956f58d0204a3-67dd3fdee8amr1338621d50.55.1795010135902;
        Wed, 18 Nov 2026 05:55:35 -0800 (PST)
X-Received: by 2002:a05:690e:1387:b0:67b:f249:5b16 with SMTP id
 956f58d0204a3-67dd3fdee8amr1338592d50.55.1795010135440; Wed, 18 Nov 2026
 05:55:35 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117-v2_20230123_tjmercier_google_com-v5-4-1ce975f2a9ad@redhat.com>
 <44c0c45c0e2f47ed77bc45be47ebb3fb@paul-moore.com>
In-Reply-To: <44c0c45c0e2f47ed77bc45be47ebb3fb@paul-moore.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 18 Nov 2026 14:55:24 +0100
X-Gm-Features: Aa3M54okPSWfJ_g3ixS3iw1yy5owTDFGTKhnOXZ64bND8Gaqu8R-9XYtSNGyOOw
Message-ID: <CADSE00LVsFVOmezzLgPrPWDd+L+SSGzGvqKTiX25waxRnVPh9Q@mail.gmail.com>
Subject: Re: [PATCH v5 4/8] lsm: Add memcg_charge_task LSM hook
To: Paul Moore <paul@paul-moore.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	=?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>, airlied@gmail.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org, 
	echanude@redhat.com, mripard@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 11:54=E2=80=AFPM Paul Moore <paul@paul-moore.com> w=
rote:
>
> On Nov 17, 2026 Albert Esteve <aesteve@redhat.com> wrote:
> >
> > Both DMA_HEAP_IOCTL_ALLOC and the new DMA_BUF_IOCTL_XFER_CHARGE ioctl
> > accept a charge_fd field that, when set, causes the allocation to be
> > charged to an arbitrary process's cgroup rather than the caller's.
> >
> > Charging is currently limited to the caller's own memcg subtree unless
> > the caller holds CAP_SYS_RESOURCE. But the capability is all-or-nothing=
.
> > A process holding it, along with a dma-heap device node or a dma-buf
> > fd can charge unlimited memory to any other process's cgroup, potential=
ly
> > exhausting that cgroup's limit and triggering OOM kills independent of
> > the victim's own activity or privileges.
> >
> > Add security_memcg_charge_task(), called in get_obj_cgroup_from_fd()
> > when charge_fd refers to another process. The hook receives
> > the credentials of the allocating process (from) and the credentials
> > of the process whose cgroup will be charged (to), giving security
> > modules a controlled enforcement point for cross-cgroup objcg
> > attribution policy.
> >
> > When CONFIG_SECURITY is not set the hook compiles to an inline
> > returning 0, adding no overhead to the fast path.
> >
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
> > ---
> >  include/linux/lsm_hook_defs.h |  1 +
> >  include/linux/security.h      |  7 +++++++
> >  mm/memcontrol.c               | 11 +++++++++++
> >  security/security.c           | 15 +++++++++++++++
> >  4 files changed, 34 insertions(+)
>
> ...
>
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 03cd90d5e623..2e6fcbe14d43 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -60,6 +60,7 @@
> >  #include <linux/lockdep.h>
> >  #include <linux/resume_user_mode.h>
> >  #include <linux/psi.h>
> > +#include <linux/security.h>
> >  #include <linux/seq_buf.h>
> >  #include <linux/sched/isolation.h>
> >  #include <linux/kmemleak.h>
> > @@ -3198,10 +3199,12 @@ static bool mem_cgroup_may_charge(struct mem_cg=
roup *memcg)
> >  struct obj_cgroup *get_obj_cgroup_from_fd(int fd)
> >  {
> >       struct cgroup_subsys_state *css;
> > +     const struct cred *tcred;
> >       struct obj_cgroup *objcg;
> >       struct mem_cgroup *memcg;
> >       struct task_struct *task;
> >       unsigned int pidfd_flags;
> > +     int ret;
> >
> >       if (mem_cgroup_disabled())
> >               return ERR_PTR(-EOPNOTSUPP);
> > @@ -3226,6 +3229,14 @@ struct obj_cgroup *get_obj_cgroup_from_fd(int fd=
)
> >               if (IS_ERR(task))
> >                       return ERR_CAST(task);
> >
> > +             tcred =3D get_task_cred(task);
> > +             ret =3D security_memcg_charge_task(current_cred(), tcred)=
;
>
> Do you ever envision this "from" cred being something other than
> current_cred()?

Good point. No, I do not.

> If the answer is "no", we might want to consider changing
> the LSM hook slightly to help prevent misuse in the future:
>
>   int security_current_memcg_charge_task(const struct cred *tcred);

Agreed. I'll apply the same to the cgroupfd variant for symmetry (its
"from" is also always current_cred()).

BR,
Albert.


>
> > +             put_cred(tcred);
> > +             if (ret) {
> > +                     put_task_struct(task);
> > +                     return ERR_PTR(ret);
> > +             }
> > +
> >               rcu_read_lock();
> >               css =3D task_css(task, memory_cgrp_id);
> >               put_task_struct(task);
>
> --
> paul-moore.com
>

