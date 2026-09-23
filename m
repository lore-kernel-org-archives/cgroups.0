Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07981351C10
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790147468; cv=none; b=IjiJF31ZTnp7xjHZJM4YHVaxy3N6WzIQZLtDYgH3Drs0IJYClp4ETaNfdPs5e/XgNEJmYQg3ykgDoekEAi5e/W3+SyfHjphEe05yW45tXClNi9tkevdYByuD3zPS8RZqT31vK82bdvIKMX+jASyawaxzlasXlN3CEe1C6xEMUmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790147468; c=relaxed/simple;
	bh=tMhv2qOhzG4jrkkzinGONLyAHB+FkZzKXBAXmbOVLII=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eDvg/sz/QOVxgB2jKRQso5AWrTkyTv5iA8aE8VzexyaF3J+dndgHlw3jNBe4HVL8uXMa9BWyrs79vQBIyt5BX929U4YDUEvnSzt3qsxP3E/RrI4M6GAfyu+kyzlB921HLEP/ssClWIF+if+jDOdAVzviPYsXY9ijoSvvGQnTsxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4K7mJVk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4K7mJVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24441F00906
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790147466;
	bh=tftRg/27iV6vOu9wnOe9xdmjMcB/et17gUJyLajCKAk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=e4K7mJVkpkC1fa5WHn0jgNxeZgLiKbJ0V2NjaEG3qzCK5AyydHhTDbey8BS+/L11W
	 /2S046vecEhv/E5OwuYr37Y8lSMs1597S2iq3IQ/oI552uwUefIem5Tr61+VzhHBXX
	 CGbk5246ul8BR45uuZbPESGnbhx5cvZyFhIxpkywKDMvmuPBL6D4EkTQis96rJbyyx
	 5aSM/icXeu7OwogW83YvJZe8jwGUcbuikeJ2plZxXoZOXUQ5bEqOXFwVeKuYokn2TJ
	 LeRsbHsveLPQ1mfeIzgbE+giOj2h3y2bKpY9AQ8uLJdHaWgr5boSw5IMiA183DqQyY
	 3y1PR8hT30oxw==
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-895eaf306cfso7766697b3.1
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 00:11:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwrWMMdM668YDfheu3FW1dkf8E5/wyYc2VUPayhIkcpRzHgOUj7+Tyb8kVzG1sW74qzeosAvM9/@vger.kernel.org
X-Gm-Message-State: AFuF++lel7PdSHAsIbiVyRBgSgiLEJ0VhS6cupZjGWSWPeMBZKTUTD7+
	bROsLgCxVbqNIT1IZF75oaXi71TQ51ZU3gWK3qo3ahxcRCdeoR/9+KCEzv16aY/RKbJvKO+KjUh
	ApJG3IefJO7DQEVMQ8ezFthd7MZkyrCWSXaazTHVuTQ==
X-Received: by 2002:a05:690e:b4a:b0:66f:c1be:3186 with SMTP id
 956f58d0204a3-672d59e6f9bmr769388d50.93.1790147466000; Wed, 23 Sep 2026
 00:11:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F> <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
In-Reply-To: <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:10:53 -1000
X-Gmail-Original-Message-ID: <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
X-Gm-Features: AcwNN1UwLMqYNrXn7OTzxPK_RQ9DWuqFMbs5fykDFtZyEsnuAKIyTcjTdWAUOSI
Message-ID: <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 5:53=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Tue, 2026-09-22 at 05:43 -1000, Chris Li wrote:
> > On Tue, Sep 22, 2026 at 5:20=E2=80=AFAM Gregory Price <gourry@gourry.ne=
t>
> > wrote:
> > >
> > > On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > > > Right now it has 64GB of memory.
> > > >
> > > > That is exactly my point. You are running 1/8 =3D 12.5% system ram.
> > > >
> > >
> > > Chris you are missing the point
> > >
> > > Zswap:           8812236 kB
> > > Zswapped:       24927876 kB
> >
> > I am well aware of the point. The 7%-10% data I provided is before
> > compression. After compression, the real saving is about 1.5% - 2%.
> >
> Here I'm at 28% without any issues, with room for
> more.

28% is one thing, 100% is a difference beast completely. If you
haven't tried it, don't assume 100% will behave the same as 28%. There
is a point where too much zswap makes the system unusable. It is hard
to pinpoint the exact upper boundary. However, figuring out the upper
bound larger than that exact boundary is not hard at all. I haven't
seen any one can use 100% system RAM sized memory swap out to zswap.
If you have a data point showing what that system with 100% swap to
zswap looks like, please share it.

>
> > You are not listening. The boundary was set due to feedback from the
> > application SLO. Those are real deployments not imaginary usage.
> > Please respect the user.
> >
> Different users need different things.
>
> The kernel needs to be able to accommodate all of them.
>
> The kernel default should accommodate the people who
> are least capable of configuring their systems.
>
> Hyperscalers can set their own defaults across their
> fleets. They know how to adjust settings.

They can use a safe value, e.g., 100% of RAM. Let the people who know
exactly what they want to swap configure the boundary they want.

Chris
