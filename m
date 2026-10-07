Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C214921B4
	for <cgroups@vger.kernel.org>; Wed,  7 Oct 2026 16:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791391673; cv=pass; b=MKqSw0gT210DhcNLn+IEhC+Iu+vN95Pat05smNMMMlq1zLCNkV6PKHuyUI1vVmmyqWpOI56IPoikIqzpeV0kwSv40cGxN6Pm6+u9hWXxb1eEhxpC4xjJpC/34dZwTEPbZq9R/h4DHnhZ1sqDwArb5vXjnIHbupmK9R9J8pDj3m4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791391673; c=relaxed/simple;
	bh=mUg8bGzuDc1hntbJS6/jkPP2umt4kBrIq8LnvLb+dZA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GC79Hda2f9SWHkzpjtIbBmruf3ukriStUnYMYP7JX4RSsNdDBLksZc2X/XTP+o9zwCR/Lz2Minlpdg5yUtgR+Cf5pRbdSX9VZ9GjdaDk7Et/h1/DJ6BM0fs9rNZGxD89yKOgvAnIWeuw6R5SEd+e9xLDtADsu1s6hC8xVRX8usk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CYE0ZNhR; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CYE0ZNhR"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48b0d19cf7eso1506087f8f.1
        for <cgroups@vger.kernel.org>; Wed, 07 Oct 2026 09:47:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791391668; cv=none;
        d=google.com; s=arc-20260327;
        b=sK+vgE/T9WYWrpXq4N9YurLkiWGJUTU97mEG9dE8DfaF2DtOmfnnkYP6JGvSKuQNOi
         gNolkr83gwitavEnGQ282P1C2VwmRoeAWOZon/+pYpE1VuW2AT2N1S9uevq3LaMhVhE5
         CdDO1Ha81d/NtPXA8zOb6D2qOPfu4rUUSoWDkLjsSiaJKNfaBwjUe89A/9YQMHsk821A
         onO06kD/NAB8auLivlRTmnTK+95Qjig3KHCtWntTIQD1YvquIgxkXkjpqc47EEOBe3QN
         NwYYzkAQUpGX2JFhv/05ZLu/tTqRgFpL5e6Mwkce1DTc2IdXxcyhJAsEQbT7euupMsC4
         q1/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mUg8bGzuDc1hntbJS6/jkPP2umt4kBrIq8LnvLb+dZA=;
        fh=dN/bUOuf1VjWAVDFaYgAIt7Fvg8jW5UNYMImoxzpOm8=;
        b=QttHD/DHZ2uBFCWaehGX8BQ+hpK278DA6bvR+wW4VngNZTlGfcfUMDeyeFUp6U87pl
         9NMf0wYzl7P8bcf0NbvWdEb6FmyyqxkB3KIKN/ICecOAc82tWKQPmOZItWth1SLDL0GA
         cHP82pyXbPq2mPd9EG60qXByciVmlBkZYeLz2KrX5m8BZizalsYa2A+yGWDkXcY/36Nf
         LcVDWZnwg8R9/UQbJKHzPUJ4uxsZTVJG42K598zQizQAMU/v4gvu6HHgyCNr9p1MKz51
         0AxLshpjsd8ZcWMPg/wjk53vo5FDdr5uw+80QYFoRmwX48JEU8XwjwwkmSIswg3jp36u
         Z1FQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791391668; x=1791996468; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mUg8bGzuDc1hntbJS6/jkPP2umt4kBrIq8LnvLb+dZA=;
        b=CYE0ZNhRW7efU8KTspmjqXfyMHO4ZYVWRTFgwe7fP+knJzS7VUE2CH1STR36Eny10m
         RFiUt0tFf3UIrJ4nKHc4trvWnPwCYxnep2REErqho/RImTVdXsCgSjMFWI4Caz5Gecga
         QvWjQ/QSAeaxJrRiVNvpHuXlZYxH0VFjCQK1gV8u3+ALDz7E0ITRPhhx0huF5fi/0vSY
         2RKlARcRv6d8+0/F176Hmxyv5jTIZCTNCn3AoR3A/rWhaWEMPNMsgfuMyarfUK0KeFaI
         TkUV4o91p7LAaG1PN/pk1NA29u1HSq88X1T4R7Ufn7hWBo2WyC9dWFVLAjtW/l8UYuWU
         ojkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791391668; x=1791996468;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mUg8bGzuDc1hntbJS6/jkPP2umt4kBrIq8LnvLb+dZA=;
        b=RNwbo0GT15+ToPBG75eMoNNEDb3BuwCdmrvWMFO6fzWQmOb2cg8cqGnVAXfrwoXlwT
         cgwSe4FGBjgec8J5O0C05gjaILcvyPbzpMx1SR3DMDlMk/9J4XViRNwr03nsVB9+GIlW
         NY+d8pATCIMrnd7DW8DYpSljkeBOfwB+RFwtCZ6SmsF958eFTS3vDf9Hjt1NDcSYJrWB
         XNjYACUOtse5uwfLYzA4MRm7V/Y8UUxrSQU3O87TR5JsY4pjLkjWu69saIOaMZgF0LoY
         7IK3XhmeWvWtFCbk7ehk0tKkAMrO/DE/dN097Fpir6OLZE5cvhi4BVp9UUcuAn/VfTcb
         6Geg==
X-Forwarded-Encrypted: i=1; AKwUvBz+f5zpobxpZ7TI8xZy/p5Q4xDHJQzD8JXI5Q1JXwHtHCbPoVMK1qslvOC24VWCqFeVggHn63yn@vger.kernel.org
X-Gm-Message-State: AFq9FYJ3zIfvlTLmDSdN4Uyl+IWl7UJj1wAQ4pjG7O4imPO/cNa3oWqW
	X82SCo4WIDOkfglQu4/bMb+vm49DuU3bxDC6NyNWl0y1tcUELPei2Qn3ROs8egD/QFjNGIFmE/T
	ujGqzrzg/0GRJUmGSGBkMyY9vhLZKxlc=
X-Gm-Gg: AYBFou1cujyB0fxsgVm69BudYesgF+M/iYxqSsFIw5Xv6MiDQQ0UHNQdqFd6WC4GitC
	2Xu7sW2Vw5FVSM7ES/peqdXWNDz5ZwtWMVrIM2+OzKNrzwDKgaJRF8dxrBS02q19XyiXLqGOQOd
	R1F4nAQatBaFl864k8lOMnp4cod18QmYLgoRKhDYwasf37FbIFK1VbhH/1qp5cm/zVpchVOBrV7
	JjnCYVRPM5ShCWYQqXwGdxOHJmWasrBjOD11j00iU8MjZXHopZDI3H6lAIbisrTfrhOsPAdjXAl
	CpALmNVMEU6AnFtpQq4UTB5eQOZxKfYWaPgrJaSpsRFzHoAAcjN2hTJD2ituHe2ZDgdG35aSyAY
	uueFa78ClbioA
X-Received: by 2002:adf:f088:0:b0:488:5468:c23a with SMTP id
 ffacd0b85a97d-48c7277b307mr5249685f8f.17.1791391667725; Wed, 07 Oct 2026
 09:47:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com> <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
In-Reply-To: <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 7 Oct 2026 18:47:34 +0200
X-Gm-Features: AclHuK-gd21Gfnuh5UQqK7_tIu770TUyW0AwEOlzN_uNtFL1qi4hjnyF8DTH4ZQ
Message-ID: <CAKEwX=N28g4T8mqniB-e+e57ie9D3Koaeq-EmV-TEk-u41FBPA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <ryncsn@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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

On Mon, Oct 5, 2026 at 2:19=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 9/22/26 15:38, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> >>
> >> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org> =
wrote:
> >>> No that time slot is too late for Asia developers. I don't think we
> >>> should use that time slot for swap alignment.
> >>>
> >>> We should find a time slot more friendly to Asia.
> >>
> >> Any time slot would have that kind of problem. We're spread out across
> >> the globe.
> >>
> >> Let's just use a standardized time slot we have for MM alignment sessi=
ons.
> >
> > There are more swap maintainers in Asia than in the US + Europe, at
> > least based on the maintainer file. Please be more inclusive. If the
> > alignment is done without key stakeholders, it miss the point.
> >
> > Sigh, we can't even align on a time slot.
> >
> > In that case, let's keep discussing on the mailing list. At least it
> > is accessible to every one.
>
> Looking at the mailing list, that approach doesn't seem to work.
>
> Finding a time slot that makes US, Europe and Asia happy is ... tricky.
>
> 1 AM is certainly unpleasant.
>
> US vs. Asia is also tricky, but doable.
>
> China 8AM vs. US West Coast 5PM?
>
> China 9AM vs. US West Coast 6PM?
>
> (Europe is 2AM vs. 3AM, who besides me from Europe would join?)

Thanks for suggesting the time slots, and for offering to stay up for it :)

Either one is good for me. But there are folks in east coast who might
wanna join (Johannes).

Johannes, do you have a preference? How about the first one?

And would next week work for everyone? Say on Wednesday?
