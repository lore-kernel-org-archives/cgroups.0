Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793212420;
	b=d2oHkCnBqEHq3BKIMwzNT4W2F1qyIBA8ztWRA2519DQmOG0A6p0wqJQ0cj5alpJ/8C3K
	 65kxZcAZpg0cz0JVxbImQj6ODZbXq55fSxgZt/36V4F0dWp8SXSTqiZp7dIVH+14oDseY
	 DU3z35zoCCZHu/IzzpKntllH3BpeP5dPg4mNKxsQoxJNjeKyWlImIKYxx0tj1bzq5vNsV
	 l7dD0+35B6F4S04lvlwn6rxsYnQg5f6aB78Lvi+CY9yKqpnZAFTyCETjarfHFlEgyo4C6
	 R4fXZF3vLXOHy+kkmyFJKNPGGZiGcpLG3zwoWQKv18fuJxO0Lc9x8oiwo3kGP0FDz4w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212420;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=WLy4iM7sjMurHn68gexgh9d6giJhTKkJQBRBvB3l3v4=;
	b=xFSs+PSWF3OeFObdwMnR+oW/+eBvnIC+/Zqbd+jJ0zwyR6r2sEQUxboeaPBa5Tvvq0L/
	 WE3X3iZ4P1F0WAppaPzq5GKAugm808DnRolDGLw/JP+a5OBWtZjzXfVwxQWI2rjIsIq+H
	 BU2nWkJN2cxYWb7T1W3RetRJOFLIx6pwd739lJA90zljSKk6JMiEptr7kmA6a60w8Ec8D
	 BzmxEYmpaZr8mTIG5IY6/ntD9EnKKqHgOhyHbZDSqfGlLMEy3NWUuj94px+taewdGa6Xq
	 vVWao5l2zvuSj4/2Sgu+EJ+CZ/c8wGrGCj6LZQv9CwLjCC0PQwCyU1avWzmkoY1O6FQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LPEm6PbC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C983606A31D
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:33:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C983606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LPEm6PbC
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso1010775f8f.2
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 11:33:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793212418; cv=none;
        d=google.com; s=arc-20260327;
        b=pJD+w3i3E1FxZX+cYe0tu4aeiE3Zy7kumRNA7Uoy8zd0REcSljT4o5Mxn09wbyifgC
         o6zLn3IuoV276By+YHxlA6tkgGL2zvIeaCeU7S5N7858G8bq55LgCdJQQfPBv2+sCQn7
         I6ZFkvGSD/jiWz1IsRTD7rh7Ggb7u37/1jfuiYW0pccWm6yny7gXlYaRaAmcbbSFTHuE
         uthKVY4Ghss3XzemlWQBYtsYmvbI85ZF2b+psx7Z0o5vIkSt9JHQ4kosMuXvAQ10gEjk
         4+DtWNslpyJb9usQDaBlWnEyhN/Kp2ifkMtiu0C6cb+LMf6y5kzMq5NAMy84U7yxyD9Z
         j7lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WLy4iM7sjMurHn68gexgh9d6giJhTKkJQBRBvB3l3v4=;
        fh=2crsJVTdMKXZi4Wcn/fGcbZhURyBVrLmyT6aDumVIpI=;
        b=onnPUsvD4tCmaXrj1ms4Xw/MtM0qiV2l5cTVGIU8MIhE9k6bZS4+5AnEx1kS/tImkR
         iKvgaGQGJPukLUBSfqib4M0suxYhBFJrRMYEPcf4C/9U0zarS6Jaz3mr2UTB06r4k50F
         9xqMd588osGc8F6gbYbZLEa+JO5t0AwtOICm85s5ruAB3NI6dr3GZKToPkqCJ9wbbqqR
         we47TagCZfked4/m2wlWQOxFug0IYXdA+fQDOopwMypjhAwFcSNm963DjOvu1IY1bghY
         p7PLxNFXT5lucqB+F7lZOLM6vto05ZPbNFLPIB9Lc4iWtEPQwM/NfOnt4s5aM11viHBk
         9Gbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793212418; x=1793817218; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WLy4iM7sjMurHn68gexgh9d6giJhTKkJQBRBvB3l3v4=;
        b=LPEm6PbCoEAoWvFRLIh4jElq4sPGvjZkdLl+6s83uv8965ADij1KbtiXrQGIWpLGvU
         4LwbP+jhYn879IiRg+L0B6IzOj03unawJ0n0pKwwTaaxdvWxDTT1lV619XsiKsrZPWNL
         LrQDhSJJmhfZFeHwM3N0AkSCtiOowMy2PX7JC6di3VvAPY7zLo282VzntJvYuMfy3PFi
         RR4SwRw1X9duisJELOFdBPhBvbEyLLsewYgwJcfrVFDBtav1QE95T+w+fOFuzlNQ9mnR
         pEVo3ADWmMZRQfPjxBw+7BZv8gewIfAyPZG1Wo3xFTw+znFacK143CxAYK0LNAWnjqJZ
         W0dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793212418; x=1793817218;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WLy4iM7sjMurHn68gexgh9d6giJhTKkJQBRBvB3l3v4=;
        b=fSsm7s7mACtk4GH/r0znA0aHzFa62iTXPxyjvvnpYH97kprUQ2Hxx/ZC+YBkFTttyC
         lmI9+EyiWOLIIQO6gF0rvtLwCCQstWk0MPckIOMOok8gKWVzqarI9uap2r7jPqRFQJq5
         zQ74LAMGvA8Exw6vS2Z+w/VVeW3Dz+U3ca0eERagGJX1lQvwEL7EqSZLoUVRFAhQWGrq
         y8as26G/U+cpF0pWjru4K+BvDODRG5Yb1et5AsZkfpS8zNdb8bC9vFBzOjm2ViNik80B
         4SutwREA6Yu707jrsX9/t9Uls1lHwVaHDgMs6RQPGMHqWW1X39TOs9LqfVuASr/cda+T
         O94Q==
X-Forwarded-Encrypted: i=1; AKwUvBz5Xa+FCnWCkj3CxbIQU2ojYEmrg9qAYAjzUY2zuKy72NNGGQiKqSRNkdh5IBLiqtQFkY+eQZHy@vger.kernel.org
X-Gm-Message-State: AFq9FYKr/3x5ByTl/UYKd/HbBgqJsX/jpo5UV+Y5pnpY1REma4D1LW7z
	Wp40s5F3xWLlmHcA98EuD2UwWh1D85h9+d7BH3O0xCxJ/7YREbdkjU9AnG9ZlfLTAiiGtCzUpda
	+4Drgiv8z9G3vjGoAKb030wxRYcRTYZY=
X-Gm-Gg: AYBFou36YIqzEB8V8Z/cVznfLHZMIE/EQPROmd+azSEHDSUX/9pyqt7vcA/lPFedTeR
	tjRkQkYBWHf8k2Rp6NnQ1rO9G/1PRfIIRFW1NFEhv80+YvhaTfjwhPhxmlllaI/l6nEf3HcgM+R
	PzVkiZLzVMUslvGV36O7Dv9FJ+FMjrWeCTooeOitGu27Du/8c/FinONUgt+dq86zsgpNdvXH1ro
	Wh/KiF7jd6DqmeDTRGE6KMxiQjsIFzLmwQjhXFhuq00NbmeNZmAfRNC3h5FTHYFhK7lbRG0nNAn
	RnbvkSsmQwR6nr8KdwGvbmESmh4fUnx13NhDZxeXpIyUzPvbDe3hM+qz/jX0YpPrf7yoJKhRDYf
	EEWrU26TxH9rV4jsk2vYjsCQ/ho+FmHMcTLHRii1NjNAwIaTMCWFcXY/fA1pj9FrQavTewRdM/u
	4Xolu7R6QLPAfDH4vW1g==
X-Received: by 2002:a05:6000:24c5:b0:48d:fbdd:4132 with SMTP id
 ffacd0b85a97d-48e5d2e735fmr7896834f8f.18.1793212418278; Wed, 28 Oct 2026
 11:33:38 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
 <20261023155407.0b519a3da7313137a0276119@linux-foundation.org>
 <CAJnrk1Z-zzKL9Jebk4XMpfOBtyArppGPTv3__GTbCZXGiEJjOQ@mail.gmail.com> <20261027192414.cb3318abc07232ec5f1bc937@linux-foundation.org>
In-Reply-To: <20261027192414.cb3318abc07232ec5f1bc937@linux-foundation.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 28 Oct 2026 11:33:25 -0700
X-Gm-Features: AclHuK88Lp-URHNAJMmVOulPZwNOZDWdUu5bfn4DmWPf6pmLBXKAO1fN5Zvq1ww
Message-ID: <CAJnrk1Zxwn8W4w5-rJw9DNPvZU0Or6Z26nL47RGxRHhFCKu=ag@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] memcg: reduce cacheline contention from lruvec stat
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 7:24=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 27 Oct 2026 15:57:43 -0700 Joanne Koong <joannelkoong@gmail.com> =
wrote:
>
> > Here's an updated version of the "Fix this by moving the memcg_pn_cold
> > group..." paragraph in patch 1 that mentions this:
> >
> > Fix this by moving the memcg_pn_cold group, which is only touched when
> > the memcg is reparented or freed, right after memcg_pn_read_mostly.
> > SLAB_HWCACHE_ALIGN only aligns objects to a cacheline, and the struct
> > is 576 bytes, so depending on where an object lands, its read-mostly
> > cacheline is now paired either with its cold cacheline or with the last
> > cacheline of the preceding object, which holds the end of
> > lru_zone_size[] and the reclaim iterator. Both are rarely written
> > outside of reclaim, so either way the read-mostly cacheline is no
> > longer paired with the LRU list heads.
> >
> > Would you be able to swap it in or would you prefer that I send a v4?
>
> Thanks.  I'll take care of this when I process the patchset.  Which
> will be quite soon now we're all merged up.

Sounds great. Thanks, Andrew!
