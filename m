Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793213468;
	b=X9XUN9M0ffgYyqTjH8uZapBF/+zOpuU75fT/s9kCvBeaKktBz5qk7hX13zg4PMs2Tb4j
	 S1d8lrhyyP7WAsQzSJD4v7bNKIbTS04eAhJRXVDzKqqvmjrvkGgqQSWQ2GQQTuEcRXbqw
	 7tLQQU+sx5ytJQnMJYAnIw87y4S0Z1fXlTkeu2Mk2DRza01BMqIJPYhQWyKKr7AXccYrv
	 F6xg+WwU2oP3r61BuLnSFyybpe97xtxq3eptTKXgdGkHJirL/FJdbJ1vuKtkMT/YJlZrN
	 dtrpd27HgXZcULnhFqLFmDGmgyqmUbVNu/dME89xb3jyAkOSkuvzP361ChJlEZZJ6Dw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213468;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=YsxFQdeZKl70TZpDvN7IvbuYmeaB4nmztdIPw08KPJc=;
	b=klv3GDWViEKBFgBrjOtaaFCOTEejfXHBehl/xgU+bdS4ryY/mX/7D5cM1dWhYz2GAKZb
	 vX4/peLvqPPtNhqrfH6JA407/R64GDNNU2SBHqJxHiivvcYnZitBLO8AHH25zosbdvCq9
	 sbTHtl7vqqJ6TqzDLp6aq7DZ5g8BeJA5CdTjdzbiuNpVWf0Wal5BEN7kNcXKRoQy7GTTl
	 3m3Sj2UMGaHSrhBPxq8aLV0gLrFp2fLUw1iP7xAbhJwX0bcbsoGdoT6QuR4d5qMJ5+J1P
	 ompybXTkyWwEHfK66Wsmf3ocnlFoYu7rtArWH0+4OLcU7Tzk6yfIzW3LKuaoL76jb9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C0Asfuux;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD60606A321
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 18:51:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBD60606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=C0Asfuux
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c45111bebso666084f8f.0
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 11:51:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793213466; cv=none;
        d=google.com; s=arc-20260327;
        b=dzzOQz1klGwDDDgPPB1ul9PZICWOsfo+Dkbu1ZwJLzd6hnoPHb1xg3Q6uvaF1deBQo
         /Rgl28wZhq10N0iQSGGGLyCSXbbxI4rFsgBXcMGw79b+9w7rKfP0y4scPDpR5y1J76OP
         x0xsb+jvD3CRfbxx44c7EY/o3jncZotnWSIH2xlWPouezpCJ/W2IQG19Rwh5ki06Mvct
         /K/EFo99xM8NUu3phXcipog3Yg6fJ9YF9abK893MCoEkhoEZbJlM2kdkJIU8z0VxRBrd
         P10AAexasxMul6z0shJSQouj0+zalfZ5K88eLEPXAC8EW3RX67vjQeHuPJOilaub2+1I
         8GGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YsxFQdeZKl70TZpDvN7IvbuYmeaB4nmztdIPw08KPJc=;
        fh=MqjiDW+yMc9vS5wWBgZuNi2EdfK2cLX4uzaOkMc3Z8E=;
        b=mJBZu985f4WT3+3b2VCmLCn+RiJI7TUAaSXrTc8ES84ZwwG9lIxYIdMU525OVUhfHF
         YSUca0GxfIMdikf0sKODzlRm8lzuhnCI6mA/ohTfQU8vsimZmMOWXTwXIAKyJMmlkUz4
         fJKTiYPUJNb2GOoUXjqvHTiuQ2qMHoXcqTi9bwyI++zRzFNHdNODvQ/5SpwmAsE7hX8y
         hN41ALIgUwMXj1mXT2UlCBPOynYPoaDTyFz4vK2vOpb1BucQ3t9s6fjwOZ50pdyhkKfS
         jdy56+++QP1AIFXs1ae7Y+/m0M0q/Ohi2vivpzmZ7S3xIGY7vuj4bZeyhteAn1kt8V/s
         8UmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793213466; x=1793818266; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YsxFQdeZKl70TZpDvN7IvbuYmeaB4nmztdIPw08KPJc=;
        b=C0AsfuuxwRpzhksmh1ZND/ylkN13pRdx7Kxf1KnOi5bablp1AE8thUo+dzAYNmWgzF
         JoxRq/+In78VSZP1feuD67V0gaRvK8cZqNcIFHUsCmFVkI0fK0t1i/3F/GaJJH4ULlVr
         QUKbIhN74olsjXZK1q3SIzmbBfk4ilFwQk1IjatO1KFf+2DSRgHVALTVQOg67XkX6TXq
         6uxe+ufB53w7i6JOUhYzkpd56iJIr5oI+D8U6NrmAQgIcby6V8+Pneuq4KVrDHBdI6qO
         r0//ziZSP5WjeOg1iHWES5moe1lLMvfXWkESuLanvIlurnG+mpW7eYLZ0b4Yrb5Jglo6
         zgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793213466; x=1793818266;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YsxFQdeZKl70TZpDvN7IvbuYmeaB4nmztdIPw08KPJc=;
        b=wrHKL9WmETsTPkwPD63b9ioimbGsd5Hx6SAOFnYHV73ifB/EVWivwoki4qLOv9eQEg
         YV6KKQKEGLf0A73VaDXyTGDV1oRIxXvoYNQyFEFIRfe0ULTmOFTdJLSO3A/nnY0WB8PM
         g9hzo/uCj49kkhblYniwxL6q8N9kK1mm+n4X0kqa/klDIAm+amOJAhM6W9447yb2M3SP
         WU3gXhXn0p6OcCUcaBGFEHOd09S2jF+sTWFQ7Br0n2M222DQuFnh5pfkwR6wOdyqIoL3
         OrrN+d+euv0ocI/3U/0fKfnZS2k76CwIfg044AF6dd/lldUc01vKnJqvKE/Usl0ksZhI
         ZyiQ==
X-Forwarded-Encrypted: i=1; AKwUvBzOXWMDqsaBopWJ3602lRnoLCkIn7waYAjYQZ3tcTYMGjgM5Cla8qvbSz6+7WVFi0BfY5/cSaUE@vger.kernel.org
X-Gm-Message-State: AFq9FYKH/r30jnZC/i+2w93U0PPle45dV/7qF4DsZDuvFeB/SjSydOR7
	xwUSwyWjZBBxUnQ/j1IyPIOicieiSm+JBEzGfMiX/zra/VGo4xrPfZRrh3Nm05l7zUw1WrCB6A+
	REDSCV4XmJwiEK8F7aR65kaERRttqH10=
X-Gm-Gg: AYBFou0v/6C9crv27kELa6MUn3fX7QnPxsCxEtfF9mxjQRBLYYo/myXAMbXGmL0/COE
	UylUhkCwtdKnFTLGUIyHqO8EqrkRfceHlCYrHDZHKA7gEoNuwUjcxOEIYe/1hm+OaWmnsH9zvDg
	jFnOEkJ/knjAKYcvOBpaKWqadQvGlHhlAE8t74zf7Esx95o5ofzQifXmcyIb8EVm7cUjgRBQx/g
	SLZq0daTHdkme7uw8GlwHfvOnmsX0km2hTTueQ8YbirnDvXuofwV7QMjTkhCjf8PwI7HWNv+OrD
	3JAS2V1Q7NHmSSKpIRqcKJ3trTzAjuLVlkjmxlZgCKOnY4zHv96MqxZW8CMrQVNaIyXXJ5zUVYX
	v8gkAVR6u2fVm9HEGdCEVR8xotS12Egswz2UlOCc3UhRKfoyCpdHu1mvsElxM9Q+59I+MyXtNrC
	XVgYSiLOhvP2AzfX+S7EbDSlM2CuQSdu9H/mYJLWY5A+IEF7HztjEr
X-Received: by 2002:a5d:5507:0:b0:48c:6fa4:fc89 with SMTP id
 ffacd0b85a97d-48e5d2e704emr6315682f8f.12.1793213465946; Wed, 28 Oct 2026
 11:51:05 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
In-Reply-To: <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 28 Oct 2026 11:50:53 -0700
X-Gm-Features: AclHuK-Cll-04Q9PCKTnwQsH04kXEbIsuiNTHafay22oqcGn_p331RDj9A27JMY
Message-ID: <CAKEwX=PEkQEap=KRsutwtuXp23=zoeCNjdk=4rcLJtO_3ESFJA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 10:24=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Mon, Oct 19, 2026 at 5:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 10/19/26 14:24, Nhat Pham wrote:
> > >
> > > I'm traveling this week, so it's a bit tricky. I cannot make Thursday=
 morning.
> > >
> > > On Thursday I'll be traveling back from Cambridge. But hang on.
> > >
> > > My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.3=
0am - 2am.
> > >
> > > I could just naturally join that day.
> > >
> > > So one day later would work for me.
> >
> > Would that be too rushed for you? :)
> >
> > For everyone's convenience, this would be the time slot:
> >
> > PDT: Thu Oct 22, 5:00 PM
> > EDT: Thu Oct 22, 8:00 PM
> > Europe: Fri Oct 23, 2:00 AM
> > China: Fri Oct 23, 8:00 AM
>
> Hi folks,
>
> Thanks everyone for attending - I didn=E2=80=99t realize swap was so well=
 loved :)
>
> I took the liberty to summarize the points being discussed - please let
> me know if I missed anything or misunderstood any points:
>
> * Swapfile sizing: Kernel kept swap slots after read faults to save IOs
> if these pages are swapped out again, and thus needed swap occupancy
> (and hence static size) for a heuristics to trigger reclaim of these
> swap-cache-only swap slots. However, this is not useful for fast
> compressed backend, and zswap invalidates its compressed copy on page
> fault anyway. Vswap does not need this heuristics because it just
> frees up the swap slots eagerly on page fault for in-memory backends,
> and rely on the existing slot reclaimer for physical swap backends.
>
> * Logical footprint limits and charging: cgroupv1 allows logical memory
> footprint limits (unique page tables). Cgroupv2 controls physical
> memory and swap resources separately instead. While virtual swap
> entries continue to count towards memsw, cgroupv2 counts only the
> actual resources they consumed - post-compression size in
> memory.current, and nothing in memory.swap.current. While cgroupv1
> continues to be supported in its current state, a cgroupv2 transition
> will present a problem for memsw users that still needs to be worked
> out in some form of overcommit control.
>
> * Swapoff: this was brought up as a request, but we ran out of time
> before we could discuss the motivations and use cases behind them.
> Folks interested, could you explain as a follow-up?
>
> * VM_SPARSE v.s xarray: no performance difference between vswap v.s
> part 1 of the xswap=E2=80=99s patch series. With all 3 parts, there is a =
win
> for xswap, according to Baoquan=E2=80=99s testing.
>
> Let us keep the communication line open and coordinate on the next
> steps.

Hi folks,

We made some nice progress last time, but I think it will take more
collaborative efforts to drive this one through :)

I'd love it if we can meet again, say next week (making this
bi-weekly). Some agenda on top of my mind right now:

1. Use cases that are glossed over last time (swapoff).

2. More interface design.

etc.

I can bring some concrete proposal to the floor so that we have
something to work off of.

Regarding the time - would shifting the meeting by 12 hours (so that
it's morning in NorthAm, evening in China, and afternoon for Europe)
help European folks attend? I'm fine with the old time otherwise.

(BTW, we'd have 5 timezones to accommodate, because where I live,
Vancouver/BC, will be in its own unique timezone starting Nov).

Best,
Nhat
