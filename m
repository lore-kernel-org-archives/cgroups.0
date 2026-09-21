Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331953EE1E4
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 16:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790007121; cv=none; b=ejVkhW7BcYSbKfyF+YO+l0XievLtHmv6jdPgfQZRVfWVJPffMQ3rqqeUeOvzVooieFxj4Ki7v5mkHnh9t9SWwQ19MgARWGQkCs7UGR6iU8pAKbAmG1Z0s72vueeo3r4iz+SscKJteVww74CWW79uImqyrCkBc+V+m8Pqz4aqXoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790007121; c=relaxed/simple;
	bh=MDXf4pN9TxBovN9ogrsp8I2hmcVR+PhSHUrds8gcYDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JdE4Eus2jE61z+j3bhVVEvBkWI5lIP6u+xJaxh5u6x6f1V8hp408bXqDpkdn+qyJ8IsjFfU04bbcvms7yA8iDW2GWuJQz9QKdLavmOhpXLl4UNzopzfZCjhzgfcigtnSACqcbOoZHsZxfinEc6q2ojbzbeIv0Y+teFHfYfa3jko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgdVCj8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgdVCj8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20F71F0089B
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790007119;
	bh=Bp3IBrDxSg3j2mpmgJ6jbKGXoqJCAZK/XpOEiySiNrk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RgdVCj8Y8MEZpnY8Ynmtz5Dy2UDP7d9xzKnUit65T6xk8+YMxnlM7DSiiYU1AOpBR
	 zvWmmx/kpNPrEVC3+dkPUlbTSKUBrMFc4ZXp95XtAlJPh4JJw1/U/vjJiKx1N5IYmX
	 zlPLV+yHk5U49q14WR5l0zjfqYYW3OTrPp4bOCWFyv6a7UtVjfKNC70fnTTvYnoCq1
	 0vbvbfWNLVfS6U4cWKSFf5HBZQKiOxDqOVIvkjcb9Vui3oPDdPCOzkzSdH9s20LCGn
	 JVgWNC0h3NP3RpXUOHAGfajyXdsgDKXaOL8ztYwgAbjK8lb6758XnPMpoAtLJUp/th
	 u1ZKVFeYiv9Eg==
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-910531ea7feso30728776d6.0
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 09:11:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwHJ1tiiJziB7zORu3r5gCxdxxrYlYAcctAHA67vX529+dnazaryTnyq/J9heQ/Trxe73TidnPj@vger.kernel.org
X-Gm-Message-State: AFuF++kG31PjHnutF9tXRecxLvlfa5BDnCFrt+B44cm+wAPrR6aI++yH
	L3ApVJxzI9hEEuyAsCbTsYYm9neJt5oeuDcUaeHWN+FZxV1L840Rwzt6WkFQIFPRHfN/ySD2d2N
	DfvgaMLDTMpmNxsTaJ3FA93kEnxBjg35j9fzBc3L1tg==
X-Received: by 2002:a05:6214:d88:b0:912:517b:7bc7 with SMTP id
 6a1803df08f44-913fc9691bamr12933946d6.38.1790007118678; Mon, 21 Sep 2026
 09:11:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F>
In-Reply-To: <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 21 Sep 2026 06:11:46 -1000
X-Gmail-Original-Message-ID: <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
X-Gm-Features: AcwNN1XW2qPwRKFrDJtBwtgJeNORhYpDb8TYjJkQ0_71FBj_TGhnmFQwOxcat7E
Message-ID: <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
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

On Mon, Sep 21, 2026 at 2:53=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Sun, Sep 20, 2026 at 11:43:59PM -1000, Chris Li wrote:
> > On Sat, Sep 19, 2026 at 3:53=E2=80=AFPM Gregory Price <gourry@gourry.ne=
t> wrote:
> >
> > Let's start with the real question: on your fleet what is the max % of
> > zswap memory compared to total RAM?
> >
>
> You're asking me to predict the future.  Any number I give you today
> will be wrong 3 seconds from now.

No, I am not asking you to predict the future. I am asking about your
history. What is your current trend.

You can not even provide a single historical or current data point.
Do you have historical data points to back up the claim of this max(%)
large swing?
>
> You can't know the compressibility of memory until after you compress
> it, and requiring a user to predict the future by forcing them to limit
> the total amount of workload compressibility does not scale with the
> number of workloads of variable compressibility of data.

You likely just need to pull a SQL query on your fleet to get that number.

> That should tell you that your model of reasoning about this issue is
> ill-suited to address the problem.

That is what I'm suspecting. Nobody in a sane mind would want to zswap
100% of the RAM and maintain reasonable SLO.

Chris
