Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DA7397699
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 18:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789150495; cv=pass; b=HlRoCVbFPuera9R/9nLpuDvFlEX6gZni1RglJRfXIzJYqseRUEegxB50gLyuNRhOF7aRHNCkXq9W+Ou0qLjM/fG/oyaqKnLwo0SVW4kUvFHqzhmPD8ZbXy43/IAXll/6EvuBcCqlQJfaE7BL3hfbh0xFP8YsGHvnyYP8J92Fmck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789150495; c=relaxed/simple;
	bh=GBuxWMSsg4wZZ3OpOH0+odAqCmKuZujhQPqIzTdn0Yk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L0rPq7iwar/TGaS0w0d0+aHlwmOoWwzPjfvib/Pg6UmygZ0SeJhau/TKIO1Np0Z96iN8zoC2NR9nDPzvZtJF72cdsLG4102yqfR8APDtomjWG/9eddmJ+dbtJpq1c1XsKmYdI87QhLTarPCNdv4a/KmKEV6Iojbl50/tzdk4ioo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VX0N/ICf; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VX0N/ICf"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a9a4dc8afeso1982488a12.3
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 11:14:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789150492; cv=none;
        d=google.com; s=arc-20260327;
        b=oCO9mXrhipANrK+KuJNZVuDLCBmENv0tK36WcnfBBKCNSMjgMAwD0HGEc/EbEzU+iK
         dkmTpBkuRXyHTGG11EI8x6G0c6U9jjV5hbrz/YObbFN53/YxYwurL7vXk2JGac9joIHM
         Yf2YN9ERwdifTxQekq8zGQEDzHtRv4AvjlleywWOEjvbKgLPA++GJQ4qNdmMqhYZEAlu
         Hycfx9IE4jo1JYcuUEypP5iRbCq/kZX4tpq8ssmGPsN1G8/+BP2uDi5w/mwPkXLfPmaU
         WojJln7yhbHC7Aiih2LFlqNUdt18Hix+ZsRWrtiWF4vGILjb7Wxj8tgfA0Fz9burllGD
         +SuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sgMffH9c4Ut5GzZRUzz1jul/MtsWXNFvANxlyz2Cqvc=;
        fh=NXSQVtDrccYfmRPef/ZCZ3ZR5PUD20qRF7MRgiAd4z0=;
        b=nOJKmPADlDBF6nx8Z5adcQz9pqHHT/Y0Scu5dtsC8/JNUomxj1E/T5mldjz78Fmu+E
         axjrjUdvn8DWaMVmxpAcdrR6q0j3KOAUgcptkHNLnU9pUR0P7MpKExFegYq2jYt8Coa7
         uTZhBn9eXbVL2GW8Ay1+CGF18iMLY7U+KoK7YpMDV0OfZ7XFsd64GFm+eudcDSotZGpm
         YayR81z2aQmAKOzT+PkzdfdcapnohLiph46RSI6NqexRrqYDnlsMGlpj+P9JPjQzx86U
         1Y+4/vl+FA96NQor9SPy0hkHc2aYuW819fQAXiQ+ugDonajfuTkZtEU4VWuGiXrvmS72
         BX+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789150492; x=1789755292; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sgMffH9c4Ut5GzZRUzz1jul/MtsWXNFvANxlyz2Cqvc=;
        b=VX0N/ICfu6nRhxaCAHv2F/9u4G0ce6Yvyyj9kYf6yKwcgmh4mGHhVrKRzUUGrUe82e
         dBSCR9VM4bbbucXmQuVRNwen9qIBQbUC5lhp/BJhA6uozTYw3JJ6C3hY61Bc8V2N0oMH
         OsenC7xrPsCNjt4k17SfnYGAnwLGIXuWASqa3KcopYNNdixArZx47YK8Wn6LzSXzvDJX
         x1NsCnbmPvYJES2RR+9eDOEqUPc0DMcZd2UUzDR+6XBPvO+0zHxNEKNqw1xrCN+LHBha
         tcZ3NcfQQ/VmrXX0AlN2GTuAzmN1CX+k2fKbafpWss5W//1XDE4S+Nyi3zOpUrriKaLu
         wWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789150492; x=1789755292;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sgMffH9c4Ut5GzZRUzz1jul/MtsWXNFvANxlyz2Cqvc=;
        b=C/lxpOTvmQStA99vRC3YjfIwXbF1CPbDZndTnZYmi98NioQ1+esbFD+yQf9YIvw9yJ
         1elbKEOrEF6SxJ5EZLrNWvWIUXvm6HHMrYDwFdg7NPwcoGJFKyLq5ub2j2daL4U4ONUm
         6/esVU5bIS42LozAZS0z/CkysAOxPGWRABMu/FzM9IkueZS6WMfxfxlDWwGE2kB6EccX
         iAFsiDV5miO0fuxt+GtZKBSDJjy+F9nJXydBGlXVHvkw1AzK49PwueJw4WG4+DwBAEBE
         A0n5j3xU/jJMLLUyaA40nweHOEWbu0s61t1LmCmjKyRR/N6yZFuz6GdJ+iwBGqgENIl5
         x77A==
X-Forwarded-Encrypted: i=1; AKwUvBy62jF4/xLGFAGGOYcYM49NA+YMFpJ9b4tePIxAln85z/LqQ5WjCBccgRrEf8A71yPLJMvvPrM0@vger.kernel.org
X-Gm-Message-State: AFuF++m4fKKCfYx61NAQ69wRqiKkI9GO8wA+roRs07XMwUtPPRjZWJVi
	lq0Lq5p4c47ks4XumqNKveCtZNKp7CUgeEK05MiWU/y+7lmZhk5tpQQlwvELeeAMi1sH1iahYmN
	5biYbYGF71ntN4uYlzlF5kKPr1tbmBYM=
X-Gm-Gg: AYBFou0SG7He8GVoRHZqjIrBZElOEGu5qy37ev6xmGS3C7brGCbz+KcNPYb8KLTvqah
	nI4eCesd6vx3Hy9StKRFWokTWRy0RS+iFYWPsDQmLJoj/ZBrqDuYSDTgvwy9yz7zXa34sXTbZYo
	rEUVXbtAg4vW6zmmrrOb5d75pFeTMt9tBs3CkAOVe76d72RSG/cYC5s6D8sxIk0n5EENl8o5Yl1
	bWHuQGao+JxsqekhUu3GknqCPyr7sMiKH4ykOG3ds4ET3gqFTQNYG/vG+EsSJEcGHyoSh2vbX60
	UqhWvrf1G6ROzrjQmtf2FyEfupLvUSt7ZtRq05NDNu/6tIKCM0O+3OIbWHP25cM7i6tkUAmJd2d
	NvWK1PNIcg6jX
X-Received: by 2002:a17:907:1c10:b0:c29:286e:2e3e with SMTP id
 a640c23a62f3a-c29666d5f9dmr241723566b.38.1789150491872; Fri, 11 Sep 2026
 11:14:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <CAKEwX=O8i+OsP6BJXNZNk07hveN9HDT+PoyMTAU6gOc-xp0Ppg@mail.gmail.com>
 <CAMgjq7BQeQQOZMDPFJ+8LS2N4t3x53r6Nm+9o0_pi92oVUgjgQ@mail.gmail.com> <CAKEwX=MS-7C96i4tzBijHN=-xuZgny_wQEa_0YjfHzhoNysdYQ@mail.gmail.com>
In-Reply-To: <CAKEwX=MS-7C96i4tzBijHN=-xuZgny_wQEa_0YjfHzhoNysdYQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 12 Sep 2026 02:14:13 +0800
X-Gm-Features: AcwNN1X_Mr5nGygMYASuHxKAbKSbuoEdUvrKDUVcI7Vk1_FQ39e_c44cG1FLDGc
Message-ID: <CAMgjq7B7Mc7vpQN0gBknsSrfZWXdif5L7nU29YskG9mzS-_jsA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>, YoungJun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
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

On Sat, Sep 12, 2026 at 12:57=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Fri, Sep 11, 2026 at 9:10=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > A boot time bool will cause real trouble for us, at least. We have
> > many VMs with fixed boot images and fixed cmdlines. However, the VM
> > itself is used by different customers, some are ZRAM only users, and
> > quite a lot don't want any kind of compression (e.g. their data is
> > dense compression is just waste of CPU) and prefer plain swap. So I do
> > hope we can have a runtime tunable instead of modifying the cmdline
> > and rebooting or rebuilding the base image for different cases, and we
> > have already seen that a runtime toggle isn't hard at all.
>
> Ah yeah I see. But before moving back to runtime parameter, do you
> think we can come up with a heuristics for this that have does not
> require userspace input? In v4, I'm doing this at folio_alloc_swap()
> time:
>
> a. If the cgroup enables zswap, then always go vswap.
>
> b. If zswap is not available for the cgroup, then bypass vswap, and go
> straight for physical swap entries. My intuition is that we are not
> buying anything for these zram users, as we need a physical swap slot
> anyway. Thanks to your design, both can co-exist in the system now -
> that's something I actually did not envision possible in the original
> version of vswap. Pretty cool eh :)

Thanks for the test and idea! Yeah, I always hoped we could do this
because there are some very promising use cases for raw and plain
swap, not just ZRAM.

> Would something like this fix it for you? ZRAM users will not get
> vswap indirection overhead at all, because it would bypass vswap :)
> Down the line we can revisit this decision - for e.g, if there is a
> use case for vswap-on-top-of-swapfile. There might be other interface
> that makes more sense.

Hmm, this interface looks confusing though. you mean tangles vswap
with zswap through the cgroup's zswap limit? I originally expected
this to be a problem solved by tiering, skipping certain tiers seems
much more intuitive. Maybe Youngjun have some idea here?

> > > > doesn't conflict with what vswap is trying to do. Some other of the=
se
> > > > differences involve design decisions rather than just surface knobs=
,
> > > > and those are the parts we're stuck with once they ship.
> > > >
> > > > So a few current interface difference of vswap and xswap I've notic=
ed are:
> > > >
> > > >  - default size: somehow also tangled with VM_SPARSE, which
> > > > needs an initial virtual value. It's super cheap if not zero cost
> > > > (the only cost is occupying some vmalloc area, which is fine
> > > > I guess?). But we still have to pick a number, could be large
> > > > enough to satisfy everyone?
> > >
> > > 8PB? ;)
> >
> > Right I saw that at V1 :).
> >
> > I'm not sure if this is the reason that is in conflict with VM_SPARSE
> > in your mind? Techically, at least for 64 bit, we can just apply the
> > same limit to VM_SPARSE, for 64 bit machines we have a lot of virtual
> > space to consume and that should be fine (VM_SPARSE is just the
> > cluster map, which is much smaller compared to swap space).
> >
> > And another thing is do we really need that much in any case? Will
> > things like, e.g. 64 times the physical memory (max pfn) be enough? I
> > know Baoquan suggest just use the physical memory size. So that could
> > be tunable, it's really easy to tune, just a number.
>
> Potentially, but we have many users at Meta. There's a huge diversity
> of machine types, workingset size, access patterns (both frequency and
> file:anon split), compressibility, etc.

You can just set the number as 8PB? :)
