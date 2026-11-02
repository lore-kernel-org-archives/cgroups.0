Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793643074;
	b=mPzeaqAOlnKSK4POivfnql9O1jfR7umxg2/g0RZmjuvKMGfxcpc9Tsd6qZkCsXs7Tid7
	 s9PFZKudX+YrS5ktT141GMSNRb16t510UR8mX9QCL0hFdxClmYWJl+/mmb+clwx3eWuf1
	 lDrFgayH46q4XEcHXg+c2CjgN/Ha9Xgpl2IiiJwPbNCvQ8l+hvRzYKajHWPwwP0tr87C9
	 zWkKgEhixIY/gUrir/8U+flQ2aaywFgN/+us4qO/S2lUneGemyL8+4YOwUZqLH84pFegZ
	 GnwN9xCRDEHU3ss4k4H4Kyf1QZRRIBTKBPQ6fw0b2gm3WwPjXIg0wWL7GxwMr3KbiyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793643074;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=aQruTCC5hEy9EJEA7VtNTy/+BSL1Xc1NZBa6W4LKkR0=;
	b=1+7bj9/dma9IqVQWKTPK7Brr2eM7Xg3JCq6MQED1ZA6vYz8gd5vhZm8b+D3JPlm9KKPx
	 jHSRMnjW0kgvvj4WktIQX5fvBNtZ/Wj1ZlVqgbKpmFH0XU5r2pmmKLrTfUTUFo1klrGO5
	 0wsh31GOyPHyZ3Ig0i+fY1uC+Wk2mNmSAi6bI5jMgPk47EU60MEVBVgMMF9ceaTMhn4ws
	 JAIBJartPTnfaukL7ZdvghAdvshlFFoDy1xgn12lRXL98M4TkAO+hwSI3pniP7O5isvAX
	 AGyhnRgvhsxNWT1VsQyVJeI1rjMpVqs7dMifXRyKe+phtbzk2LvttfHzpAs7ruRBEnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=S7fZGOJn;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACAB606A32D
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 18:11:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0ACAB606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=S7fZGOJn
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so34860495e9.0
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 10:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793643072; x=1794247872; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aQruTCC5hEy9EJEA7VtNTy/+BSL1Xc1NZBa6W4LKkR0=;
        b=S7fZGOJn+iw6rZCKUziMBDNX5mLSfgdLS/L1NKTMKwQ6NhlhF85qAINiVQ0JBrYun9
         LYubZizvwAujb1n0IT5qjIGOy26KpHahFuQDanB/1WX3pCn11z02F8gLHbUmG85g0QnV
         Y+RLPLcpcsLzQZETsbrkjsxNiZrkpqVV1wIFFGSPrYdMLal3u0BWWfk6+hN+GLk6f4ZB
         EzWsqPYeOC2jGYUKpON0Cp19myXk8x7nu2fa31Mwn+IdzMEwCfsSxf5ibbMNu2CvW53d
         x4bOa13B18BMt1F3qrloJtNHav0ELfxzVQnktiu7iXFL5ZHvGv2vvc2KhDF8viO6A89q
         7pqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793643072; x=1794247872;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aQruTCC5hEy9EJEA7VtNTy/+BSL1Xc1NZBa6W4LKkR0=;
        b=LsKUTK6r9BlLgQKbUdnrCC0szDEBn3XKsO+8RWISkQxiExIWF9V860Boh+i7mpjRdj
         Dv8Oa69xm6ID6K7Dv3IlbddFwvSREoiS7ipWnGw0QJx7UVBVwUNm+HXYPM6/VZnMxz4d
         fUnEKnMRHsAITejsn2W9qJ4qnA/+zwPdGjud24scZi6kJLZAiUWZ1O6MrwID/KbeE3O0
         nDfM2KI0IRnGzDoLZ2NaDeRYnDwx5YND6nloebJjMQgYOPTOo9HLF2tEckAO1Y5uXdRn
         QHG07ojPzDMWLkHBtD0bOWMdXe3Y7wsxvY33+KgeOTyKpTqrJb3j0nHVmc3AT32N3QJD
         k8Sg==
X-Forwarded-Encrypted: i=1; AKwUvByQ5ma2GinQ05PJPRt4dC+USaXVaWAeg4FZqcEXU9X/peN97TQfZDxqYl7mJJeXvqUoBb1lYG1d@vger.kernel.org
X-Gm-Message-State: AFq9FYI/urUGCVVWdqFq4W/SPQgKYLwQ/2+zwOWS3qcGSTHdyW62tSiR
	iSutQ6jE7WR6NB16Aldizoygm7IGpC7s8KjDwbFhgFZhrjWxxZBAir9PyT0a6eGAH8Q=
X-Gm-Gg: AYBFou1ZSb64IAbbrQCc2bMzUOLuxeX7godo3190v0m+jRN4BO9hh9CTGbVkJtFXMYN
	rdK4UrEDEP8niVGVK1xaspywV+ZJ3+CcLn1hjJlrCTgHHzCqZTdvV48Lip2c62AKZIzCcS6Nukk
	qcL+Yh5Vqeo1GJal6zFJOUGBYti5EJreC1Af9KEPCvQC8HoqaRSK+TH7LTiA9cKdKbcAm9FjN61
	KqXH1PXvxmV87e8UkG2Z2i/+VVgb+5fDfy1PfIqo/dQdAA+L/SXjn6K9odG+QHGOvYannjMBwHu
	xGwYVbCFdl3E29+NHvw2XX5k84AZIj4zTUQcVLgs8/Kjtzuenho7wkRYPDTGWA0+c7rJ73YYf2h
	Dgf7eq77JKaDwag4vnbA0HXDCK6Xq9cMHzPLLGvJIydVFAp6uM5IXaNe8/7a33nme4LoJ1v8jMS
	bqPw1hBMKTBzdc2msNT2mXfj86UGbzLtt2TJ3IEeT3JC/wEls0YtbxdSkx7G3qdfz4FXulCeO1l
	HqRP234U4DJR2GZ1KndYdh1C8PrwFYMjVQN3sqPYpFN0IkkbAouozEDReIS6NSIBwW+1M7zHV1N
	K5hCQTW6Pe8mStTy2mBQs/ylmrJu0jKRPxgcCwU=
X-Received: by 2002:a05:600c:1c0f:b0:4a2:150f:1601 with SMTP id 5b1f17b1804b1-4ac1709a7bdmr254417725e9.12.1793643072380;
        Mon, 02 Nov 2026 10:11:12 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2a82cebc1sm5836795e9.1.2026.11.02.10.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 10:11:12 -0800 (PST)
Date: Mon, 2 Nov 2026 19:11:11 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
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
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to
 page_counter
Message-ID: <aujSP_sfbasQaKu7@tiehlicka>
References: <aui3TJqadHUv-4RW@tiehlicka>
 <20261102163014.237806-1-joshua.hahnjy@gmail.com>
 <aujCcqKKyio7oZ0x@tiehlicka>
 <CAN+CAwOwRJUDXHj0RMr4p2+sdA1V9bX-OgOH1PpER+u_cB2fAg@mail.gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+CAwOwRJUDXHj0RMr4p2+sdA1V9bX-OgOH1PpER+u_cB2fAg@mail.gmail.com>

On Mon 02-11-26 12:40:33, Joshua Hahn wrote:
> > > > > Personally I am a big fan of how try_charge_memcg looks after this
> > > > > series, what do you think?
> > > > >
> > > > > > Quite honestly I am still not convinced this move
> > > > > > is the right thing but I would like to fully understand the mechanics
> > > > > > first. Having discrepancies among different counters just sounds like a
> > > > > > potential source of future problems.
> > > > >
> > > > > I hope that I can present a good argument for why this is not as
> > > > > concern as it may seem initially.
> > > > >
> > > > > My first point is that the memory usage counters were always fuzzy, as
> > > > > specified in the memcg v1 documentation too:
> > > > >
> > > > > usage_in_bytes ... doesn't show 'exact' value of memory (and swap)
> > > > > usage, it's a fuzz value for efficient access.
> > > > >
> > > > > Secondly, the raw value of the usage is actually always accurate. It is
> > > > > just the stock portion that overcharge the memory at times, making it
> > > > > seem like there is a discrepancy. Flushing the memcg stock immediately
> > > > > bring the counters to their real values (like what happens right now).
> > > > >
> > > > > Finally, this is a change that is only limited to cgroup v1 users.
> > > >
> > > > Right but is there any actual point in adding caching for memsw charges
> > > > now? If you have a way to opt-in to caching then you can simply disabled
> > > > that for memsw counter altogether. Fewer problems to deal with, explain
> > > > etc...
> > >
> > > I think the problem actually still exists, unfortunately. In fact I
> > > think the issue becomes bigger if you remove stocking for memsw.
> >
> > Yes, you are right. We do actually cache memsw through the charging path
> > which charges both mem and memsw with the batch.
> 
> Thanks, Michal! So it seems like we are in alignment on everything
> except the cgroup v1 implications for fuzziness. FWIW I think nothing
> really changes from the userspace POV. memsw and memory usage has
> always been fuzzy due to stocking, so all this series does is to
> change "why" and "when" the stocking becomes fuzzy.

Right. The discrepancy was not so obvious but I agree that this change
doesn't fundamentally change the picture.

> What do you think about this? The other alternative would be to remove
> stocking for cgroup v1 users completely. But I am not sure that is a
> good solution either. For the record, I tried making the stock tied
> together so that they refill together, but that was a nightmare in
> terms of added complexity.

Nah, that seems overreaching without much added value. While we do not
support new features in v1 we shouldn't cripple performance for those
users unless there is no other way around.

-- 
Michal Hocko
SUSE Labs
