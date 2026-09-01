Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0B3357D17
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 10:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788258778; cv=none; b=CqKTLUTLtAXwZHN7mOvmUzHGigrd+bFg1a87GWn4CKHXiqf2yjDcNbgH0Whq3Y9/AINysJkmAIFedIX2Tj6Z62XgVjMxZZOj0eQMElygJhrUmvnz6n807E2tTUMh/uOnv/EmSV5c3A1nt6bSQ9du4hNhHo4vtsl6b7UOrZ7a/BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788258778; c=relaxed/simple;
	bh=kz2UKluoElEtbtcr6f/jgfNgmNiv9DhwSNGNfkgr3+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mUnAglrcEDTpAPIjQU0ogCeWGne9SJdbi6tjI4WjbKAJvP/7TbgkKeO6fmwen3bn1bH+1QsKgV2UNNrQ5RmGey0uszgPl/XTqp3YhZqLRlE/2i7rcYYyhEAfdP8dmVxpSFfYVZAGCcP9Aw60OF2bz1jToarPH2GDXJlqerdyReo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZaqD2/r7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaqD2/r7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5304D1F00A3E
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 10:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788258777;
	bh=kz2UKluoElEtbtcr6f/jgfNgmNiv9DhwSNGNfkgr3+s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZaqD2/r7DOFhHjl3Rwijm+UVxqJOCWeFYyAuth1jKdEaSwgX50/BRaHJ7PDb884aH
	 VdBZsDI7gTFyvvjMplFzrrfv+TXrux6NhVTT0HTF1qx+tvxU2w+d2YijZj+gf6ohOk
	 ER8cZ7J+1qlOb0Hlg4ov1mDlck0NQ9vn+4rfTJNdHRelnkwR+BMqOe+Q1Z0Xx1jnpa
	 U+LzaZLsAitBO+eRMa04FUz0WfCAvIN1iFrds9GtUeSe1KNamkywZ5OhiSPNLfiM7g
	 OfS84d2PNLPxKjEcXij0qmUmr6fAub7FeTX/Jj4nrctAPFC/Ue12sKvrnXWBXGMq4y
	 xPzC4xCx38Zrg==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9392aa26b25so80507685a.2
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 03:32:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq4wMwJiN298zoz+ybZAU2zkXAi88ZjK37WRVTkvmKdxtX07Es9RftvPwJ+SXBgv0hXDWOzrivv@vger.kernel.org
X-Gm-Message-State: AFuF++nmTf8/EXBPW7EMFO+N59N7winYJ4q3YDCj2iYOQLGNZqGCKATs
	xeCiW2m7UM48ezNeS8O+JzFb7E4wXATL2kGJ87aKtOekO+YwnEHBBN3CqvZxvapSJkvUsqcVCRC
	ajK9jW6LvYCYXcXBP0bFzrcN/e1uCCI4=
X-Received: by 2002:a05:620a:4487:b0:937:6ed3:78d with SMTP id
 af79cd13be357-9391390b4b4mr2930150285a.20.1788258776414; Tue, 01 Sep 2026
 03:32:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831-mglru-flags-cleanup-v4-0-2d15dde0d7ee@tencent.com> <20260831-mglru-flags-cleanup-v4-2-2d15dde0d7ee@tencent.com>
In-Reply-To: <20260831-mglru-flags-cleanup-v4-2-2d15dde0d7ee@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 1 Sep 2026 18:32:44 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xbXhWfAv1EaTW81yyNRDHO7HVpcR3uRcB9v5Afeck-5A@mail.gmail.com>
X-Gm-Features: AcwNN1XHWhtzaukFlsh3FhGGQunilwYP5RcrWIDVoEx7eVnU4Ym4-Iqdeoh4g2I
Message-ID: <CAGsJ_4xbXhWfAv1EaTW81yyNRDHO7HVpcR3uRcB9v5Afeck-5A@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 2:43=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
>
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.
>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM, thanks!

Reviewed-by: Barry Song <baohua@kernel.org>
