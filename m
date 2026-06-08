Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AC03D45FA
	for <cgroups@vger.kernel.org>; Mon,  8 Jun 2026 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780937298; cv=none; b=g7Gf8I33hrQsL8kRkf2Nx+VZJHMkTJSB7+w6TzCYa1jJnbT55DIIOqo6PKXko665oRpS6YmXFjJ1hKMfz/gtPXbmwnZMNLff7rSQoLV8QtNQgQj2WCxAx/6pBT+AiW/4WbPbAy26K2oTcS3O1wsqHf3Hs7cQjeyIxvfQzGcgwKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780937298; c=relaxed/simple;
	bh=r+1aT7JV1mm9b1js3VgiqFC8zPbQnRMTHWbScZDq/ik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dUzJEUpIvKme9ngnzmyZzq4nBLEi7jbgss+VSFLfutRVSE4/Da9EneUx9McMrglaXo4oGaOtAtbsO/zEczBfuZYWJLysNKQ0PQbL3cY3r3TdKtG7xs/rrzLFDoZlxY/KHyPsRjTxwKDyKfRluO+2kb4MiLaYpTbY25pCJHLNe7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNFl4nbi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNFl4nbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0BB1F00893
	for <cgroups@vger.kernel.org>; Mon,  8 Jun 2026 16:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780937297;
	bh=r+1aT7JV1mm9b1js3VgiqFC8zPbQnRMTHWbScZDq/ik=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gNFl4nbioyUbS6BJnQJHKF5QVe2+IOnv4urftYscKD/Ynp8ZqY+uyzuPjUQcBPikZ
	 UmBbJ4vXk/1Q6RysVfuW7H+mMIjRUShk8S7S+xrtGBiW6SMTHxD79GA4+jbCkJaGQM
	 HYlRe5jCiCDwhqLMKIeEixgrKlU4tE71VyGMan6XOl/kFmuY8w1WN4f+mK0pDQo/Wa
	 uzpPvpmdz6bBzz0ZPESbXzEO8zxV8fpiqTA6bYOtZsSjcQ+zppsLY0D+Fg2dNUBhky
	 esSDPU3/X4JBUSzLW3ux34eejv4w6lkczMheMMOx4F/2PXILOXa0v5e0+7Yo4zgJYm
	 pAt5j/yDoQbuw==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bf84a2b2077so84573466b.2
        for <cgroups@vger.kernel.org>; Mon, 08 Jun 2026 09:48:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9jZI4CNhvEOLo7pTIYgzQTtfQAH9OfsrCWVyXLrgqOH5oJINjEOdsjeT3R9QR+hiF7kNZ9bXBc@vger.kernel.org
X-Gm-Message-State: AOJu0YwG0m4njR9pJApdhv9Ek/XPsRydHQruMd2EZogEl7L55TqtNdvX
	35HV/EODj7buIzXpOCxI2L/v3Ao946gFO+8v4ZbMz+84uspBIgqyt9w8qADolzTorci3SBvBqOS
	iOhXcvburVhAAKwsoklwP0IUeXVSNIIg=
X-Received: by 2002:a17:907:c247:b0:bed:6e53:bb16 with SMTP id
 a640c23a62f3a-bf3743e5c7dmr827142166b.43.1780937296187; Mon, 08 Jun 2026
 09:48:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com> <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com> <ah4ZZGl7GYJf54Wz@google.com>
 <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com> <ah9i3uhh3PFiS0Uk@google.com>
 <c7870fe2-3588-79db-cbfb-bd6a2b78f594@gmail.com> <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com> <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com> <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
 <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com> <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
In-Reply-To: <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 8 Jun 2026 09:48:04 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN6VVZz7dpjNrh8n7wbLkqcrsROPm70MQQxO49HJSmMFw@mail.gmail.com>
X-Gm-Features: AVVi8CeeTbVJuFLU_KkBwyY-XLqJGYP-jt-HrmqRJi6DEDHgaMpdFvhUoRLKrPE
Message-ID: <CAO9r8zN6VVZz7dpjNrh8n7wbLkqcrsROPm70MQQxO49HJSmMFw@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor per-memcg
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"

> But OTOH, this does seem like a recipe for inefficient reclaim. We
> might exhaust hotter memory of a cgroup while sparing colder memory of
> another cgroup... But maybe if they're all cold anyway, then who
> cares, and eventually you'll get to the cold stuff of other child?

Forgot to respond to this part, the unfairness is limited to the batch
size per-invocation, so it should be fine as long as you don't divide
the amount over 100 iterations for some reason. Also yes, all memory
in zswap is cold, the relative coldness is not that important (e.g.
compared to relative coldness during reclaim).
