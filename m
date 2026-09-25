Received: from mail-wr2-f27.google.com (mail-wr2-f27.google.com [74.125.225.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F75A46AED1
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 18:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360695; cv=pass; b=Z2h3CF1kX+3gm4a6p/d2zzhLD5fCqavhuF3KGFeYAhPkpVXgiNrKDcgkh9Mm/dONXPuw47qRC0YXdrbMSVOO4sxfVPp7byq48OP8XP1dlUftZDhho/gtCGZ+qdHbyRP4PucfvclmYYOiU9ULvwTr1DQ/OCIw89RtZegkJYsaL5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360695; c=relaxed/simple;
	bh=VuPCu0NVXXA8ZEi+lRFtiBIDXTK3MN9d4YX7eIhKxYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LcQRrSH7gZ9dUkntUta+JNR+Ps1P9iasYeqMJkhiRF6oKqgKrEgOMAgfOxGt/GIr5893qgCruMzRRrAq8DfFJwZ2FZK/+7ct6tFlC9DqYrz+d9vaIVw7lIgLbnOx44AMdBPTj/2q7QMrvzXfez2NhYEeY2+WLOLIhzPKTyeH1IE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BYcfj/x/; arc=pass smtp.client-ip=74.125.225.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BYcfj/x/"
Received: by mail-wr2-f27.google.com with SMTP id ffacd0b85a97d-4843796e373so736772f8f.1
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 11:24:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790360691; cv=none;
        d=google.com; s=arc-20260327;
        b=Qv6vTJzhp0p+dN6zku4VqCgZL/Y9FADVIfAo0UI2CeDEsQX9nPy0UsAh/vIJhqBwdl
         O4T/XH/Ldq8kbG8rNK6Zrgu9k5fcfFARcUNLt/YvyS7ijMLpliF9OzYV59YQ/1OP0uDw
         aMrE8vD7EVxi1fkG811lQYBDY8UCpb7OJvYT66IX8xT2yMvO1nTueU7mfXDOKqXuxSyI
         2Vg5jchPvap6wiwV3awu9ahIVhwda6kwPFs7oEzh4ep6BHGfuE5BfxMTH2eqqzZZA9kp
         vDWLi6GZIJl1rJw+EhZH7+bsbR/QX7k+JRz71We3fye/oeEoO29155UrW/6P5g3R22OB
         YOuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VuPCu0NVXXA8ZEi+lRFtiBIDXTK3MN9d4YX7eIhKxYs=;
        fh=wTept1Qp3T/0n/WCOC9EELWxbTlhfq0tsHaNcOrKBIo=;
        b=BDVeFm3p5Dqmq5bn/XwZ9imvcsVv7Cc8FXu1Zjv1WLm37+JC5C6+YRrTheUA4g943o
         L1MOi/l2vXwqNc/AECXuH0GRBhMZROaGnsDVwAScIjnuXZXi48kHlSgwV60AzpM34Oog
         O91+ThmA1NdAgdqhHf8P+4qIi78Dmj4Q3/EMCuszGTD7kB+mSefr79PFAqBN7yYsP6/B
         w7mJ1xdmESpEqR3aDxbRjF2RguK2SoCscgKIN4xvWeK0Lny6+SytuBgPItgwmRmILYRp
         MGxe3IkMQczoLIBeWw6RXTsqUqsuoKfT8lIJCiJLx6LgQfF6u7OXi3gvcgT1K/77hGNo
         svSQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790360691; x=1790965491; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VuPCu0NVXXA8ZEi+lRFtiBIDXTK3MN9d4YX7eIhKxYs=;
        b=BYcfj/x/NapnAY/+LR28yha0Sf87wS3pFS9r13vmJvPjlUkjkXyzUnpTMT36w9tN2M
         Rmb9aW59fXrBMdce3MClCt6GQMAzGmWz4HiVAqL6gv+aEXEpys3NYQkPLAS27lzg7Ung
         ecqv2pCQMV+vosgKuiZexW6w9fbjKJAU7f2Zfx30/OOnxdxywddrzyQiZv/3cb2pN7Qy
         vED0PbDLmsInI0rSNIBVQQiUkxWJl+w+vqOn12zxNRuw2dZB9i5nYynbLJ+/IdQlqfjo
         17zL6wvPCyXpcW+8DJDkSnBdT9wWtMVW/2c183YKDv4DdNRbpw0tx/UKLqJwmx1l0nx3
         7+Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790360691; x=1790965491;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VuPCu0NVXXA8ZEi+lRFtiBIDXTK3MN9d4YX7eIhKxYs=;
        b=2TnkVmfhKjqFSGqZOn8ae7Z95V0vtyyh4GPi8tWu7u0W5rrYzCOW0KURTrDPtn+Zqz
         2He7+2O/fBO7YqtEjOPz7GGtJ0iLJYB6sKramUrEPvqaaoC7bw3Yr1RcNeyVsnZEZO0p
         T6/gNcqUsiTR1ib2Zizs2YsyAAQMgSoj/Kb329ul87C3oBEP6Xy3PzZV5l8uKYyQDBwp
         DgwDcdNCZ6t56pQ5A6Q9zx9njaeo9MAnMSyzyu9qGdqstnxbkWLhY0cB59M/GKVupKXU
         HRuOWm2xcB9DSqx+O4w4VUCLfM0xVPMZTQHM7VeLjqgRVhBO+bUpM9Fsx8hXhneISOky
         ZiAg==
X-Forwarded-Encrypted: i=1; AKwUvBzQFSNauC60pSxYKTJFxoe973gaTpB4xYFUkVv2LDY5Uxu40bzQH3P0En4GntJb9KT3G1a9UgKO@vger.kernel.org
X-Gm-Message-State: AFuF++kLIE4eXCs60NoadLvF4qvWKclOkHsKYGwQ99ClPt9QzO1+olCj
	OzQlZOXHNNDvR4tYhewCyc4Z7kk9VylOfVQ/bNsaUv5BxY9kdtOTYdMtsmSxSJOeTqp5pPVwH8u
	PyTb9agICnYLJ+iqarXMlqmdOW0EeaQk=
X-Gm-Gg: AYBFou04bPqfTC/fjkVvWA98nOM9IxX/6Z5QIgwyZFoRJ6Grip91YyvNsMF8yrEVohF
	dPxIB6XES3yuBhXLnOPN9nJWa/P2zN1vu6l0wFAgVH2ioBTjdgur+/eJns/fZObKh6pJjVxc36U
	Gr6XZyUfor5P0PKG8jEfkeDsJNF1+A87UaO9P65GIpr9Iavs2t6KG7O2qmn8RMr2imBKmxvx3y+
	RY5QojSp50sxB3t6Uj0FA7od7XY/aH1K0ZxrHuC5GXf+hsyaE0+g+2pdYy3R955PJP6+5nJqe8j
	Jb/BM/AUGHZ1Ms6fxXAwlvuG+kk6S9nRbntaN4OcR82CUajxN1K9H3tbNbsC+0ywa7ecmLUZn/A
	CIJagW9zjtBU=
X-Received: by 2002:a05:6000:40da:b0:486:f907:ebec with SMTP id
 ffacd0b85a97d-488716f419cmr13910053f8f.31.1790360691287; Fri, 25 Sep 2026
 11:24:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <7571f005bca65aa4ad5e7ec89e62801ad058b689.camel@surriel.com> <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
In-Reply-To: <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 25 Sep 2026 11:24:39 -0700
X-Gm-Features: AclHuK-nk61jbPKSQK9eOD-whCQNgC46gTK8mZrS59_h9wP0CK07WrJWS_RDZQc
Message-ID: <CAKEwX=NbD12FfApEb9g+3Gt_-Rmof0tovYZsxPPyk5TCbFq=Lw@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, akpm@linux-foundation.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 6:17=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Thu, Sep 24, 2026 at 8:13=E2=80=AFAM Rik van Riel <riel@surriel.com> w=
rote:
>
> Yes, but it will pay the price for going through the unnecessary
> redirection layer always. It incurs performance and meta data
> overhead. That was one of my previous objections to the earlier vswap
> version. Sorry I enjoy micro optimization too much, that is both my
> strength and weakness.
>
> >
> > When everything in vswap, we don't need to test for it.
> >
> I've been there and done that, the result was pretty bad in those
> earlier series.
>
> > Handling the details of what's behind the vswap would
> > be handled one layer down.
> >
> > Chris, do you think that would be cleaner?
>
> If it can wrap below the swap_ops, it is just priviate inernal dedail
> of implementing its own indirections. That would be much cleaner. That
> is what I am trying to pitch to Nhat in prevoius email but does not
> have following actions.

Registering vswap's operation as into swap_ops isn't too hard. I
frankly don't see much wins to it for vswap itself, but it's not hard
to do if you like it.

What I'm disagreeing is treating it as "just another swap device". The
implementation shares a lot of swap device's machinery, so I have
don't mind adopting it, but you can't treat it like a normal swap
device, and expose it to userspace like one. You get issues with
allocations internally, and externally you give userspace a vector to
misconfigure with device priority.

That's why I've been insisting on what's the use case that motivates
these aspects of the interface that you're interested in. A pretty
design is not a real usecase, especially one that creates problems
with userspace misconfigurations.
