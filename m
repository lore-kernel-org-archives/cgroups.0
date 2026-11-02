Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793643390;
	b=Rfsu+Wlu+TTDAsbgDWZUXjJt9eIdjk9GXwJFL6kosCqIbhTwb7yccOlIjTzDFUmAdHxG
	 6Ac0WBl5A5A+gP0mmi06QcmHAVnxHz7MgjD8+ZY/BAro4hgeXYiu58FXSEOtA9pPBu0yO
	 ao1730WtZeFyuZCXq4178FpDFyp3S2pl5OIOSaFDOGpHI6Z96MnSHuEpL1XBZlouW/d+d
	 rCvEBW0+RO79Th7CZjvUgvNoKyuFZzFeEH7ukEDZe0HK6fTNlrcQkP+8i3QJnUeaG/5JU
	 O0r9w/fDCzTdoeCuJoOUxy3pGKHVnTKufueISiItySMKVYoZ5Ji6XRQfUzSDV2MSjvQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793643390;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=T9ICWzy7eh1ZDcwlW7hKp1lrYbcuv/hAuIABl4o9hxM=;
	b=tx857rrtqIEYaNPT1tF811WHzh5+5LY6rjgdX/B9g2v+z4XFl9BFAnCzdSQQyLuj3exi
	 3FgZeiJnNEDtffH0aQARAv3zgfhVIlfl3NbZMNdMs4yscuiLQ1G6fE4OBVNA9nKnio2Js
	 TVR177xaZppRk2jBzqGuFXpdS/WAmfubrBmZ6C98EshGwVqKkWPzRk5Iz9dK8eOvXL0a0
	 K9QrkQpN5eBdFJbw7uo5nIgHj7yICXT3Iw/zT3i2rqJ1WCO1K/7v/sao6G0HCCb78KYO2
	 A1x8i3tXd7w29Pa1njfyAI4Z+o1BcK8pr69/7pmJ9/WhgL53XvDuiKoxFvU2PvL1+dw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="MV/9PO20";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.53
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC44606A330
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 18:16:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4EC44606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MV/9PO20
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-9950a7530d9so848182241.2
        for <cgroups@vger.kernel.org>; Mon, 02 Nov 2026 10:16:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793643389; cv=none;
        d=google.com; s=arc-20260327;
        b=CFL0xc5q6T6i7C+ud1v6kn9BpfjN+9Yy0actCm+up29mV52h8bkof/zUfvVVcKj2Y8
         anPbaevXqDRpJTV06yq/EofART3lB7W2Q/IZ/y10VjZsIJDzihVFB9sTfAVY41wS00zI
         AfNBhmeRM+nURmrnwj6gKA7BBBIoKCbKptkTefPFtlIx30Y84AYHaOg8+LtGmF2F25o6
         Zp5lqg6s/iLJFoy5AM+lxC8dpUoWt+j/yI40lnp62Of5yzdn8U+shzNPHRd6RNvh2YTD
         e/9+8PYwcXBzLPWo09Glm3EVB5SeK11ysdTz052vCH4xEARxGlvJcJqJNwWpyQ+KGTxQ
         bGvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T9ICWzy7eh1ZDcwlW7hKp1lrYbcuv/hAuIABl4o9hxM=;
        fh=KLzh/Z1lnsEBE94KPO3dzSVJgGgL6tWb6hMT1U58xDc=;
        b=ewMig4zAx97Z6A0DMDvTMsm23HPNNlfEJFeeHPyIz81M49Z6XMgHhmmdEeUYQ9rphg
         0gHAkCJSW8VLRmGpHJd1Nb7D1o3Iu94CkUpMyit+JlbUqdy1u35RU1tgYT8DC1Dvhtlb
         zh606af5u9cCz/TkD4vSlpvTLVbpagwMx5pZPk6DiLDZaiuGNkyn/XnJeswJG6IiXgJe
         eP0qajm62/oa8dB2R5mLhuyIHVtdfwF1zYiGOyczdU1pqe9lh/VyB5P8EgxziV1YdCAc
         lVxspxUppjL/EHHPFzB7RbJx65ixszfToyCXbCRQ8HyzjHhPaO7jc6v85NPGu88VPCgG
         4NhQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793643389; x=1794248189; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T9ICWzy7eh1ZDcwlW7hKp1lrYbcuv/hAuIABl4o9hxM=;
        b=MV/9PO20iTv/IbWrD4hFexyIGZZNqdsY5fggwZvmD41h+5Pw2hmnxnCC0ByLAJgOmN
         L9B2aZFYygwucrR/n9M3yuI10kX6ktGciuq2wBBy96XtooJwnNVogS5PPFM7fafTIUo6
         V1pwseLy6CyoWnePc+ZsGOA3J/8VsK4n8UzYGxR3S82/QjgxvOdU/RZW6LC5egXqNqjA
         Lh8F4ut8zlhnnVhU1oTCGiHwjfNoacEt1mZsZ7EsLXWcN10JSgFW34xjytg8gNVlidw+
         Y4ZkJku7Ka6TZ/LFzB9Ex96ukzXyZaBViOU+gScstg9XcfyoZxFqIasEbJbuaZItVBt/
         sIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793643389; x=1794248189;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T9ICWzy7eh1ZDcwlW7hKp1lrYbcuv/hAuIABl4o9hxM=;
        b=L6994GMRsDv9eqB+cxgeyRehYJ95nZSUuN3D96YkfYfRuMiVNhCPiwbWtUF6BQZ6Ca
         LOU1uTVB7q7iR2o5pzrcgrb8pldXVehqCAR3tpp38I+HJC39AycE9aVf9LuNm7peP9dY
         MMdqmPoKTXNIboobJGFF1Z4emgWjCFZBaGIoPGhUKDI0qePLxEyp1SgVGdBs6bdMFMbw
         PsJZ7zpeSxlJYUl+t66S7MxWv/HbGisJNX5dKNHsAh60BN9ZUctl1x24OXSv3RIHM3Ct
         eC2jfynDVvaiNgsqg1o7nhQseV2LEhS6Ocp3fWl7FrTya1pMHLU3POSoPkBXK+c6FcAZ
         4HcA==
X-Forwarded-Encrypted: i=1; AKwUvBzjGAKpoFL03DSrzpawmjEbb+d/sCEzi1cc9Mm00t+n9TKYTPyumrVsYC6V+YcBEo/VuUalQBta@vger.kernel.org
X-Gm-Message-State: APuU4Z8tVZ/pQ2ifNsYBRo8YmWbbYU2F/Y0aJFAR/k18WsBIKdhsNecV
	UFKlgkpYMWxaT/zeM3y59KVdh/aKHbUVOAz7kIHx1xsOnCgktZ8XT1dPhnwaEuU9NEae4h7sXvf
	Tl6sm0YjYwRlIrECTQbY8qIXuMU6vejY=
X-Gm-Gg: AYBFou30vih/y0GGqDU8H2/QIucTDvyUXVfkSGDzmpG1C9TsQTg+EGDMvMwAo0pMLkp
	vzxpnXnSZEBEvhIP34KnYQqPDzOJ4bk9EHegNuES1WJ4UXur5lM0NoAo0IHYF03iY/j40Avfj60
	YndmtNIv/GjziHNH1YwGEjGtDwqtMyLj+km77f1okefYs8WymUYMqYcAZiOgjpfjusCQxTXxM/y
	c12110zeCPfxF2vpFL+g0SThdzuLhbDIDKBylW1b2pG1lpHhzzWB/6GA/ywrPv4YKvuTkEMZnur
	/FHkpsJI0BqHaAj96uL+hnUGqv8QXkVLX5+i/bp1GjA3uC9zvAMkg8VBsDoMKMwzIE236h6bUSg
	69tJbygisVzkjSYCGc3EWVq6acKtGhVLzMRzPLeG9ylv3w7JeeTs/DNnZ9xnSba7j6MPiPcl1Kb
	X74q73q/aR
X-Received: by 2002:a05:6102:e0c:b0:7cc:2bb7:1335 with SMTP id
 ada2fe7eead31-7d07276121fmr4390550137.33.1793643389113; Mon, 02 Nov 2026
 10:16:29 -0800 (PST)
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
 <aujCcqKKyio7oZ0x@tiehlicka> <CAN+CAwOwRJUDXHj0RMr4p2+sdA1V9bX-OgOH1PpER+u_cB2fAg@mail.gmail.com>
 <aujSP_sfbasQaKu7@tiehlicka>
In-Reply-To: <aujSP_sfbasQaKu7@tiehlicka>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Mon, 2 Nov 2026 13:16:16 -0500
X-Gm-Features: AclHuK9EkEv8FL6xfP3eWXeFQa1t-cPp0lrx5vZ8E-g9cOqfGbbE6u5P1MgVKZ0
Message-ID: <CAN+CAwNVuxqHxbaEuu2n8BmUtXhuVeX5v-v5Gu7eegyV0sT+=g@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 1:11=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Mon 02-11-26 12:40:33, Joshua Hahn wrote:
> > > > > > Personally I am a big fan of how try_charge_memcg looks after t=
his
> > > > > > series, what do you think?
> > > > > >
> > > > > > > Quite honestly I am still not convinced this move
> > > > > > > is the right thing but I would like to fully understand the m=
echanics
> > > > > > > first. Having discrepancies among different counters just sou=
nds like a
> > > > > > > potential source of future problems.
> > > > > >
> > > > > > I hope that I can present a good argument for why this is not a=
s
> > > > > > concern as it may seem initially.
> > > > > >
> > > > > > My first point is that the memory usage counters were always fu=
zzy, as
> > > > > > specified in the memcg v1 documentation too:
> > > > > >
> > > > > > usage_in_bytes ... doesn't show 'exact' value of memory (and sw=
ap)
> > > > > > usage, it's a fuzz value for efficient access.
> > > > > >
> > > > > > Secondly, the raw value of the usage is actually always accurat=
e. It is
> > > > > > just the stock portion that overcharge the memory at times, mak=
ing it
> > > > > > seem like there is a discrepancy. Flushing the memcg stock imme=
diately
> > > > > > bring the counters to their real values (like what happens righ=
t now).
> > > > > >
> > > > > > Finally, this is a change that is only limited to cgroup v1 use=
rs.
> > > > >
> > > > > Right but is there any actual point in adding caching for memsw c=
harges
> > > > > now? If you have a way to opt-in to caching then you can simply d=
isabled
> > > > > that for memsw counter altogether. Fewer problems to deal with, e=
xplain
> > > > > etc...
> > > >
> > > > I think the problem actually still exists, unfortunately. In fact I
> > > > think the issue becomes bigger if you remove stocking for memsw.
> > >
> > > Yes, you are right. We do actually cache memsw through the charging p=
ath
> > > which charges both mem and memsw with the batch.
> >
> > Thanks, Michal! So it seems like we are in alignment on everything
> > except the cgroup v1 implications for fuzziness. FWIW I think nothing
> > really changes from the userspace POV. memsw and memory usage has
> > always been fuzzy due to stocking, so all this series does is to
> > change "why" and "when" the stocking becomes fuzzy.
>
> Right. The discrepancy was not so obvious but I agree that this change
> doesn't fundamentally change the picture.

Thanks!

> > What do you think about this? The other alternative would be to remove
> > stocking for cgroup v1 users completely. But I am not sure that is a
> > good solution either. For the record, I tried making the stock tied
> > together so that they refill together, but that was a nightmare in
> > terms of added complexity.
>
> Nah, that seems overreaching without much added value. While we do not
> support new features in v1 we shouldn't cripple performance for those
> users unless there is no other way around.

Sounds good with me, and I also agree here. OK! I think it seems like
we are in alignment with everything. Let me spin up a new cover letter
being more explicit about everything we've covered here and send it
out soon. This was really helpful for me, thank you for your time
Michal : -)

Have a great day!!
Joshua
