Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795134806;
	b=WJyyXjwu66HpnyUqDrzL6yB+yhogF0DB9TEsVs6nh4O5JiIhfhPhTkJ7WPp0JSX9EEkp
	 uNerl97gMgy9BM2YcMzsnF5decE3q56QtYroCGafsdwcpGKWWZ5R06kpG0bq/LcpZ3V3w
	 V4g4BfYtcmDr8XcLjvUYoulWTxsskcZet9Nsxf8t1TeeANaORd/E19DPABnBiN8YOGMwE
	 uoqC6y+ADjEd777cI3/FADUVcafuBz4gC0TIkTtrq2JV9RlHmkUBsoR+eHEBSz1XNH31t
	 WymAL7A5qwzrTh1xrcyAoh91jCYNmfIFfV+Jycyvufq6ClyvTpFwMF8W1Wxx1xm0f3w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795134806;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=q5dwbG3U1cLtbFVF4+FubgVmvLvUVgq9jKjpGQEHC4c=;
	b=Ak3Uf3y9u65DWX2TDNzTXWE+z+HpAgtH3Yf/uX4r+nzMhFB6bB3Yy/LpSKdrrQVDmL4v
	 lr7DH790N9sDgDxRhIsN0N64d7Cind28ElEqXQNwa7HUhVWFB7CTp+0iCr+wlTnzpvKBc
	 CpyLHNTwfsxlP4J6EN8mFHXMeJJtYHqXEZfCWqIuUcAwIpcdccrQr8xWSZOgFPoCPbrYw
	 i5WfpUK0lMn+W4G4csHPTzXfj2hgP2WyxA8r3hBnQvOXBzQljMrMTPWpidvC/DZONhCEo
	 htWwNBlJSVS8rvxRdbjDCHrw9uHKnpZpyHOuls44iSEzDbhaGufBQCHw+jXcNKZ1Tvw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0P87Qpzm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07755606A325
	for <cgroups@vger.kernel.org>; Fri, 20 Nov 2026 00:33:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07755606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0P87Qpzm
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4a2f4ca0dcfso126407f8f.1
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 16:33:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795134804; cv=none;
        d=google.com; s=arc-20260327;
        b=bF95ZLW6z6DCDQ6QZesxETY+wuipKvaoPSJJnzKDjKCBdaaaSxrAYWtxbLtkbdfG1Q
         E0+OHiC8kstr90IeG6yE+scnRo1fFHHB7mOknKyfzopHWdPtL445o9s73VccdANlQb+G
         RsKbQ08jB34mS5Qb+40cS+ppBZnKx5nSe3OKaX4YNeC0we9gYzVhBggD2pNh9I4DbilL
         /NZe+z936hHTinIcQ2EI68+ll/gZ60ggr2oCVbwpoPW3lGsJNPPkBOESHg8IDzZZ1EEn
         4yV9G+SqqzkHQX67tcdqJ2GyhVbkNeuFr0JYpndIJkqFriuSEpL2JLkxthUT1sE4qUE6
         dgzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q5dwbG3U1cLtbFVF4+FubgVmvLvUVgq9jKjpGQEHC4c=;
        fh=tnPGa0Z/0FivYnbr6uBhKeF00bSd3nZoyY0w6QVyGmY=;
        b=gyZ9bs2cuYXq58BXpqz3vQcoaUBR5qWjK1M5lquW9WG84c5tNZcuxKB6SlVoykkT5N
         roDz2Vf6JDx4GP9Vs08f6L8Jc2QqqkZ0AW5QyYbRalJ07bJlG6IbyfdYTFGp+Ihc6MM0
         fmqoKu6CEYw3wEqP9VZu4gs4UaJG3CM3+Jfrq64+jZ4bK+zH/5Bvvmd6Q1aMB15sig1i
         ZfnSqLTDmMIDGaUYEot+/4R4S0jjGjup6Yt8Kf9C10b+J8YalKEd4NBqYhCfD1cffCoY
         bZUnaEjk6t2FCaEzYdVzb+SQmjgJAEPx8DjbOCH17GLDsvtOaY3ep7tBpUMBdAZTkBuZ
         FHnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795134804; x=1795739604; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q5dwbG3U1cLtbFVF4+FubgVmvLvUVgq9jKjpGQEHC4c=;
        b=0P87Qpzm1F20EuXWMACOdhy5E9bAKujy8FYcavA4eX9xIQj0BBxpR2ZuCa1TMmYCGl
         ICqMarT5M66UDr4+WeuI0HdwqIlhI+cR5t1RkJzWkJL9VptAisydFK9srsrSZaLKMk59
         f0IjGUgwHGuQBM4Vhj3VziGOzJIic0JBsgreoeqrs86LQ08C0qM1ckomcgsUG7Qg90u4
         NAtB1v+0U56KVV/Jl+M17YQxgmPpTlLrFEHg22SByhkRcnyjdlQIRloC1mQyoippkIaN
         QLjkSfFn8fn1R48NsvUn0dvk8lP0kyFPjSLVncBFpHNt+l1oB9dp/AJrpkhUP7iPwLHP
         2EuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795134804; x=1795739604;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q5dwbG3U1cLtbFVF4+FubgVmvLvUVgq9jKjpGQEHC4c=;
        b=C5kHjZaS4Qsg4yw6btS5VOdP8/Gordjuzut1HC0JGMARAOGGDOG+tfihKcPAxUEF7W
         fJTENWBJgdUmsRpr8Fm6E1PVwvNqQu0unsThbmaBp9pmC4VHzA/4ZRGz1+1xfuiIuKYv
         z9fCGJNyPTtQaJhd3vZkqyiAEXE9M6PqyU42HBk+k8JCS/JXgvRwamX8JzNf1ZB0uYb3
         kgsPv0z3/+VZXffroD4tMgvOlNpZJSWv6tweyZDPREaFVS2sP7d2EZae9+20Gp7YJ796
         C7HJ9NUFVlW+kpic/LCVnFS4lnAD9grwHxBOxwuyQNmhQ/QnO6YiRg7uPIOe6iG73rZ3
         9H0w==
X-Forwarded-Encrypted: i=1; AL+hErHSAixXgyUQieAvqZcvoDqSzqBxmJMt94a0z+/Az+c6EBsfUi1O43mVi9nSkp04sO+3U7tL1iex@vger.kernel.org
X-Gm-Message-State: APuU4Z82jeZyszksxLuDviUBAePPBj3InZt8sCtcCoMcUmt69cwHk8JZ
	kQwH/8fdAXpmztgA85qv4qbuHuAn2oNqb7W5bu63g2d83cX4UIq1Fb/8zyxs5+SENpw+/1EN23O
	7Za8+QbL8grao4guCCWeMA+2jCx/HBf4=
X-Gm-Gg: AZFdTZdxrqihrQv7F9e7slR2jKyp65Snn5iJYMvt8VTj0OZ3s481YoY1/aYW8gD2uPj
	kh7eYwSsfHW4lhudeOX5qZbeOkQ4ZCMDblxfI89hzUwJuaWFKvcK5HY/aLSBroFF9749eDjVjrj
	r1cI4xGKFXu1zSKBY28IqvYqioCNePLOsBVm8b0LFlLIfhB9JBfhRIEIoo6HQIxdNmTyNZeH8l8
	tm58yk1Y1eYAJXq1V9umrERg/WuMf5fYkDVP9VHq/z3c3d/fz5OsMQbrarWXhedp0WnraL7CUdk
	k6AMDZW8Lqj+9xLXS8pkOzvzfgsaD/0x+njpcV38JD70iChlHNSCVN8B9yOldjV/dsOODc6MiIP
	jYnTUp75e4BpWamft2W7DQEMQJ+sW88w/k6rc/EcpZzR3AwXxTcmxY2DXEyeFl4Q990BIsJaciZ
	LaInDHjNtkLRNZoiOgJ+M=
X-Received: by 2002:adf:e186:0:b0:48e:20ed:d5e7 with SMTP id
 ffacd0b85a97d-4abb3a4d37dmr2109434f8f.34.1795134804351; Thu, 19 Nov 2026
 16:33:24 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
 <20261114002822.1043378-4-joannelkoong@gmail.com> <avvhF41RlOQSYFq6@chrisdown.name>
In-Reply-To: <avvhF41RlOQSYFq6@chrisdown.name>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 19 Nov 2026 16:33:11 -0800
X-Gm-Features: Aa3M54rY2agoJDn4R2X4j9vjOezNYoLRKUGxlNrKNsn9CzkEMvge175LEU0QmY8
Message-ID: <CAJnrk1Y+QpbFhA7NZQYu_enEa9d_dp5ySL=oegeEn4SkkGE_HQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] mm: workingset: skip the root memcg flush in workingset_test_recent()
To: Chris Down <chris@chrisdown.name>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org, 
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Chris,

On Mon, Nov 16, 2026 at 9:07=E2=80=AFPM Chris Down <chris@chrisdown.name> w=
rote:
>
> Hi Joanne,
>
> Joanne Koong writes:
> >-      if (flush)
> >+      if (flush && !mem_cgroup_is_root(eviction_memcg))
> >               mem_cgroup_flush_stats_ratelimited(eviction_memcg);
>
> Not a big deal, but in the v2 thread you mentioned you would try a
> mem_cgroup_flush_lru_stats_ratelimited() helper for this, per Michal's
> suggestion. That still seems like a good idea given this skip and the one=
 in
> DAMON rely on everything read after them staying in lruvec_use_node_stat(=
),
> and at least speaking for myself, keeping the root check close to the lis=
t
> in memcontrol.c makes that easier to see. It doesn't need
> to hold this patch up though, and I've tested that refaults in the root
> cgroup no longer flush, so either way:

Thanks for reviewing and testing this series. When I was updating v2
-> v3, I tested out what adding the helper looks like, but found it a
bit overkill. It adds two new api wrappers (one for ratelimited
flushes for workingset, and one for non-ratelimited flushes for
damon), each of which has only one callsite.

Maybe it would be clearest to add a comment directly at the callsites
and above lruvec_use_node_stat() to document the dependency? I'm happy
to add this in, or if you and Michal prefer the helper still, I'm
happy to add the helper APIs.

Thanks,
Joanne

>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Tested-by: Chris Down <chris@chrisdown.name>
>
> Thanks!
>
> Chris
