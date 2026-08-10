Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330AA3B27CF
	for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 22:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786400882; cv=pass; b=GRqYjogdpdEz26McUDgDKwTK2MOM/B3+7qQoPfsQ67LtS3lW1qbMsC+vKUaminrK1ipxb6+fy8prXcTUcqs99UtvmXT7WR+et5/YcjaxoHbGO6/zp9P5Cql3ZLrMmQ7U3TWedXsiT97Hob7I4kVdOVxqx5R9FhmdMttSKeCD0xw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786400882; c=relaxed/simple;
	bh=tG00cln/EZfmDZKyIkZr1KbYylCCT00dXhW/ufTCbgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ehr1taXp6VRwMk3gvIC/T6CLxGzS2y/cffAzjbD8ExWk2GJjNuePPOsNK9LuN68fel6NvL3z3KCVFIO+/qFTa4W+aRDVyqjfT0JigfYFPHedztQGrMe51RY3LfRJN8+h6DthjXnEsvoMOCwk2EOg52mv+GMJ1PrlZtH4ziSjcLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1R4LTDM; arc=pass smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1R4LTDM"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so16527915e9.1
        for <cgroups@vger.kernel.org>; Mon, 10 Aug 2026 15:28:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786400879; cv=none;
        d=google.com; s=arc-20260327;
        b=KBlr1LYtT6YTvpS/1+JwX5lsHfygzSWL6uw56TWJnaMwS5KTSJpbaaFTvinE2nADxS
         0zG1LEm0c2PeCgFdvFa8sXDRov9j1peePj+hKgDNOxGAfbDmbQLEzYIgVC/0eRdMdiE9
         LCzjYc7V4LDbWNt2iUKeuaDMAYeonWQ0hdfLvX943iHFKuziXW7nUZ3I/WVreC9yLmqi
         6Tizz+n0K3PnRjISDRsFBVSgdGVN4d/IrxIG71IAjnC0iyhJXFUNjx2oFG8w/Od+jg04
         MpsTW5/bOif0wiLnnluXQgEqyM7EPXXNU9834wab82/cZWSdKwYhy352GFBbzTJN5zQr
         kviA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tG00cln/EZfmDZKyIkZr1KbYylCCT00dXhW/ufTCbgc=;
        fh=1rX8UaebcWDtsdb4lgpGxucQuc1ZE+IHX7b3wT4/OQ4=;
        b=CFgXq6orgUnfto8HICFI+9/Kkjsuh4hKM56MnAYCLgl5c666UAgK8/mnGUHbnVKcGB
         9sapiZSftEIocVXqg4Q4NE0XaTweU7fwiVK+uzeZP/mdnJMkYM32Eg0n7RZEMJXQMhS+
         ZEZjec1A66b4qzi0b7+DKH6kmpBr2hrLLyhw4NBdxdAxXlR+D4Io20t5f4546+Tp42Pr
         xwyEYHkY1tzDKBUIneCVK73+r4+PkWwUItN/b25X+e9dkDQgiNgJz5XT4tphHtx5V8ve
         sDF4Pf/SLQPNjjMYLtJRgpJMSqw5PFI9UoqUwYgRUhVw/8bvtb3fLAnnOEeCSTd8mo/X
         bu/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786400879; x=1787005679; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tG00cln/EZfmDZKyIkZr1KbYylCCT00dXhW/ufTCbgc=;
        b=V1R4LTDM2MRY6S+1o8cNQLHcERSXU8wtoei3zeKyEE4doN5Pw1jlG/EEeDy3MRc/vG
         A7F1kquZ2y1eNGZK9yLkqqjaLebiPDmK3KC6Slmu2C30lUDHJehP6k2qAFqXeQZ0UAm+
         Bju4wR6uPxtKw5gvPEZedzNFHaei1w3zT5/bQzJWqbSpX4RpqJUHgna8S0m88Mz4lUAq
         NuNiu3i96Emu0uoM6LFN4rMo9AANddFUH85jGoppZK+iuxCBAUTuLO7+26NB0/PMd2xu
         8KQYthLkWLYrK+uaedFpE4QmEMUOj3q0Ie4IQPB44NdWizdIt0Bl231fzeArmffRp+RC
         3eAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786400879; x=1787005679;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tG00cln/EZfmDZKyIkZr1KbYylCCT00dXhW/ufTCbgc=;
        b=TSYB7b1Eeh9+YFeDKyGZEpCijqJfO7gU6Meag0yocdZ7VoN2hTDLe7fJTA82yrjvFw
         iVbyugV9tN0nM9Qq/VOmAE/axo0pKdEhQVYcHTM1qZ0CS5Uav0aXkKYfNslHBMLacROW
         UDBApKVzhahjh2FuxR0yVANcuWguwVX9nY5K5643RIY75KUcDQOmPNWJ16wgeXNMhaG8
         Mbtcn2DqlL9QyaYVZpcuDZ0PewfGdKxR/LgAzcGthrebjgS+4I+FklNSNUacbrxQoZoE
         Na+28hMPYPzLGHFykVfTTsk8eZR7qaPkzWzJ3OoEPMZeoCtB4iYwFK3u9qoACD4uqUWP
         4UkQ==
X-Forwarded-Encrypted: i=1; AHgh+RpWSGlw9IOcxZFswb2tMTmsOZ+GAKtkr75H2EtVL3jX2l5nLa3VaivFwkU6DPHVPwFYSXNNcVuk@vger.kernel.org
X-Gm-Message-State: AOJu0YzhSoJTtb0eKqGuGIBS5C59pV0UxRbbRPqwSN9nGvNNv81FMxga
	88Npla6Vj8LFpjfmQMNlHB3UxsAuV+p5JozS/VKF5ZUyJwEYpze53pC+JPUQtuY56uLfo36UsqW
	twnpXLXNQFns3ueoWQwJ5Zi9VBzj8Nhk=
X-Gm-Gg: AR+sD11a6NkXbdVfU0EqnDw8quD8dM2LwgvvbsM5XoBg3KidW1oBBKSt2QfrmQSLt8T
	Tstob67v3ElGauHRhvvBnA7a3ZXKXkGW+3WVUGYRqhXI4geIB2OeQui3AJMVs1J25XXJYenWvz/
	iYNle3emZU9XCuSQjGNo00WCrku9G+kLQOPaKb8g2YnxX0ahfSRy2Zm7YBhV7YSu4uYX3Lxcbch
	mCdyziLK1QPKE19Ll14zbMx3TVrxdesyE7QjhK4FMIdPeG8zBRrSxGZMWcqVXWNvFM3laCHusAo
	UFh7yORaUbzIhlykmnyi1LD7tWNo+bWYt3ifUIuwJvxGivi8hjkOG/pS26K5b55CukCxuXaAAPs
	Bvtrcte5TtF4C
X-Received: by 2002:a05:600c:4fc3:b0:499:4892:d022 with SMTP id
 5b1f17b1804b1-4996194cf28mr264737515e9.8.1786400879152; Mon, 10 Aug 2026
 15:27:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <20260806184254.3790858-9-nphamcs@gmail.com>
 <anYIboHEUZb4fhHv@cmpxchg.org>
In-Reply-To: <anYIboHEUZb4fhHv@cmpxchg.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 10 Aug 2026 15:27:46 -0700
X-Gm-Features: AUfX_mw7dY0-F9-Ej-FIs5p3N5Vk4fr4DFsdoOHN23XY9uPiTQmxJlkSPfIPaBs
Message-ID: <CAKEwX=Pcr7a1Pfu2U=JQ3fw7k_u9LbCkNZgDh6ySH=JMN3HXOA@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] mm, swap: only charge physical swap entries
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 7, 2026 at 9:31=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
>
> On Thu, Aug 06, 2026 at 11:42:51AM -0700, Nhat Pham wrote:
> > Charge memcg->swap when a vswap entry acquires physical backing rather
> > than when it is allocated, so memory.swap.current tracks on-disk swap
> > usage. Zswap-backed and zero-filled pages occupy no swap space but were
> > charged as though they did.
> >
> > memory.swap.current therefore no longer counts them, and a cgroup whose
> > pages all land in zswap can now reclaim anon memory with memory.swap.ma=
x
> > set to 0.
> >
> > Direct-mapped physical swap charging is unchanged.
> >
> > Signed-off-by: Nhat Pham <nphamcs@gmail.com>
>
> To head off any uncertainty about this: this is exactly what needs to
> happen in terms of cgroup semantics.
>
> memory.swap.* are about physical swap space. They track, control, and
> enforce fairness for a finite resource that is separate from memory.
>
> When a user switches on vswsap and a bunch of empty pages are stored
> inside the zeromap without consuming swapfile space, these counters
> must be 0.
>
> When a user switches on vswap to use zswap without a backing file,
> these counters must be 0.
>
> When a user switches on vswap to use zswap with writeback, only the
> pages that get written to the swapfile must be tracked and controlled
> by these counters.

I agree, and yeah I should have been clearer about the reasoning in
this patch commit message itself. I made the argument in a response to
Kairui's inquiry in the past, but forgot to include it here. My
apologies - will expand on this in the next version.

It really does not make sense to make zswap and phys swap competes for
the same limit, when they don't compete for a tangible resource (zswap
consumes memory, where as phys swap consumes storage space).

>
> A few inline comments on the implementation:

Acked. I'm trying to implement this. Will report back if something
doesn't work, but otherwise it will be in the next version.
