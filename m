Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792792334;
	b=GVELCX3ZcjuBFmKkDQUIViWwugebcZUrHeUpQEqBGJoLL3OGJvVX56DBdnwSWS/cb+jS
	 WCwR4k2sH6AD4eguFW67fH0vG8P/vOODYcWRkThn9NbGOiuS5clLA8u/uN4Z+igj3o2IK
	 orvyOHQZFrlqd6jXAWQi8fxIb/YbnKnEajwjd6bQ5o7+1xfrud1WOi7r5/qZrq9vkbVmr
	 IBiy2pf2eA9izRvthqPD3oZIj2i0xW2SB1FqEGkzFKt6JZci+YHCngmgUjATQ2Rgs4qnq
	 pVw3g+Ri0qk2Wc+Au07YteLYKgaZESgHdn9ELBOfMLp/a49ZrlorapkTn2e7q6JP+rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792792334;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=jU1IZAOHq9r8Ir5hIP1rjGnLwS+weWaNtdurABD6X5g=;
	b=gCwSb6eU0pPP6wBG+mSHCp79tGu41LUnhCWl9NHddkS6hg4BX/k0eyYEkPQwNot2HDEC
	 85ck1Zq4PbYiHBh2zA1Hfy77BVq7oIrxaDQSkzxGI21WwFsTcBQNHkZkQYnxSwcuhsU7m
	 DEbF2FF5VySzA2NXwaKF2P0ShUF6KPchNa0SOarpVasoZW/CSB6AkIs8dDTp4WEYd8kAe
	 qgqYTnWho85o8CZDAyVR0mE7MAuwBINWryHQVjPRO3UomuNq8sVzt6uCxzs7CPXtQ5FU2
	 wtnVFvtZqRls4i6IfwwFkhoy7r1aObRCfo6HusEpNVJ11hAkE8IGOev8IkcZ1AaBPeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=HGqGxOqE;
	arc=none smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2625A606A31D
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 21:52:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2625A606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=HGqGxOqE
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91c3fd7bbdeso9978116d6.1
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 14:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792792333; x=1793397133; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jU1IZAOHq9r8Ir5hIP1rjGnLwS+weWaNtdurABD6X5g=;
        b=HGqGxOqExzIyB7hPavSyBDvkHprEJhOVaBIV5g5URIZNOHs9N4YRyG5vMPVAgS/q/e
         I+cQ4l3HPXviBlFxpvlTlRpxuOp49ndv7fAU21ovgA65rnX2guDwXIma4qyoNi5MLYEW
         XdDuwvuS3z1gB5IYmho6szpf4Tiu4hoTuEnvYWQ0aVg16z3kioAJj7b6bMtlkyHxzpaf
         x7JCS2bPNpM2zG0eH4t9jDuct8F8iPqapD4rp8QHG+PT867T5gcDXwMdI93RmUcWGrEb
         R5C73gEQs8Vwj6CV7Ik+oQgE3G211F4vOsU82Rad62zdb4R3D4yQIrQarhQRnytIwAHO
         BB/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792792333; x=1793397133;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jU1IZAOHq9r8Ir5hIP1rjGnLwS+weWaNtdurABD6X5g=;
        b=L0ZJM2z51/Q2FbzWclLA37XIYN9wdz3jbmGV15kW+Nuz3eNiA1OHOWEQ4SMs/0ZTI+
         OYfrPUH4zAAH9lPr+1k3srxRQhP6c3yGX3WkRaEii5I9cSdY8CYIfgYx9iqU5VcLC1V4
         Dj8dPBFMcKT7NN4FdZHqJfeiZpK0yG54lah9a5Y1GNwxVOK7hfZPueVgRZEXFpAR0Eaz
         qVmgQwqvbu1wYadilSwN0OuasPlaQ5eZba9DjCdq82RGQ8j/f0gsBVGXmfxSkfyZdLt+
         99yo1ftmA8quG++timum0/eTkwYg75iSg0fxanQqksfHwdPjAHDuI3rtR1ZpUY+tHwYJ
         lxyA==
X-Forwarded-Encrypted: i=1; AKwUvBwqR76CNQRjOj5Rnd0eWisyN63doRQTDGg1ABms/+R/MzyhHR0H61dCaVWVFjMOvRrnTFp8aLOT@vger.kernel.org
X-Gm-Message-State: AFq9FYLR2svJijpPMN5Y/SEPu6+igOBhte0PRXn846kVJ0cDy7WGp3py
	fc9N1MnK8mf+e5B5GU3BwxCTJBh0ewT6bUKq5+uVT+svKdQc8rIFvUjQLrDtiSG+0ME=
X-Gm-Gg: AYBFou2k+to0aGfplbucE8xlesGapBAeQdxaEzbRnm7UdPSMlHtGJnGs2sq0uRlqWHy
	/x5tZKP9v7SAye4/pgW8L71FLjRw3ut7bynN1wuko6msu7JcGeKtS3fx1odUcA/b6O/futTsslx
	sG7NLyH+95KdYa1CMpoiKVr5Fdn+Y4syvkAhd0LRhbHzvSHkXjMM/tQtCOz1eK35KQSj57csVVu
	BgfXRhnVCHoYr6iAs3qdt2DAiugtpeKo1w2zSewZ0JD1ur73uew51vjI2nARA+rijks0PivUPo1
	ANfPymQQBvPinq/GBu0TAgCsBRyrzFUwMnK5Aqxo04u6L+z8Krz1yR4JIKKpJBVS2ceNCMII0VL
	FcMLAOOuQZw2AnBmdV1vM2P8nyzSMfuEeLnPbR+2ffCjo+8VVVRBch/I/zYSo5IgJJlCaOtDEfW
	riD+OC2wlrvNxdVse8fs2yi/d5Ndp2y9XmjdCC+awgKeR4qN42/f8ryxcVsbf8TGJk8KACCy6c7
	Ze7lNk22NDwZpOW5aZ1qEMNHIjgk1GWazNpSZkw6LvOVHlrvn3IpPa0cD4RkNV+whggFMP1uuDG
	ctDa4lGI9B1j7B/erchRyjPyBCc=
X-Received: by 2002:a05:6214:5c45:b0:91b:8870:3930 with SMTP id 6a1803df08f44-91c48e76cf4mr5685596d6.45.1792792333037;
        Fri, 23 Oct 2026 14:52:13 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c6f3bcsm5375386d6.29.2026.10.23.14.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 14:52:12 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: Path forward for Virtualized Swap?
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
 YoungJun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, 
 =?utf-8?q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>, 
 Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
 Meta kernel team <kernel-team@meta.com>, 
 Linux Memory Management List <linux-mm@kvack.org>, 
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
 linux-doc@vger.kernel.org, 
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>
In-Reply-To: <CAO9r8zOtK7YYdBNS+h5bNW-miKED7p4G0igy=D-=HRnGqA-38A@mail.gmail.com>
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
 <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
 <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
 <CAO9r8zOtK7YYdBNS+h5bNW-miKED7p4G0igy=D-=HRnGqA-38A@mail.gmail.com>
Date: Fri, 23 Oct 2026 17:52:11 -0400
Message-Id: <179279233116.3784731.9576593182600250610.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-23 13:25 -0700, Yosry Ahmed wrote:
> On Fri, Oct 23, 2026 at 1:03 PM Rik van Riel <riel@surriel.com> wrote:
> >
> > +-------+     +------------+
> > | vswap |-----| swap cache |
> > +---+---+     +------------+
> >     |
> >     +----------+-----------+
> >     |          |           |
> > +---+---+  +---+---+   +---+---+
> > | swap  |  | zswap |   | zram  |
> > | file  |  |       |   |       |
> > +-------+  +-------+   +-------+
> >
> > What exactly do people want to accomplish here?
> 
> Today if you swapoff a swapfile, every is swapped in into the
> swapcache, whether it's in zswap or on disk. With vswap, you have no
> way to trigger swapin of compressed memory in zswap.
> 

This seems like a missing interface in zswap, rather than something
vswap needs.  But you could just write this as

vswap swapoff {
  disable new backend writeback (swapcache fault-in only)

  for each backend {
    backend swapoff
  }
}

so rather than vswap.swapoff() you'd actually just want a stop-bit that
says to disable the swap subsystem writeback behavior to all backends.

Otherwise the user can just disable each backend individually.

-- 
~Gregory

