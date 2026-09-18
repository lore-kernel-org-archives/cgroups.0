Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480D924A067
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 18:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789757405; cv=none; b=ENoEiZruJK50UDy4u0lWKU7pNIMzkYqUZCFsFiR2HYWHDvwAwDXPjZvUS5MIIjQcvSiWxRM1UVKYnt0VAUwIOZxuwj0kVYhh4FtuWHHFT1bwbWJxWXDPl6ZwJQ4CCmS4Xpc264Boy0fPyPL3vqUXGUAQ0npFz9Sb3XSZAm7za50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789757405; c=relaxed/simple;
	bh=9oC39/JappGs0sqzr06Vb/T9nRG9qxulTyMwkYPuvjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N6D2uM9K1abE5q1PZCF/6gG8L9aQSigg2iY9PB5trabhFOcf9dOlR/tYRK697Is/P37efmqLdbWnC5U03RMYgWSh7fMjQf0ZPJmz+sR29Wj9dUJlsRdTxeflk42QatUbcoC1OgH7CZx91ZCZtjDJFMRUFSqpANX8OeOJ3JQ+P9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pR6TXwrp; arc=none smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pR6TXwrp"
Received: by mail-oi2-f12.google.com with SMTP id 5614622812f47-4b37a2ffef2so551127b6e.3
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 11:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789757390; x=1790362190; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/Ph6ZaVxaO7CXgv08gaPlk+fBtFgV6Zs+sxg/G7AO88=;
        b=pR6TXwrpMEITHw2br1BoaGrggsW7bp1HhgIFVbGpV1QTAcv4U+YsMI1N7ixc0z+hJb
         ElQGHys3Gn8tXBrOXLBfNLXmaCLRZYpE4KdFuOOhyYqt9NFLm+3PrBq7MIePSjrPYmVk
         hGeIT2CZL1Sru91/5dQHdJ2LWfSo08eKWWLyUBJQzpcvfsreXK1S7UO7vdEHbTnLp+jb
         3ugysWsEf61cAExDw4/gmoaClvYMNtcqyFmTBFhVzzn8zKe2Smsau5ZsqYt5tD9Vaywr
         3Ho8ozYTiLY9most3r4hMEN23idPpARFlwn8T4VLlOvSoUizBe5pmuuk2rq9WZdVN4fY
         vRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789757390; x=1790362190;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Ph6ZaVxaO7CXgv08gaPlk+fBtFgV6Zs+sxg/G7AO88=;
        b=q5laBxdzQA10ZsR24JjLtSxXABeUHs8twbAH5H+la/XhkoQ1gtD7atnv82nbAq2ePQ
         LTcg+kQPC64VewDCfisnSBsA/xi1QG3DOvx29aEbgI0PcE8Owe4nrnN6RFdwM8o3rFLz
         OIiIjDiexvRORb4lNfIkpspujuM/97N24IfZND/XfUyR3JbptgwxjBmVX5MFeOBtNXfk
         yYZpyKhaUIDJW2xDo8co6SKVX3yDzFKl4wY6f0WqcmxsK7VuxCGEkN3kZpPec2RoIXde
         Osbc2Loz2eNLQmPDrae/QDkICCjHilj99xodHoHVbnshAQhT47LszAnQM3YkGGOEwLX2
         ka3g==
X-Forwarded-Encrypted: i=1; AKwUvBxRLFZ9jejJjJLjYsLv5MVLTgTr6pB+6rrEv9Fo8BUqZ4iuhVEPORNhK3GPfomNrWPWYBLBN8gL@vger.kernel.org
X-Gm-Message-State: AFuF++mMjPZ+uyw3zPOxwULQtUVdW+vIld1SPmG7/v7rT/6t5naQ1wR4
	+0746SLUhKKJ4ERud2SAjiGStEtEljyNJjVIsyr2e7Cz8MLJYZsqjSkc
X-Gm-Gg: AYBFou19CiJKAJVPjxvcRRp4bCFln/hmMLQsAc0N/qld9RLO5kxq29ePlJ7u8NfiRVE
	N17wbuIZe6fye7475LanbIPpaOmI9dreX2/42y/i1lf7Lpme95twSuyh8MCDNVv6bfPpVA98quc
	xBv+/UQhpaIO7lIZi+eWSFFf6pZvFVmtodgTfdHwB98PWXARUn1mgQjpSLX232jpo4d2MvXv+Co
	RSLUc8Bv0JoYB/2B76Kza+5sBEimiBiOHhim1E7d+dCe3NuK2S9uBEd5EEuyrFvx7ypeL2MeJmV
	1gm922JcrzQdBfFBvOWYDy24BqLRXoWL/f80mmk0jSNqjm4okYhWNH8+KJKgzumpMtUu9QOAsNv
	oKMuCWt+OJnJQv2Kdq1lgN9kWNScSaSHi6wK7iQw1qymY0c663YKLgiAUKad5CPtC6/+u2nPCrk
	ADiFvHOBnW5Us5i4pyUMQwX8jNCwL+JWheoHqs7mgVw6udgV5PuWFNw47+PVbFzHlr+bMIA5xWd
	UxMZIDbFad8wNPQ5y9bK4AVrwp9Tg==
X-Received: by 2002:a05:6808:13cd:b0:4c1:83fb:8c7b with SMTP id 5614622812f47-4ccf6f9803amr3772164b6e.12.1789757390210;
        Fri, 18 Sep 2026 11:49:50 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:17::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cf3f77781csm69823b6e.18.2026.09.18.11.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:49:49 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v6 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Fri, 18 Sep 2026 11:49:45 -0700
Message-ID: <20260918184947.3681164-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aqzulM8S63363Tr1@localhost.localdomain>
References: 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 18 Sep 2026 09:58:17 +0200 Michal Koutný <mkoutny@suse.com> wrote:

> Hi.
> 
> On Thu, Sep 17, 2026 at 10:57:00AM -0700, Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > 
> > This is true, but this is already the behavior for vanilla memcg.
> > In this series I'm hoping to preserve all existing semantics without
> > changing behaviors, so I can fix this problem in a separate issue.
> > 
> > Specifically, in vanilla try_charge_memcg:
> > 
> > done_restock:
> > 	if (batch > nr_pages)
> > 		refill_stock(memcg, batch - nr_pages);
> > 
> > ...
> > 			current->memcg_nr_pages_over_high += batch;
> > 
> > So I've just preserved the exact semantics that we used to have before.
> 
> Kudos to you for the conservative approach.

Hi Michal, thanks for your kind words : -)

> > 
> > The problem isn't that big anyways though, it's a transient inflation
> > in memcg_over_high and will be wiped on the next high handling run,
> > and there is no effect on accounting or permanent inflations.
> 
> It reminds me [1] where stockage imprecision could even trigger OOM but
> it was reportedly only visible in LTP.

So I was thinking about this part quite a bit in the older versions of
this series where I changed the draining from being async to sync.

If I understand the issue you saw in LTP correctly, it's not one of
actual memory OOMs but that there was stock that the memcg could use,
just not in the current CPU that was trying to fulfill the charge,
and also the draining for the remote CPUs did not happen in the time
that it took to run through 16 retry attempts.

IOW seems to me we are synchronously waiting for asynchronous drains.

To me this did sound a little bit unfortunate since there really is
memory that the memcg could have used, just cached in the "wrong"
place (and for some reason that CPU is too busy to do the drain).
One of the versions that I worked on previously (v4, [2]) used an atomic
for the stock so that we just always do a synchronous drain via
cmpxchg and we wouldn't have the problem above.

Obviously there are pros and cons. Synchronous means the reclaim path
has the ability to reclaim more memory NOW and prevent futile reclaim
retries, but also it makes each flushing operation more expensive as
the cmpxchg operation is more expensive than acquiring a local trylock,
even if it succeeds on the first try. 

In my opinion just doing the synchronous reclamation makes a bit more
sense to me since it gives a stronger guarantee that we are going to
get the charges we need to fulfill the charge attempt NOW rather than
spinning until some remote CPU gets scheduled to perform a local flush.

But this is just personal taste, I haven't really seen too much 
evidence that we are wasting too much time on the reclaims. So maybe
asynchronous drains are OK here. I can do some more digging in our
production data to see if we're ever just waiting for remote drains
to finish.

Anyways, I still intend on separating out the two efforts so that this
one is just a simple code move (and make stock more scalable) for
cgroup v2 users (and I hope not-so-big impact for cgroup v1 users)
and I can work on removing the 7-slot limit and improving the draining
as a follow-up work.

> HTH,
> Michal

Thanks for your thoughts Michal. Have a great day!
Joshua

> [1] https://lore.kernel.org/all/20250530151858.672391-1-mkoutny@suse.com/
[2] https://lore.kernel.org/all/20260623180124.868655-2-joshua.hahnjy@gmail.com/
