Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD453BE62A
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 03:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785124492; cv=none; b=VOR0Cus717oEWJchGTs9+EPJgRo7srtYkQrU7qo08/9xWMSi/dyKbc+AnD0+O9JaJYbBdfXoVBiyKJCpjDSSJv8B6270YmCyZT9Fyplec4WGnhGGGhchMF166lYrkGDTTmi3b/Blyqw9dSxqOFB0vXiX6NogMYcddSS9uXVIlbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785124492; c=relaxed/simple;
	bh=lMyOlwFH9ojHCoaUqhlCOyDhZe4zgJ37rWVmIxNhIAw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eyFUmqIK4kNfK3MCLXpy7IG4Pe/SlQz5HR2J1yctyK405CI2E6NcGZ3GbbsjcUzRKX4AMRJ1b+Asx9VSlRroo0YSQPySkT3ZC8QHyKCK+poR/8dJ3XhvgBpHeKqYlBy609NhFMQzKjP+EKkdfK5AncWyQ7Eb1i4LTQQMybPl0/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKN9vZLq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKN9vZLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6231F00ADE
	for <cgroups@vger.kernel.org>; Mon, 27 Jul 2026 03:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785124491;
	bh=TDt6XRhHBziQBa/u0iomOboiTDHrthJqxaelhr7ao5s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YKN9vZLqnJJ7q87b9lUHfv/i4EC5YT4QIWKDJZTDDJz8evKyrlumbgRx7KDCP+u8q
	 BkCsNa6ssFLofdZ0GWRxItd2Z1HiRo1NY9p6+yND2psKpnQHKtmf9dwZBbKlztxHst
	 GA6m+/I3budEwzeov88L4yob4bpcyqnT1/Yo/qCAQqZE2zXC6qksOtpppeZ43JShRw
	 /uBu0XI/OadQ9QhBPsT4L3YRehwzspndzDgNOq3G0cy1zcof6IDM4v6hhoIEto7J8s
	 5oeznMGda5AtsCwvY1QMVEh0gSszSCN4ht7qlZC5xJ14/N9A0d+9tyscDCckVq5VIi
	 uBlgTKobUdheQ==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-930c0f9c1b1so154497285a.1
        for <cgroups@vger.kernel.org>; Sun, 26 Jul 2026 20:54:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqdx+1pd78fyiCbHuB/4JS1k2AcJ/FPu0lY207QVMsczp2Y2WOKuvPdpeUORF4kOMod/nDXt+JA@vger.kernel.org
X-Gm-Message-State: AOJu0YxrrKyw02+dqxyIGxuCUZcarkYmXfzipVwwDhFGNDyNGcYp4uZ8
	bS7B3pnd7Qk/pFpmlB0pougcv+ZlxhyyTwG1RHlmxSh4iM1Q+AkGkpziqedxkPiWXe/X3iJzABH
	67MrwWxyO6H423GH25wzdguTDzhD1lMI=
X-Received: by 2002:a05:620a:2546:b0:931:403:2442 with SMTP id
 af79cd13be357-932df6576a9mr732957685a.18.1785124490445; Sun, 26 Jul 2026
 20:54:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714121529.2237261-1-wangzicheng@honor.com>
In-Reply-To: <20260714121529.2237261-1-wangzicheng@honor.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 27 Jul 2026 11:54:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xt6FhvRgmPyoSKdfHd12V+miOZe6SSkg7GGW6TzJFbdg@mail.gmail.com>
X-Gm-Features: AUfX_mxeJtLVdMRlseYd3JXsOkBoHM_0YgC_24_IrWAn_07tj9FPGYqXiGkmRio
Message-ID: <CAGsJ_4xt6FhvRgmPyoSKdfHd12V+miOZe6SSkg7GGW6TzJFbdg@mail.gmail.com>
Subject: Re: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
To: Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, yuanchu@google.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	weixugc@google.com, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	willy@infradead.org, denghaojie@honor.com, baoquan.he@linux.dev, 
	kaleshsingh@google.com, tjmercier@google.com, tao.wangtao@honor.com, 
	zhangji1@honor.com, wangzhen5@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2026 at 8:15=E2=80=AFPM Zicheng Wang <wangzicheng@honor.com=
> wrote:
>
> MGLRU inverts the reclaim order when anonymous memory is faulted in
> bulk: anonymous pages sit in the young generations while file pages
> sit in the oldest two, so reclaim evicts hot file pages before cold
> anonymous pages.  swappiness cannot correct it.  This series adds a
> per-cgroup proactive-aging operation, memory.aging, with the
> observability to drive it as a closed loop, so userspace can rebalance
> a cgroup's generations before reclaim runs.
>
> The problem
> -----------
>
> MGLRU places pages by access path, not hotness.  On the current tree
> the entry rules in lru_gen_folio_seq() give:
>
>   - faulted-in pages (anonymous pages; the fault path sets the active
>     mark) land at the 2nd youngest generation (max_seq - 1);
>   - file pages from read()/fadvise() land in the oldest two
>     generations: non-workingset at min_seq, workingset at min_seq + 1.
>
> Pictorially, for a full four-generation window::
>
>        youngest                          oldest
>        max_seq   max_seq-1   min_seq+1   min_seq
>        -------------------------------------------
>  anon    .          X           .           .     (faulted in)
>  file    .          .           X           X     (read/fadvise)
>                                             ^
>                               reclaim scans from here -> evicts file firs=
t
>
> Reclaim scans from min_seq, so file pages are evicted before the
> anonymous pages two generations younger, a hot/cold inversion.
>
> swappiness does not fix it: it only selects which type to scan, not
> the ordering within a type, so reclaim can still evict hot pages.
> swappiness=3D201 (SWAPPINESS_ANON_ONLY) just flips the inversion to the
> other side: no value recovers a correct hot/cold order, because the
> order comes from the access path, not access recency [1].  This is not
> Android-specific; the same file over-reclaim is shown on servers and
> worked around there by forcing an age iteration before reclaim.
>
> Why userspace-driven
> --------------------
>
> The benefit is workload-dependent: file-cache-bound servers gain from
> aging, anon-bound servers do not, so no kernel default is correct for
> all.  The kernel also cannot know when to age: on Android the right
> moment is the foreground-to-background transition, when the app's pages
> are cold but their PTE accessed bits are still accurate from foreground
> execution, a framework concept.  The kernel therefore provides the
> mechanism; userspace runs the loop.
>

Hi Zicheng,

The problem is that when an app transitions from the foreground to
the background, it becomes inactive. As a result, you clear the PTE
young bits accumulated while it was in the foreground.

We basically need at least two rounds of scanning to determine
whether a folio is hot or cold. With only one round, many folios
that are actually cold will still appear hot because their PTE
young bits remain set. Nobody clears them while the app is
running in the foreground.

So I'm really curious whether aging should be performed while the
app is running in the foreground, rather than after it has switched
to the background. If this significantly improves the distinction
between hot and cold folios, allowing reclamation after the app
moves to the background to reclaim genuinely cold folios, then it
would provide a much stronger argument for an aging interface that
only sorts folios in the LRU without reclaiming them.
I have a feeling we may really need an aging interface that sorts
folios without reclaiming them. We can then use the sorted LRU to
reclaim cold folios whenever reclamation is needed.
But your use cases don't convince me :-)

If the goal is to work around MGLRU's swappiness behavior, we should
fix the swappiness implementation itself rather than introduce an
aging interface as a workaround. If the concern is swappiness=3D201,
I believe swappiness=3D200 will be a good choice once my swappiness
fixes are ready:

https://lore.kernel.org/linux-mm/20260726122123.7614-1-baohua@kernel.org/

Best Regards
Barry
