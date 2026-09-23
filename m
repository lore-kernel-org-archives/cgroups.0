Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8FD3DAAA8
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 17:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790184394; cv=none; b=nQjEbpSRG20pkn2kBQ8uRsb3C7o9r7HAkMDkSDsd73XzmIdTT8XmM0G9zrDexyQKHJW/5W4gY8geRZHROkVEl4CXV6mCNDNDxh6sPzXPvE8A/gAHcqW1YXvbuAAap0vWE/ADDyjROQbTD/ndskT/BQglHFWnKph4NPeMBsndYy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790184394; c=relaxed/simple;
	bh=s5/ANrnAU4dEafBlRbm72OwWvhG9DOKchuohcmHXkXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pm3ksRUxuq1taXS+zwNvahYgOc2UgaxV6RoPAXi5qVerAurK4+qivNniQyvREyj1gc7N/AsUGKIHXCjFu11Arx2pFm5ZJsFPmg78ciK7e4/HyoW84tcyb/TjwftHWTTw/e0vzZInUq9P/yfQNrjUwR++ZHvOCAXEJ6B1RrnGMkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K4RKYw5Q; arc=none smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4RKYw5Q"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8cbb7b9cfso982623e87.0
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 10:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790184390; x=1790789190; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8iDfKiTdrpXplViiKJrQEoO3nFWUHXMki5lh4/edWQY=;
        b=K4RKYw5QenHKgKay8IMYbc7xDcXkGAIqQiYCmbws+MQ3SW0mGLVY+bYPrTtcNceLgk
         SiGHHVZsISYaex9l0SKBhCuCwtv4ShE1THqtHM+QMYjp0e63AsWjPGiJjkduAU/8ANV2
         jej4smiFApfct+h9reiCC5J/uKUkNV7WtQvcltYhBt+eyiNhhc96WKcOD6fGBIjfTfJA
         Dn5azcnwjseumcnKpb6sHtKFClBbSJdIQibzMvc9b9IRQ6fbO6JQxKhzjgTbCToDVsMS
         zUikwAZshQ9l1QUixw1gCkEAP1Q6+heZFn5sU9pKf9zSoUbArtUFCBdY8x28QffWZxnY
         5Q3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790184390; x=1790789190;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8iDfKiTdrpXplViiKJrQEoO3nFWUHXMki5lh4/edWQY=;
        b=sE+ytnNI0KPAeb5lrYAy1Lyf672zMcC30nGBeehS2h1c0tvAvYTK/5EkPcDeQv0ZMc
         FFRasX4cFajkjDDU+zDFSZgfBeWao4cN2v8rZNvfeev3k72ulEyg0buaR6ONeQohVk0M
         gdWQRwjK8ETMPje3x19hzW4OYpdJO67iQrgp4JMRIzfq7h75yN/9GtU7jeibWqxi8mQZ
         +zhJJ1tIWH+ogqraOFRxBZ+elnuUMSvtqD4nznBydhTHK7jPRtCnIaWFWdogiS7g9JH3
         efJSd9cnOZGq3DXSpQ1alvtnV4QK0lIYSzu4g0v72okk3O2TpkHNW39QOPIpMnv0ZcmM
         ZDjA==
X-Forwarded-Encrypted: i=1; AKwUvByaXhTNLaUKQfYo+hz7vPbaGmnHjgNcVNZS5SX/+wocskc69GryX9HnFhOD26025vtEdgd1q3r/@vger.kernel.org
X-Gm-Message-State: AFuF++k/+KyZyyQ1F3NCTbk/PdP7j2UHa9H4YBiWxI/GfjRQyIOtE6nZ
	t/7bWkacGRzUH2+T54lTUOX1meQBxlQ8yN4LFEDHNuXzPCfWOuWNXVJq
X-Gm-Gg: AYBFou3klV1mkyQQw1zeik/KW9kVz66ghfEoTwh0qZ9ucQk8xVjMndNTDfDcdDVIxG4
	pudia/3R/g/QQNyn0xKXDI3NZGErDqT7gWMmqvrBiFWw0gJyrfF6KHDwxXW8rPDBfDGUWwUHgcu
	uyVjlsxVlagnk37DPz4rMBbYZhR/EfTHqMY7JadnxoNAG6CKPC5WZLc+XR9MiG2EjhpNTOIuoNw
	JwnqZ3fWoXbWRIIar3wR6d6wTHUMWOAFFjZhs3k7yBzKYwZNHwmVdiLPQRSEhsG0gjgLvuQS0Ra
	sM5PpcR7TWxBXBUQXlvfGLSBRLxdrK8rJhlia5IzyJNPDug5h3tB0ZaOq0smHEfyMluPAn8Vgl/
	wycZ525Aaxi9ngax7hbYlox+k8NgQe4Z+6i1bz8kRrE/kGs4PfnZLajToXdiUf/OjchcuQFWzdL
	C8tfBI1orqoqKb79bFo+KOHnOsmbyCu7rTNZPAFevZlPOtRsQBIi9IpxkvhUmBCiggY7N6l/bjf
	cw3xQyz8y4Pr9Lsy5D7mUlIkqlG
X-Received: by 2002:ac2:5696:0:b0:5b6:183b:d20b with SMTP id 2adb3069b0e04-5b8d89c2a97mr1393127e87.50.1790184389706;
        Wed, 23 Sep 2026 10:26:29 -0700 (PDT)
Received: from localhost (sol-eduroam-pathost130.ki.se. [130.237.96.130])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d85787b0sm784443e87.16.2026.09.23.10.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 10:26:28 -0700 (PDT)
Date: Wed, 23 Sep 2026 19:26:27 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arQHTTeLIsmw5NiJ@parmesan.int.kasm.eu>
References: <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
 <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
 <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
 <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
 <CAKEwX=Mw8DsieAeEK=Wjb2d2o=wxEN3QOoOR153u7Ki28003gw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=Mw8DsieAeEK=Wjb2d2o=wxEN3QOoOR153u7Ki28003gw@mail.gmail.com>

On 2026-09-23 08:43:41 -0700, Nhat Pham wrote:
> On Wed, Sep 23, 2026 at 5:52 AM Klara Modin <klarasmodin@gmail.com> wrote:
> >
> > Hi,
> >
> > On 2026-09-22 21:10:53 -1000, Chris Li wrote:
> > > On Tue, Sep 22, 2026 at 5:53 AM Rik van Riel <riel@surriel.com> wrote:
> > > >
> > > > On Tue, 2026-09-22 at 05:43 -1000, Chris Li wrote:
> > > > > On Tue, Sep 22, 2026 at 5:20 AM Gregory Price <gourry@gourry.net>
> > > > > wrote:
> > > > > >
> > > > > > On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > > > > > > Right now it has 64GB of memory.
> > > > > > >
> > > > > > > That is exactly my point. You are running 1/8 = 12.5% system ram.
> > > > > > >
> > > > > >
> > > > > > Chris you are missing the point
> > > > > >
> > > > > > Zswap:           8812236 kB
> > > > > > Zswapped:       24927876 kB
> > > > >
> > > > > I am well aware of the point. The 7%-10% data I provided is before
> > > > > compression. After compression, the real saving is about 1.5% - 2%.
> > > > >
> > > > Here I'm at 28% without any issues, with room for
> > > > more.
> > >
> > > 28% is one thing, 100% is a difference beast completely. If you
> > > haven't tried it, don't assume 100% will behave the same as 28%. There
> > > is a point where too much zswap makes the system unusable. It is hard
> > > to pinpoint the exact upper boundary. However, figuring out the upper
> > > bound larger than that exact boundary is not hard at all. I haven't
> > > seen any one can use 100% system RAM sized memory swap out to zswap.
> > > If you have a data point showing what that system with 100% swap to
> > > zswap looks like, please share it.
> > >
> >
> > Chiming in as more of a user perspective.
> >
> > On my 4 GiB BPI-F3, I can reach more than 10:1 compression ratio on
> > zswap during some parts when building GCC 17 snapshots. E.g:
> >
> > MemTotal:        3966864 kB
> > SwapCached:        31872 kB
> > SwapTotal:      16777212 kB
> > SwapFree:       16638128 kB
> > Zswap:            280140 kB
> > Zswapped:        2859840 kB
> > AnonPages:       2927376 kB
> > AnonHugePages:   1409024 kB
> >
> > While this is 72 % rather than the 100 % you asked for, I think this
> > shows that what size a potential limit on the uncompressed size of zswap
> > is suitable heavily depends on the workload.

Just for completeness, here is later during the second stage of the GCC
17 build:

MemTotal:        3966864 kB
SwapCached:       100488 kB
SwapTotal:      16777212 kB
SwapFree:       16500688 kB
Zswap:            371128 kB
Zswapped:        3995796 kB
AnonPages:       2792748 kB
AnonHugePages:   1026048 kB

And we are past 100 % of MemTotal.

> >
> > I have been using vswap consistently on all my machines since about
> > August, and I have also tried one or two versions of xswap (but the
> > current lack of writeback makes it inconvenient for me). I really
> > appreciate the work being put in to decouple zswap from needing a
> > physical swap device to work.
> >
> > > >
> > > > > You are not listening. The boundary was set due to feedback from the
> > > > > application SLO. Those are real deployments not imaginary usage.
> > > > > Please respect the user.
> > > > >
> > > > Different users need different things.
> > > >
> > > > The kernel needs to be able to accommodate all of them.
> > > >
> > > > The kernel default should accommodate the people who
> > > > are least capable of configuring their systems.
> > > >
> > > > Hyperscalers can set their own defaults across their
> > > > fleets. They know how to adjust settings.
> > >
> > > They can use a safe value, e.g., 100% of RAM. Let the people who know
> > > exactly what they want to swap configure the boundary they want.
> >
> > My personal preference would be for a default uncapped (or very high,
> > and I don't think 100 % of RAM is high) limit on the uncompressed data
> > which is backed by zswap, since that would mean one less knob to tune.
> >
> 
> Thanks for the data, and for the testing. Please let me know if you
> have any requests or encounter any problems :)

Thanks for the good work!

> 
> And yes, I completely agree with you. We're having a very backward
> conversation. The default should ALWAYS be less hassle for userspace.
> Ergo, as transparent as possible.
> 
> Exposing priority, sizing, etc. is *adding work* to userspace. That's
> the position that needs justification, not the other way around.
