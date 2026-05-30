Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0B7341AC7
	for <cgroups@vger.kernel.org>; Sat, 30 May 2026 17:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163483; cv=pass; b=CbNvfXP10tESUJ/m4ZT3dPYjZLrqUnhC9F99shEe2FZYemNZvw1N1nvGPoO/LnKpbZMFeA/Gdg3sV/6iKkfCzDtcP/9v95eGt5JHckVD9g//jVCP380kT1TotyGOcwOhzqqcp24BeUgmz8ReP7HDD0uEYuhJyodsrlP/zJ90d6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163483; c=relaxed/simple;
	bh=at4X8aqmXzB80deMHTECXDxTQcPI2DRoi0gnfsDf6Zo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f9G/8RBMjSVaUgDJ23R7eK0lDXmLK5rngtitKhi7fp0jsK8J+XfoMuVcs0Lum4+S/0FZwMvn+AA9SzThHK0jS29K5D4RGuEdXRLAtnnS3JaUT8+wdjEH/OQG+am8BrC+/KZnoRuGoXGl1FGdG4sjxzEYzWEHu44BiiTvvb1QZeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UWKWOGMg; arc=pass smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UWKWOGMg"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45eeba68948so2012505f8f.1
        for <cgroups@vger.kernel.org>; Sat, 30 May 2026 10:51:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780163481; cv=none;
        d=google.com; s=arc-20240605;
        b=IRbgfys4uslagebIaGpF/5rIwQTLLhoXhj0EfHjaBieX1ngIwgsBpu0FaMeW7ph92k
         iLXO+BU8WBxyZY4mP5YgWRbATj+y1zpzIDQxcf/mZwI4GOLhbnhmQvAxZEbfZrQFeppr
         T+EGHo8oC3UHHh07G8ygBFjY5+fE9anQjzHmfzc6Pslyb8PnjwSJtMTka0FMY7AENaPp
         JxSnDzGdHBpdmppw+5WEJwpKoAL4cb5bPQ/ElKtNrpQuXyKnNd3ckVVP2No6KmjekP39
         Wi9A+apOn5ugCUvRKt7x+irvThEd7NCxlH5lDQk4Z2dlfvRfP3qeS+nzw0RJ8bo+mfqq
         9upg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fEiQIzcLvG0Dvxwk1kFzCaCJ5b25r1mlSzZk1lm1fL8=;
        fh=NY/Dk0smod2iS9JBG4mR803ZUL5SKCNg8wxh+eC0wg0=;
        b=cGfVteethSCOYEGP6SEtG+K9Dl4aKmdqfe2rVNpoy0ViAalhRc6l36fGnAJHrLBoeu
         F1dBzHv7HaTXbAUjEVSqyDNgGiwvlkuGywtek+EuKnmUAxNDtJHvUqGVRBlcFEn/XmqS
         F09Mno26qkvIEdWe1CVG1lnEAkCenPwiBiWtj/xQxNr1dCy+uohJEr8pIWn/pCmB4AyO
         ym4kVnI7SrBgWY4zq2OHpl76H55Rq2RCdGmencENCERqOYreHfsSSVJJkqKF5Gz8UfUx
         sd73gwQ9D37BO7Fg6ak9f9Na0AB/ioCYXRuZecaDG66/XsNLogojWmhnT8+JhaJYWetp
         kbkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780163481; x=1780768281; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fEiQIzcLvG0Dvxwk1kFzCaCJ5b25r1mlSzZk1lm1fL8=;
        b=UWKWOGMgErJtee4DlWnwyg/3x4LbeZc69INoVxAzTt9+9huBY2SYDRhAGb+Sczj9lK
         H6jVxAE3yDRan71lPg52Iejsgb1cGV/1mAHmGkmgcYqTyP/G9H3tyybAEcS4cUOvWu43
         FAsBm6seslySlVOS/RmzWQzNQpEuUobORjxGCgxQHqgPVlBDPJ0NYlPY8XbSkruLLSk2
         cepze7yBgwmN2AJm4SbzlvJXi3R3836CEhgx9yIgzbalhKKGWQ3zdPdhba0xIyWAnX7J
         toF6IQT/K2noALMescmHdfKxmx9pQEUyLsOI1+zQur4DlwYUplDCdfTQpLy/dZq5NNzh
         m8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780163481; x=1780768281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fEiQIzcLvG0Dvxwk1kFzCaCJ5b25r1mlSzZk1lm1fL8=;
        b=Rcis2L2U3fHJJRSH2sKrIOeJLnVByabXA2bIU3+p4EJr7v5MTb1FEIcEiCDm4Sf0cB
         W6aboHR9YuoTx2xHAUwensfR2bAJr5ezljkIQPi+n7s+N7RH9WdeG+FD7IKaz4pOvfeL
         bJj5B03cDlA6ZaOpE400nsmEBeRy57KhKH51MoJK8zTi1FtZ2mR7VZtMOtsAnUg/egVP
         kJbUnpvf1p9JsJKrEUKcL8P3MdffN8p1Xfx/6KvshBwYcDAwxWRscpl/7FkmcKPw1XBP
         YiQxb54Xr5UrG6Inrp1k4J4HyFZWQD3iIu8B0mOl9A3+Jv0DTV9Mlp81aMopcHOe8ncN
         ZRcw==
X-Forwarded-Encrypted: i=1; AFNElJ+BQdVx21G3VN58YifxQUakMOSKTuZu9Sb+b81fwTNz1fVSb+BBA1pMAfC+++kUta1WW4/VDNgm@vger.kernel.org
X-Gm-Message-State: AOJu0YyFteMY/tCiZXhAKMupzVt/LYM8gdz+hpXKNNWoo/GhX++kpu3d
	Q+djZYXQ3m4rIRjTu0VyzDvv65QJRfwW6HvvAEK6ualH98hAHb3WtFc9WWym7H+qVqmvs7Pv4gR
	ZoMnrIaJT37J28UHZ3BJFZGkDT6d88NU=
X-Gm-Gg: Acq92OHjMAVn5SXoJTLXXR/javbXjUm1v6BkPO1azWgNyXt0cWoN6JDNhOAYsvKNnTn
	8OXjDI8cNp7Qq8B/VIV0cPliH5UJPHGkH816LfP9Ho+fzrYOXgBlpPtRawV+GR9vvy2uHHpCLCz
	2iWNmeRKo47i2GBXW0XLHBX35pgmmIrYFqlzsp+Li3/+nM+EsSb+ADW34I21Y5+CVXlOay6kZvJ
	brnhbI0DSjf3QtbUgWkBrIJEs+dhTLR22ZYDx2LIZxJ2VB2TPmNhq2RsqTEOYp53Dm8NWLvKqa1
	fKnX2lTHIoB0GN6bv1Jrktph7B9n7rqY0YkshKR/A4TJZFnSVg==
X-Received: by 2002:a05:6000:41f9:b0:43d:d037:d59c with SMTP id
 ffacd0b85a97d-45ef6b21a0emr7571210f8f.16.1780163480771; Sat, 30 May 2026
 10:51:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260527062247.3440692-1-youngjun.park@lge.com> <20260527062247.3440692-5-youngjun.park@lge.com>
In-Reply-To: <20260527062247.3440692-5-youngjun.park@lge.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 30 May 2026 10:51:09 -0700
X-Gm-Features: AVHnY4K_JUreZofOuMIpcH2pYrhoIRKIoA8T3KmoVj7Y7nP_Lo7fr1UunDUAmsg
Message-ID: <CAKEwX=O-_OZ8x0UC96a_k+0eZfAE+mWMWDdn68uy1LHRq=JC0w@mail.gmail.com>
Subject: Re: [PATCH v7 4/4] mm: swap: filter swap allocation by memcg tier mask
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, 
	baver.bae@lge.com, matia.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2026 at 11:23=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> Apply memcg tier effective mask during swap slot allocation to
> enforce per-cgroup swap tier restrictions.
>
> In the fast path, check the percpu cached swap_info's tier_mask
> against the folio's effective mask. If it does not match, fall
> through to the slow path. In the slow path, skip swap devices
> whose tier_mask is not covered by the folio's effective mask.
>
> This works correctly when there is only one non-rotational
> device in the system and no devices share the same priority.
> However, there are known limitations:
>
>  - When non-rotational devices are distributed across multiple
>    tiers, and different memcgs are configured to use those
>    distinct tiers, they may constantly overwrite the shared
>    percpu swap cache. This cache thrashing leads to frequent
>    fast path misses.
>
>  - Combined with the above issue, if same-priority devices exist
>    among them, a percpu cache miss (overwritten by another memcg)
>    forces the allocator to round-robin to the next device
>    prematurely, even if the current cluster is not fully
>    exhausted.

I had very similar issues when I tried hacking vswap on top of swap
table too... It's even worse over there because it's not just
performance - vswap needs special handling in certain cases, and in
some places cannot be used at all (for e.g in zswap writeback). I
ended up having to add separate caching for vswap device:

https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/

How expensive is it to add per-cpu caching for each device :(

Anyway, as a first step, this LGTM. Reviewing from swap's mechanism
perspective, and leaving the cgroup side to memcg folks:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>
