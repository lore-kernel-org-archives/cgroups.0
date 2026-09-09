Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B09B57F72E
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788972124; cv=pass; b=VrD+/6nTkqqyEV6OHuuuysVh/D+OzRZ6iTI1YF3qDfk7zltc3VX653SWjJKr+DWTk5t3HVJ8AD/vvg6BIdEA7eqBzo1IBW94oE3wlNNyz1NMcEMBNIeDwjc9cmE7Gf/hfYMOo7kK/P/AghX9o+2PtcVOLJSFN6UADBZN/5D7Yb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788972124; c=relaxed/simple;
	bh=/PVQoRJaxnOVHklysY+eFPRn0PjfeKzNOqRGrKxgA1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TxS+lSpZym3RoUt3AgEWx0QH4q6ctoi3xszW69RbLLbFyo7PZ3LPj6ExTI/ibH0xT2rYDYLFVhdN8Vzeqk5bLd2qzeP8/AO6fuA3HycijtMziXKlsG+DLB/fZwH0f1OwB0rBskX5q70rECZepCvipjUyDkc6tjYRgr0KyRnUdqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KMdV5HJZ; arc=pass smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KMdV5HJZ"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3a4835ab78cso25713901fa.2
        for <cgroups@vger.kernel.org>; Wed, 09 Sep 2026 09:42:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788972120; cv=none;
        d=google.com; s=arc-20260327;
        b=iqE9DKXJB0tSV9sf2dlMvH5S4NSzG8cv3Kbk531LvuZCIcGSPX8qDTufMOKMJA3BZI
         1LLaXwPLARLI9dAjddYpxmukzJ2xmA/VYJ8X2D34feUfnK5JWbmmpYbzJrpsrTKW0CBB
         tOSLGIX2uyB10iCi7+Ixhfmj+t/OFrXMvUQNC89k073nRuWcDJaG2H/puKKUjHbnixEz
         LMRRcHl3+1OGzFkTt6xpQ/MB5OPLKCP+9/e3GA0DvzggUK4hqm5hO3k20eOkHZ1rSEE6
         oOKGIe48X757lf1n4/hcpZswWsFVjbD4qmzYDG335m0D4D/ln7aXdzpKHKQc+WbeCnuW
         Krcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/PVQoRJaxnOVHklysY+eFPRn0PjfeKzNOqRGrKxgA1Q=;
        fh=sXBjrbpgso0AOi6jxGQBIuPiA8oN0pkGCUXnXY21ZBI=;
        b=XE2JNyGA9vjsEUk5EYU+5nZKdGfio+6dazKCXuaYrb7JWuZF9F9669JmFdVBZ+7u8b
         4qeCwD+wUuqX2u1/Lj1wVAuyYhbrax7gMmnLzsfgSNo6d2Kx03xKENaWI4h4lFN4nRqE
         2XQRkwZfe21IJEq56sdDDYJak07PcmIW6wh/S+eIIN5cOSn7knNTKA2Vdnaz+/pkXiB1
         X+Ow7xSLDOsQEJvQxfW8rp1oNdaapE5xjlqdD2xFHw3NhIGSWP8VA3y9o4LCG+XYfI4E
         ngOnXwLVu89tSN2GVzg8i6ThHXOV5BdfRG2wxyPIBBE7QvuEcQzypsaT/u9UU1h7ymH0
         VKdA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788972120; x=1789576920; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/PVQoRJaxnOVHklysY+eFPRn0PjfeKzNOqRGrKxgA1Q=;
        b=KMdV5HJZLLIGtdTClDxjzcAuheXnvNce1P1lhEryWKx2i8eALdZs63zfXF+uUbfM2C
         XToTkhlCI+ek3ljZF0Cew7UDx038xg1rJ3x+oJshyqwgORB8iiCvpAOjAv4LgcFBxBJa
         g0qiswT5jPVitQmJvPqLoRjKT359Nz4buKHHuksAgwUQnVp9GwHZ1DS5xI8+WcmpNGgK
         7Nu91E2WjY9yxcUSlcC/sFq2usp1DBmdr8iaGTJzbgoOJ06J8ibkvpSJlIZgL3VeJvqG
         ozrJJwvMMjy9d7XW0YzsoAW/Q2ZEFuXct7MHPiPDKLgizH/BUTkNWGrbndLP+Kum1SJc
         +JLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788972120; x=1789576920;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/PVQoRJaxnOVHklysY+eFPRn0PjfeKzNOqRGrKxgA1Q=;
        b=UIFWCMhxlz4k0MCrguiEJa6sQ49HyIpNOqAEQa1YKv2PBBKNh6RrUUSAKFtxksdKqH
         6e0P9CIPk1rhG+ck6LMQBZJ8gVZVicUsch4KuJcmlvVXT39gL4th6Y+VS8ZnurT2JgUw
         fi0JRT3U8bYTMll9jB3GjJAQZYtSa0z+JX+YVOmpFoqs1/G3aczEriHAlQPGc5DKEmpP
         SRiMB2zxpn03ZgdU9sBZIkmTJ03MRNsPiegDuqWOZOLrKwhGxi/cK8kUtpwwMa48Pkkf
         nGQVcGfJVzJsENxSiiyGYI6vBBEPvK+LTgmvAG8RTLP2aiWaAr37KwdlLGFiSOk0Madn
         WtJg==
X-Forwarded-Encrypted: i=1; AKwUvBwqRZhGcu5gZg3RjjNby2fbpBWNCImdeGhddkkZvbZjVDoA+7C2C2WRneV+l3arjZVfMBFU8VqU@vger.kernel.org
X-Gm-Message-State: AFuF++k4q5DlHxZdhQXjvUZVyDL9+jtQ9prLRpY2w6BF9gfOKtuzqk2h
	GxyBf47t3STqzEz/6nXgM9wG2y1l2S4IEa8iIRXaUE5z7uScBMo+Mw0WoPuloWYraOs3M3O5+/s
	nlhlW2yNRpB8/vC9BInB1KfrfjNMHZAQ=
X-Gm-Gg: AYBFou3LzUWaT5uglRYKYG445+iRbNNLkrBV5cDhBRKbSLF42C7wbAx0BJgdmL2emUb
	EizYEAgS+4k9jBWbEW4WJNOsvrfP9ZXyqYSMeHY42aMKmAC2Q63g0Tk4eS0Ex4020ntfiJJVB3z
	n0f21Tkpl5+HHCwqGiu2v1KkCB91is27ALLRyip7O8X/cDQqwleX8yTgPYRgP3GK90JxnNhVvyy
	boMVAjxAukk+rN7UZ1NPZTr2foka1aCsa8wbomoIf7vhgXVfXjDm1OeTti9W+2DXcjI15TLLC/s
	9I25Cc9gAXNryBDvgrmpooJ5JKkcNC6q+IoqszbiTdz8tRsC+OVzhVgRkgJZhJfh5NY2Q4Ed+Ab
	9orXvdrPPYHA=
X-Received: by 2002:a05:651c:221f:b0:3a3:2585:3bc5 with SMTP id
 38308e7fff4ca-3a371a898d4mr40270231fa.3.1788972119897; Wed, 09 Sep 2026
 09:41:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com> <aqBT_35E-eSoN_zj@cmpxchg.org>
In-Reply-To: <aqBT_35E-eSoN_zj@cmpxchg.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 9 Sep 2026 09:41:46 -0700
X-Gm-Features: AcwNN1VWXPWfi4oFELOf49OQVDIrkZtLFgj_RbpHarRwRGht_40BlAv3JxkMu4E
Message-ID: <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <ryncsn@gmail.com>, Chris Li <chrisl@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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

On Tue, Sep 8, 2026 at 11:30=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Mon, Sep 07, 2026 at 01:51:31PM +0800, Kairui Song wrote:
> > Where I've ended up is that unbounded growth is a real concern. On a
> > host with no memcg limit (root cgroup, and most desktop and embedded
> > setups), an unlimited pool means usage can keep growing, with no
> > admin visible ceiling at all. I'm not attached to xswap's percent of RA=
M
> > knob specifically, but I do think some kind of bound makes sense.
>
> Swap space is just process virtual address space, no?
>
> Swap entries already have one or more page table entries pointing to
> them, which in turn are managed by trees of vm_area_structs. That
> means rlimits apply, overcommit protection applies, and OOM killer
> attribution works as well (oom_badness()).

I tested this theory. I spinned up a process, and let it spam 0-filled
memory + swap these pages out continually.

As you predicted, oom-killer picked it up eventually. The host was
(and is) intact otherwise :)
