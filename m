Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19C24DEC2E
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 12:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790167950; cv=none; b=gjijUiYLvQ8PKmQxI5yOaGAnJZmV+/gBQqGypnUw+Y4p7pqLZYsfOMVKxFctY3JZLo5Umv0l/UTqhtJILiU8UxrwsCKL+B+5jEN3s1ym36MmInPm1i5dJUnTIHvcCi706cXUElo0rYC31fWNRQ0vKsDSrhzhafvw5SvQE62ctvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790167950; c=relaxed/simple;
	bh=WAI2SPpJ8puZMu37X97Tb+6oxDR/Qi6/9yk8IhH1Rz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RbCihFKNyOz6AXw/ixV/cLH7yILVz0jFeFrl29ITyJk1NQhUJnhFEWsw3TLaPyx8C6JCxBHZsWoos2U/WXofMiGDNgIFcHxOOTgDDWf3a5ty/ReA+VG6GpFOXQKe/etJnxsk8fcd6Y51D+A3ZSHZDpZ1xc92isi5+VFQj9LxzsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1cVActw; arc=none smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1cVActw"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8c1b8d7b5so791217e87.0
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 05:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790167946; x=1790772746; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sm7vKUqKVBNM8fpsiqdcEcneUTHOJiE76zYrPR0ilCY=;
        b=K1cVActwFcDsjZT//i/mfB8v9KJpJvYseaGPk2FkC0KjxU4b6RsEf3COWAlP1RTDQz
         smMge2qR22zCmc82xCqreoXQNJuubsLmJojOhzn+4q2TTaH1W3r+kiOmmj9LkJdOtedl
         e1INrx411WVKfLmfX8HqBMZBIf2xMfABZLi/HeV9NtdGWKWg9hTtnU+sqcVDI3b4r96+
         Cx7X7pvKVAyceoszelTcEvknJk4wbSbBJ7luYz7aQkBD6zHS9tdQB9+CmW66UeEEN5gI
         3GAtcY6tGHOS2FCgh8tyeRwIM7R4HMSu4w5F5ZMXz045xynvmftA85L4mS6NdYKbcZLZ
         Z1vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790167946; x=1790772746;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sm7vKUqKVBNM8fpsiqdcEcneUTHOJiE76zYrPR0ilCY=;
        b=1zSJmsX8V9h9TllMDKYP3swt07kVHnlPElUlIy26aBa5N1bH+UbiEHv9oNSYSRXYpL
         i9WauhP5axih+/qtgjtI1eRnzTLY746i1PezpFUKUjtsFC0P8aTA16aXWqvRQMUka5QK
         4hAkrIj2+2KhmCaY081Aou1NWxYGRLsSJaJd5crF4KdtBIMZVXEn4B+XSFPmzKkc9a3K
         L49glrzNRBtNYky00ju/uIia4dTtrAMu913X3xJ4y+3BHZVFtd2FCdOD2wf/tmmzHNo7
         lsWgGZlB5PRyVg1NBf36XkoYlaW6b8+7ALd/UNnMYxrD/MTv7Yk/rUEl7iVU5SA2GGy2
         cWaQ==
X-Forwarded-Encrypted: i=1; AKwUvByDjU0a7zFKWGgyVMe9hhzsUUOri/3f175nwt1TCzgv4QVDPL/8ui+RxHvCA9jyjZ/I9suAVvbZ@vger.kernel.org
X-Gm-Message-State: AFuF++kMHGIx3kDml50dEVZqZs3+VXGGh3fDd8U4LZrbLvzROS6EOxM9
	okdFCQdzMoILYRU3JEf1+NnuhNq2muvaA3hZmVS/M1Okq6M+kpD2SWWR
X-Gm-Gg: AYBFou0oOVU4afqXPiBADPEZx7tvuv5igfpTdxFjo2wk/YxNHoxv0hswcbUKFVi98xc
	RwwKdIW7RIFskJaZ4aYjXaj0Daq292MWyPAWvI5gAzxdfDwOvNdbxfXVUCY65F+Lx1N1acLur8F
	x6yMRIMaFG3s/vqo03F2vZH3W9o6jZWzYH+6/Q9aoMlOFlscCPJ7AMcH/cPLSQXoSMCn9AcW3JL
	d0LqbWZthA3xL1ARn3/7H1uOGFilUZ7LLNd6ZMD6BhEw4Og55zFkUxJlWJjMPQCr4WWorV/pzLk
	Hk2CkqyOiQYLUAafOcf4GcPyEwG0Hpe2m+05vEcE89bG3IJ8JW9X2432RcOYrmruhyeQbS/icsv
	gVRWaoMl6ao/d4lkgKjBZSc9tnsWLhbxLYLiWfmw3lbWEs3RcLeEPueGqaLJCEu+C7JVW9jg6RH
	232ac1LfdzaXrYVR1qwjugzp6/HXF+7Ge+ycKt8FothnBMMydnlTsvLUnLxZQEb5tUEJiXuzcnX
	g4uDq0CN+d/CJLs3yogu+fiV96R
X-Received: by 2002:a05:6512:b22:b0:5b0:113d:8ae5 with SMTP id 2adb3069b0e04-5b8d895fe88mr1057730e87.10.1790167945480;
        Wed, 23 Sep 2026 05:52:25 -0700 (PDT)
Received: from localhost (sol-eduroam-pathost130.ki.se. [130.237.96.130])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d85956c0sm567280e87.78.2026.09.23.05.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:52:24 -0700 (PDT)
Date: Wed, 23 Sep 2026 14:52:22 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
References: <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
 <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
 <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>

Hi,

On 2026-09-22 21:10:53 -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 5:53 AM Rik van Riel <riel@surriel.com> wrote:
> >
> > On Tue, 2026-09-22 at 05:43 -1000, Chris Li wrote:
> > > On Tue, Sep 22, 2026 at 5:20 AM Gregory Price <gourry@gourry.net>
> > > wrote:
> > > >
> > > > On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > > > > Right now it has 64GB of memory.
> > > > >
> > > > > That is exactly my point. You are running 1/8 = 12.5% system ram.
> > > > >
> > > >
> > > > Chris you are missing the point
> > > >
> > > > Zswap:           8812236 kB
> > > > Zswapped:       24927876 kB
> > >
> > > I am well aware of the point. The 7%-10% data I provided is before
> > > compression. After compression, the real saving is about 1.5% - 2%.
> > >
> > Here I'm at 28% without any issues, with room for
> > more.
> 
> 28% is one thing, 100% is a difference beast completely. If you
> haven't tried it, don't assume 100% will behave the same as 28%. There
> is a point where too much zswap makes the system unusable. It is hard
> to pinpoint the exact upper boundary. However, figuring out the upper
> bound larger than that exact boundary is not hard at all. I haven't
> seen any one can use 100% system RAM sized memory swap out to zswap.
> If you have a data point showing what that system with 100% swap to
> zswap looks like, please share it.
> 

Chiming in as more of a user perspective.

On my 4 GiB BPI-F3, I can reach more than 10:1 compression ratio on
zswap during some parts when building GCC 17 snapshots. E.g:

MemTotal:        3966864 kB
SwapCached:        31872 kB
SwapTotal:      16777212 kB
SwapFree:       16638128 kB
Zswap:            280140 kB
Zswapped:        2859840 kB
AnonPages:       2927376 kB
AnonHugePages:   1409024 kB

While this is 72 % rather than the 100 % you asked for, I think this
shows that what size a potential limit on the uncompressed size of zswap
is suitable heavily depends on the workload.

I have been using vswap consistently on all my machines since about
August, and I have also tried one or two versions of xswap (but the
current lack of writeback makes it inconvenient for me). I really
appreciate the work being put in to decouple zswap from needing a
physical swap device to work.

> >
> > > You are not listening. The boundary was set due to feedback from the
> > > application SLO. Those are real deployments not imaginary usage.
> > > Please respect the user.
> > >
> > Different users need different things.
> >
> > The kernel needs to be able to accommodate all of them.
> >
> > The kernel default should accommodate the people who
> > are least capable of configuring their systems.
> >
> > Hyperscalers can set their own defaults across their
> > fleets. They know how to adjust settings.
> 
> They can use a safe value, e.g., 100% of RAM. Let the people who know
> exactly what they want to swap configure the boundary they want.

My personal preference would be for a default uncapped (or very high,
and I don't think 100 % of RAM is high) limit on the uncompressed data
which is backed by zswap, since that would mean one less knob to tune.

> 
> Chris

Regards,
Klara Modin
