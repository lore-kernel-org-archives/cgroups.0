Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0B8208D0
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 10:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788086441; cv=none; b=Z3X6rJmw5vEmXdiZRzW7yPY38+BSlW+wcKEJj2CoFC8XOZV0IRtWtuWBXzI0qjh2hWF33Z11DabUgMCW0f+iOmwFgFU1K98b2W8pg/u1O3X4s2Hza0XwCeuVBQVhgYR96aW8K2lxVMor2bcWccVFLi9wg/jKB3iDPDq/CIFsK7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788086441; c=relaxed/simple;
	bh=s7dNTbr/tNVz69TngDdkquZjYKowk/qW7jQMXcLbnMI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H42ZOjoktk7EFqgKlmCAVWBzRI0cWH0CdOZDiU6yHqgms6C8sEAMaZhgZbvru7g2Khej7SqfZvoVcm2xdLgocpPoeZIELV0zF0lNjolx/3Lof1EAZPcD6r1fBmHBT2Fq0DKyTTae/we+0XeRUQrP3fJti47gwPpb4TTtYUpgG1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JYXXyJoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JYXXyJoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A028C1F000E9
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 10:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788086439;
	bh=uFsR1+Syprr5J5tje5S4jkkUx1bx6a8Akbh+NdTo87c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JYXXyJoHwCSTw9qsSlqLrTD7PeISTTjS3Zj7XpmajY+WaeOGB0rVWI440x1BBXAZQ
	 K1NbqpFoooSU6OOLnPkQJ5AoiypWTmY+bHxerjp89MH2Wlx8BCvvAvxAYmB+vzWn3/
	 nldQhLQ0GHwpx8hjBPCAmtLb+wFkCl2nDojA6gkWn7UIayeAJQu/F4yOVMLu9ZKLOd
	 5dXjiPDEGItOxAiea6rEl7C99BvkEX9Jj9FHDy0nxFFsCsbHVeCeGJ3H47fg8BFoYH
	 PesFvH5exf8IXF7ssscBcu8kk0bQHFi2Cdj/jnOkSv0QY/XWOB/WCMech7EaQ0Z8a2
	 BbVrCmoBhcP+A==
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-52f2577ac01so17005571cf.1
        for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 03:40:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrFpot4gOKqVGNWfVzIJfqhxn+KvgPe1ELi1nNX1duFdbl44f0gfi2qoK9NfpVt0qSdcQ5HEMfA@vger.kernel.org
X-Gm-Message-State: AFuF++kHWWW7A+zCLpFUlY+6mKesQbNcRe/+c+zOCLaqkdByqFRfn805
	+rR+wZ6ynp0Y3K1zCld5ROoE/x5Uj1sII+p7BcGDZGUp3pnGUak5JBhdKNcgwD+/Fh4RgW5YIQI
	xjAew4SCUuQISZC0dd9EnlFJbE8Z9hyY=
X-Received: by 2002:a05:620a:a0c8:10b0:938:fdde:34e6 with SMTP id
 af79cd13be357-939138cc83cmr1680232985a.28.1788086434432; Sun, 30 Aug 2026
 03:40:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828110919.1324028-1-ridong.chen@linux.dev>
 <20260828110919.1324028-3-ridong.chen@linux.dev> <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
 <c0a32c3c-bff8-433c-8552-f0723e3a07b7@linux.dev>
In-Reply-To: <c0a32c3c-bff8-433c-8552-f0723e3a07b7@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 18:40:23 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wvYNV2UMaFW0a3Fb9U09v6bPfXyg4Rzw4B27xo-NVYbw@mail.gmail.com>
X-Gm-Features: AcwNN1W5OF4FZEbyI9ahVrtlbMzghVUAZzbwgduCOLK4Zm5BUL7Ps1VGygdfhkY
Message-ID: <CAGsJ_4wvYNV2UMaFW0a3Fb9U09v6bPfXyg4Rzw4B27xo-NVYbw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 30, 2026 at 6:13=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
>
>
> On 8/30/2026 3:53 PM, Barry Song wrote:
> > On Fri, Aug 28, 2026 at 7:10=E2=80=AFPM Ridong Chen <ridong.chen@linux.=
dev> wrote:
> >>
> >> From: Ridong Chen <chenridong@xiaomi.com>
> >>
> >> memory.min/low is silently bypassed for MGLRU during global proactive
> >> reclaim (writing to the root memory.reclaim) and global direct reclaim=
.
> >
> > I guess nobody is silently bypassing anything. It's just that the
> > effective min is stale data. If kswapd has run at least once, should
> > the protection have been updated already?
> > I guess we need to update the changelog a bit?
> >
>
> The children's emin/elow are derived from the parent's min/low settings a=
nd
> children_min_usage, both of which can change over time. As a result, emin=
/elow
> may become stale, even if kswapd has already run once.

right, let's just say this in changelog, we are *not* bypassing we are
just checking
against stable data. The current changelog seems to be misleading.

[...]
> >> +void mem_cgroup_protection_path(struct mem_cgroup *root,
> >> +                               struct mem_cgroup *memcg)
> >
> > Can we rename it to `mem_cgroup_calculate_protection_path()`?
> >
> > BTW, I see that the only caller is in vmscan and it passes NULL as
> > `root`. Do we need to keep the `root` argument if the new helper is
> > only used for global reclaim?
> >
> I'd suggest keeping it as is. This function updates protection along the =
path
> from root to memcg, and could be reused later. Note that
> mem_cgroup_calculate_protection() assumes the caller has already performe=
d the
> top-down walk, each level's calculation depends on its parent being updat=
ed first.
>
> For mem_cgroup_calculate_protection_path(), it can be called in any conte=
xt
> without such a precondition.

I am fine with this -  keeping the root there. but I guess rename is worth =
it.

Best Regards
Barry
