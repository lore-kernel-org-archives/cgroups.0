Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1742364949
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 10:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784024524; cv=none; b=dDoAQNSKQXD3Vb5/VCkVmG5Xm/g76OlnpmTMWsX0wHUjmLCOxoularrwQClE/iPAAsu6p4dybGedU4/g4bG8GVcU/01LvPojZSbeQP4IRm/FPuukkpfKDWHVuLEmEjC3qJr8aWIkXJVIDFC3nHFkQBwZjwaiz3Sd80QXD6fOj6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784024524; c=relaxed/simple;
	bh=uw69uhkHsW1eTPurootcWnud9izN3fGJi9NOG8rWLvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cyFQLEevvg3pyV9JQGiDvTG+hkT+OhS7/ZNgIC4H2ucg/SGcPRnM9HN8r75mDKaxNnj0Od1/zIEAnQPwOk3vjbhwFYgJ2Zd+YVG3ePZsDlqD2G5bSmoU6JoGvENsyj0OFdsNBRl2IuMSszk8HpKa59N9qX92fSS9e6LoPQ6KsvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4Rqp1Sn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4Rqp1Sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95C41F00A3E
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 10:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784024522;
	bh=N9MWqkbaVeSAs5QQWSSS7b7WvPqPkyKj21JCF4S69vs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=l4Rqp1Sn6WdWoE4yLXk5VsGX8HcCgBXMmRWPd8Hc3mRvzrdBZQ1WE8IU1YiBFJpyH
	 B2e7iTWkk0/NF1WnAl2tMFiIN24nKSVgrfm/06kFm936EyxeKJ4OSB/2oZaY4b9eVf
	 Udied/4vKMyJmPRtXuwn/FU9J3nmlSlpqUWMx+XX198CMszfCrvYUAR5v/nKys+Vk5
	 vUP6I7RuKRPwOspnyDiJgvWGLv7Nw0E7/Nw91ykVjASxTSA8UHZaLMJZSYuoD+YmRJ
	 50mVDdC4q8DKDZf/0BdZCirdypixonSyUXbsrrVjHzpUL8e567u39CIooaI2yJy3Na
	 LPHuNjyqVaCbw==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92c7a0a701aso269933885a.3
        for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 03:22:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqMbVKvGxCysA/Mpozf+NwgzLc1rwYfTMXchv+vc5h2nRSRvqZ5edppEp9ApYzAk1L7wSxXlIsJ@vger.kernel.org
X-Gm-Message-State: AOJu0YxZX0RJdvDIT3i2iEqJ6tDBKQGpUiV2JmxdShMy6vkOUxZkW4J3
	7NZ93k2BP4nEEMOd8OUd7/XgZHc6j0W4Lq9Lr1954tumP/86KsS4tK29ZsV0PplfzVrRoR+wC6S
	WedwmDF+FKESP4KU2plwHlUVcv6lzsQQ=
X-Received: by 2002:a05:620a:4543:b0:8cf:c106:faca with SMTP id
 af79cd13be357-93083c77332mr261027385a.36.1784024522021; Tue, 14 Jul 2026
 03:22:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-2-ridong.chen@linux.dev> <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
 <87dc4105-b98b-4541-bafe-c0adfbf58836@linux.dev> <CAGsJ_4wDMrdvGksTJ1SMGE=aHY3CMY529ceKDD68cXLsHQCjtQ@mail.gmail.com>
 <CAGsJ_4zcgURKZKBAc6i0Y5g7u2OXjENDE7A=nqYcQ9TTVuR=Hg@mail.gmail.com> <0545ee70-b0a0-4a93-ac2c-3e84ff504e5a@linux.dev>
In-Reply-To: <0545ee70-b0a0-4a93-ac2c-3e84ff504e5a@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 14 Jul 2026 18:21:50 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x7cg-L_OzCdyZy+8zoKptVi-Jh18k1HRkvTBTbn-EQRA@mail.gmail.com>
X-Gm-Features: AUfX_mw2KgsaUXheEE1KmhPftKrhTRh4Ox0BToKgjyllBsTmCYfrfr5f-D4f_Ig
Message-ID: <CAGsJ_4x7cg-L_OzCdyZy+8zoKptVi-Jh18k1HRkvTBTbn-EQRA@mail.gmail.com>
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

On Tue, Jul 14, 2026 at 3:43=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
>
>
> On 7/14/2026 9:48 AM, Barry Song wrote:
> > On Tue, Jul 14, 2026 at 9:43=E2=80=AFAM Barry Song <baohua@kernel.org> =
wrote:
> >>
> >> On Tue, Jul 14, 2026 at 9:20=E2=80=AFAM Ridong Chen <ridong.chen@linux=
.dev> wrote:
> >>>
> >>>
> >>>
> >>> On 7/13/2026 11:08 PM, Barry Song wrote:
> >>>> On Sat, Jul 11, 2026 at 5:12=E2=80=AFPM Ridong Chen <ridong.chen@lin=
ux.dev> wrote:
> >>>>>
> >>>>> From: Ridong Chen <chenridong@xiaomi.com>
> >>>>>
> >>>>> The per-memcg swappiness knob is v1-only; v2 always uses global
> >>>>> vm_swappiness and ignores the per-cgroup field.
> >>>>>
> >>>>> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
> >>>>> to memcontrol.h where it belongs.
> >>>>>
> >>>>> No functional change for v1; v2-only kernels drop the unused field.
> >>>>>
> >>>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> >>>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> >>>>
> >>>> Reviewed-by: Barry Song <baohua@kernel.org>
> >>>>
> >>>> With some nits.
> >>>>
> >>>>> ---
> >>>> [...]
> >>>>>           struct mem_cgroup_per_node *nodeinfo[];
> >>>>> @@ -365,6 +366,9 @@ enum objext_flags {
> >>>>>
> >>>>>    #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
> >>>>>
> >>>>> +/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
> >>>>> +extern int vm_swappiness;
> >>>>
> >>>> This is a bit unusual. I'm not sure whether mm/swap.h would be
> >>>> a more appropriate place for this.
> >>>>
> >>> Thank you for your reply.
> >>>
> >>> The vm_swappiness variable is not utilized within mm/swap.c.
> >>> Furthermore, since memcontrol.h does not include swap.h, retaining th=
e
> >>> extern int vm_swappiness declaration in mm/swap.h will result in a
> >>> compilation failure.
> >>
> >> If this is the case, it still seems better to keep
> >> extern int vm_swappiness in include/linux/swap.h.
> >>
> >> Then we don't need the comment:
> >> /* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
> >>
> >> It also makes it clearer that vm_swappiness is an extern variable
> >> belonging to the swap module, rather than the memcontrol module.
> >
> > BTW, if mem_c_group_swappiness() and vm_swappiness are only used
> > within mm/, could all of these be moved to mm/swap.h and
> > mm/internal.h instead?
> >
> > We are making a big effort to move many unrelated things out of
> > include/linux/swap.h recently. Could you check?
> >
> > https://lore.kernel.org/linux-mm/20260708-ch-swap-series-plus-folio-lru=
-cleanup-v9-0-2bc72b4f8730@gmail.com/
>
> Good suggestion. Moving them to mm/internal.h makes sense. Will update
> in the next version.

Either mm/swap.h or mm/internal.h.
vm_swappiness probably belongs in mm/swap.h rather than
mm/internal.h, right?

BTW, I am not particularly eager about this cleanup;
it could be done later as a separate patch.

If you decide not to do the cleanup, I think it would be better to
leave "extern int vm_swappiness" in include/linux/swap.h rather than
declaring it in include/linux/memcontrol.h?

Best Regards
Barry
