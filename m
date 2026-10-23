Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.221.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792795142;
	b=DNyJT+ad0kV4xqQERq449L7Xeq8+UNc+m019kd4MeAMEdOgn6tq5XxQLWzY3sbXGSBvu
	 ewjsgprNomtSsnHi2ook1UoDdEzCF9CEZi4NInbUHi/NdCZbITwpB7bd87DdBCPmTfHF4
	 v0M55wcNIoxuJd9cYLoRjaPhb9T46tYAjZs2NlIu5sG9VT/ssw1HZo271toSZszJDJ1A0
	 2MTkW7AxoIItzg/DZ1W90TfFfMndV+aOvi1a9HU7w8HG7852otyxxvJhnMTQAVxHkXhiv
	 2yReA8tGz7hbEa9jFIZmVN0Za+B7G/ZF1tJFLuED/aYzKdd5Jc8P4vzlaT8J6xvE2JQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792795142;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=DQb9soIuy2IWf1LrfZEp4aNcssN1ddSrfFmGCMehWsg=;
	b=sabcR10Y4ePKfJbV5aK02ZRZqG0bXplvCIuVUD4q3Xnr5/XS4fxyBalZE54v8Uq/sstu
	 EprqhEUp9Kasv4z7rKLUY1glQZJFLd0NWlfFgdWYnYv8qpN5j6O69RVKLhb8HHjnIpnTz
	 auZDiDDT1PdLWh6RLbI14/BwIPNDjUhE9lynpI2JJRIeEllun+7NKslOiNP1NndCQt37a
	 pVkfJChLUmOicQSUI3/b7GdaNIWgK2FsdRv6V0Gxu34XgWqm02UExTQTcXgdd20XT5Ofj
	 L2FSJrNo16Z2TxXC9xCRFaK3w9ASgM+jmGuWZmKx10z+crKd2ma8fm3YbTj8qspyj9g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=h2JEsMGR;
	arc=fail smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D982606A31E
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 22:39:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D982606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=h2JEsMGR
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so1109190f8f.1
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 15:39:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792795140; cv=none;
        d=google.com; s=arc-20260327;
        b=if77FE0+w+Pk4flR2tpfZe7J/2SFqvggYdp+eeAYYDoKEq68PE1ePgwHv36u3QqhRs
         z458xwRLjUBqDRI3DbOk0RXvQ9KRWreY7qnQgXHraEnp/xRYCjwoNeDeF04mKmFYnWxG
         QkDp4perB/8dQrRRUApD2psYSoacfucZwDY38B82YfhmHrvU3Wxwv4oPpeZzZ/fwKyi+
         ynnZu8haS3NWYIX6r9CpEYBG4kgYmOl38MMMls3tZwZAyBj+QsZFT06qZgFTfg1ZIRUO
         efW/7XlihhjTJlxsthMwkyCYkbz3Has3XmIMShS4eQ8VvXgzkTRq7EDpIqR9n20ALixb
         CJPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DQb9soIuy2IWf1LrfZEp4aNcssN1ddSrfFmGCMehWsg=;
        fh=W3Jc7klygClOHA3X+XcJScg/r3Nq+pmU8q7VfdUGSQk=;
        b=MNhxaH5hNjed/z5jQyHpaQ9FRmL+Ixqq+EA/wq6E8IvfEoTNDT+7d3AtvGqo1pdoxn
         SNHxQ+jrG9Cw4a7eAoGmLA/+jpGt9Zc6MWtZ6BYNe/7ZhkwzrMNsJZ2Fg2E5DSulvc+g
         nD7pcqBZ8FXIq9vqvA6JR+cD6HU9YKQQNFAo2YzO69fwSWPSFf5yG2e1Z5kB/EVccv/z
         J20RuRZKnkHAX7gG4tY5FFBGjgs7ncK0H7godsk7sZK3WnNhbrBPfkUlRYkzy0P8A7jH
         5buguBLoLVBJ1YomLQf50pI1Z/EbVxDHf9EW5bX8K5C+qzxG8WBOZGHg3KKMcOaZ9OUp
         WqjA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792795140; x=1793399940; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DQb9soIuy2IWf1LrfZEp4aNcssN1ddSrfFmGCMehWsg=;
        b=h2JEsMGRrVURSB0j47TGc5GJasxIhVL/JHhnfpggkvfbknB7iXYx4eM3fv179YZizS
         UDP0PvSpu3n/sqjgLr1SrF3YXEfIYj+wNtrMzD4T2trvVG1avenYj5g3ZI+meZwGPRK9
         opn7VSPA5ZI7wDpF+91pO+99cubxigV7u0ifnJvgrwnqjxpMGyoOflnN2rJ4GbjRUn3+
         UaYcfeSvsBOUXLlS3Itld7VGw0rSpsygpl6Kkm8EnqjFSllNzdz/+Afc6yuZBmetCJHF
         b5ayg8KUcHpQIuOh3oxQ67ZOL86P+WJV6NHR/yZMHzjfHGdS/VoAQ/Ssp4lKbf3Qm6nI
         x5nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792795140; x=1793399940;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DQb9soIuy2IWf1LrfZEp4aNcssN1ddSrfFmGCMehWsg=;
        b=TwJqarPZ/XEcj+0+tEWeZVbBqi/+IFBdgruk9rIT9g7C9Cj3ddQq+ppbYLAJ94s3n6
         L88cMAySdF2C2w2VbDKivHyMNssXSjaGJ3pTsnn09I/GT8dMcBZ+hUmCewBPIxds0e2E
         jjO7ewxrFktsIRWOhKtVJ+od9KSRmj1Pq5o+bkO8cLq6owXtENvmdAYJxpLWnEUBe6+A
         LymqVEEdtewZOZ7tzuqf3wqxGmaJrH8L3wldHpZtCjLok+V0U+1TaZYHe4EfEWdNRx0C
         DoXKqmlhZI/YyfrL/a0/djyrZ7CCRqoQR1ewqGwWTbYvZBrtdn8+eCJXYaGvTqOUTpeV
         q4ug==
X-Forwarded-Encrypted: i=1; AKwUvByM/lfK+T/+eBrevhz0qAILuhnbIMujaaIPUtq57LHC+YKCMrZAXgC3h3f0oTSsRDpAZP2uR2FJ@vger.kernel.org
X-Gm-Message-State: AFq9FYLtR357vmvkwdR+UQ8FfsswKDg+NbSfWX5XP/8ru4kydSVbs+DA
	BpffCd/oD8VCXTIxfik+0j0J8JxzJLqGXj65IvYO3C1uVf1k4uQd7c5D57yJ3H55Vyuut8vCEIb
	v94kxqsqLFR+wy9GF29V30ipA2oZo+Zs=
X-Gm-Gg: AYBFou1hImIHKR3ggDtdknhBNtkxvfuFpHsYpSeZJSnU1sj69dVCpj5X8Wdg3gOH5TQ
	q/avzvu7yPdfp+nuSV37X3FED140s8qzLU7R+h4NcwqMckqCQNDCTsBWe3TSVE5XjDlJrZQUbJZ
	4PQgA4le1DqBfNMtGesv/x53IdgjRB+WdER5jMv8DQkOU8zwfUtkqrlkV0CZUTMxc9HisnmSNVy
	ITxLmdHty/SiH65MKhuk3FI9cernQ7sQ5ShYjQJsgmfidUsADMbi6CIr0HD73Q2vG1mda0rRfJS
	Ppli+7HXRi+Qv84eRoEVSf1a1p7x+8JVblWBc01HWFdaa1rBgL7vT4n/viZ+AdyiWsVAMCPcaYi
	rzf91ymBFfSiKxAPjIP4ReJGoslWnuAaez7e7aQpXJ4y7B1mnJOPPHd8yq32/KvPPvCRfBxuPTs
	e80mSZ++4VHO2OPUI59m/rAPO5pob5PHXQUF5duVOulrl3CoSlnVTG
X-Received: by 2002:a05:6000:40cc:b0:48d:f069:570c with SMTP id
 ffacd0b85a97d-48e3eb93429mr575083f8f.41.1792795140106; Fri, 23 Oct 2026
 15:39:00 -0700 (PDT)
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
 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
 <CAO9r8zOtK7YYdBNS+h5bNW-miKED7p4G0igy=D-=HRnGqA-38A@mail.gmail.com> <179279233116.3784731.9576593182600250610.b4-reply@b4>
In-Reply-To: <179279233116.3784731.9576593182600250610.b4-reply@b4>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 23 Oct 2026 15:38:48 -0700
X-Gm-Features: AclHuK_IYUAj5HLbnP3AeCgr3emPoTaAjXpZJxAWWXcpmGT_QzEhtpufA_J3jmE
Message-ID: <CAKEwX=Nf57X+Bb7C+0L1L6bkVDw2rjTMSfn=xuMRsXY_qrB_ZA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wenchao Hao <haowenchao22@gmail.com>, 
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

On Fri, Oct 23, 2026 at 2:52=E2=80=AFPM Gregory Price (Meta) <gourry@gourry=
.net> wrote:
>
> On 2026-10-23 13:25 -0700, Yosry Ahmed wrote:
> > On Fri, Oct 23, 2026 at 1:03=E2=80=AFPM Rik van Riel <riel@surriel.com>=
 wrote:
> > >
> > > +-------+     +------------+
> > > | vswap |-----| swap cache |
> > > +---+---+     +------------+
> > >     |
> > >     +----------+-----------+
> > >     |          |           |
> > > +---+---+  +---+---+   +---+---+
> > > | swap  |  | zswap |   | zram  |
> > > | file  |  |       |   |       |
> > > +-------+  +-------+   +-------+
> > >
> > > What exactly do people want to accomplish here?
> >
> > Today if you swapoff a swapfile, every is swapped in into the
> > swapcache, whether it's in zswap or on disk. With vswap, you have no
> > way to trigger swapin of compressed memory in zswap.
> >
>
> This seems like a missing interface in zswap, rather than something

Yeah, and I don't think implementing "draining" for zswap is terribly hard.

Zswap already has the reverse mapping (from zswap entry ->
virtual/physical swap slot). You can loop through zswap lrus, then for
each zswap entry, basically invoke the first half of
zswap_writeback_entry(), which loads the content into memory (i.e swap
cache).

But you're right - this is something that belongs to the backend
layer, not the virtual layer!

> vswap needs.  But you could just write this as
>
> vswap swapoff {
>   disable new backend writeback (swapcache fault-in only)
>
>   for each backend {
>     backend swapoff
>   }
> }
>
> so rather than vswap.swapoff() you'd actually just want a stop-bit that
> says to disable the swap subsystem writeback behavior to all backends.

Yeah if we can "swapoff"/"drain" each backend then that brings all the
content into memory!

>
> Otherwise the user can just disable each backend individually.
>
> --
> ~Gregory
>
