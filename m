Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CAB28505E
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 07:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788076759; cv=none; b=QewWGwIPObpsgI+FysqyX8DhaccmbOns89zMICo/Vu0dFPPyZReAya/r2pXJlk+qCCaEyBhSxAFEkaDiK/N64iXBXBK5pSyOsZRjZUoo88gf+XnejPN/AgFT9dM2dGLYxS7OBuvpbXU77XRRZGA6ltxyn9u6Qf/L4eFIrTrKjE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788076759; c=relaxed/simple;
	bh=dktkFusJORwS0wg5TREbRvxTJv6WJ4glZJP83ZLSGXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JTw5RM3jUcvKpjXFjC5UFdLrTrIxJ30CdCqRy4wZRIg93TfSLsmjGO6ltcaPJ5uF7L9mdSWevA2JSzuDR1s6/5xe8vtIT6qX2RxeJ3g8gWbjZIPa3ecBEyArranUwSaphTL2jkPAGeSvZDixBXO/00xi+P1iZZ5ESGgRF737yog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIw0faM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIw0faM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A135C1F00ACF
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 07:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076757;
	bh=NrLDNBRCYN+jXa4vhl3946i3kCe1JZe5SP3/HQaL10U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lIw0faM7AwczaPglu+Ccvr2HXhVNbDDmxWNjJXQ5CjV4eGSR/yPsCnHUn0p9Mg/qc
	 YVgNxuBLmyqhygOdOIphzwelaalJTN36rqN6TCmLGicMk+9y0yevruc6IfODRc0cyR
	 U3zzrMNXe1Putuqul5Ssc94V879+Q2V5g6+af2a9Xy7hIsEBGjQV/6HFr+1Ee11m6l
	 mZiy0JqnURPf2rmZh48RhFX6cuj4XWA0NH7RCsHlEqvtdvyhY8XhvhiWGvcsoacEYf
	 TlpjYailZ0wm6CauWCtPmJMEf5PftYSFlRFfT0BANi3bs4iPpk1DdjKjveXZe40lcF
	 5iRg/W3GhgNMA==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e55b62640so129776685a.0
        for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 00:59:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrnoqjY5Yz06l9BFfGIJY2xc+UyXbWX9+mjtH4ES/a8d8eJkjkLwXRr4UkI6uv6V6pX0aS8Y3Ch@vger.kernel.org
X-Gm-Message-State: AFuF++kxBitgLbkPILYwQ0C3H8TNxN2YOPMMK47FDmw2hfhQWGuwB6b1
	xjMGDPQsoXGaaZBsih0dQOk2tn0mAhWqEHcr6ht4xae8Pj+U7YYhYk9ogzYeN6VwLTNJEhr4OYO
	gzQsTykHXFSdwObbnZbBMS/Apk9J/Z2E=
X-Received: by 2002:a05:620a:29cd:b0:915:a953:4b9c with SMTP id
 af79cd13be357-93913749780mr1843635385a.3.1788076756998; Sun, 30 Aug 2026
 00:59:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828110919.1324028-1-ridong.chen@linux.dev> <20260828110919.1324028-2-ridong.chen@linux.dev>
In-Reply-To: <20260828110919.1324028-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 15:59:05 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wp+O3AX2YQMsU5iHNZX2tYJ1TuSH30eyp=_XeEb2gSrQ@mail.gmail.com>
X-Gm-Features: AcwNN1VSR0ETjAivAghBgogeIeAmAQL0JT7gsTA1npC62VHF_x-d0gDpe0cIFYc
Message-ID: <CAGsJ_4wp+O3AX2YQMsU5iHNZX2tYJ1TuSH30eyp=_XeEb2gSrQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/page_counter: avoid integer overflow in effective_protection()
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

On Fri, Aug 28, 2026 at 7:09=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> effective_protection() scales a parent's protection by a ratio of page
> counts, e.g. for recursive protection:
>
>         (parent_effective - siblings_protected) * (usage - protected)
>                 / (parent_usage - siblings_protected)
>
> The multiply is done at unsigned long width before dividing. On systems
> with >=3D 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
> protection value and silently breaking memory.min/low enforcement.
>
> Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
> usage and parent_usage are not read atomically (a child is charged
> before its parent), usage - protected can briefly exceed the divisor,
> making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
> the ratio stays <=3D 1.
>
> Reported by the sashiko review tool [1].
>
> [1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@lin=
ux.dev?part=3D1
>
> Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low=
/min calculations")
> Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>
