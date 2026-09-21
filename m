Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66066501290
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 18:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790016967; cv=pass; b=g4fNFZfZdY1BqKfz1N4JsTh7l5yh16MDC1Wv/MiPaXEDpAEKT0KXu3e0GehZL5qj4OGrjMKZZlgfTn5R4iSt2rE6Jniksl41tLYwsF2NzimIMbsC/LVIuuASJ31tuep9U8Dcyz6ksO/+7b84kXG614VFMLYsZYtvuMuKyJvV5+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790016967; c=relaxed/simple;
	bh=BfFXpLin8UbdB73DGs4mouTnFh5xNjHoAQbr3ky7Ets=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kONVjdD/zSfIn+1tlWVWUwa8xkChEiTGUZNNrAa5Pt7+Yd36lNtK44XPOvRxWG8Gse3Jpb2e1bKlQC4USDT1UoQ8WkzFDdvNDegce8aYQMUBR9aynWc/8ahLrB8cux037i2a8k1MyfKC1TNTL6EqpIJ3ISjcK7pdEluX/8ME4f4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DPU9tOsC; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DPU9tOsC"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b2522so2289341f8f.0
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 11:56:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790016962; cv=none;
        d=google.com; s=arc-20260327;
        b=Xe7vhpJX/5VBihMumbKaxQ1wvHJHPgkh3TnOtRccOjtULR9sEJrB+eSCo8v7E2HEg2
         tu5GwKcg+T+Hn+/Vi3c0dB8Hb3jF0NdG9szFlLYCSoF+2jgALyuU3HxDBPzW9kG8h7S5
         Ij8FN5asjVfQf5eDup4v17r/kIrXnqeYtbBYRYcnaJThkVBdxckblGjsvJXKik/htokK
         vmH1KGUsZrxHvunrBSSsbTGmZsiq0UqDceu5qXmExQaD39ZsgsKQDlksWN50gRtrBcbD
         St29LMkEc9NlOBZV5bEJnbtk0NPRkSB8rsR7fd6BeFJuwotBbWKCLRCoYxtXebgMcWg8
         bc6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BfFXpLin8UbdB73DGs4mouTnFh5xNjHoAQbr3ky7Ets=;
        fh=D6EE1aWzEyj2G0L5p34o+ytbJ8bnJ8IuAcRsrXinCM0=;
        b=PM+bfOiZ7qddOKXQI/xAMGAiH7I8duDPLs/uPbI+zR4OojUFrQ49QHgkAkTx4rCiiV
         SDfpseRbTuBHaTDm7FluW8d8OlXoliEzTu/xErgoeEItCV0QoAmdhATb/4/iHDvuDROZ
         sdaiBoZ3C/UH3Hc1aBcod0gsELKVD1BttkK2sSAMhCS6S6MU/yNwml9cuVFE7abIwe7Z
         qKHHoLhU0CCh99iD7QeilODFClzHvI3JfIyXtz2yT/BsoVZXpW32AqRwIg3W9dP+Fans
         mGsCp1LzavegPTfHzRThWMDJflu/tT751tKF361j1edW8HKGE7uZaz4bekMXZKyNVRHS
         g94w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790016962; x=1790621762; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BfFXpLin8UbdB73DGs4mouTnFh5xNjHoAQbr3ky7Ets=;
        b=DPU9tOsCqXqbBraOPxqWp1o9AB/EkHB2jwVYQ+lTlX8ZwJwyTT/Jxfkyr/a9Jlix+/
         dpAkD68t+y0gstZ2/HTRyEKwrmnXYSunHLpU28k40cqc+WV2A25u4isPw9wXMdlOVr0u
         fa7E/jVP3lTeNARJK7pnVVac1vULG8qRUbSi2XHrJZf5MglCbwkqeMlXHNDb5I6TP7iZ
         ZWQakQ0kQkWtw0nyAZImz5h15i+uE9YTTxu9C5oMFGQZywoEKi0BTiGilZp2K4AK3OvV
         99ePtEkCEyqqX3/vXozgEnL95Lk4I+91InnHCOLgf/GpOwWmVmTOHyJ8rWP3ML1uB0jC
         v9HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790016962; x=1790621762;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BfFXpLin8UbdB73DGs4mouTnFh5xNjHoAQbr3ky7Ets=;
        b=KOpyVB1cqXZcDpovjgcXWApwAYhuhZQT45JhBzhGSqWDehDuynBUVkMLHmUQanfKF+
         7XXZ77UByc2VUAa2kU9MZYf6fvbxNxxOLJrHU8pB1D8pBoU+Lz87wvAowCCWzf3y0mXn
         T8hjTQxuhl4PF+1VZ9VF4dTaPl2aZY8Zd4J/25tDnhDRcQchfP3Mr2B9A0UMrITdHULJ
         3gE8phl3OMnmX2kiiHnJXPcXel3nFCfz85hbY9GS7n6/tOOnnIcMU8nrJj73X/Qrvm+N
         8kx4lmU/f+wIvWgGpZtt8LvqNpyW3bm3220uGbrJ6B8SF9w+5wVxKKTlr7pqo7OMyWfq
         w++A==
X-Forwarded-Encrypted: i=1; AKwUvBxejjCAijU2RDjWAXZO6zSkMTQfZD4tgrWxEAd48vc6ukGG2KViu0rUGnimWhJTx+CuWf8Y+d5b@vger.kernel.org
X-Gm-Message-State: AFuF++kd3c+3zWpLAv2GnFCm25kqNg9MuE9r74k/zU1F8Ff4UM9oc8tH
	O76RXAxGFMBA/FpUFOC1jKfmbvcH76FvmUeNOl7MRr7OX/wTz6FvcRa676sjYs0I+aGJVxw+oGE
	Okjy0C9kmg4vipb8UzSFyidR077B+J4k=
X-Gm-Gg: AYBFou0scIkC0cM9zhnVM3kQHa+5dMhwiJCv/wKOtrraHvOgS+0hq2fDlwKhvCYU5BB
	/yJhbCFI5xndcrAvpDLiY/uetvLEJB4K7dt45SWa1D1kYZfhVPQGvCcTLbA/BA+5ZHeFw5T8X8g
	0DFrlvtg8yGX63qtuXMVfi1pNzHhYegS13A6gEV/9G9MXK8AVp3j5Ymip0foJL5ERq4vi3vDmx2
	YVmXaLBcTvfwsG+HSW1WduViKs6ce0u56SunYkKRReCaWYimm1PDOmoKbPpQZFnDhyRm5oRtRoP
	Wk+SAhrWH+d6eUxbtCfScQ/qzllIcRVezmIY3JO5jK0XbCXB2OAs77ge43mLq7nhaF4BH+1LnxI
	m0tl+ThE1wXY=
X-Received: by 2002:a05:6000:26c6:b0:487:fa6:d7e5 with SMTP id
 ffacd0b85a97d-4871e386ffdmr22164283f8f.25.1790016962241; Mon, 21 Sep 2026
 11:56:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
In-Reply-To: <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 21 Sep 2026 11:55:50 -0700
X-Gm-Features: AcwNN1X9C9t6jZ1elLcVhCMK8X-LC57IMfgOb3DvTZPE3O0yZGqwzYORodlnY9A
Message-ID: <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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

On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Mon, Sep 14, 2026 at 10:00=E2=80=AFAM Baoquan He <baoquan.he@linux.dev=
> wrote:
> >
> > >
> > > Is 9AM PDT fixed, or can it be adjusted? 9AM PDT is midnight for the
> > > UTC+8 folks.
> > >
> > > The time is still fine for me, though, I tend to stay up quite late
> > > anyway ;) so that time works fine on my end if the slot is fixed.
> > >
> > > Is there a calendar invite or something, please send me one, I'm happ=
y
> > > to do a swap sync discussion there.
> >
> > Thanks for opening this up for discussion. While the time slot is a
> > little late for me, I am not very sure if I can attend, will see.
>
> No that time slot is too late for Asia developers. I don't think we
> should use that time slot for swap alignment.
>
> We should find a time slot more friendly to Asia.

Any time slot would have that kind of problem. We're spread out across
the globe.

Let's just use a standardized time slot we have for MM alignment sessions.
