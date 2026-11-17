Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794956262;
	b=k1qbelou6J2HkAP3G0d5M3WBsW+T14ZFyqHYg0mHVudSB2TToBjwztqr0Bv7axk8oDSm
	 5aSOluma7nfyO97xhazpmKRIjGJFrD1AIbHBWds9RZBJD8059ZtSDIT/vuAUrH7RZeqAH
	 zPo2j4+Iq3J9GQQf3QpsisJkS9L8iTxpwcLu4bp0mqUlgWrfo9eq6Je+322828TfouB84
	 GVmuQd88/Ana1fNLvRAcywfrd2+GeafTvlcrdAJg7ec4iJ9M8y5FISWpirQoFBPG2hLGw
	 S6q13WFPktIUgbqHFYZQY18fl2bDdk5vVQpEeoRu1NdtVRzjoDJDNmmkYUya/Kkj6kg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794956262;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FsqJbwkV/uU/DSRZoNtapIdLtn+SA2yH6t5SZIf1Yv4=;
	b=nudJsCyNlkPcqXpUlc7hN0bMnWbLnReCRaBjwOs4jZQOOQ5QET3SduPO5X74zM4QPuDi
	 ouMzg6CprAuZtheCxQ+DXTLtecowsigDb3v5r+U4MSFbkoXyfUVPmXhdrlB0NKGHBQXlb
	 /pXnHSuvs2ac3B6PYBThwwGKcILqKopIfWTrunRMjh2RpHawoSAh63wPrQS70Y/jz71f5
	 PL7HE7iPL6Ef6GEyAK7JQu/sLQIRksmWLahNhvgQ1YmBSbp4dSRwoLHtT9XWJ+UVtLJgj
	 82HhzFNDrOD4kOt9JXIiymvrcaH8ho4CatMFtl/9N7Ds6j4fYx24WkqQe/yn+A1VbPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z727BfMb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB138606A334
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 22:57:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB138606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Z727BfMb
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4a32576da88so149871f8f.3
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 14:57:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794956260; cv=none;
        d=google.com; s=arc-20260327;
        b=k94dU7211N3D7vaUfKJjgaKuONE4GhuSSkyUFJKGrJYcA6nLiBeDGyd10MlMktx49E
         Ss/9WJq+TGkP5YQ8ASLNBSAq3W4cUpIeQMY7KTYqtZkOUrBHU695E0FQzT66GX8SgyfI
         4y1v3HTuhXtRjcuMmJG+sK+zcKhQGZ7bAkhFSxz/nDByoqjIc+yTDacEjN7cjPw4KkNq
         P0djMyJ6NDj0MImYjqhylwtHqD+OuJdLqKVRNc2cv4dP9AGONF+W7e0xENWO+SoD1F3w
         cp0fbojrcMZxvOAvsm4tp4KCFQddVEhkGf6KT3nVJ1bNqR4CWES7rECYGV66fDEyjmi5
         CzGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FsqJbwkV/uU/DSRZoNtapIdLtn+SA2yH6t5SZIf1Yv4=;
        fh=5NjDzdPSBJHJfoYEnKK1n+0OIJHtslT+Gf15nIC7s10=;
        b=KG0yLwaj7p/21wxjOtxmccyditKdzs3tXvhc7oB6n9ysXSu3Z5iSvDkWUqZzESbSp1
         TcFVdpzDXsXdPOAg9uyHsrx8AB//prI+96QYX//o4DSgrnTMH2zRfM5v61K6TalarrkI
         4yjQv7u78R5SuAVmgE+AbytjzRgL5fonZlHrl8727Wr85QTaZyfqFo0o2Sy9vSOCl2Dj
         IwLL6t3QkPdLV0zjsk6KRX8HQLkgZN+HA7g0RzxM3HcO52DNKOp7b8k9TFRfwbzuTN2y
         J1j7d66ommGkZY7DcXKW7G5CVqoJ9kEpx11hpARZExoABUcnPrqiUXytEc1Jx4g6ExZR
         /RsQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794956260; x=1795561060; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FsqJbwkV/uU/DSRZoNtapIdLtn+SA2yH6t5SZIf1Yv4=;
        b=Z727BfMbH5q2nf+Kkim4q85WEKbR7887da4hCSXSULc0A7ZPMl6gBZ1oaNynswqKYR
         xhTZIUWSVK+b+pmzo8QV7z4dxNMwutFHK24B1LCPDTP0rxqZKTrBqnzZ+P4F/IDXdiYq
         css0vDCgIzzxw9E/L7ZZP23xJsEYrkjtS9D3g+RYU5NEHY6bJyNJrELN7d1WjR9wup8S
         OKHKxu5J9NwVi5rkL9sat8b9L7I4dzLurQgsgf3kPGKz2VDw2bloQsWKqjL99za+z9sC
         orhxTwWuxTYjBRyPpxhWHpz5tjeoVd80IqG7N+RCA/CPwLLvDdy4H1dPxLKkH8mXGAuZ
         MtCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794956260; x=1795561060;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FsqJbwkV/uU/DSRZoNtapIdLtn+SA2yH6t5SZIf1Yv4=;
        b=zSlSQrPnQ0ZhXr14VKjZ7IWc4nBdQoL03dZSoJhM+ze6tOeDtjytwll+iaTB6UTI3s
         9ibH62tPah0jGQKlEWBZMJ/PY94/64z1ktY8H/EZc4BfZAG48ppdwGZFjdeAnQMv38TH
         S+sF+7vmYuIG5n49fh1rsW00Glc1awI79hDJSGI/lBNPZ2eNgpNPUEmyA4rmiJkmcMyC
         eSBY3MVFqclz0bi+nJf0SfY5Bk2kOzhNM8bmAjp8B0H4FAaiEBsBoxE5j0neG3zEiUul
         ANIq+9in38Crf68vZRnY5rgEMUaWwgZLI5/gX+O80r989PlHBE36KqpQIkt6/P96/HVL
         fjlw==
X-Forwarded-Encrypted: i=1; AL+hErEcvJZM07cAOpSJEw2seUJ4xpQ7dLBGjpbvijTNzJr49EJ+IjS57jpQvrWbJ4PeQ1JvmvyFS3gn@vger.kernel.org
X-Gm-Message-State: APuU4Z98GAIXtleLa/KqRICAPG2BLt1SUJ5mkb5YQH11+kCVeZD+soq6
	8SEcIeN0wyQjnHqUOlASRjUBGe2Lfil9BldqRlC01xREzPg0F5Nkv/FgMV0q+SoelFXiQnEnfQp
	fWqOgCdjvr7SUSp5ar9VKm39AJZtIRLA=
X-Gm-Gg: AYBFou3mhFQTKLD/KF+m2k8rJ/jqsBs0hlIkbGHwJ9u5JaOUu4C9GJqvrFsxiQjV03a
	lg3b260/tQFb3a6xt9UTX8a2/QUEFi4sylUedGFPI6MKg6dDHapwFK+1dXA8BjNxO2GJYCpABDQ
	IhnQOtYuBD56V55RWp+Lcbp99vLCpmChQdxDkbrO7sL1Li1ZUDt1Mvol77m+cV1j/KhfsRta+oY
	xkGOnnQ4LVu4v0IOnKvDF2Q7rx/dTul5Maqnyiudp9D7Ruy+gmIhC4ulO+0LGnDdmCu/MQ0c2f9
	8/EuG5pdZ5ubfovDQN9JnSlZJq8SCUHvCqtCnyRPO5WlwGrA8htjeWKvX3zoIE4WJr5NwMJi4O7
	Jw8BLm6GkvYMq7nAP2K9Rq5QvIiCKrR2PXAv3cDkS8Y/Ki56GlkX8RER/lfpUUdjPwOpayTSDM0
	N+Ym/Pe6eAIrgMIYbPMmb4ZU3NyAK0eBG2n4HXHNYeOp7FSLMJLUu7x83jkpSZq5rgJ6+sgA==
X-Received: by 2002:a05:600c:1d06:b0:4bb:6a5a:783d with SMTP id
 5b1f17b1804b1-4bb7da25158mr12547015e9.18.1794956260090; Tue, 17 Nov 2026
 14:57:40 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAKEwX=M64ZmMLBRiAQ6FiiP8f=jkA4m=HM8rgQo-cir2SENPnw@mail.gmail.com>
 <20261117161028.475891-1-nakixii@gmail.com>
In-Reply-To: <20261117161028.475891-1-nakixii@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 17 Nov 2026 14:57:28 -0800
X-Gm-Features: Aa3M54rLZoi7B6oMnsab_DhD6F5mz6P2afScumNTEptyJQeY10XdZ8aO4kmMqJY
Message-ID: <CAKEwX=O3qkG0pt3qVsRTDDfP9sC2AuG2c-t3Xaudquw0xKwa4g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
To: nakixii <nakixii@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Yosry Ahmed <yosry@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 8:12=E2=80=AFAM nakixii <nakixii@gmail.com> wrote:
>
> On Mon, Nov 16, 2026 at 06:13:46AM -0800, Nhat Pham wrote:
> > What's the motivation of this line of work?
>
> It started as an attempt to get something like the Darwin memory
> compressor on Linux: keep reclaimed pages compressed in RAM, fault
> them back directly, and push cold data to disk only when needed.

Ohhh I see.

>
> Honestly, your virtual swap series already covers the core of that
> (zswap without a backing swapfile, no PTE walks when moving between
> backends), so I don't think a separate subsystem is justified.
>
> The parts I still think are worth looking at are restoring directly
> from the pool without going through the swap cache, and packing
> several compressed objects into one swap slot on writeback. Do you
> think the latter would fit as another backend type in vswap, or should
> it stay inside zswap writeback?

Ah interesting! In the future you should include the motivation in the
cover letter - either new use case your work will enable, or
performance improvements, or overhead reduction etc.

And yes, compressed writeback would be a good thing to explore! I was
thinking about compressed writeback sometimes ago, and I came up with
a slot-packing mechanism that is very similar to what you are
proposing here (IIUC). It gives you both LRU-ish ordering and good
storage density. Something along this line:

1. An in-memory staging area of "buffer(s)", where we pack slots to be
written-back (by LRU order).

2. Once the buffer is full, we can writeback the entire buffer.

3. Refault of any written-back buffer brings it back to the staging
area. We can use the same mechanism for defrag, compaction, etc.

(I'm not 100% sure how close this is to your idea - yours might be
vastly smarter. I'd need to spend time reading yours...)

But the challenge is the synchronization mechanism. Right now we rely
on the swap cache + folio lock as synchronization. We can't use that
here, as the whole point is we want to avoid decompression. We'd have
to add a backend lock *somewhere*.

Ideally I want this to be decoupled from zswap, i.e as a vswap
backend) We'd have to re-introduce a bit lock (almost similar to
SWAP_HAS_CACHE) - I don't know if it's ideal (Kairui, what do you
think?). Or maybe we can add a backend-specific lock, which pagefault
can block on at swap_read_folio() time...

The other option is we can re-use zsmalloc's internal synchronization.
We already move slots around for internal and external compaction. But
that would blow up zsmalloc - you'd have to implement the stuff above
inside of zsmalloc. And we might have to go for the pool_lock, which
is effectively a global lock...

>
> The numbers in the cover letter are from 6.12 and don't compare
> against vswap, so they don't say much about this yet. I'll redo them
> on a current tree first.

Yeah let's focus on compressed writeback. It's a concrete problem to solve =
:)
