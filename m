Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56F136C5B2
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 01:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783993726; cv=none; b=cNpAr3AbhSJtKl+QeVSf0001nw6IDhWatGR9c/ypu/sSUmsSMU6v2924LcaAj+U48mlO8sGPMRzqiTetauDpuAXuoswNcvGQPU3gMHMBYRByPoMiod550f2kNdlEV/vX8cwuQDA9qKEl/FprSqauF5YCxbJCQevf0gnArDtD+Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783993726; c=relaxed/simple;
	bh=d/zDPy25BDchOmQIxz3e1O7l05JT5tzQofE6tuV7T4w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jkQmPYhrFVOw/0iOu6sH7N8aS34gvQSFEQDKX4NNZ7c5iDDLjl83D72yEjlsUkWp7A9LYAEaBaZ3kAgdjJNbu3YzzO5vIpmRw5XHxQnyIh4V/8hBoRJftO3pY4LeJsrCCNJhs+15K+ZrzqhiZ8y5VFG2AvmvFwZQZIOkH230Jbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gVVH5P/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gVVH5P/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4B01F00A3F
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 01:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783993724;
	bh=MbOjIsi8JJFa+ekLd2ueCKtLKuoFN78zQ1K70+DeCBo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gVVH5P/fjgbM1OPgTRHKxV+piUyPGvXao2h4/3Xn3V9C3SE+vBBrKLHrbQk76/oqa
	 CEZ6zmfHLS/fR9EzD30TrlQiVGraU2NJGOsKUeTSuPWNUjWh66Iuobtrw8VVHpXJaK
	 42P8QqfwChVaT7lugOEXjGvabUnqFp7nexKwqi4to6yk/AoPY268iMBbqctte0DRcI
	 gQgpKdOgUEIvZtoHfjWWprGctNoRi/3wwFYl8qz89HLGOWHbPWjlTBjV32aI1GJEeZ
	 l8Tfb0tcoBVEahfLUkorsDRqLJh03mG+LzMh+qocqmtDONl0wCu72fKLL5rUHre4me
	 cduYEQ6HjJP0w==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92c7a0a701aso241367585a.3
        for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 18:48:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoCSg16cQuY1Gn13PAB9n8LQb2wqNA5uecVKXcpwcCupCMSA+9706UJDFfTp42MpdAVFRrtAeik@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3vPgf4aCAw8rOzwVlMK1hJnGD6DWZ9xq3CIrV6BrPZoaDxndp
	L1Fn0gYKLYF5IHj7G3hbniITMV17FWjVQV2CpbWjVR/a4I8C7VCL26YGC7IpvpG6PYkD6/pKrRK
	vlW4+hVf8lVpfxssBc0qMP2LMzzZ1qvo=
X-Received: by 2002:a05:620a:40c9:b0:92e:72a4:f291 with SMTP id
 af79cd13be357-93083c771aamr143577285a.35.1783993723543; Mon, 13 Jul 2026
 18:48:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-2-ridong.chen@linux.dev> <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
 <87dc4105-b98b-4541-bafe-c0adfbf58836@linux.dev> <CAGsJ_4wDMrdvGksTJ1SMGE=aHY3CMY529ceKDD68cXLsHQCjtQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4wDMrdvGksTJ1SMGE=aHY3CMY529ceKDD68cXLsHQCjtQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 14 Jul 2026 09:48:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zcgURKZKBAc6i0Y5g7u2OXjENDE7A=nqYcQ9TTVuR=Hg@mail.gmail.com>
X-Gm-Features: AVVi8CfG3B9nlEacyjsxWYdmVKS691GC19CUAX3lW2WBM6ngcXxIYeumTVwHA-k
Message-ID: <CAGsJ_4zcgURKZKBAc6i0Y5g7u2OXjENDE7A=nqYcQ9TTVuR=Hg@mail.gmail.com>
Subject: Re: [PATCH 1/2] memcg: move mem_cgroup_swappiness to memcontrol.h
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2026 at 9:43=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Tue, Jul 14, 2026 at 9:20=E2=80=AFAM Ridong Chen <ridong.chen@linux.de=
v> wrote:
> >
> >
> >
> > On 7/13/2026 11:08 PM, Barry Song wrote:
> > > On Sat, Jul 11, 2026 at 5:12=E2=80=AFPM Ridong Chen <ridong.chen@linu=
x.dev> wrote:
> > >>
> > >> From: Ridong Chen <chenridong@xiaomi.com>
> > >>
> > >> The per-memcg swappiness knob is v1-only; v2 always uses global
> > >> vm_swappiness and ignores the per-cgroup field.
> > >>
> > >> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
> > >> to memcontrol.h where it belongs.
> > >>
> > >> No functional change for v1; v2-only kernels drop the unused field.
> > >>
> > >> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > >> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > >
> > > Reviewed-by: Barry Song <baohua@kernel.org>
> > >
> > > With some nits.
> > >
> > >> ---
> > > [...]
> > >>          struct mem_cgroup_per_node *nodeinfo[];
> > >> @@ -365,6 +366,9 @@ enum objext_flags {
> > >>
> > >>   #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
> > >>
> > >> +/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
> > >> +extern int vm_swappiness;
> > >
> > > This is a bit unusual. I'm not sure whether mm/swap.h would be
> > > a more appropriate place for this.
> > >
> > Thank you for your reply.
> >
> > The vm_swappiness variable is not utilized within mm/swap.c.
> > Furthermore, since memcontrol.h does not include swap.h, retaining the
> > extern int vm_swappiness declaration in mm/swap.h will result in a
> > compilation failure.
>
> If this is the case, it still seems better to keep
> extern int vm_swappiness in include/linux/swap.h.
>
> Then we don't need the comment:
> /* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
>
> It also makes it clearer that vm_swappiness is an extern variable
> belonging to the swap module, rather than the memcontrol module.

BTW, if mem_c_group_swappiness() and vm_swappiness are only used
within mm/, could all of these be moved to mm/swap.h and
mm/internal.h instead?

We are making a big effort to move many unrelated things out of
include/linux/swap.h recently. Could you check?

https://lore.kernel.org/linux-mm/20260708-ch-swap-series-plus-folio-lru-cle=
anup-v9-0-2bc72b4f8730@gmail.com/
