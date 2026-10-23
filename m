Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787158;
	b=VCCKr3EMhdGgU7AXy/bwIOW/YdmBBgTtEIbPwhIcPGi1nHH4sFE8v4kw8jN1hFb/u+XO
	 eWIMUWbPf5AFCtyiaQlOnPN7wlxRcJe2dHc9wqjrhWFCqOKRaFUZVxhhksuTpCtdS0ZKT
	 hx5izafilOfAYH1eqLGN/xWEzpzjIdaAjjh6fHt1FvBIbet05qlLl6Nyfy4ltexgPwhcE
	 awXJGVx5ZveYM/McL0nsVzFkrDB9yX10DQVH1VVK0cUwqj0gl9P/cvp5HKtAEPgNwY1jQ
	 emnJs1UJ4CUMKW5ZP8mvD+EQg+bs+zcSp+Z/LVsBAboHvxmb/uEewOF+Eh/Z82RJS/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787158;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=cBpuKNMULYb65Wu/rSVhgxM/BAFCtGUZFo7lMN0HRYI=;
	b=aSLhee730kQSvrrDNfqVxMSyYoJUMVgJCjFR9TSndMByIloWexzGfrtayqsUpe1D7ruc
	 MVvV3dagGVgmWguq7zK4eTfRWP3MXl3FKAOZ9HDXmNs3C+GrOu7uQF54/X3h+wnhyqp3o
	 Z1dBDsfWmnYr/bj7VcJMJBfUwvf3Cg7HRWVAnT6ONv30HYLQKoJdyWhVIij07vPw8Fzc+
	 Kz/iW4YgmWpP+EkhvBQQQOESTUKAUgWEysomOgJIp9bZlwYbfsla2pR5KWN4TgGk3IyW6
	 2rNmzgRwYNdBsLH7QxEGoQU7UwWsHQg8xSGGzShBwldehBEa05WRz0lwa0WtATku26w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kUOaND7i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AEE606A321
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 20:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kUOaND7i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42431F031ED
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 20:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792787157;
	bh=cBpuKNMULYb65Wu/rSVhgxM/BAFCtGUZFo7lMN0HRYI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kUOaND7i9bo+LfQTlYCeMSIMDINnKcKAqzuMs6mTaPqaxiTdUM7Cuhgwkyc4rUV+L
	 asihWuH/R5+ji5wOTBIsOO3tYn6oPdD3FWHhPFndTOA9kKA6rHw8if0NbUunXJe+0l
	 m1t7feyGN5GBgprlHNBPEdIE0kO6FexlMjMALpVVyqJGMkl9aS0eniBHZKhisVafG0
	 K2f11eEFl4rCCpHNij+cIYKY9caWSDaI1dHvhPNnxcgjMTUCnyGP32QIzcHxoFZkWp
	 11jRgeKbR13eGBAEMoV7uX2iZ/ZwOYW9rYwiivm5PV9BQqJ1Iv0iQQofxpPq9o5BBe
	 BUNdm1MazjOgA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso193695866b.2
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 13:25:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByGwXGTwQgKkwDHShzVOjQD4TrWwWEgrWqyqRnSPj7dESIKqu5obh8T47cK6rxPl+lbOV86BblE@vger.kernel.org
X-Gm-Message-State: AFq9FYLyk0tPhRO5k+Y/DBOIG812JX355Ia73M+vU2lHrB39NxjPQiCu
	bztehxRNfRaPq3dk0cUcDVNghS6A+Le8vqes3gphYFoFtsdWElcVAGZ2MygCpK7IY2HnyRH9/vj
	6EQ88Kw5xwZ02Pj9nSgS+O3kxfQzkLs0=
X-Received: by 2002:a17:907:b041:10b0:c46:7ec3:fdfd with SMTP id
 a640c23a62f3a-c46bddb5527mr644266b.14.1792787156537; Fri, 23 Oct 2026
 13:25:56 -0700 (PDT)
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
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 23 Oct 2026 13:25:44 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOtK7YYdBNS+h5bNW-miKED7p4G0igy=D-=HRnGqA-38A@mail.gmail.com>
X-Gm-Features: AclHuK_uvs0DAK96R1pRTbfdiLY8KlmEoFiUjwQOc3DD1U1FsjbL17wAqwkQa-c
Message-ID: <CAO9r8zOtK7YYdBNS+h5bNW-miKED7p4G0igy=D-=HRnGqA-38A@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>, Wei Xu <weixugc@google.com>
Cc: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 1:03=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
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
>
> Using vswap as a swap VFS would also allow us to
> get rid of the page table and tmpfs scanning
> code we have in swapoff today.
>
> In that model, I really do not understand what
> "swapoff vswap" means.
>
> We cannot umount the VFS.
>
> What exactly do people want to accomplish here?

Today if you swapoff a swapfile, every is swapped in into the
swapcache, whether it's in zswap or on disk. With vswap, you have no
way to trigger swapin of compressed memory in zswap.

Wei, is this what you had in mind? Can you please share more details
about the use case?
