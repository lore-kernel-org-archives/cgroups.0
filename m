Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AF8400DF6
	for <cgroups@vger.kernel.org>; Sat, 12 Sep 2026 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203682; cv=pass; b=I4L5qzwXkqEBYu2fsMmjrObStr5WnQeeIjkrSmRVAGitiQWP21ScJLitc4v6yHlgUfb7/rK1Lirx6Sf39EwZM8xILnX2cNRWABPNVL52NKcAq1NFG4U4x3fq7zXBfwFEuv2f3LkNEQHSclqmj8A54wXGLT0ulgqpSFhByaVtXAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203682; c=relaxed/simple;
	bh=IPNosc/r0xfulC5WG68kmh6M6W043Uql4TTAQdGiAs8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pZo8nO8lSDjKrsn83i6PprKo5QTbKvZHXE+swZOn6pUdq7/jKiQ+tftrpiaNRG0cxq0DDVZBzyJu4Y0KmW+NIKSGmSy8+D1eXnEls5d/fvR9onNqS3J6xXyD5FHsxJsnPEv5NuFqZjpj5vDTVrrp96mbilLwsSo7cPOokJmpHTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cphMH7I2; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cphMH7I2"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c25b661d37dso267956866b.0
        for <cgroups@vger.kernel.org>; Sat, 12 Sep 2026 02:01:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789203679; cv=none;
        d=google.com; s=arc-20260327;
        b=SeiqsVa0TvRRlXalcs8ZADbuslKod6/7uCSEP2qWIyhKNQv3sq8LIbpT88zL4aOn4e
         HA8aVaQN9sblodpzy7t21L8N/j7SCUPUDI1AHO4prJ4LTUscAXXF/ltAzSgvNtz5xccH
         g6w14/fYbKlmKsoz09lMJUeB0XS2UPO34qoRWtErGXz1z4iey3m6XsASPRT/ku7BeayE
         LFEO0fgzSofTUw/Je+E79znVaRc/85j6ayUL9XArk2s6IhnXaiqaVvlMJpWqMVhORvru
         YjiabLQCfW6zO3BprdRT1pVlcXre+aZQXm/mU0Wg6pfG3L3KqDoKgxSEvIgH+P6skkmV
         gBsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Emo/VHVaZMhmQcduzPD7yxfTUOKr9C1DEbaLmLBuIaI=;
        fh=hcUck0OYOldyhN32MXRO74w26Sd6jOsI+PZKVEG54N8=;
        b=eQhl32pU8i184m2ooz/QG96WLj3JijuiqW1+aTnvCs53wb16ZnVzLI/curL6WGboCu
         LFusuY1a7yXkxPEo/Jcom2ccQWVGO3ej+FuPheU/8bnERqI0U0L0mCCzG9B6p5FJV3Nk
         vXhzxWuUtIpcVop4lkl08XjyKeMiNiZ0B9juToGhcGBgxPY0mn1rtBdcawnc9MVVYVoP
         /fC/1BbJEtC01FzWX11x+zwqhTlckYau+hpSNkwCyQ3hXLHYxo9AmrBktEmo1bwDEEcM
         h4XpSPfS7WHVYIzPinUQIDhNpWIb7rDyjRF1GFXRbk8oBIeSMmWA1NZfoR91lW1NO8BO
         /9KA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789203679; x=1789808479; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Emo/VHVaZMhmQcduzPD7yxfTUOKr9C1DEbaLmLBuIaI=;
        b=cphMH7I2NbjgYz9Y7q4cvOIjKX5pGTY8W2/iskq9B7nGNj0k7301wz5doOVV6+aTVr
         LIo6OcxJqd/it3YEzllDVrdV+6MRbfFIJhKgiwjAwQM40YgAkJs5YRfSotp+m4AZEEO4
         tRNBQw51bNBDE+YMltcv1NIYcxldHzDQXK6MaWlhu52lLDd0lMYK0x2MN1wTUqFXB6Nj
         RtAlSwE9KgvQvze3Y/My6eAYs90PvCCc9HxZXLn8JZy3P2QX/aoYs9fT6t+xEZxhgpap
         +BDLXm9FF6AygIxv1GYhBoEg2KPJ0kYc4upched6ca/pIqohLomPB/aC1RgYAnVLX3IP
         LsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789203679; x=1789808479;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Emo/VHVaZMhmQcduzPD7yxfTUOKr9C1DEbaLmLBuIaI=;
        b=UJpH69GhCzr9V7rLjbhNKLsdqVpMI1CIhYHwoFB9L6DXOPE+VySLU9a5kg+yVeaVZ4
         78TvWWHL85mjPW+w5IDXpAYlJyyAwPzDZ0YEnRIffcjjZQU4uhpRHui7Vt1wF2s8HN0k
         OwmJ97eZnfmhF9Izff87egGOW14ofhhhcoAjMXaV0pxM6Qy9qbw5eup243DvW8XKxAAk
         RS8GVEZPtp9BDWsZJJ0cfmDktAPNUJFkdsAIDXfKGAT4a2vN6gwNXnT8x2f5GWBnV/74
         rqHt+VSMdF9heutoVbG99yRo0sPwZarOpMz8IHVMGHhY5X8AxhthAGpFmt3fwe/V454d
         nbsA==
X-Forwarded-Encrypted: i=1; AKwUvBzrVwYUxXliw1tDR3HPX2WLZ9hiPn9MAdRTYdxrs8bwDEinNHbVSjNoi+LLagmrlHkZKhp5qX7m@vger.kernel.org
X-Gm-Message-State: AFuF++n8xg+HS1JPhnmj4DCXpOWHICtiGfC1O8GL2b+O5nQ5lLwylUn4
	OaHi9LILffyTUrjjV8t11JC5bu6Fm8/9JErOdm5stK7q7FZrHPzpmZNz3+AtiatFk9Y3PC2R9sd
	XobnA1x7lo/Gvs+HwUpmo6c6laFPHlqA=
X-Gm-Gg: AYBFou3wWrqjYManqlPy2VNyoa6OfUjgB+1VjOjWIBGdD7a5fCAEBv6gRJpO4aL+z8/
	ZfhFJvqI7xg5gHer5hprRYBb/ueQTdxu/FZ3kPLbOO1ixbz8BznnwAcdN/qWCItiF7EG/7KDyM+
	+zgm3yxqgy0AfAd43Rtt9yXuTsgzFvcsdNAzvZnILL4dURhMSYeFO0uCrEanuzuLyL1NKlnOv4S
	zgrUZn0H/c14YHxDxDXVOrZ4gg9CCo5MxsyACPIWB4LWFgJMK3w77CKLaE/8dFQSLkNGuYdwILH
	/vLYPt8Zb7A8QMCKZoel9yIHGIgPQmzxwHHjEeKfwfZfcLjJObe7lv9Da9WOixFq8lDsL8TLrZ+
	zZiB/2Jc7P/U+
X-Received: by 2002:a17:907:3f88:b0:c25:9102:ed with SMTP id
 a640c23a62f3a-c29665ff973mr349742666b.5.1789203678979; Sat, 12 Sep 2026
 02:01:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org> <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
In-Reply-To: <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 12 Sep 2026 17:00:42 +0800
X-Gm-Features: AcwNN1VTyrOeQmFG_efe2_ca4qa89c2Nr9YsCc4NghZiW0bnHUOivuHs2n-bDVs
Message-ID: <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 12:42=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Tue, Sep 8, 2026 at 11:30=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.o=
rg> wrote:
> >
> > On Mon, Sep 07, 2026 at 01:51:31PM +0800, Kairui Song wrote:
> > > Where I've ended up is that unbounded growth is a real concern. On a
> > > host with no memcg limit (root cgroup, and most desktop and embedded
> > > setups), an unlimited pool means usage can keep growing, with no
> > > admin visible ceiling at all. I'm not attached to xswap's percent of =
RAM
> > > knob specifically, but I do think some kind of bound makes sense.
> >
> > Swap space is just process virtual address space, no?
> >
> > Swap entries already have one or more page table entries pointing to
> > them, which in turn are managed by trees of vm_area_structs. That
> > means rlimits apply, overcommit protection applies, and OOM killer
> > attribution works as well (oom_badness()).
>
> I tested this theory. I spinned up a process, and let it spam 0-filled
> memory + swap these pages out continually.
>
> As you predicted, oom-killer picked it up eventually. The host was
> (and is) intact otherwise :)

Good to know the kill path works. But I think the accounting side cuts the
other way? Won't that conversely underestimate the host's ability to
handle memory alloc? Not to mention a lot of application are
swap  space aware, some built in logics like e.g. with vm_enough_memory:

On a 1G machine with vswap enabled:
[    0.241906] vswap: created virtual swap device (2199023255040 pages)

a 2G sparse anonymous allocation fails:
[   46.044002] __vm_enough_memory: pid: 1129, comm: search_agent,
bytes: 2147483648 not enough memory for the allocation.

The default "Heuristic overcommit handling" policy is meant to handle
seriously wild allocation (as documented, and it's named as
OVERCOMMIT_GUESS).
totalram_pages() + total_swap_pages

Is the limit, the heuristic exists only to make "a seriously wild
allocation fail" (as documented). But on a vswap-only machine,
reasonable allocations fail. Common swap devices, zram, or xswap don't
have this problem. One could argue that the size there is just an
optimistic guess, the compression ratio is not controllable. But that
heuristic is a guess by design, and a plausible number serves it fine.
"Unlimited" seems break that.

One can switch to strict overcommit limit, but that is limited by a
user specified ratio or number; again, we need a concrete number. A
fuzzy "unlimited" seems odd.
