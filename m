Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794439709;
	b=aqUPEUdT0m0mMZkBH3ITwB3XNwSYByu1QQlCW89cJYsIocX1fCggJngvk28qdTeaJmlr
	 a59JK2VHYG3XJj81eXXyzANgc1uSPzMe7Jys/NM5gcPFPqEAAvTeEI4DWq0+8sx4zPfJM
	 RDCHVaRwvB6t2VLuTS+u+YiB2nNpiNQI1jZNwD3R4sOk4ZzYUAjsZ+yYjNW2GQ3lrE9ag
	 8h1wXhbZg7wWWq3DUGv1q610I5yrz7Hl0/vUgMEQCqPseoWo636Eu4JmgMmvWNzrUAV5G
	 EgsVP5GDgktrISCQ2uQDmye0uqRsmvU740VjDXugxwA6bPN2SSe2T9Xovj1fBqP/XYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794439709;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kjKsRt8cRszpgQ0Xyi6phaRtCt9rAnhHaLCwTH4eFiA=;
	b=FU4Sfq1B2pEzDIFMuAxmyhE2X9gDXMGsoA3KyrsRpFR5soc8zBtO6WNG2SehKyStnAMY
	 eybwe/SC8fnSgl6lHrPCl7/X/AkFLkoOsGezJv54o3UsQyGYkepGUIYSzLszU2vCyHmg0
	 foUljrH3d3SWdm+2sOf0ivAGrQ+uqajXfV14zTAF7yassu+xhO9AoBBKJm4u1QIgRJNZ5
	 jWwRN1TsSUWP6GJfI8155oBMjegwbrCDCrvmjbhb791W0iw01B0qH/LL1d6+T9GqLYD8t
	 /w5ptE8xovojvNNue5jIiDoSDdk4V3Ai06mMb2PLUs4I0+Q9NKSjMB8vYrhFVRNMfCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iCm0D5T5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E65606A331
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 23:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iCm0D5T5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836F81F00A0E
	for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 23:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794439708;
	bh=kjKsRt8cRszpgQ0Xyi6phaRtCt9rAnhHaLCwTH4eFiA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iCm0D5T5Ln0cjHZxEusV4a38FXqCDX92CgPRMWeJAdFstQL6vlxX7o/mQmrmbXGua
	 cTmgFcbEBZlF0ot5TiqvAf2P9dWA2K04hDK6k5ZPM/DTo7iJVNETGw4IimsMC0Bkkq
	 YRCKz6yr32I2uZ011ySUFEUGAo9VNCTdf9uFVegqFOo2Ok23SLqNDbpvOPEQCtZwIb
	 aXFGcPMTneR7hf9Uo0S9cuNjMUZUROl85Q4txGD/w/2sHZdYLJQc76OTUUFgsWj9tr
	 MS6san06x6XR8W8mT/HqPppkyEyWkkIyB7npDD34yjfnGPTZBR6kv7WebGa4LEJuYi
	 qc41Vo6zrjXoQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4322d310e7so561485666b.0
        for <cgroups@vger.kernel.org>; Wed, 11 Nov 2026 15:28:28 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFGvbVOvVamh9uL+ljyzIGuVzZEqzKHuo576ZETy0HaTZxaVVuXojt4zpKp4Fzjju93iSjcKH7q@vger.kernel.org
X-Gm-Message-State: APuU4Z/0/jbupU0qQ7bNEfnIxGhIcEMLhMF+Tju7CcBhTX9v8nyZr0W8
	xqH+OxU8yQnAqGp8yrmWIiFufwdYmA2g9U2yScAs0sxcLaL5yZ6bB+AaDy7tVAxen/lhW/DuF15
	sPFr3i+iFAaCh3DV9Y2J7B2kXwS4ozIw=
X-Received: by 2002:a17:907:7ba2:b0:c46:ba33:1f0a with SMTP id
 a640c23a62f3a-c5066c957f9mr308104966b.31.1794439707397; Wed, 11 Nov 2026
 15:28:27 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai>
In-Reply-To: <20261112-zswap-zero-limit-v1-1-19f33081b09e@perfloop.ai>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 11 Nov 2026 15:28:15 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP1o+L-akRDJx80bgGj8bf9rdN09t5upPfkduSmNKwpKQ@mail.gmail.com>
X-Gm-Features: AclHuK_hFEguqcApzcHoN8gE28_RQtMAzD_ff31LFqIL3UJmzagtdSNw4U0_8qI
Message-ID: <CAO9r8zP1o+L-akRDJx80bgGj8bf9rdN09t5upPfkduSmNKwpKQ@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: honor zero cgroup limits after successful reclaim
To: ts@perfloop.ai
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	roman.gushchin@linux.dev, tj@kernel.org, chengming.zhou@linux.dev, 
	mkoutny@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	cerasuolodomenico@gmail.com, linux-kselftest@vger.kernel.org, 
	shuah@kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 3:23=E2=80=AFPM Tom=C3=A1s Senart via B4 Relay
<devnull+ts.perfloop.ai@kernel.org> wrote:
>
> From: Tom=C3=A1s Senart <ts@perfloop.ai>
>
> Commit a65b0e7607cc ("zswap: make shrinking memcg-aware") lets a store
> proceed after a successful cgroup reclaim. That also lets a cgroup
> whose memory.zswap.max was lowered to zero replace an old entry with a
> newly compressed page, although zswap is disabled for that hierarchy.

Why is that a problem? Setting memory.zswap.max to 0 while the cgroup
has active swapping processes is naturally racy. The limit can be set
to 0 right after we check it again anyway?
