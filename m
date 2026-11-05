Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793890255;
	b=E5vBSefg0Ce1LKlGY32C3olNj2Rs+y+8EH2x7upIYnxDHFWiBj4lTCGC6vh5xsE3EeBj
	 51PVN6sZHDBnb3i7zPE0WC6b2pc48+VW026vc+jPM5HfhU29xczMjva8NKPY194wOzbfu
	 eJfg8cYT3ASVThHJvVNH+omFPMXUoB83bVBFQXedyny44PYNI8kc7o38nj1C41ijTbAv9
	 hdk4O0VmvEXPSFL2aGq1//LwIHVboqFGBBjxxIJKEkVuByWX7j8GRpcMKQVWsXCGlGiju
	 xUpESvTvfes0Se3ch1DuvNUZn18PbSCcLtcT0GSe/IdyYaMuhV7JdcgqnYNtODyOtNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793890255;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=x6AYBRDQlDAqtDeCOrRnb86KC7Ggop6ssABCp4bzpWk=;
	b=E5G2J3A/yq9EEfCC5k41bz5AAPxrEo8XhEMUOKEfe9xM/jfmtIA4SEWUr9k4z5Tg0b8I
	 +rCWfmXYzKJ5HiBviXWP6K12LhnwObZUm/+O+70+6cBtzuxjI6lsUjXl1GL827589oSRa
	 HD99EIZYak7k4K6GAXsjMl25LbvbGq4LhN0Fy9ZLylhpCY2LJe6z5dP1QmFGn8AdaUi0S
	 LXPvvdl0IvERO2QV8E0YVs40yUoGQkNYftLrIbljBrCeIkyPZUrOOEAn/mNpj/Y7ZgZel
	 36LHRZzLqoM4zWAmP2O/UnuXmPmJ2Jdru1e476rN2CEOErWxzFZ4nyf2KvrAfggJoPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Qrf5XQ3S;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.52
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D4A606A33B
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 14:50:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75D4A606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Qrf5XQ3S
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-998749fe872so1084280241.0
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 06:50:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793890254; cv=none;
        d=google.com; s=arc-20260327;
        b=EQVhSJgwDJwKktgRjLkbiwMm/MGK7TSZsG2I+FwVSxFElr+1YO3Ap/Q6QIxIFOdbvR
         ViIOElolFJo8d/dZf/SWgCaff3K43iKbEEeNNDwhB6J7ZYEBdV3vqUMV9Q5kHwvVqTR9
         wah8pZYS0JOB+t5WM5b3lMLy6+4yrdnmfqVuFybEvplczLJjfJPaDdMuApKjtyaSdKPG
         kH/Ybax+rZ+0ZBrYp1RSBsPU1qUi24pKunqQJxuzQUUuAu4HzdjlZTM17+P4gMmvG3I3
         zMJHWH/yScQkeLsxFFQu6hErGoavDZ7jEZvzCAUuPcl1lQEzEkC0ZhZmaFXkG/xWLVdM
         1KZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x6AYBRDQlDAqtDeCOrRnb86KC7Ggop6ssABCp4bzpWk=;
        fh=/rFHwILKdvVaPlY2u7boh+DDk5pT48O11F2gEozoEJA=;
        b=cwhUlUSA12c28mGcFZyjsJOSnhmuMhOSLIVphbMAyGbJHBYxKS6YytQ0IO/0+pPqvH
         HjsM0scQjE5ZLegkeuNjpJp5Wl7DEC6nxC3cMdlLW1Nial5zwUo+3sRZBhj3rE9FrJiX
         iqjSmj5cnDLR/VWpS5Y5s8T7BGbo6EctZKgphm4OCZffHxl/dqy41+AdBRHaWWre8Yti
         H0By4nx8dMBPK3YRhP6I7F+P17XTp785pxLh6Fj6HzIiVkDJeNUjfEi3l3T8a91jAZYk
         eI8dTy1qb4NgqCfZxigkEuTcsvEof1FvcE7AYV1Yl5xdZf+oGWxL3eq4FOeK0L04W3cM
         VC5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793890254; x=1794495054; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x6AYBRDQlDAqtDeCOrRnb86KC7Ggop6ssABCp4bzpWk=;
        b=Qrf5XQ3SSTLAgWvV+nnFlsLm1JLWLJ2uInCBOKdNaEFLZlZ+/tzVzEIfIk3hbWb/vD
         hsUHhBGmPqU303eF71vK5rHMyUQ7GsuMwV6TjWns2/RoNhaU7rwom/xHkz66g+8n32WJ
         50uTk93nV2xYkb9lu4salBmLqTUfbGMA4mQqsrnLpf39FMQ+b9o/rPaVN8zdxJ7zmsv2
         F961FedeqnnlKdMl5WnurPwS+SOgPGa1mDpOgkePPcNWAlY2alAELq31DDUeGbddEPHW
         5KmJkk7LBr/4vcBaZHFUeJgMJDQgO0atmaj5t6QKpxUnX1w7n2K5KG6g4fglHKwZR1xO
         3DMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793890254; x=1794495054;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x6AYBRDQlDAqtDeCOrRnb86KC7Ggop6ssABCp4bzpWk=;
        b=Ro/xMLYdsi8z+95aMJ7SMq0JBKY+qHkCbMb32B+7+wjzMMdryT7cbuk1Vj/58BGbYb
         3KOLr4mra1nmt/J0x6L3XMY0+bUgXgwhFF4HbmGDvDPfPviv/+sQN979glLiVFaJ24Bc
         VLf2HdFn0eEvgOKkGWITStUmKbVTBboXTJkOBSBRPRtW1xrznjF9nTHS/y+P98VaX6tz
         TkspVFJcg3kKtYcZWV1c+UnnE/qsdUhA93v7QM4mpwihRxiA2xCn2TlOoH3HHh+JSdrx
         qg/jU79atzkNi/wUvsjJpyK7XTm6wZq53yd/h0BeOGzqpAvhux0X1HIWQ8FHnwLmHXpY
         TjNg==
X-Forwarded-Encrypted: i=1; AKwUvBx+C6dM7iYMFDRDaux+33ERU4qfbotTLjEEhPNDgj1Y3QaFCWjM1nyB3cGGRSPqo38RuA7yAyg8@vger.kernel.org
X-Gm-Message-State: APuU4Z9kAf6tocHQ1FqqVYpx+Zl2/pE50bDOTOlxBr3LvEw3+SUIz7xO
	aNwO8VL7FhyTz8uYrYNXs87ExwD247dne6BOzQ4gY+n5YpJW4Wl+cwfKYLZI5TVm5xHPLLgcJGs
	xPi+qZ4p+IRD4NgNV2fn8IKAyZejTDcs=
X-Gm-Gg: AYBFou3mVFm5windLtx56zaRs6L+ufG9hGHyTgKrabwUOP7Q7G4XjRL1l8qIIB/ZBB7
	VThk1qwZHxobltprBLNzndYpJxmDJ4Mb6M2cYMq5Hh8sYOjlrBwR9b6yLOdj1dGDWNC5Z+edJgg
	OWIH8zuzYMTdEFRK6ET3V9CiOszwAMICkhude8WAZSHAEEd7nkwbp/adM2X28RPFNtrGwr/3M8O
	lZYkAHMuKg7SLwBjsF6grUU26S372ltb8gBsIaQy9cDfCG8diwDP+dEUFOaVa0gyjTFh5n5qkhT
	Rmj7LoDQmuYBmogSiwF34r5uD1laEZQHBNqSnfge6yEH2AJApH7yoPF9wzATjkLBZAgdCdMaPX1
	jWLzzlt/f3RQQpin1nzyFpQixUb57z32D9rbmvaSPq+r9Sy15gLGHRIL0Iyppx8x0Ums/q3MvBW
	roOvQZCRq9
X-Received: by 2002:a05:6102:5243:b0:7cc:115:ddf4 with SMTP id
 ada2fe7eead31-7d072cafbdamr9042312137.25.1793890254113; Thu, 05 Nov 2026
 06:50:54 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com> <auwfZj6QTwQqFIZb@parvat>
In-Reply-To: <auwfZj6QTwQqFIZb@parvat>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Thu, 5 Nov 2026 09:50:43 -0500
X-Gm-Features: AclHuK8f94VBTeNgSM335yz-5hAFVlY2uvlhDStBMta91PSr4DplroD4jKbuQCM
Message-ID: <CAN+CAwPNsSWyqbKRGEL_rtrz9CWTdFvhKFvZpbUNoJJONXxuZA@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] mm/page_counter: move stock from mem_cgroup to page_counter
To: Balbir Singh <balbirs@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Harry Yoo <harry@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 1:17=E2=80=AFAM Balbir Singh <balbirs@nvidia.com> wr=
ote:
>
> On Wed, Nov 04, 2026 at 03:30:21PM -0800, Joshua Hahn wrote:
> > INTRODUCTION
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Memcg keeps a per-CPU stock of precharged pages so that small and
> > frequent allocations do not walk the page_counter hierarchy every time.
> > Today, the stock implementation lives in memcontrol code, even though
> > the operation it caches is a page_counter charge. This makes it
> > difficult to add new page_counters to a memcg and preserve the fast pat=
h
> > behavior.
> >
> > This series moves the stock into the page_counter layer.
> > page_counter_try_charge() consumes the stock, charges a batch to the
> > hierarchy on a miss, and refills the stock with the surplus. Memcg no
> > longer manages the stock in try_charge_memcg.
> >
> > So the stock keeps the existing layout, which is still a per-CPU bank
> > of 7 slots, each holding a count of precharged pages that it hands out.
> > It maintains exclusion using local locks on each CPU, and for remote
> > drains we schedule on the memcg workqueue.
> >
> > This change gives us the following benefits:
> > - Separate charge caching (page_counter) from charge policy (memcg).
> > - Makes it simple to keep stock out of interior cgroups on cgroup v2.
> > - Prepares for future work for stock improvement, which can now be
> >   isolated from memcg changes.

[...snip...]

> Is the main motivation ease of addition of page_counters to a memcg?
> What would those counters be, why not add them here?

Hi Balbir,

Thank you for your interest in the series! So yes, that is the main
motivation but this series offers standalone benefits as well (which
are right above).

The new page_counters that I want to add track per-tier per-memcg
residence. Those are used for enforcement (and not necessarily for
visibility), so I think they wouldn't make too much sense to add on
their own now, without the actual enforcement parts.

What do you think? I've also linked my tiered memcg series [1] if you
wanted additional context.

Thank you, I hope you have a great day!
Joshua

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmai=
l.com/
