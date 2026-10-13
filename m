Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3174718EF;
	Tue, 13 Oct 2026 18:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791914556; cv=none; b=VYuGyQ3XxnLAwnrpMS5po8UHUeq29IDzsZ1nOiQ5WrixTbMoN/HjwHCif22omFFp/BwVTguBwMhsRSk5+27zc2f/a9nV1FqlmEhP8/vUew0KTzgJqaXWLwVtOl1cBGhgk1wAHScQh9mFNvYJI3PEmtJPpZgRoOdw65bPz96E4/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791914556; c=relaxed/simple;
	bh=4mU1lwDPkzUgQW8b3yzTVOWvbnN10Uk/B5D2OZEUK7w=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=XZ1C8xIXyE6BalhFjFlebsUji7GlWCzKCnCjgb/hMyYiCg6izWbbKnHh3V+WAx9T9Nhf8TPZ95TgfK/ISnSiEXJIOlARadNoFSt2gNsaP/YmjGaFIU+2xzJKYVypKZhmmwXwVBQ90pcuRX185eULi49jSiUwpkyZzyVCntJiXxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnBzFRZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnBzFRZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713F01F000FF;
	Tue, 13 Oct 2026 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791914554;
	bh=MeeFNFJubG8PDj6YUUF1sN/pCxwclu2LdzrnSIGxX0o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WnBzFRZjmsBC607KBUWP8qW7aDvZBspvMh7ObL66WWuQx55u3HcdvyIVhufA0ENcM
	 qXSGowXhE1ZU6UrVCJdVJw1Wf4xLzxlJkbmcXXy3Z2+KxXHWZf//8lbdUeCsW6XQ8P
	 Vin5m3r7v9fD0weSI26xXyQMXV60Nyu/ij0JN29ACHcxfg22Ogno5BzUhiqlUG3Tt1
	 RAZQninW4PdXffL0MDnnB/A930Sz2EKLhJcSzjpI2ol/QPp47pR/IuPBTyEiEiLImr
	 iYt8gMedUW4Te3yTHOtSUWzEt4Zh1neGo4N7ALNhMjjcQExZSIXagxyGILzXEFEZVl
	 MTZYxFAm8ZgRg==
Date: Tue, 13 Oct 2026 08:02:33 -1000
Message-ID: <3eda489898ebf7c848ce61760af745d9@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode selection
In-Reply-To: <CALOAHbBE_1ssK_26c-UY7N6WxhkVNpB6v9WACVGaOiWZ5zchCA@mail.gmail.com>
References: <20261012120438.52849-1-laoar.shao@gmail.com> <d9a3367a1852158f60cc2e89677fb12f@kernel.org> <CALOAHbBE_1ssK_26c-UY7N6WxhkVNpB6v9WACVGaOiWZ5zchCA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

On Tue, Oct 13, 2026 at 10:16:32AM +0800, Yafang Shao wrote:
> Part of the consults are keyed on struct folio rather than struct
> task_struct: the folio surface answers from the folio's memcg, the
> owner's request, not the touching task's.

Right, and I take the prctl() point too. It's stable uAPI and too rigid
a bar for this.

My suggestion is to start smaller. The op doesn't compute anything
from its inputs. It returns a fixed mode per cgroup, and you don't
need struct_ops for that.

A kfunc that takes a cgid and a value would do: -1 for the system
setting, otherwise the existing NUMA_BALANCING_* bitmask stored per
cgroup. Task callsites read it through the task's cgroup, folio
callsites through folio_memcg(). Same capability for the use case in
the cover letter, a per-cgroup field and minimal plumbing, and the
kfunc can grow later if a real decision-time policy shows up.

Thanks.

-- 
tejun
