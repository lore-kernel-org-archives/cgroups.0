Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795361523;
	b=0zGjgDweZMj1YF2VWo+hWEZ8/D4oRrO8L5lCo9W6XdZY5YrZBBzCF9HiAeuX/fpVRaq8
	 LkMZDiUuGtH3HdoTDlMV/mwexa8LoGkEqSdbs98wtpQVx+xLe6EfZUuCVEPspkNgSfyyD
	 NNct8zoBL3YfqdeFetMt343hVaSLtDgHob5jeGeicAOYLsP3maVzpjyOdBOfve30xlkIQ
	 5TKb7W0UuxZy1rxbg4YSRnauPjPjV5H30MzqHuBwSQ6aoG1kSNVe2TWxi6iFe4ESdwOqV
	 4t+m+bbhwXF/3wmh11BIGCnmgD6wgiBObm2d6uF3hPjWEMFlY2sqr2hgiGiuYc3pTEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795361523;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Content-Type:Content-Transfer-Encoding;
	bh=NYFpjmsPtm5tW7G6832pWObwECaMPmu2sWxAUpoI3jk=;
	b=RKLd2k5AKbZP3Ml/QY9b8fp0jhC3Em+QeR9e+NJoRWny6SJqRLvdGFl1gFwsrQS9d6XA
	 RXJa+exi1rYNU2I5vNxeYH/q++K3yOZ+74EEaWIVbtsHes3RTga9Bli+F6WABmZ4IqPxG
	 dgay0F9HWF684ee+e/6fHyje0naAmth16VuVxXzQYxoQNn+FDYaQiyZ0M/qjdHjvYSjWI
	 a+xV9Pf4Wczx8kUjbBAUBq7jU2o89r9d42wHx6jGT/AG2tQZC88KG+TJ5IzPjeoRmhSAT
	 omoTeijsR10UA8pb1nzZMwRdegRl2XGCtE8alTEvNZY2rZzU1lS+aRtQcfu/vmcqe4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GDgqyqH0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94A8606A32A
	for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 15:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B94A8606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GDgqyqH0
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso22510105e9.0
        for <cgroups@vger.kernel.org>; Sun, 22 Nov 2026 07:32:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795361521; cv=none;
        d=google.com; s=arc-20260327;
        b=laGVJXSPmpUpNqCVmOvO/jcfON7eZsYY82jQnfzSwsAui6K/Z6nVtMPF0B7tcmkGuY
         LrTWYawVS4S45QuDLsc1Us0lhCQ6c7xH+JWnwEFNqG1VkaOeAq8UHbISBnJvMT4kKaAc
         LB2KvEe5zmZh/HZTpONjXMIOvaph9YwnnudNRacdUyNELOoV7I+WAplyyOA8lVkap5Rv
         i2TS7HGUifOsyL1RaehEyTvjNJviYaF4PmuDAvRkmQf9AqBZQ+T0a39ZG25U8jZU6V9m
         eRXeirDVIEXy6ywypKi3cIgbf2+MHzP/bi0TqUMvC8HzkzxkB+3g+1MhML1uJUCD1eT6
         M3HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NYFpjmsPtm5tW7G6832pWObwECaMPmu2sWxAUpoI3jk=;
        fh=Cys0oxxb7a2wCFgF7wg3MTB6/0wgZ6oCjjwKiNrgD6Y=;
        b=ik7L+vFvz9Fzuco0sHR4FVqWjNwFUqIKPYrWysptpMaZ+PCXQEwNQJDUklSbvH1WhW
         Hw8rK9Do1IVf2LZ0XReEkTFB2729Ilm9BTv70mOPCXD75CzPbp/uGVCTnQnEAjkWN0Xf
         oygE5xrQpXOcnUj/bkhZp3cV/BLc4fxOs1cvNiiMyKgQtbJFfMXPEyVQGLqsM6hfhxPc
         LXU+JHOT3XUEWIbf64MoZj1IE/DdTyWRjgrRywTTOTWXqNyO+lg2H13GbCOMIT9i12iN
         0eTl32rf8r6ImNgxMIUVRkSTCj9oYxiAwegsnqVXrJGOz3pGuYbbBxEf5yNbPiyanIYF
         XgVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795361521; x=1795966321; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NYFpjmsPtm5tW7G6832pWObwECaMPmu2sWxAUpoI3jk=;
        b=GDgqyqH09Skisb0RcI0q/2Ph5kOcC9liZDmq8v+txYgdch2/nXsG3HAHDqpAVz1dln
         nhlTn+MskzGW7ddHZEYCSTLSGjYpThPI6ZEqtODp3dkhEOdUB1HogKff6nf1Yi7hrVLg
         wSkTRLhkKlJ68RLwcmpUN6JQZa1dyjgpMdBxhM7bXOO++rGgxCTeSGSyDkyysr2cP0hk
         zROFRmQaNyrzcGXrJ7wtBvrT5rgbg8NYjB3J8EP3garr0p8zRbTvnTHZfROpRvmdihzZ
         n82OVN9msNlamWkZWRQm6XaGuJeXIKo1knCakO79lN/LfUBB4cWM/hyoTlCNVohpOc4N
         FY1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795361521; x=1795966321;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NYFpjmsPtm5tW7G6832pWObwECaMPmu2sWxAUpoI3jk=;
        b=bKeuPIwEaOu6Jwz8oeFFYqcvpJUinDT8Ve3alBzLnVaYPSVqV40I4sqI2Dya6Rz2ig
         UroAZg5G3Qf7hd+1OBCh7xnM5o4TJxD6q/4I3VW/6KREhGxQfo4N2hF71djjwNaac9QB
         s8fQHjSG/a/fJ43rXhSeWNRU0BBi1ukNI9OnPU6N6jc2cEAnKO9S6YUyRPgHKzIabdjC
         bDAF8b/gDbiOAEFgwkEfbznk9Z0r/hRXjBueWET9ZBryiezFZ9Eq+zWbio8QuY4LJ8UA
         4DagOuQ6MSaF8ZVPkEd/R6t7ywkztevWP3WICYpOLHr5C+hABUG1kxj6wHEIZfGGLB0j
         A8xw==
X-Forwarded-Encrypted: i=1; AL+hErGfZw6dI7ouC6eu51+91rZh9MAjftfENxrCKnETvKrTqpaPi3kagHyLbnnEXqLg00VqAICuIJus@vger.kernel.org
X-Gm-Message-State: APuU4Z9rb4u4cJOn2eU03H7tQqOsjI8585ojbbKrUGO8HK4qnN+BKPnA
	ZEddWN4NfytZcnqoKPlXSLwwN12+ZdCkcYactNlFg4cNuxsFAFKsaETSnRFMGufB8UJbIHIYtCJ
	shSPS8JR+a+/A6d5OtHQlLKwJ/pfCOKQ=
X-Gm-Gg: AZFdTZdBetdXr4ok6yvXbFfuATKfpQvz9vaeogBLzyxyBctebm9oBGq9JGqVSF4Kz1P
	vafoMRB2cCDh2ZgCZQa1ELlRlzYAdgSc8YaXwPmBpu5AWr75c3ErZtIG0DJcrI82aHNEeQlrZ34
	PsbHCnXckuvP1CaCYLGYyRLjmVjdhm2yM6/WlYJC3eEYkmTLfs/eiYlMwFJ3b6zrVd00rKvSXkZ
	fot/kbRcdvPztAYWI050r5hwGoY9tkq1V9aODlkFH6zdN9aPc0yNyYLv3FdkZNwfTAvXWfYjJdr
	vTSHWOldx6fsmFFbFzpjyz1+bZEndo4n7MLPCAwoOo51t8k8leRsBk1WIrpnj4w16/zLHTKPFLp
	ynbhR+PUW36RLrf6UtqQVwEvP6JeyfAxhBKdOIhFILpywXaNj7knCTPMwSdGhpF7nMzNQE/95+D
	zReBKJVDsuxOCEYSxpPFfyNvlTgLxjK/6TisoofOwHWPwcWje9a8a4
X-Received: by 2002:a05:600c:3511:b0:4ba:73f:ef5 with SMTP id
 5b1f17b1804b1-4bb88828304mr192354365e9.34.1795361520883; Sun, 22 Nov 2026
 07:32:00 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
In-Reply-To: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 22 Nov 2026 08:31:49 -0700
X-Gm-Features: Aa3M54oFs-onXEgzFSCUJR6noxWe_j7pdReKnjl-3Np_FarnqLTrTWVKv1OO0fE
Message-ID: <CAKEwX=O2McF-gyqJT2a8R5q79+QABCPjULrcjC2CC0v8TnXxJw@mail.gmail.com>
Subject: Re: Virtual Swap Sync
To: "David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 2:06=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> Hi folks,
>

Hi folks - thanks everyone for attending. :)

I summarized the points we discussed below - please let me know if I
missed anything or misunderstood a point.

* Control interface: Google is interested in a knob to cease zswapping
(which already exists and will still work in vswap world). Kairui has
a use case for remapping all swapped-out pages.

Vswap currently bypassed when zswap is off; per-cgroup selection could
be added as concrete use case arises (for e.g migration/compaction).

David objected that a virtual swap abstraction should not carry a
swapoff interface per se. Folks also asked whether making vswap a
mandatory layer would make the implementation cleaner (Nhat will
explore this direction and follow up on this).

* Virtual space sizing: We discussed using vm.overcommit_ratio and
vm.overcommit_memory to limit the host's logical memory footprint. The
exact sizing formula is still unclear - Nhat will follow up with
Kairui on whether it is acceptable.

(Kairui, if possible, can you respond here for your exact use case? Do
you want to limit physical memory usage, or virtual? My understanding
is you want to gate physical + swap, which would be closer to the
latter).

* Priority and multiple swapfiles: should not be added for now.
  No good use case for swap priority was identified.
  Multiple swapfiles were used in the past to work around swapfile
lock contention, but it is unclear whether they are still needed with
Kairui's new cluster-based allocator. If contention remains a problem,
we should fix it in the kernel before putting that burden on
userspace.

* Proposed phase split and charging (from Nhat):

  - Phase 1 - initial foundation:
    - Decoupled zswap: Let zswap operate without reserving disk swap
for every virtual entry.
    - Physical backing and writeback: Keep disk swap available as a
backend, including when zswap cannot store a page or an entry needs
writeback.
    - Charging: Retain memsw charging for virtual entries; keep
virtual-slot usage out of memory.swap.max. Actual physical swap usage
keeps its resource charging.
    - Usage counter: Expose vswap usage so users can monitor
virtual-space consumption separately from physical swap usage.
Essentially this gives you a method to estimate the logical footprint
(memory.current - swapcached + vswap).

  - Subsequent phase(s) - further support and controls:
    - VM_SPARSE: Add VM_SPARSE as an optimization after the
first-phase foundation.
    - Runtime controls (added as use cases arise):
      - Host-wide runtime disablement knob (and remapping of swapped out da=
ta).
      - Per-cgroup vswap control (for e.g, if some cgroups want
migrations/physical swapfile compaction).

  - Orthogonal use cases and concerns:
    - Cgroup-level logical memory limits in cgroupv2 (memsw?) - swap
developers will follow up with memcg maintainers.
    - Static sizing: Define the host-sizing formula and decide whether
another interface is needed.
    - Swap tiering for cgroups: Explore backend selection when a
concrete workload needs it.

Folks, please comment on the summary and proposal.

Let us keep the communication line open and coordinate on the next
steps. I will schedule something again.

Also taking a step back - once we reach a consensus on vswap, maybe we
can repurpose this series of meeting for general swap alignment? There
are other swap/compressed swap developments right now (looking at the
orthogonal use cases list above for e.g), so maybe we can do this once
or twice a month. My experience in the past year or so has shown that
we clearly need better alignment :)

I will reach out to set up another round of meeting. I'm hoping we can
do it one more time in December, but I understand that holiday season
is coming :)

For folks in the U.S, I wish you all a merry and festive Thanksgiving.
