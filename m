Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9532620DE
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 10:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787997901; cv=none; b=Ufs2/sfGhr6KX7Lyj60tu+qWCWzg1VeftLvGrTZZOlxDCAQNCNkvdC9NvG/sOy01S5M3Ts7vGyzgDDAIyDNq1fHxn6ZtcHMDcbM13ogNezmdP/Re3xfHU2w+4vSHeQLHBVTG5GMtL7V9T3fJO7NOJJITWsGmbnNcdK587gO2Fhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787997901; c=relaxed/simple;
	bh=Bm1bDKma1fCaZlo6UL6h2FrDywYhUARIBqg2ikagqJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TtkFG1XnBD3RL9CgJf3gZ9jZCLP45z9dKTH4zmOKOiFh0a1kgoRSDf39nvtDAAdnWptzIfmtDfZqk3cyzrON6ZWwR3sa07vov1it8MMkK4omwjeEfdTtk0U/3R2Ime4cnb73PRzdJBhgjqNIfcig3TPxLP6BkXc4XYW34mWfH5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+PqkQXG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+PqkQXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595431F0155F
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 10:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787997900;
	bh=Bm1bDKma1fCaZlo6UL6h2FrDywYhUARIBqg2ikagqJI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Z+PqkQXGYbY9/A0mRMQa8SBREguvmiQFpgCS7ncHAY/AUCJM9o2SfDjA6hsgDq8Ez
	 +3Mm0EWs9yOftNpFTALFo1/T+66ksL0gVV4A1tpo6YlluRt4TItKIvveb2VOCnHa5N
	 qyZ9/zp+VynmUSel3VpOHTfB2nLDy+USLgjJ+/6uKQH/b1fYBUM9k5lrwfgdejEja3
	 Joxpavp74DPSqhjh8YnFLypvUiZai7OoyEhtJgwIzBUHExOlvyYAEdSq6CiIpPS8OC
	 lD6aF28g15EroYcIZFcC1mU3OeeQYx5PmP4jCJ/hKDR0BsKQml+m4q+iBuPkCku4FP
	 2yb0Jf4mwuH3w==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-90cbff85fa9so12726176d6.2
        for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 03:05:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzCs6ZBeg9B+2Bz4cdb8G+69lls5qmpGopx3SDQRY5ZxzLOtIe8Mhm3AijmeUeOGQQpawmp2Uh7@vger.kernel.org
X-Gm-Message-State: AFuF++lvRrKz0k6NKjaw3heDIToBgZ8/3461L7NZSfoUdTZD9SZTF19h
	NEDzY+9Yd07e/Kppmhv8kSIMwzubNhfi2PomSDI++VbKnsL6xcwyIN5Uak+odygxpkmoCcC+jBz
	0uE3pba/ODASQw1eWBNgxsF7kGwe0tFQ=
X-Received: by 2002:a05:6214:4497:b0:90a:7fbd:ea89 with SMTP id
 6a1803df08f44-90ce0e572dfmr180465806d6.1.1787997899307; Sat, 29 Aug 2026
 03:04:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-4-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-4-d9f1c75549c8@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 29 Aug 2026 18:04:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wU7B_Lnz_fbKOUsb+2fs1D3GrMcPq7FBLN4n4M7LLwBg@mail.gmail.com>
X-Gm-Features: AcwNN1X-K486iK9cL85ffaV_ppz2Dedfrrpz1iVvNLwjwGEYt4Lbvyldsp-xaSY
Message-ID: <CAGsJ_4wU7B_Lnz_fbKOUsb+2fs1D3GrMcPq7FBLN4n4M7LLwBg@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] mm/mglru: move max_seq read into walk_update_folio
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 26, 2026 at 1:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
> each read lrugen->max_seq to compute the target generation used by
> walk_update_folio(), then pass it as a parameter. Move the read into
> walk_update_folio() itself so the callers no longer need to compute
> or pass the value.
>
> The max_seq read now happens once per folio update rather than once
> per walk range, so folios always get promoted to the current youngest
> generation.
>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>
