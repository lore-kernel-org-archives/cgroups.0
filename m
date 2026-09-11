Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60A53F105B
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 19:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789153454; cv=pass; b=GaE358BZhgO8G+aBFLMXUb3WDuT4fqhrt6+xyoSs/qS3znKuvKQq9CSkNuNQWVfyOj4VxJYaCtXHmPysTD+nHMkIKPOGMvpQM49I5KPVLi7r2ds2FDEqLDCXi+3dcr1xhtxjQQrYDpi3qh8v+ryx5Oyb5z/pVzGdKYONCYsLBxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789153454; c=relaxed/simple;
	bh=trX+U7XJlu2wfrqosEL7RKHWRz95q3a0XycwYv9NMmY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JS88uUy29vKTG+7k02tzzIWFJv7fefoLKDfErTFl75DGlOqUze8SVMWDthxNNNnMryZWBZTg4t7QpPqpjOc+UUAe1EDdsSDkBwIrLWwURiff2BAZDZ/6CiaSe9vwdUBEnYWU8dzRDyiUgaMBbC1tqk4WEAoFKAjz6D0AJOTJDdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=guED+60N; arc=pass smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="guED+60N"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49b0eab380eso6998975e9.0
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 12:04:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789153451; cv=none;
        d=google.com; s=arc-20260327;
        b=KvBn3CmEGCNzkAvfdxszxmcE/9zVdokFpwsqPI9Y9kgMSAoDS39k4gdR0GezjWrvl4
         IXwm0E3ddy7KFJUxQ5/REogGjKslPkVGB24Rwi5Otj2uV4rj4EJccCRwuoNr7fTOeCsq
         /aq5VGxvCviFr+KvQFNdcP8xAkZ/AqVQymJABewteQysAjwdeo/wEi/L8PF03jKVXETB
         s/7wxE5zGsbXzyi0mbZfT8m8SM0YpvN/Hvnm6TmVi6iqR4mGslyXm3d4ZlXs2pFkw436
         kRpLvPnfd/p4JI7GnURh0hQNLGZmWh14z9Pcw+bQJG+b9TYDEUfCnb44cIK69Edtl0De
         +hUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=trX+U7XJlu2wfrqosEL7RKHWRz95q3a0XycwYv9NMmY=;
        fh=Dy9CepJgvHUuSnIZLwV/FMmvZAHSd6cZ2rqzAR9aZ6M=;
        b=hEmcbiYdM6r/Krlyo9IFBfHdUQYD84Q5J7x7yaHLEDokClX8FcAGmwzyw7o4vMbB5D
         edhkXV2xOJsEsuq9/uVlteJgv0rjrJ4ampdoa8svWDw+dM+liBUbejfY4FRHqhZf8FNA
         8g2MbFMXh7TTZj6Hya8zNUtDfCW2BX24I38ctTESavt8Ea2RHao2tLTusMNC54kjC5Du
         pZIRfPPgHyXcoeu3UztMwDX4X3mVijvbk5vH+zzzqaGzCM4HGwuRkcvtV65wZGXiqQk4
         KoTaoWwqVCn7Hp5n1aFA50YGHreWZWVVVCwFRKAsx1tolCFYLGIldzzoHoHXxv3vsW9M
         s6VA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789153451; x=1789758251; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=trX+U7XJlu2wfrqosEL7RKHWRz95q3a0XycwYv9NMmY=;
        b=guED+60N9+7cL2o6r9EPpthdfQPVqZkG1OXjvqUx2o2JRExpILfXtPPkI/X8ey4as6
         dKsiFfySJHOKnLnBILgFwNydmhCWDXyOoqF92TR0943aJzhX0BIkV6Yecc+VoSPME0J2
         ipvhtsAsUsEjH4XSJ06th4871uh4PJ2ht+2CYBWpWd+6NUjcB+3Ph2d4uQRU5pD7+R+g
         /RDfqZbDUhbcOrEUYXpI6beBmfU7zRCiMrcQZtfPT6XYMOkpmhezMwMxDv6AngTeOWA6
         ISYzeB6suuXFsCZ228rNDj3xuNjmc43QN22rdKP6O+QLyIqm2ghaQ7Ze4A35ELA0XFcM
         Fltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789153451; x=1789758251;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=trX+U7XJlu2wfrqosEL7RKHWRz95q3a0XycwYv9NMmY=;
        b=lRX/6pMKLFvwrdDzpPud1azj7bCspMn3Ix9pKgTZic8Hon57E1b+CG9JJ5Jl77qE81
         HbMLT4/rhMgbWiltjD+ko0vjQT50fzrc78VUJnxsoKsx0RcQCBWwlh6/LBzIo7ZR2sXs
         jU4s+uofRi/DpgA5sMVGjUPdcnA6xMo+p/FJg8eDj15Hp5d3tskJcaZaUTtLUso/HQL7
         ptCu2ib0+eBJ6OUfZmuFQrg631pDR2ybpiXYMjhN6Z7duvDMWXNzMYouJxp1DH9GvgKg
         BBIrA0YeWywIXuqnYdQBtAh4ybxTCW3vf3mUMjpEFSdN5kHLgWrvLwywMoM5SZRDS/ip
         PPKA==
X-Forwarded-Encrypted: i=1; AKwUvBwF7RcfeYIHlpsnYephigXQaKqsKn4TAb77//e8Nae/xlFQw/KfOA/LJkOcc6uc/awtpyaxOslC@vger.kernel.org
X-Gm-Message-State: AFuF++kWAkYuRoSLoFCwjtXH1k4uZ/3Nl5cLwym5aBto0I5lLij/6rvl
	roymHDP1tfCKSOuaKLHAZZEbRXUZAqDeRaZbfCi4tkEOB7C5hODkSKPNLZYzvRe2pl+lcECaJ8K
	wLAzhl+9Gx11jcvLOluv7Q17cOZwNLnI=
X-Gm-Gg: AYBFou1tNgF0XemLzvBPE8DdNfQmj0g++PTW/lTuy2VccpmVbsZKkQ7X7Q1sk5l1yF9
	1GWmJzpdSYnIVAOAp8fn0QtJGTF/z3wDZYscDDY+5giDq/PwiwGSXMqFK5MTocJ5kHsWwpPtiOL
	6dbjmOLtGqtAPwfehDyLlnmXeGe4pMVUqqr9AgFH2LTkrRWCMbQEBF0mxl9fPKNvsXtSF5Ow13l
	VEnnbZ3vngNfduNAGwpF8FCEumY/Hw6pGvoCG7/zaebrR0om83OQLnfzasTrdH/sbq80M1tx6/v
	Od7S/r971Nrovaz79XzFWF0NoSf6vq7NAj/VSDrjiNZHi1b8Tly9TjaTauQnUkf8I9GRNVNbLLK
	he6cuSLDdmhs=
X-Received: by 2002:a05:600c:3584:b0:49c:ff66:7d88 with SMTP id
 5b1f17b1804b1-49d26d7f8a2mr170508775e9.7.1789153450782; Fri, 11 Sep 2026
 12:04:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <CAKEwX=O8i+OsP6BJXNZNk07hveN9HDT+PoyMTAU6gOc-xp0Ppg@mail.gmail.com>
 <CAMgjq7BQeQQOZMDPFJ+8LS2N4t3x53r6Nm+9o0_pi92oVUgjgQ@mail.gmail.com>
 <CAKEwX=MS-7C96i4tzBijHN=-xuZgny_wQEa_0YjfHzhoNysdYQ@mail.gmail.com> <CAMgjq7B7Mc7vpQN0gBknsSrfZWXdif5L7nU29YskG9mzS-_jsA@mail.gmail.com>
In-Reply-To: <CAMgjq7B7Mc7vpQN0gBknsSrfZWXdif5L7nU29YskG9mzS-_jsA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 11 Sep 2026 12:03:59 -0700
X-Gm-Features: AcwNN1WTqoBlEbiKI6CdE02QFoxhwTxTh-PKBQg_YuUX7rc2TMIFeAiuSkD6Ytk
Message-ID: <CAKEwX=PxZ68_4240DC8HjcqPRE0bQWGmouoqapqqTQ2b0xqpvg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
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

On Fri, Sep 11, 2026 at 11:14=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> > Would something like this fix it for you? ZRAM users will not get
> > vswap indirection overhead at all, because it would bypass vswap :)
> > Down the line we can revisit this decision - for e.g, if there is a
> > use case for vswap-on-top-of-swapfile. There might be other interface
> > that makes more sense.
>
> Hmm, this interface looks confusing though. you mean tangles vswap
> with zswap through the cgroup's zswap limit? I originally expected
> this to be a problem solved by tiering, skipping certain tiers seems
> much more intuitive. Maybe Youngjun have some idea here?

It wouldn't be confusing if this is something users don't have to
think about at all :) My point is that we don't have a use case where
we need userspace input on vswap-enablement on a per-cgroup basis yet,
so let's just keep it all transparent. From user perspective, they
enable zswap, and it just works - vswap is just an internal
implementation details.

I have discussed with Youngjun regarding vswap participation in swap
tiering interface in the first version of this new design. It's
technically achievable, but we decided to post-pone that for now until
a true use case comes about - trying to cut down as much code as
possible...

>
> >
> > Potentially, but we have many users at Meta. There's a huge diversity
> > of machine types, workingset size, access patterns (both frequency and
> > file:anon split), compressibility, etc.
>
> You can just set the number as 8PB? :)

Sure, but with the vmalloc-array approach, there is more metadata
overhead even if we have not allocated the backing page of the
clusters yet. This will be annoying on the smaller size machines
(O(dozen of GB)) to also pay the overhead of 8PB-swap space metadata
reservation.

With xarray yeah it's truly just a number limit. Put it as big as it is all=
owed.

The "allowed" part brings me to the next point - not sure if you have
seen my other thread, but I think we need to be even more careful with
this limit - I have found another weird interaction between memcg and
swap subsytem, specifically with the refcount of private id. I think
this is another argument for transparency - this limit is now also
capped on architectural (page size?) and implementational (refcount
type) details of the host and the kernel.

https://lore.kernel.org/all/CAKEwX=3DNYoMH8pTKeCvA=3DXHFmmNVMeDz3mxbhp5q6-P=
xSTJ5wOg@mail.gmail.com/

Seems a bit much to ask the userspace to know all of this. Better to just l=
et:

a. the space grow on demand, automatically.

b. the space be limited by an implementation-induced cap.

all transparent to user (until we have a true use case for a userspace
sizing knob).
