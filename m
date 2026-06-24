Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E368E3B3BF1
	for <cgroups@vger.kernel.org>; Wed, 24 Jun 2026 22:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782340912; cv=pass; b=atVNFf8uUisG8GJuV16GRbcSNTGgu385+/4KSOsL8teeJiD3e0ufjP8QSnsJ7Sm286JtGlLMzH5zJ15JGiMxqEj+HMd68Z+pS/Q/K4Cgcgv3jfe57rbyI7TB8Z/fnNBVaaRhC1cGJ5rl5NWa2LwCp4ZiaovrF63K4kAT2rEqCMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782340912; c=relaxed/simple;
	bh=44vcFT2zS81zuO/QITHQpzEjB4PfuTchVm77v5ONeL0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pEAC6Aq+3N+lzeE+fVA9iMleuwb1xxPV0hGFvx0uQ4GHX8qjyayGbioIO72GOgmB/hAqQmL8WNSvI7tcMw2qN4XXCXuw4QezvQ8oMSPoIHkv3opI86zT3l/QHdR0G2XqNnWbNZWBTnaR0czgUYpb079saSFL3mH6TGtcfU6IzRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DEwKlsvC; arc=pass smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DEwKlsvC"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-46cf972f281so405535f8f.2
        for <cgroups@vger.kernel.org>; Wed, 24 Jun 2026 15:41:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782340909; cv=none;
        d=google.com; s=arc-20240605;
        b=JKIKdi/jk/KYVIHNDNYmP9Rg3CkRR41KMwB3mScoe5e8a5rShAhP1TNX4YSqotT5Ld
         esnzMqLBsUlP/5VV0XasJJtB0NMiyMVJOzxqYPpjaip4YaLBmREG1aIW7OcPfzIm0+EQ
         5B7qiyhAAwg0BooK83szHMDMUumd9RMWi6MT1UTTKPDIOgRgZlnJ/oZuNpHW5NbNfWhL
         MnHo2u2poidgqydyUhOjbrCSD3u3PshUi03DPu5rg3eYqgatq7D6BBhDLUGd7VBDC+Gm
         4rapZAQEAF/HoOOKhhlSON+NKHhPaNWL2AauyAnlW/qy61dK4IpG9RbY5oyMtFgCU+yt
         iEkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WJs/bqJV28nRmEFkkVv0HdnYQ72Ru/Q9zWNCjXeVDns=;
        fh=Oby7TF3r+2dFoCqG8xxzDTgxiUZHdaB0CgLVwZ1PozU=;
        b=EbUwVncPx5AH6mX+gPV62ReTo5c7Es4rc4q8EJpsqNxyUu5lg9jMcuPbyOwWU7hiUS
         S5uRjr7cThKxParc1CBEtqg9jEAEtHhD5LvAdGpJ2PyOIuJxYkX0QMGBpG3Xsh44Gi0A
         mLehhe/gymLbfVPn8KQUJ5+vD527xc+o44G65BkR8riP6fzhWz3iQu9K++7sMqwka5KK
         kgJZfxFEHfDgBCO9SRv6dTX2DTlhgl6fYyyzbgMgQEhMN3FQNzYKTwrF1JJ2dB3GS8GZ
         GMZpRwaK+RBK6KNpe6xuc62MHhfd9ktUTg0KTJAnthWAhmKOKUwIRd7/uLRpLs9JsQEF
         2j4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782340909; x=1782945709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJs/bqJV28nRmEFkkVv0HdnYQ72Ru/Q9zWNCjXeVDns=;
        b=DEwKlsvCinJuFjIjF+71iBf4LBKFUneOinYk6iPGZZ+3qekkSh6J2bvkc9cqLps/pc
         84X0iJMKaRZYngnf7I2ApWUMQknHbuRWTFIJPBqUAXuubcHvniQwuy9IIR8Y3pafDwlN
         eSZcj7OzuxmLIrgQDNhuvWT2RCDQQFdIb7CY7gpnV/7HfFIkX06vrXWqjGBCky6HLMz5
         UndAahnDoUXQKesah6Q/jUqOg0DbnG971Iqyei53DMvmR5jrYLBbKv75BjTDWZZcNw3G
         GJUo1q2lyfwY8k/dndqdi2spHPY9n0HL6jXGclKdAXG90e5CFuJcDkuiNGvaobVCchIu
         CKpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782340909; x=1782945709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJs/bqJV28nRmEFkkVv0HdnYQ72Ru/Q9zWNCjXeVDns=;
        b=Ws7fXIYpbQmeQ/wTnZ6RE5MoabUUMM0sJv7G95PswRrKzGxMS5+tLBQnmu+y7YclNY
         4xx/rbF0w1gGzwnUtyCfketCRlKpijWRp01hyXSsYdSHJWsUQz6MflUBVUlIgHtmmIHd
         AwNLn1WCuKDYDXFwFZiPU4qF0n1CC7TZNlxalRHG5cqsckKIpFpBOs0x7LLTyslOOl9n
         IZ2tfA8bPIEExzty5yIxm+LlcujO0x4GFSN/Uh/uczPPDS+qcTR3UteKZjR2jl60xxcc
         Lp6ZULryI8zVDbD5PbSQVE1r8zo3iPyD339FeLyQDXPIdjfl4sJyN7UuI2InhOU6bAqq
         U4lA==
X-Forwarded-Encrypted: i=1; AFNElJ+eLV11B1CaMlCg9fgO+jw/wOVldxZTbUwPlLKpIZLERboqu+RnSV2O4gx4hrdp8YCCUQEwu0uD@vger.kernel.org
X-Gm-Message-State: AOJu0YyMqORuxCcNU8MIeLaaNlSHP9D0+HisPVfowd9ghnpz6NkOlUN1
	orLGoUDTbQPDjVgpTj8e24a+DIWW9dHeG15xXh+vgix/kKeB4a08/TbTB2AAt00L481JSmR1NMp
	FhnFtVVIIxhCnxHsqtWSK3J5YXbJiuz8=
X-Gm-Gg: AfdE7clgM9AfnwQ7RnwTywwmQmh3+0Uhf0ITXJEmWge4pXweFhFm2fz/NZ3X4KfB6tD
	OeQzRWlO294U5dH/dVWthhGiQnERKw6NrHQ7t5kNxK5Ntw8jVak+CL2tnEM7TndpBXkTXL7tKc7
	4etCc4684i07LyMrR38IpGGaGqtTGBXf9jE3LCOyAD+WNQERDH4JksUmcOrtoD5t9usFvzbNvpM
	Mv3A6RZYlmu/jIM3MEsuNsfL6mPu7GiXh9ZYv68pU18WXE4nY66mdoVQLIyrS4Q2pg83Y8I6i0T
	1NjVo5d3LY/u0GF2HlrhaxB5YVeKzU/EViC8lGeT9N/qMSDpGv5uzVY=
X-Received: by 2002:a05:600c:2256:b0:492:5cb2:aa54 with SMTP id
 5b1f17b1804b1-4926087ba9fmr54723185e9.34.1782340909046; Wed, 24 Jun 2026
 15:41:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612193738.2183968-1-nphamcs@gmail.com> <20260612193738.2183968-3-nphamcs@gmail.com>
 <ajnQxMY0W3VGyAUE@google.com>
In-Reply-To: <ajnQxMY0W3VGyAUE@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 24 Jun 2026 15:41:36 -0700
X-Gm-Features: AVVi8CcLr7H4jR5RtejdKP7Hpj9u7s-tS31S_dqbqyaFggMebkaysX3HiNPrzN4
Message-ID: <CAKEwX=PwOV1Oh8B=QyrfGXSR-Xu2wUBTE-VOQhXv9-YEhYGZEw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/7] mm, swap: support zswap and zeroswap as vswap backends
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2026 at 5:18=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> [..]
> > @@ -1623,16 +1642,14 @@ int zswap_load(struct folio *folio)
> >       if (entry->objcg)
> >               count_objcg_events(entry->objcg, ZSWPIN, 1);
> >
> > -     /*
> > -      * We are reading into the swapcache, invalidate zswap entry.
> > -      * The swapcache is the authoritative owner of the page and
> > -      * its mappings, and the pressure that results from having two
> > -      * in-memory copies outweighs any benefits of caching the
> > -      * compression work.
> > -      */
>
> Forgot to ask, is dropping this comment intentional?

Ooops. Lemme restore it.

>
> >       folio_mark_dirty(folio);
> > -     xa_erase(tree, offset);
> > -     zswap_entry_free(entry);
> > +
> > +     if (swap_is_vswap(si)) {
> > +             folio_release_vswap_backing(folio);
> > +     } else {
> > +             xa_erase(swap_zswap_tree(swp), swp_offset(swp));
> > +             zswap_entry_free(entry);
> > +     }
> >
> >       folio_unlock(folio);
> >       return 0;
> > --
> > 2.53.0-Meta
> >
