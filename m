Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34D330CD95
	for <cgroups@vger.kernel.org>; Wed,  8 Jul 2026 00:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783470841; cv=none; b=Zm9378FdrjOXdTReqV1qGdvXqIM6bP7w2dj6/Ao4ZYjhY40XHqF/JRxCFuP6xBrwsgxKq8ZcUyHoWeEx5ldu6INQrdKT7sfIcXrpfOiN5WZwq2O4S2LbuJyTssASAf2U4xo5Qek6/3WKD/GEwr8IsmmqjbvCS1Liba5JDsbsivs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783470841; c=relaxed/simple;
	bh=O8dlhXGaKZVLXNWM+o64TPqGISoXyx4XSm5T4i4QYg0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CUAAbLQxMArpSGZ9M2Pv6xqEDH1klMrP8gfbPw5MMOI2Vp9QTWXs5tOHdGirEIrRizzy9vkz/ok9vb5T3fjeD0CAVKb2WVD1K+RJQ5NuhY6gPVo/r/I7rvr5cC5qKPfiD4CkvQdf0SXSN5Q1/ufKVW4LGHkYvo/+vXYSxOn5X54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ktbeh1//; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ktbeh1//"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cc73e322dbso1323605ad.1
        for <cgroups@vger.kernel.org>; Tue, 07 Jul 2026 17:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783470831; x=1784075631; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6PPCHw1C4s9wB8+ak3IGBUi1NrCIfjVxm5EQeAbcpyE=;
        b=Ktbeh1//7+N3DxvK+f6VKqWUItIjmxmhQgtPWIH9NHPeU5iLF9YQzAr94iegew2tVn
         QJRB23/JdrTOZ8tOp2X/2NfVQ2S2fjkob1wnCTJuDDaUJWkzME+XeZDsa3to7zTCSsAL
         qKWhEsACssY+HTq66AIFmIW1uHUba0BwiYKuJplIPXgzg3fwkxNsxvln9JsauINjMrH4
         GV6fZ2TlwqE4txmntQqtHmJ2avFR94vnzqfk3enrufZW2gTrCV3t/Ep3l5JmjB81iunJ
         FfqwXOFW15TCBHngaCYxg0ZFoNxebp78lWH181oWdWM16pUkWyy4TvvwHQzu4RcCakMn
         qw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783470831; x=1784075631;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6PPCHw1C4s9wB8+ak3IGBUi1NrCIfjVxm5EQeAbcpyE=;
        b=Qq0uCrBONyXfGMK2QBXFPXgoinQ2WQ6z8vzUkYancRyVpACdHa9j8KbEU9+XasQ47w
         44OP26YAArMklBadc1yvuk7p9/eVCfzac/YK4jjSp2bEWTSeHKfdu8sCa2I8ELdJsXv8
         PjgEGYuyVykCUQj264nJXX8lAlP/OEmbVExcdIxjPaitFiHjRYFPbJrPAA+06rg7gHsM
         J5us2Yj+DJX4HQ+SSBjS7dHlINKaeb+IYdzNqKg8kZeggbtQiogYrwMvFttHGRxE2Sxj
         VKH6NJRNiOdw16nyaDEjjsYckFTUu+5l/UFO59VEwDEjvZKZi4q9TyQQ+6Ogmaa2VYRM
         kFYQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpr5Ao810GFkzI0Q0ZaY33qEhufc1oUvTWk8vb9yeshTncWz4hoh5zWABkvmPiI45cJ1EfkJYSw@vger.kernel.org
X-Gm-Message-State: AOJu0YyEGcj002/OgqGUjNs3s47BGSuZuCq8xarrgoujQep7gmVLHBdf
	F+aTFu1EYPr6ZIJkk6nVYZSJ+dGlIFVJ9EiKBEQH2IKnUFwUaAmsDoG1
X-Gm-Gg: AfdE7cm0jkqknMcQw5egaK7ZQO8+5FHfyMceUaUDEx+pz1ngJrogC0dbahyLaBjb9Ge
	nODYEnmSZM4qQrH0BcHJt95lHamyWuBV5PcV7d2PeKpu72naqmgsbV9TI7IK2rCvtBRT6CckJ+j
	6MLYJoUpTd06AXKScS+Ut39VrsZVLnKIF3kAHPAOQnkKWpH4I5h3NL98DMz0VSjRbJ0Coo8gSFJ
	uDlbJUHygiaR5AnbFp5ewnABio6k163E/ZzbRW0jbWm8/R6yB4v9+WC521ku9WA+MB6jg9DGR68
	ZsvFjKcKfi75p74ptdjyoO/mxblDkHUczG8mwEm0eP8iU1rHqc5W75sF00Dr1p9IhscgOAuGENN
	qygR/2qiQ5HYd5dKhKzVRxiRLGeyGhz22pQqPBherVC0/5bUMQLPf9UfaRGy1OzDEQgno34gat0
	083D/gxFCVAwkkUbN1i/Y/SQ65H+ZqsDES7urR5YvK3ZLYSfHj5D67CA8zZUUp084ElUhVXMwPm
	p1TDY+y
X-Received: by 2002:a05:6a21:7706:b0:3b3:1c7b:ff7 with SMTP id adf61e73a8af0-3c08ef16b7emr8743089637.46.1783470830910;
        Tue, 07 Jul 2026 17:33:50 -0700 (PDT)
Received: from ?IPv6:2a03:83e0:115c:1:f2fe:14ed:44aa:14cf? ([2620:10d:c090:500::2:84e7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659c865asm13266118c88.11.2026.07.07.17.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 17:33:50 -0700 (PDT)
Message-ID: <030dc01fa51430f4ac27d3f4eb4a6147322cb51d.camel@gmail.com>
Subject: Re: [PATCH 0/3] selftests/bpf: compare BPF and memory.stat memcg
 stat readers
From: Eduard Zingerman <eddyz87@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Ziyang Men <ziyang.meme@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
  Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Kumar Kartikeya Dwivedi	 <memxor@gmail.com>,
 bpf@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,  Song Liu
 <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa
 <jolsa@kernel.org>,  Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan
 <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	kernel-team@meta.com, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2026 17:33:48 -0700
In-Reply-To: <ak2Wpk6OnhTyon65@linux.dev>
References: <20260704045617.487664-1-ziyang.meme@gmail.com>
	 <bc12730fe6eccde10d36e6544607ae2464357e05.camel@gmail.com>
	 <akxW5dzvR9e2CfGq@linux.dev>
	 <eccfd9a8dd1af1668e142b9b866194333647b0d5.camel@gmail.com>
	 <ak2LXDWoPFSJL2Q9@devvm16600.scu0.facebook.com>
	 <bc47c75a00acab57e7fea72612e0f6f089ddecc9.camel@gmail.com>
	 <ak2Wpk6OnhTyon65@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-07-07 at 17:31 -0700, Shakeel Butt wrote:
> On Tue, Jul 07, 2026 at 04:50:11PM -0700, Eduard Zingerman wrote:
> > On Tue, 2026-07-07 at 16:27 -0700, Ziyang Men wrote:
> > > But the patch also carries functional value: alongside that compariso=
n, it
> > > checks the correctness of the stats the kfuncs return.
> > >=20
> > > Let me first answer the main question -- what these tests add over wh=
at we
> > > already have -- and then lay out a plan.
> > >=20
> > > First, the static test (memcg_stat_reader) vs the existing cgroup_ite=
r_memcg.
> > >=20
> > > The existing test calls the kfuncs, but for each value it only checks=
 whether it
> > > is greater than zero. For example, in prog_tests/cgroup_iter_memcg.c:
> > >=20
> > >      memset(map, 1, len);                    /* dirty some anon */
> > >      if (!ASSERT_OK(read_stats(link), "read stats"))
> > >              goto cleanup;
> > >      ASSERT_GT(memcg_query->nr_anon_mapped, 0, "final anon mapped val=
");
> > >=20
> > > It never checks the value is actually correct -- i.e. compares it aga=
inst the
> > > value in cgroupfs -- only that it is non-zero.
> > >=20
> > > Besides, it also walks a single cgroup:
> > >=20
> > >      .cgroup.order =3D BPF_CGROUP_ITER_SELF_ONLY,
> > >=20
> > > and reads only five fields.
> >=20
> > Arguably one of the the cgroup_iter_memcg.c tests can be extended to
> > allocate some mem and check if the value is reflected in the stats.
> > But there is a line between MM tests and BPF tests.
> > All BPF kfuncs except iterator logic itself are thin wrappers on
> > top of the existing MM functionality. Hence, I don't think that
> > BPF selftests are a place to stress-test these things.
>=20
> That is actually a good discussion point. Where does such kind of tests (=
i.e.
> testing that bpf based memcg stats read functionality is equivalent to
> traditional memcg stats reading). As more subsystems are exposed to bpf, =
similar
> questions would arise more often.
>=20
> In this particular case, IIUC you want only tests for bpf related code (w=
rappers
> & iterator) to be present in bpf selftests, right?

Yes, I think this makes most sense.

> Personally I don't have strong opinion where this test should live.
> Functionality wise as it is testing rstat infra, I think cgroup selftests=
 might
> be better home for this.
