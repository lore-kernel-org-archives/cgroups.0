Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795714237;
	b=nTwL+5Rp0EM8buOVMa67Nsk/oarrNZ2NmtWNWVAqW/f1Td6l5uiH3d9cUD7akegNOfGN
	 3vWlzu2g1lvJNmnyQKL8T8rawfDzMMX3Hx/umEn0YrEv9USLh3YwtOKl+1Nb1GeOlgczL
	 Jji4KoIDePbvk9i5K0zgPNAu9pQyO0gSyA+FzpGmXyRtUP549iCMJTamxSgqAjkPYseMG
	 PaJRhcpFolE8DUKzwYvTr8gcD1gjU5vB4s0D0Hav7Mzqr6UnFMwnKBRN6od0sz0mXfBbJ
	 fParzywrJ+0pf+yLSr2s2zxF5xHYwT472P9buCuMaZlw/eikLPQw2Jcg/rK0K21Sm9g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795714237;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=gddPbAWbVCreSTfaILEUDv9Rsv+EhM6Ujvvqb1L6T4U=;
	b=tIcr19FE5Fc3IH2qwD+8E4u9R39mKqfLDb3vO7yk02bAHTFhN6ssyStYXGSztdw1P9m0
	 jJPVAlC5NNlKKFfdF0KN8qKFvPqf709GrYIbxkVsOHi4RMgms45uoSyNWD22HZ9BVh/q9
	 3Ml9RbDjOD2B7BmRZYfmMCDP+ns4BwbGyfmLqxBdwHzbLiBWHsJlUlzisd3/s8iAfzb8T
	 sdCGbtTQStgH6isp4QXlt9GzGKjqKXDod7LYrWNFlNOiP31MSUUAkG0pn5z/94/XmHP6o
	 NzSzUd88eO+FrWT6rIG3tY4ODPWi1KkDXV0Kbnib3seGdfKtLRagMuBFiSNU2pYwAYA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yl1ycuOn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FB9606A31C
	for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 17:30:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38FB9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yl1ycuOn
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4a2f4ca0dcfso4185375f8f.1
        for <cgroups@vger.kernel.org>; Thu, 26 Nov 2026 09:30:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795714235; cv=none;
        d=google.com; s=arc-20260327;
        b=KgEBv9/upfFNqr1pAbqnVsFa2odzADwkAUPUyX5tmjdTBtUhfLam+swDKlQY5amaQn
         b5C/H+a2gsAuzDt1Y+guxlPnk8PIAKFHXeUc0jWjtDAtAQhSzXltUNS76LeEJ3HyMN4A
         Ws4BWQx3ZBfQ7IjqG3vr8VKq1hMn1ihzErYK1toDAYw3fKP3bhusq58YT4RrJtsnAR3+
         M/3bF6Ic0dSJD96oCc9UeoJgjaeIikvGxjM26BMZ9X0NfXElTt1q9uzaq1kA1NMq+CAO
         ueV6/gGThgZ0AChBB3bra/m8xmrXlRZU6uF3JBjL7szb977oYAtFhVFDmTmhoIJu1vUq
         gGTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gddPbAWbVCreSTfaILEUDv9Rsv+EhM6Ujvvqb1L6T4U=;
        fh=xa3hSinHm1MvrT2+lNwV/6x3/0i3Vry83tsbifgPCA8=;
        b=iC8J/9PS32KZOdZVu4ZDHETDH2WHpJlLj4B2XtFlZJd/VxH0dgDw0KCwRqePYlByXe
         lDwhJpeqOOeDrecoVRG1BHjyPB3vUWvMEvRChXzLUUfMDovONmX81cyRAccVQYPBE8Cm
         +reRXGIOwaJK3dR/TgZQpMo68lGZnnyzLu5Ms22t1n6GOnCmXqXyLm2ujrXtBU7fQFpC
         KAtmOXutM6HV/5S0NcY7MPTMUyaz2UtKQqccvCiMwOON0eKq4wRU83B0ci+PZsTrioSX
         898W7a/ZLsC7L8YItHTWqdacxruQptV52lGanQiD47C4WIkJT5iyuiHZ6eOtnp/rD+2Y
         E4Hw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795714235; x=1796319035; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gddPbAWbVCreSTfaILEUDv9Rsv+EhM6Ujvvqb1L6T4U=;
        b=yl1ycuOnnP1KDAXmH8fctPRffHQl8YRnO9GeQuWr1uAayuqhAPRrCKL8UUjnJpZEuP
         b0+SvfeCzMyqBDMraozwCqvGFGQEdwPgZc3kCRBE75pTRjWeeC+mawI4QBiu5iNCFosd
         opi6/rxI3xR5G6U6CNyawEl+FndXptsMsj/s2W8UNxcd8dtwI7K6kPDP60qMFx96S+Qt
         qUsz/M0BdL/Lia6WMU4oropELBD9nsqDb8tvua2hugSbKSmV6V1jJrHzeq6DNP+F0Xf9
         45wuOXR4BUhw2oj/qUuBsYLEn9fatjWSEcwynq+UatqWeOtY5l9ZRfRRIXhd9OVDS4U6
         pAlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795714235; x=1796319035;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gddPbAWbVCreSTfaILEUDv9Rsv+EhM6Ujvvqb1L6T4U=;
        b=YCEFOLDEx5eEzUB0KLRrdlZUj7sw0QHyrFDyt5k5kxIUiUM+jIxOVo8PPMDEckJ5n5
         SwvXH9Z49OrN48WjNT4gXjUY8K078+c0FkHSixk4vAvGDsaipSg9asqTmsvJV9yIyQZ+
         V13Yra0+qfLa2ZeTOvfgba1ICxoeaVHnJeV9ANva412zeUasnNMejlSskyEw0s86kUzu
         TK0fRn3O3/ji2pFgzHLkOZ09xOF1G0Vi9EW8LLZ66UlrW9poVLQWu3sxGVHPKJkB45K8
         31NOWHT1FYbJOOw+8llPuQHRuK2u9DqVRrRK0jIfaraZt8j37SEI50XlewDyN9l0imrT
         poXA==
X-Forwarded-Encrypted: i=1; AL+hErFbkSxRQW9bvcRpjTV/oOElIw8/BKHh7FbnLCWJ1uaIeo2PpAMzaHTCodFspHNGVG1vvyoBwZWv@vger.kernel.org
X-Gm-Message-State: APuU4Z+JD9OruCJ0FLgGns3RwOaFWa/4/3noQNNN3zj33e1ik3Jz5f0W
	SS3nq3q6YAnSQh8uU3s7CO5nkw3hiOPP9XETFpE02Wei+T0q6B4BFaj6c5rxU+0VUfe/tGy8GFx
	plQ0zLK1jFOa2441bUEAqPN+OqvSYVKo=
X-Gm-Gg: AZFdTZfK7zm5AildLEksrSZMKKxL/iuL4HIxsun1wocqQFZx2hHbGawk4oxrrRhVBRR
	HaB8hfxwPsj38yxR0lTfXqFKsRt6oRmtgImb0530igffrC6wVawUlltxSXC0LsEpLQgw2TTjdD2
	ubVkNDeid7A4rLe6r4+ujEKC/onZvcrQQBtwNX/ih8uxSPh+xG6mnmUgQjiw770sTdCMYADdUIr
	pbFOeX6z+GKRopYJBvD++K6mIPUbAllrS8EYpTm1FRCE/vEI3oXzHmXkgaY6vhhURXiX50ZU+ME
	vigfDUkHXN2lAd+D95d486VM5fzbuPQIH8INnQFGneRJlnkO09C5BlQM7YPtqJPv+7cO1XqJNbM
	4+GRQHA2eaRKjWs+XmXnijmMthUd9Rl8YMUFNBf0ZeT68vE6SP1/3CBVeMbBEZRtcf6VhSTIUak
	HggJCXA8KqdjUI6mayPCWc4B7UfSSRwDY4cjbe4c9zMiEcXnFYrjKg
X-Received: by 2002:a05:6000:29ce:b0:4a7:1fca:e52d with SMTP id
 ffacd0b85a97d-4abb0e46a88mr29683986f8f.9.1795714235150; Thu, 26 Nov 2026
 09:30:35 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAKEwX=NXSwSiuY65EV5nqFocMLd6-afsiJfgy_ahB2v_MDmcng@mail.gmail.com>
 <CAKEwX=O2McF-gyqJT2a8R5q79+QABCPjULrcjC2CC0v8TnXxJw@mail.gmail.com> <awfLp4H_pyefSM5v@fedora>
In-Reply-To: <awfLp4H_pyefSM5v@fedora>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 26 Nov 2026 10:30:23 -0700
X-Gm-Features: Aa3M54rJTgwPSeOjApk5LSNeUtBIt7uA3RemLayFHLNNoWbgFBictWmfnBliNKE
Message-ID: <CAKEwX=O2d4KKzvmReuv3x4TPX+NGSN4WUmuWY-OtANse+=sNVg@mail.gmail.com>
Subject: Re: Virtual Swap Sync
To: Baoquan He <baoquan.he@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 11:03=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> On 11/22/26 at 08:31am, Nhat Pham wrote:
> > On Thu, Nov 5, 2026 at 2:06=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> > >
> > > Hi folks,
> > >
> >
> > Hi folks - thanks everyone for attending. :)
> >
> > I summarized the points we discussed below - please let me know if I
> > missed anything or misunderstood a point.
> >
> > * Control interface: Google is interested in a knob to cease zswapping
> > (which already exists and will still work in vswap world). Kairui has
> > a use case for remapping all swapped-out pages.
> >
> > Vswap currently bypassed when zswap is off; per-cgroup selection could
> > be added as concrete use case arises (for e.g migration/compaction).
> >
> > David objected that a virtual swap abstraction should not carry a
> > swapoff interface per se. Folks also asked whether making vswap a
> > mandatory layer would make the implementation cleaner (Nhat will
> > explore this direction and follow up on this).
> >
> > * Virtual space sizing: We discussed using vm.overcommit_ratio and
> > vm.overcommit_memory to limit the host's logical memory footprint. The
> > exact sizing formula is still unclear - Nhat will follow up with
> > Kairui on whether it is acceptable.
> >
> > (Kairui, if possible, can you respond here for your exact use case? Do
> > you want to limit physical memory usage, or virtual? My understanding
> > is you want to gate physical + swap, which would be closer to the
> > latter).
> >
> > * Priority and multiple swapfiles: should not be added for now.
> >   No good use case for swap priority was identified.
> >   Multiple swapfiles were used in the past to work around swapfile
> > lock contention, but it is unclear whether they are still needed with
> > Kairui's new cluster-based allocator. If contention remains a problem,
> > we should fix it in the kernel before putting that burden on
> > userspace.
> >
> > * Proposed phase split and charging (from Nhat):
> >
> >   - Phase 1 - initial foundation:
> >     - Decoupled zswap: Let zswap operate without reserving disk swap
> > for every virtual entry.
> >     - Physical backing and writeback: Keep disk swap available as a
> > backend, including when zswap cannot store a page or an entry needs
> > writeback.
> >     - Charging: Retain memsw charging for virtual entries; keep
> > virtual-slot usage out of memory.swap.max. Actual physical swap usage
> > keeps its resource charging.
> >     - Usage counter: Expose vswap usage so users can monitor
> > virtual-space consumption separately from physical swap usage.
> > Essentially this gives you a method to estimate the logical footprint
> > (memory.current - swapcached + vswap).
> >
> >   - Subsequent phase(s) - further support and controls:
> >     - VM_SPARSE: Add VM_SPARSE as an optimization after the
> > first-phase foundation.
> >     - Runtime controls (added as use cases arise):
> >       - Host-wide runtime disablement knob (and remapping of swapped ou=
t data).
> >       - Per-cgroup vswap control (for e.g, if some cgroups want
> > migrations/physical swapfile compaction).
> >
> >   - Orthogonal use cases and concerns:
> >     - Cgroup-level logical memory limits in cgroupv2 (memsw?) - swap
> > developers will follow up with memcg maintainers.
> >     - Static sizing: Define the host-sizing formula and decide whether
> > another interface is needed.
> >     - Swap tiering for cgroups: Explore backend selection when a
> > concrete workload needs it.
>
> Youngjun's swap tier comes from concrete use case of his company, it's
> been v11, he presented this in LSF and LPC.
>
> [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with per-cgroup se=
lection
> https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.co=
m/T/#u
>
> This is xswap road map I shared with you when we discussed about working
> together. I also mentioned swap tier in road map because Swap tier is a
> very important feature we swap developers plan to add.
>
> https://lore.kernel.org/all/al8ohWshSSZ64AtT@MiWiFi-R3L-srv/
>
> I thought you had read them.

I put this as "orthogonal" because I don't think swap tiering should
block virtual swap development. It's probably the other way around -
swap tiering makes a lot less sense without a virtual swap layer.

If you want my opinions on swap tiering, you could search on lore :)

https://lore.kernel.org/linux-mm/CAKEwX=3DO-_OZ8x0UC96a_k+0eZfAE+mWMWDdn68u=
y1LHRq=3DJC0w@mail.gmail.com/
https://lore.kernel.org/linux-mm/CAKEwX=3DN2XcMHN1jatppOk6wnmz-Shab5XMtTtzg=
YOzRvU_6YFw@mail.gmail.com/
https://lore.kernel.org/all/CAKEwX=3DNfSy0XiD_UMsDOHGCwpE7sYmBmhV4Y9vk_cbnn=
r6J6PQ@mail.gmail.com/
https://lore.kernel.org/all/CAKEwX=3DNfSy0XiD_UMsDOHGCwpE7sYmBmhV4Y9vk_cbnn=
r6J6PQ@mail.gmail.com/

I did review Youngjun's code, pointing out some deficiencies we needed
to fix eventually, but I did not nack anything.

The problem with that series is that the memcg maintainers are not
satisfied with the proposed interface, and the lack of writeback
support (i.e data transfer between tier).

I also raised a similar concern in one of those comments. And it's not
just a nice-to-have either. We can get into LRU inversion scenario
because of it.

FWIW, virtual swap IS a step to resolve that problem. It provides an
indirection layer that allow you to change the backend without having
to do PT walk to update the backend, or repeating the logic at every
backend level. The "V" in VFS, so to speak.

Similar with the other items on the list - memsw for e.g. I made a
best effort attempt at least to make vswap work with memsw, but memsw
in cgroupv2 is its own conversation.

>
> I don't know why I couldn't join meeting last time, I tried at 8:05am at
> my side, kept waiting for people to approve me until 8:30am I was
> added. Not sure if you guys also talked about this.

Hmm maybe I missed that notifications? Apologies if that's the case -
I do remember letting you in but I wasn't sure at which time. But you
were eventually in right? I remember you commenting on some
overcommiting stuff.

Feel free to comment on this summary if you disagree with any points
:) And how do you feel about the proposal?
