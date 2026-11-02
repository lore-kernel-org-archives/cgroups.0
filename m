Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793641247;
	b=tSHhvXFLSiVlE/0Q/z3J4vAE/4kAvt7Nf+fVCedduq1C3jkcFXF/JaHw+/ZAVzb5RTpJ
	 Q5HWfS7qg9MGZ8FQ9eDbdyDRUixSUFjesz3GGkri11/upmpfga65BAhfJ1L7x9BhNMcep
	 8cYGfQC0sGdsAEBAIxBoZbbHZFwlVetK3Kh3lTT6hw1pOy2EOJylbSLLh8JrSNBJarxiS
	 ZwnZmYk8dMRJCqXdrwhSFqRTIROWpJA4nMZr3wqHavGPWzugqKm32ydkL3TrZCr99zv+b
	 0uhVXw6O4ChlYptV5ZwLKL1qiFPRM22qKk/7QkUS+KRZwCoqSsRyXDIkQMAYtaZxMFA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793641247;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=TlWIVwA/UXKyoa6jSw1HPI+XreVDEaVcyeg+VBHTtLE=;
	b=onIS2DxWZXY1F1PSTVz5iLnQKlrTpOFI7woug5cbA5vcuiS9rdt8+yCiupeYkRqZP/aP
	 9cEKRS+NP5jGVxHtJr1QcBEowwzelhxwaF59ERuE4iWc5ZY6rUkn4BdwREbJY2tofeWPb
	 8LjE0D3GiN11HAHadY4a9nB1m/Pj6eSuR1GPKFKTFe3wuMSZH5+Dk4Yul/84T0IFkPAMB
	 lr5r5/mi68eA+bN0lj+RHrAg07el82jde02ly+SWo3pVEgjIKLVtAg4SivQ4j9XMeGxfU
	 qQRUa93/LTdi0mn5wJYZRaxB2p15HR41VlrvmpqQZ6pxNOLQkP2YeM3lXyvrv/ewXYw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XXFUDEQU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.41
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA64606B0CA
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 17:40:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1CA64606B0CA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XXFUDEQU
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-97ccbba8e86so768655241.3
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 09:40:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793641246; cv=none;
        d=google.com; s=arc-20260327;
        b=ShoWUyyIgwiOHPdm1GpZgIo9WlQ1hMp4J1wqUFheUxXRnHmFDudw0OUMl211ZS48bF
         uAWwfOxPWadThenPJUxe5t8WDjDIYuC0/wVtNpekAVDbjkXS4/ZgaePNEJd33drmuMeP
         vZI0CJ9V7saMfuXy70IwSLSS8QhEdVeVYVbZ8YAHeNIf4k5Vw/dStZ8e5/7DAIMo9ouf
         ISLMCly4I0f3yDyZ+uyDgCMIX05jXkmGNIw2VI3pwST5LoR38yDMaJP1NHqJqNnhCHb4
         ZK0wstNEJSYivqFuJSjM+lhd0C2AngzUA4ZzAq8M7yAkdYwiD76+fwpVtuqazOJ02XVO
         LmLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TlWIVwA/UXKyoa6jSw1HPI+XreVDEaVcyeg+VBHTtLE=;
        fh=09ht1uKBmxmqs9KL4sYqtP56sHszH5aYA+Ng8eYRdrc=;
        b=Bh3R4qT7Usso4yQ1/u+WeZbveJZc9XKXUOSU8Z72uD2Y5cuUI+0rO6B6RJbp0Ldi1p
         M1bczen5PMJ+i2uNROlRt/seGqs/Y02aCh1BN1/Emyi88r+zq9XnGB2iQ/M9jGyIYXjk
         HJV+h204CeYLzvObUg/S7IQ5ZQ/s4YCmI3W5xtqpm+i3QBGDc/NtFV9aSL4Ed9E6Pfzl
         iq8ePnMTWJnnENLQjei4lXPFUyWYj8NbQEif5gddvWPCqoNySFzeUtaaI2ykio/E6t52
         qHnSQhdVVSvZPZ4ofCx2+vxvUIE9Jmm9NU1FoGahj/Gv2EWnPaqm7nbino8WDPCYpH1Q
         jPCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793641246; x=1794246046; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TlWIVwA/UXKyoa6jSw1HPI+XreVDEaVcyeg+VBHTtLE=;
        b=XXFUDEQUt/RMwmcuNPfKQeIT1xPpcppGrlw5ABGLmtU7yZAJ6n902Ihf0F9RqyoXGQ
         w5eXCYiY/h4klsDQOLtleFyi9PYc6hcxhB4hQlh7tOmhsWfuuyZw+nswEinQ26obyRnW
         7+qQskOy9D8z+w1Kd/RBd58h7ZIlpS2gqO5InM7u23y6TzzOK2YmqVtTCNLL0xUcvxL0
         tOjn0gXV2Qipm97u81+wczAuVYIszmor5UqnbJ1QuoqPCV8Pg4fjPeNWbenBLcvnWeik
         6mH90Wo+WohV6CURPrdk1l+EWP8YfAOsyuAqWQ0CsVcpFu40p5AcD10OTDMAv9K2TE0r
         nYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793641246; x=1794246046;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TlWIVwA/UXKyoa6jSw1HPI+XreVDEaVcyeg+VBHTtLE=;
        b=kYGdozhzaqJ6bY7+SYU3Kb/FrXqZ53TDzmISg18/tMsyVEtZYihDoxeFESzW8CDRy2
         ZpdLng9I8nC4ymeXojWmZW9sGkawN5uTpaJ6tPFF2i0WrAQ5V0Vv8w6xgAf9l0DhlkKj
         A1xleOG3N1euUcOJ+mqWBVc2zasRBKQH+pcrHcsnb2SUTDciNZF/eAbHw/o0C415OuZe
         hQYLDP7acg2b5hVbiLsG0f9sEWC6ytPDygujAER7nFxOONfrf2D/k3mxNMQu4ZplvI1J
         3gSUrwo8l8kIUPhpgosaFMN0et2WyDyjoPxcq5YnpoCC/x5GzzJN0mbLEAUhlj0jncsx
         KS7w==
X-Forwarded-Encrypted: i=1; AKwUvBxSUhgbrZ4cDI+pJDd4T5Me2r54Hj2UbcPAMRTTzBqss0JzLtSuYiqfefzwWruaFEUlSfbkmkFi@vger.kernel.org
X-Gm-Message-State: APuU4Z+6vgjh4RkDVz3lIAUuEXLjA5KPur8qyUjI+ZpC08uFXYIDoDUe
	LN/Iq7NTdornkFoTp7yc0XYhVXeyEM27y3nRxl+01g+mn1hP90QwgSFzF5cLzRY1iUvSkstRkjm
	sZpzINp8iLU0jnbvrFnyY/FkaRYhxX9s=
X-Gm-Gg: AYBFou35uu1ZwlyKcbAwNoi4mGiJSoYwk++voSjYZ8yjH6CgxoLhuYcH30CtnZY3oAb
	W8JtNFqhglfM38BpOaeN0YDUriwARcEDxP5Yq/x+eEMYiIU8OfybEjofhHk5cgCzQg+Wq7J1xhX
	Cg1CGa0h6MeXtnEjDP+jD0aQ70Q22k/tYgtbRqlzQkG6zwxHUhHtJmQHaerPN5jQe+VRvFyW8bL
	rXMKNih9mjzPyNPtPWBCANNqd2uDVQm3xAwGe4x2BK0VebPWYT1q3ZxkcZrbBuUQbuENjhpWiDQ
	lmOUJQ106TlElK0rkDyEEZctEvh007cEPuV936uTsVmcb53z6D7Bn8sw6tMVelSdWyaomHALUN8
	egtgd4gdX1KTLl06zGIWjsPRzMZEW+sFs3PHHKca8lMdtXkFtMmgnLVPFPR5bua/GVJlTQxdAU7
	WjFj4bvSk=
X-Received: by 2002:a05:6102:6cc:b0:7b5:7cd5:2a1b with SMTP id
 ada2fe7eead31-7d072634fbamr3742461137.10.1793641245530; Mon, 02 Nov 2026
 09:40:45 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <aui3TJqadHUv-4RW@tiehlicka> <20261102163014.237806-1-joshua.hahnjy@gmail.com>
 <aujCcqKKyio7oZ0x@tiehlicka>
In-Reply-To: <aujCcqKKyio7oZ0x@tiehlicka>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Mon, 2 Nov 2026 12:40:33 -0500
X-Gm-Features: AclHuK8Kcc-o5KfW3KwHQal0BbNJdxHPlCZpE8gC1XELnC_g5cw3VrvhXhvc0MA
Message-ID: <CAN+CAwOwRJUDXHj0RMr4p2+sdA1V9bX-OgOH1PpER+u_cB2fAg@mail.gmail.com>
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
To: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"

> > > > Personally I am a big fan of how try_charge_memcg looks after this
> > > > series, what do you think?
> > > >
> > > > > Quite honestly I am still not convinced this move
> > > > > is the right thing but I would like to fully understand the mechanics
> > > > > first. Having discrepancies among different counters just sounds like a
> > > > > potential source of future problems.
> > > >
> > > > I hope that I can present a good argument for why this is not as
> > > > concern as it may seem initially.
> > > >
> > > > My first point is that the memory usage counters were always fuzzy, as
> > > > specified in the memcg v1 documentation too:
> > > >
> > > > usage_in_bytes ... doesn't show 'exact' value of memory (and swap)
> > > > usage, it's a fuzz value for efficient access.
> > > >
> > > > Secondly, the raw value of the usage is actually always accurate. It is
> > > > just the stock portion that overcharge the memory at times, making it
> > > > seem like there is a discrepancy. Flushing the memcg stock immediately
> > > > bring the counters to their real values (like what happens right now).
> > > >
> > > > Finally, this is a change that is only limited to cgroup v1 users.
> > >
> > > Right but is there any actual point in adding caching for memsw charges
> > > now? If you have a way to opt-in to caching then you can simply disabled
> > > that for memsw counter altogether. Fewer problems to deal with, explain
> > > etc...
> >
> > I think the problem actually still exists, unfortunately. In fact I
> > think the issue becomes bigger if you remove stocking for memsw.
>
> Yes, you are right. We do actually cache memsw through the charging path
> which charges both mem and memsw with the batch.

Thanks, Michal! So it seems like we are in alignment on everything
except the cgroup v1 implications for fuzziness. FWIW I think nothing
really changes from the userspace POV. memsw and memory usage has
always been fuzzy due to stocking, so all this series does is to
change "why" and "when" the stocking becomes fuzzy.

What do you think about this? The other alternative would be to remove
stocking for cgroup v1 users completely. But I am not sure that is a
good solution either. For the record, I tried making the stock tied
together so that they refill together, but that was a nightmare in
terms of added complexity.
