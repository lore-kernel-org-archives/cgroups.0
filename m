Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23D03A380F
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 15:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790178012; cv=pass; b=bxH+JgMxPn2FPyd8AmkWxKDo4MIwx4Oq0POBz1k+8hIYzR6aXIh0UE5/d7UdKISvm0nENGTfvgu9fDETUbxB0XvSMACNd/6miCmevZIFyUfJs1mUwN+Pp042FtZ+SdT1n8KOlQ2nalCafDKzSoq/So0eoXvyOjftVs/05cexVRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790178012; c=relaxed/simple;
	bh=oRTF3Im1M+Uz/L6RRIk5YYuOIAwa1Ue8MbZXRrHJCXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LLlZSWRzOO1EW/ZlchAq4PPzxdgkLco9uINILVJNR77NUMfYWWFH8W9mfw2rl6KHm5rUhSx6ksvAw/GlaFnXNkbIxUk/mz1PnPAuFRH++pM0peuDWE6qNLdiupCuL/guiVKzWZJ4JLn1UOVkSEJa82jR8rVphLG7duEFzS3wIuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K705h6J0; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K705h6J0"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e620fa473so6507575e9.1
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 08:40:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790178009; cv=none;
        d=google.com; s=arc-20260327;
        b=ZzxpDAeaAf+bCi/UR0flUr+JYSrKgHwrs0Bqklx8YXMLI3E4j140ZBdmUyMI0CINdX
         XSDWBQvLGeO+gwUqcn6lqoULBXGts7QmXbyehutfGB6SvsCJsfU9xXak2WvaI6qWtgxc
         SG+916C2T4UEQqO9meub954b34DqaOmG8t4nd0bsWXR4OyqdORubpOBS+sxAUjkFL+SO
         cUOD0mgKre/DxlkZt92EvqjFHxC3Np8ue6Mlr/5lOCpkAYiFy+M/jm3vmZ2LGwsWY9XQ
         ynj3bTXO/ZRotNmx6fo/Ohzu3SabsCGxPHJMFCmRonSrfGrPi1P8zyNXNYBdktOfJFl+
         wOOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oRTF3Im1M+Uz/L6RRIk5YYuOIAwa1Ue8MbZXRrHJCXE=;
        fh=bpvhw/K8kesMCSfMhcg+XXvZ0cBL+sg0j5ehOmdGodI=;
        b=cuBW8me2wPbxtWooro+4alimSqQsZZqMyB2i5VN5rTEqopNfoBkHSeYUWus3M5hMXn
         XrHsAgD4/J9JeRwNnKral0u5zrvP+gCKo+IGwIuL+zn6II3DhLEMWvJf6FFzF8nYByEv
         UcLxLtxRR6Gx/wedv6tBdrfYN65HwZFvenEs0i7vUmV89xgV6KeB01WsCcanrqwsGRbS
         ao78sqYo81zZg0StIqfjHObUSJ9STQr2JEwq0p8nirgR6U3a5IA5PYfluzaS035V+kmd
         EBINhFDUkP3X748QB7BObwVNRLt6jKygLaz1kdO3+vbUjDshYkTTAd99cw1+VQEroJfR
         UYSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790178009; x=1790782809; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oRTF3Im1M+Uz/L6RRIk5YYuOIAwa1Ue8MbZXRrHJCXE=;
        b=K705h6J0PMgHOuxIzLtaakk50Ggqez6OUwBmnqx5qii2clr19ufvUQBm+UpxsuYk31
         JkojYfZQUkvNXoRCFaSQMubgvEdPdcjREJJQ3FpUX8xwLgU8d/3+RNEv9xSF1F6vjAga
         fgzDoexyOVw2sVIJgqIk6yH0oM66AGVlEXaMmGi4BN/SkMI94qL6FPDdCYDnuxIFnASC
         OniyjjhzEo8gZBQ5QnzGIfYpQAZPfTSV1yIEyNg2mxi+DoHePUoZBENKOZwixtSqSbg3
         OWzpeDLlKi3w/umHgRL0I4vKI4+qgcyiXZ3Aa2/v8QbKzk1CDEwisq6GabreOvQag3/c
         ew+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790178009; x=1790782809;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oRTF3Im1M+Uz/L6RRIk5YYuOIAwa1Ue8MbZXRrHJCXE=;
        b=zC0g9ycuoQsQxIAswwxYnoW/NNHjz6l+vRHCq+WKv4nO6eP1yz7yo/YBAoSYz3U9SK
         do3tXh5+wwP4VsPPkFbDVYY99D95X6XCdmIWiA8cshZEUniAjJTyuIUE3jXqJDKL54/l
         xAwiilPjEaP422TYsOnn0LhL2Ip1PufuhOa5SacBYZc4xMPsTmNhoyvkvWo558+yC6RV
         0BUVDsQIKIEWwV5vg/uFemI2vPcX8k/rHOs6lx2I8sDKv4aEtrmU0CJ1GPSf22YxaJE7
         W4wfmF0KMuL2QPNw3Bdwb3mi9GLP5/S2/PO5/YWBVYGW9uhLqiLMfo0gd6kzZPqqDShG
         Xb3w==
X-Forwarded-Encrypted: i=1; AKwUvBzxz/XVW48QVrN5jGNv6ZaIDdEA1TbDhZuAet9d2dYm506+oy7UzvUPdQbQT13GLYse/qPKqEN8@vger.kernel.org
X-Gm-Message-State: AFuF++n1xwwc+SJIMwyIQWbCV6+csZ9i1QFNT6zg3EmM/797rmzFK6ES
	rAuDanKfebz8F2ac3YMqCcdfaroZdX+FhyeNbOXvftBq7+QLlXb3VlbbdbKs/QBy+orzxX3BbO6
	UEyrQYu42rJNntkYvOCVB6eJNCUfD0Nw=
X-Gm-Gg: AYBFou15ezwAofIdPetxumW37ShUKvffWuWSuvr+uXBxsn0Dq00NIz8Tl72PgH8HppN
	VtsJglWneX6gRYbOPFf8m62kG4uZdvrpPAJjndRe+9QLAH9KjTU72egudxHqwF01BzQlt/TPrBD
	7h101CfPuWV62FmsJRtJoe7z9eDBTK1+NKhovvnhj0M5jYe+B7xYpLSUGA3jbyPr9RpnMt5ddew
	HdVmEVO5dqAgyLzQ7RY97g1SuFTTO2XkLUNMeNRKmLcVvxdYEG+sOvmJtiDuiSE0ZpSCScaPya5
	WpnlLVLZbQxqHshETgMnT84XriTStaAcRTxTTSvYmRbp9CWVzhWRDZe3gcgpJ7CkQPyAXtfyt9o
	2w+TSs6zAIx4KKmngKmaxLA==
X-Received: by 2002:a05:600c:3b98:b0:49c:ffe3:2b3f with SMTP id
 5b1f17b1804b1-49fdee0b045mr49105485e9.3.1790178008824; Wed, 23 Sep 2026
 08:40:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
 <CAKEwX=NrN7-u7gnGvWX3qfHaBQcN6FKsFP-4-k76F=sxM1LJqg@mail.gmail.com> <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>
In-Reply-To: <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 23 Sep 2026 08:39:57 -0700
X-Gm-Features: AclHuK9yzZQ8knvLntjCBA5cf9Cy4ULZiHDGlI6Lczzxd1aMzXh7STrzunZTFqw
Message-ID: <CAKEwX=NHikpXLJio+c92EVp=uSqPgS4_JFkWg-9smkGM=XTo4g@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 12:38=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Tue, Sep 22, 2026 at 7:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Tue, Sep 22, 2026 at 8:23=E2=80=AFAM Chris Li <chrisl@kernel.org> wr=
ote:
> > >
> > > On Tue, Sep 22, 2026 at 4:59=E2=80=AFAM Rik van Riel <riel@surriel.co=
m> wrote:
> > >
> > > Yes, I can agree on what you observed. You are using anon + zswap on
> > > that app alone. That is not what I originally asked.
> > >
> > > My original request was for the whole system: what percentage of the
> > > total system RAM size has been swapped out to zswap.
> > >
> > > Because when you have 100% of zswap out, it will likely trigger
> > > different kernel code path on allocating memory. You might suffer
> > > global memory pressure you did not observe in the single app memory
> > > pressure case.
> >
> > What does this 100% figure refer to? Pre- or post- compression size? I
> > legitimately cannot tell.
>
> The 100% I mentioned above refers to the pre-compression size. See my
> previous email in this thread for details. I have been asking for a
> max(%) number in your fleet for more than six emails now. My point is
> that 100% is not a usable metric. I suspect your deployment doesn't
> have machine zswap even close to that amount. Glad to be proven wrong
> with some real data points.

My point is that it's an invented problem because of the interface you chos=
e.

My interface does not require setting any such number or cap from
userspace perspective. The only cap is based internal
implementation-driven.

You're the one proposing an interface with static limit. You're the
one who have to justify a) why we need that limit in the first place,
because that's more work for userspace and b) why the default value
makes sense.

>
> >
> > "Trigger different kernel code path on allocating memory" what do you
> > mean by this? This reads like you're referring to post-compression
> > size, where one cgroup eats up the RAM of the host, affecting other
> > tenants in that host. But putting a limit on the virtual device
> > capacity limits the PRE-compression footprint. It is a very
> > unpredictable way to prevent the effect you're referring to above,
> > because compression ratio is unpredictable ahead of time.
>
> I mean triggering the direct reclaim path because zswap itself can't
> allocate memory for the swap cache to serve the page fault.
>
> Chris

Then it's out of memory...? If you couldn't zswap those pages then it
would just OOM earlier?

If those same pages are not in (z)swap you would have bigger
footprint? I don't understand what's your concern here.
