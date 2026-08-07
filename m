Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD58C277CA5
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 23:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786145056; cv=none; b=IgB1XwAMGgXbOIiUUtnK6Db5NeI/ZXabRcI3iptdedSAt9gdGphVC8YGGs6OUb0VOcTm5WGxOeppX84V7OAVXylmFQvMjX6WiJFkSzPxjK5x3RBTAaufJjwhCBgp/u5OsbVbyY1dpCWxUYgdvvTvGqYZ5RVtrOUpwUn+vctfpNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786145056; c=relaxed/simple;
	bh=olMPjnRP79g9pK0k/LaANk0plHKsEj43HVsO0fZpKy8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C6N3IsyQLbxrCVXUhbkky/eOCCuI7H0QyF62jr/R5qZG0hT6bpQVvLc6oZbYyiWr1r+reyImLVtgspKWv6YB5hJEimV8rw1eZ3H08gQ8StDENGJQrfVMI85qoTCxpKngFAYArKC1Ui2yJxUan1YOn5V4yHYCsdQ3dD39NoP87NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bW1nRoUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bW1nRoUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6024E1F0155D
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 23:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786145055;
	bh=olMPjnRP79g9pK0k/LaANk0plHKsEj43HVsO0fZpKy8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bW1nRoUZ4Nqa0gaaExwXNNLFMszt80t48rv/8pjtLhVy4VZjTxoIVUPQi9U33TRWk
	 yYVMwo0nd6iByF/TdWFv0lqC2ZMW10TQLvMa4cEq3KnBPLUKaSqz6Xt2yOMV7IXfkX
	 4XKrbh7lLgnCGhN9HxkyDgkSD2DkTm2okvf37Wlr3lHAGK2yt83aqyXvaBDnVGjPmL
	 8lenNkr5kBl3mCk7BE3+mNthg8zFLZjB+pChU6Nfcwy15vBov+0LZAOo9mWvyAillf
	 xStzYlcq6rfJoRqrHX4G/xWUHBUjvmc9WtppdLj4AD7TvJoL8xlDbS6rxmsvkSRTnt
	 +Qcyf+ZHWZMQg==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e67555e24so3590685a.3
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 16:24:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoACevrp9fpQQsoccFKuAyPNBBMZ3D0qX9XMkbBSnjxB1QkJ+bRjRQM5dIwcYEeCO9HrgqdSEQd@vger.kernel.org
X-Gm-Message-State: AOJu0YyYkCaBZ0935Lwuu+1dYQP6M6WnYJ8a+blJUm1ppxX87CIWaTNY
	usBN3zTgotFu35ab0ju4u1BxsLK239og9tRrjWhCkPSCrFs21CLIjeCIjWYn7av4dH+UNurE6sO
	8A6ZOb58V24tS6ddagEisTJQmO3wtNao=
X-Received: by 2002:a05:620a:2620:b0:915:b852:4361 with SMTP id
 af79cd13be357-9367979c776mr449492985a.20.1786145054699; Fri, 07 Aug 2026
 16:24:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-4-xueyuan.chen21@gmail.com> <ee89226e-64b3-48e6-9be2-4934c23b729f@kernel.org>
In-Reply-To: <ee89226e-64b3-48e6-9be2-4934c23b729f@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 8 Aug 2026 07:24:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ykCQWuYyAxOWk5thUOZpCAcGb+W_uCq4KVAFffo2Cn4Q@mail.gmail.com>
X-Gm-Features: AUfX_mzqI4seBIKJEvk6MKVPwksdfmT-CUfAVDeDPy-xD6vYQyx7NLbgiH7dTzU
Message-ID: <CAGsJ_4ykCQWuYyAxOWk5thUOZpCAcGb+W_uCq4KVAFffo2Cn4Q@mail.gmail.com>
Subject: Re: [RFC PATCH v5 3/4] mm/vmscan: avoid pointless large folio splits
 without swap
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 6, 2026 at 9:58=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 7/30/26 14:23, Xueyuan Chen wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > When swap is disabled, exhausted, or unavailable due to memcg swap
> > limits, splitting a large anonymous folio cannot make swapout progress.
> > The fallback only destroys the large folio and inflates split statistic=
s.
> >
> > Use -E2BIG from folio_alloc_swap() as the explicit signal that splittin=
g
> > the folio might allow swapout of smaller pieces. For other allocation
> > failures, keep the existing activation path and avoid the split.
> >
> > This preserves the split fallback for fragmented or partially available
> > swap, while avoiding it when there is no backing space for any part of =
the
> > folio.
> >
> > Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
>
> Do you have a link to the report?

No. Nanzhe mentioned that to me verbally.

>
> I assume this is not Fixes-worthy.
>
[...]
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David
