Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792857048;
	b=jxXR+dtkMbcAys94ckudaU5okdAfLLR8m+amcTBCWgXUpL+2tShxONNCs+C7hA2qP6es
	 vU4DYahxJXd14Ck0v4o+aNTMfpfFU/e3q5kGyMQ6KgyWN1kv4JVijHPfCEfaCY+xo7/IN
	 5weKUKB3TG+xNVYbI18bBBcJLHMPPrrJEH/UQ3W/hOj9IfOndZ3HSYGqvzoIlp3o9vDse
	 xnw8H/IR5iUnRgtctg0zqF75X+wKp7Cs24CFzB1gZCrFenzktip0uAzWlx7PoSXGU4Vke
	 343N81c958ZF0YAbsXL9qbdbeyKm8xyRXcuex3a9bHX0Rcq7IaOcnbOJV8gX5zIJEJA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792857048;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=oFWGrkgth1iIJh7Anrwf3nuRUssZtgX5R4ZSgIf/0Qw=;
	b=nJ2YomBvO7dQB+0EczcHYe2KaDgxzDl7XvIs3y9PU8bfGa93UKV9wiTWYI+O24+0y97U
	 Jy6QcIZCfnRawormsV44JPARTKQtJAP0IhDji6SG4b+FTyz0S/gEekOLXncK+DbBmwxE/
	 +640H4bMH2jetZDsbH8KycSS92iYa5L2/0bjD0qsoafYdEofB2X9ND9PBgmbWglH4plLI
	 g4s+AHABUkl/Ws//nd/oDDa4wFMxZDAUeleAFHCFbeXyBpFSfL9Y+qyJGuHMi/vcBqvfG
	 5TggHk9CGKsIMOQHmsLwE2J+zo4MSaSs4BmYmmpKhTa8qAL+pAM2JMyT67Fogtz3Pww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Vox89apY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2516A606A31E
	for <cgroups@vger.kernel.org>; Sat, 24 Oct 2026 15:50:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2516A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Vox89apY
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c263415982eso214823966b.0
        for <cgroups@vger.kernel.org>; Sat, 24 Oct 2026 08:50:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792857046; cv=none;
        d=google.com; s=arc-20260327;
        b=cLJ5ckd9rFSdJfBtWSac5aHfi+4A67RiSDlpjhdVeWCCBV/qqymRuJ2DwSa1bl67T9
         i8D6N4DrTAZb5lktof4CE/ygsI8KW8SrdDo+EPOQGYiYS85hOHdBeBxldOSydVc85G6k
         cu9dRZwNmSelz2AhSVo5du27OKAssupJyaH4WIhY3bcJtvceMjuH/GB9T07hkcXn6u3Q
         c1dhiqFvlALdkT9jar3bWC5U9+5tKrZaB0dc6EpZ5o8kUWRPv872PAxRppKicURK5Fhc
         9o+wUAtm3mecg97VJKxX6Q0viqfQb4GbBPgOWswEEm4NiLfiqP24dwkwTaZpRf1aMl3s
         y9jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oFWGrkgth1iIJh7Anrwf3nuRUssZtgX5R4ZSgIf/0Qw=;
        fh=qVonOvTA2iYLi5K9UZE/ULVvrSB/U1yjF3H8OikH7yY=;
        b=nLuyW3R4NFNhFIpiviAL28U5+s+niZrFC1uSboQw2NwzTN2qW7FTLVaNvBHN/xp3eJ
         XUC14e9qFQ8Lxq+/v+iV0k+Pj1vPsrEC8oUOv8v4wkrWgIJx0dqhtD8nbMGJYHdmHMe1
         E3jZpNOMw/b/Z4GPYlpHwddAHqR7QWXVjNcIYL/sssBOipzEhKoTFFnm0so8QLEHf2sA
         d+nagzPLj9XXFqFrZokH9aglMPcITTNgrPw0PfSxZZlBFWIc39/l2fi9aKyFpwZ3dCAk
         tTl9coi0I3l/f+j7tc4wUU/M+E2327wgjLfDd5oIek63WSHZ8GIS6TisGqdpeEXzECsL
         kYpA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792857046; x=1793461846; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oFWGrkgth1iIJh7Anrwf3nuRUssZtgX5R4ZSgIf/0Qw=;
        b=Vox89apYKkxzNP74T2aNak5u22twqgjwpHPx+TqfYVI0UJWK006HQLjZkZctsylKGW
         OdyR809srohJ5Y3qGxuK2W8T/C2JGVFF353PRQN8LnBXRXizIFOonARk9qtHVMvZAL5Y
         907gpDI0XshwymoUI4HpatxHpTmFpZFhnzlNOtKKaW8hh6T5743QXiv+E2sAh2Shrv6C
         lov+NAcVRKcR1cDfGudqJQcrkBkoELFFnrj/qGBSSCxAicpRfuMbh9dHP6x881FjA0rg
         5IQcjVKVNaHZPgBEDGmaSbyODaFxyys81Djm4kb1xFPSiNjkAE2s+VWYDsJ1qyCJ4wCe
         E1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792857046; x=1793461846;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oFWGrkgth1iIJh7Anrwf3nuRUssZtgX5R4ZSgIf/0Qw=;
        b=FX0gmVcqW0SmTQqAUK+kdgG6ekQ2jTR0Lp0xJF2/5q38Rv8Rf390lpi8c0iD3PIU6V
         kx6VM6aF6Y86s3F0ouUzRaP3WLK9ZkukqydMIXHmZkt3SKumaRx8nKVq0r6k1uwGeVG0
         7ArilcsKPrR5Fghq6zd0wa6oFtVD9xsG9o4BlQAlRqXYFAXE9VAgGIrxWe8H2zEynSAi
         2fKdIxsVnfcsnEPZbrYJcoAr+kYYn3UqUpbMOWIjhQ+4uekzaGDFflrbx7cLPJOfKsN3
         Tdq9Sr7kWRZqY03/TtJE+jQya1Fs3U9NDe7Y92Ew96xh3cEokRHCPDLzVr4ybc0suZam
         M3pA==
X-Forwarded-Encrypted: i=1; AKwUvBx3icasmnsQLvfkJTUY4dsJAfd8n6ZlXoTVQBf/YiBC5yxSCExq+DiavLT1VzT4Ao+0KQzkVHoA@vger.kernel.org
X-Gm-Message-State: AFq9FYKyIwuZOWOu+8ZCIGwGKCnQIN7jbu4GoYiesZBEtqL9xH4kz6Wi
	8g82OgcQN/nwLnBh60eFZ6f8Erf3XLKMgnQKQJWk+ueMrH97KZP8OYxav5UfIIFBsJVihDUR5AY
	urqE69ESEuXBNnCXQUP8yKayLsLwAPMY=
X-Gm-Gg: AYBFou1Oh8mVTSBGGHnbiBe5WLQS1VTjtvOWMbIb821lqgC5d7GiZ7nYgZJX9OCmXi9
	Zq6ofhEaLXNepDyR96xfhKB3rObIBYqLNRU4xnM/Uov6jdsANq/TGSKWS9OInlSTnUKZqD3qsZ/
	ZsP0xhJOIrsrbYN5K5YCEyrI74eMXYRh49vVfpgv1PZWht09yACGaXoqmz4JDZqcSOyR/8lBFKL
	FmYLx1Y/Voa9INdD9Wv1Sg4xvvSarKMO5LtFGWBOFsj/qhVRzRWAHW4T31iGEQDKImgYbnAX2hH
	HItCKyhGqwy8iDbEA83wD39etw0vraNauTUS2PLaShLa7bC7+gyP+RHcynK8ceLHMfEMYyWdNPk
	pqxUpU7qX3XNUOtpQ96cOy+ZLGFXTePh12r/Nvd61uNqXAosfdUT9Q7+NwBDWY057a4BFX3+RXM
	MljkMt+a9pzfBEPSg=
X-Received: by 2002:a17:907:3f1e:b0:c41:26b8:c49c with SMTP id
 a640c23a62f3a-c46bdd97c19mr234177866b.10.1792857046023; Sat, 24 Oct 2026
 08:50:46 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com> <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
In-Reply-To: <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 24 Oct 2026 23:50:09 +0800
X-Gm-Features: AclHuK8EdrvPlNQOkv86BcPqxKsSvjXgFWnjUR3jEYoufbz3bHhkuKrZQsexIF0
Message-ID: <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
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

On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Fri, 2026-10-23 at 10:24 -0700, Nhat Pham wrote:
> >
> > * Swapoff: this was brought up as a request, but we ran out of time
> > before we could discuss the motivations and use cases behind them.
> > Folks interested, could you explain as a follow-up?
>
> This is one that I really don't understand.
>
> In my mind, we have vswap sitting as kind
> of a swap VFS between the rest of the system
> and the swap devices:
>
> +-------+     +------------+
> | vswap |-----| swap cache |
> +---+---+     +------------+
>     |
>     +----------+-----------+
>     |          |           |
> +---+---+  +---+---+   +---+---+
> | swap  |  | zswap |   | zram  |
> | file  |  |       |   |       |
> +-------+  +-------+   +-------+
>
> When a page is unmapped from userspace by the
> reclaim code, it goes into the swap cache.
>
> The vswap layer then decides where to store it
> at eviction time. This is configurable by userspace.
>
> If the zswap pool is shrunk, the vswap layer knows
> where to put the data next. There is no need to
> change page table entries to indicate that the
> data was moved from zswap to a swap file.
>
> If we decide to disable one of the backing swap
> devices, the vswap layer can just move the data
> into the swap cache, and the page reclaim code
> can evict it into a different backing store, if
> needed.

And in this case we want to disable vswap itself.

> Using vswap as a swap VFS would also allow us to
> get rid of the page table and tmpfs scanning
> code we have in swapoff today.
>
> In that model, I really do not understand what
> "swapoff vswap" means.

...

> What exactly do people want to accomplish here?

One thing is, to prevent page fault (minor), not sure if everyone is
aware, but a page fault itself is sometimes slower than swap IO /
compression (especially for compressed swap backend).

There are suggestions to use MADV from userspace, which is not really
maintainable when you have thousands of different, opaque and dynamic
workload, and that is very common for cloud providers.

I also hope there is a way to release swap metadata completely too.
e.g. for fs, you at least have umount, and can rmmod the fs itself
afterwards. We also have many ways to bypass the page cache. In cases
where a virtual layer is just a burden, we want raw physical swap, and
the ability to swap off that too.
