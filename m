Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793173411;
	b=P4ZXcEyV8aftoF6icARbpVFsCDV+uO8UjoAD552HF7990krsx4+yh0i60DLsgh3+GK1i
	 QUFuJaiBOAsGLqrUZCd1nhAa7fnwTMjT9w2XVaWWIc2Q1ZVDnQ9EtgPc4P8CZZByvlqhE
	 01zsMly8VDJUeQgS3QDhKZ0bbt7eezIh2o1w65kG3CMuMk1JqvDLYFk/eg6eziln06D3P
	 rg3zuZs0cr0S3eb1x9nbkMMMRx5x9RvrrpGHMQPPY7/xk+HphgJFdb0/ptXpaTH0EkX36
	 wc/s+O7meFNVW3qdX20wFalfNX5iftq13EdD3JBvwMEK+5w7P7JicgQ1KnJqsD12y+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793173411;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=nskSZD59o5Wku3VNP5CAyzpTIbm3E/kieBuAkeS4vuo=;
	b=PT6Uk70worprpKmU8A0joy1OvxosuEkmGbmRKNmuzxzeYg2wEoFmFcRF0atgA2YwdWGY
	 hNBgsmV4X1mFrJWXtFSoG5iyWiOqdHT8ge7xWL3D9VJ/BkIPnbMGwKZdbq2mbIL1vev3+
	 fOkzoLVeEcw6fHnWvrSVVQUV2ZapU8aVVgomgplhpsjuzO3IXqBqPV/YrdJ32/jKDee/9
	 MANGQ2FccniSw5xbrEH732D+ophNwsj3UqLWWq8zhN02ueorOKcVN/j+QuORGCRfKRsPa
	 QFYRzdM5Z188FAGj5QCoWYEDQzZxK+dXEGl5Gc9g363B/lgO0UNIQHQ3F7MCUvs0+SA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eY8K2Qfq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6D9606A31A
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 07:43:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC6D9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eY8K2Qfq
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4301e334ceso45708566b.1
        for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 00:43:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793173409; cv=none;
        d=google.com; s=arc-20260327;
        b=BcUgl3yx7s+E6YIuCPN7t7PZR86Z7MQo/4XzvpIDVxqkG6iVe75KVhaWuCx/gH1zY7
         W8p6RYfD5d0cCLl4t/BQbnNyjWPgBObFZyYMyoB92GHZDwxgMqK16+Xt33doqyU0VIEb
         S2m/zPdOaizNycZ1yCaDik5S1EpyI8MMu7stKuw55VJLqEonOsKAKPoYlRK85Q5oPA3G
         ygIOZj9mp+rJrqcjjLm67ngnLgBMCFGMoTqjRe3WaO7zV8KkgzQtdW9SnqnHIJa2fwW8
         /gFB2Xc0jwRVebqqXCUsetZwwNt/StRfXptmKI1Dvvl4kM1sQL+AlWpJOiSaSvpWBqTW
         hk9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nskSZD59o5Wku3VNP5CAyzpTIbm3E/kieBuAkeS4vuo=;
        fh=fzpkmHtyJbe1mtRW68BWsF+NZ6OKOY2TsVP912HZ/bc=;
        b=PCLkat6EDc1WYgTZ8+FDoBQf+EZp+lI5w+nae6XucHTaH89jeLAYUpEqjXIgQWQAbD
         5uVtC1JP5inneOVnGaeQcxNukK0BZ9hxSOg0GeUQvQOvcAlqA8p9WlfhZN6ADXkB9R2u
         jgsgeGKZXm6zaZ78tVKNH80/wn0/Y/1sx2NMzOT5x4O7tvkDApHIHVHluAOvDuqijw7R
         BbdbfFJuikwNF0A6hu5czU53pDEa/whTYc2ubGemT/Hsn/3NhaEKxlgYyUZ98c1A2FJY
         Kjg9Y4/sDvG2/GyIE855iyPzveG5ynne6tGd+X3BizmQ0FgTgpSAmBGKkINvcjujTqNv
         4/BQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793173409; x=1793778209; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nskSZD59o5Wku3VNP5CAyzpTIbm3E/kieBuAkeS4vuo=;
        b=eY8K2QfqWnb9Uy5/XzguQIx7EQpUUcQbEVhYARBR17WJ4iuiiEJRw8vLhNRNaxP8d3
         +TfZFT1spjkwqs4FMS/lskywFPc7/3c6Yx9Baunf+hC1PNfje3kaaG+fhnKqCE3eG8dM
         YHUQ6F29rrBzhxSdqbJaZuQLiJneTH+9O6T+/e4jhEjlimbuDP2m1OIuLlTyBT3FOznq
         IAQqlkBATrqu6uq3uytL5wLjUbcRuEJinWiO5PYS6CMeSf5uFd0gs0BMOE8hRSA+rw4e
         11MR/BNlpNrTXvZ30lBSufofLldS2rH3HNuzXRtxUu5cvG+MNrQAWIFHBItMAyWuPf/K
         Ieww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793173409; x=1793778209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nskSZD59o5Wku3VNP5CAyzpTIbm3E/kieBuAkeS4vuo=;
        b=iU7E6rdqdtdpn0QIDgxoJ1hqZz2YcvwNovcuBj6IpJ/EGVCTu2Nr6dPuc+Vg3v2GUx
         sFVDyn4T/s6Tl7qqU/WVlh6HCxlX4TaqiKnADDLDsIWtWFesPABOQAm2zb8BMelPbBu3
         WUn0dOMv6uXa8Ei9FvnkJnqPy2SHm6/chEfWue7Kvq1Fm1ch5I1lv5jxd5hiAcMNfCES
         MEB6Rmeh4tEUr4xnOtnSK0h1dXqhXhWUChO7kWJff6AOwiVvj+Vo903s/cTEQKWrDe1F
         NQ49vGb1LTPbRvxAF7n5afhWQpNdiBCHInBv0uSSy0wSBVaqljOB/Jjo+7F7j8qEreXa
         ltDQ==
X-Forwarded-Encrypted: i=1; AKwUvByJ+FBvQD6Ln1HWfstazfK1NN8fi+Eh4Jz6Kvokkh7EJbVqfP8uVwbUESlf9Z4Chp/YJLfzppAw@vger.kernel.org
X-Gm-Message-State: AFq9FYLodh36CYn5PXLDjPXXSZg2MEh6O5c0AemAh9m9J8hLVegl0JdY
	tiXyf0ThMoivDi+wdt1zM5ryMSlRDPJt2MzlSflL1qRw+IESER6JbRCfFqN7/W+lo3TjuiNTQ4W
	5oX0iuAGewoBmBbR3BMSRfGdV7lJsc3E=
X-Gm-Gg: AYBFou0VNCPLuxZZgWhIRbsdkXcgEJA0CTthPeEb35rs2sOrpv+ldL28KXhwof7GisS
	GUPMmJvLZw17zQ+Wz6laQLD2ASORu0tHfQGaX2Y0s6mIOVjHt3YJhDXSbckHqGfyZ8j0J4au3fJ
	2Q3YhS34cYUuGlXcegNn8zGJNTCnGqjdnZDGV+016M0iKY2xn0V16fv+/NosEc5SMbUUUiAu4CI
	SPSgE3SL9JTuEMXffSUnxpxCRwOIAfyVNSGVcb4AVoeUWrCXQFWT/mbJBF0TdWiJh2B4B3kFsGB
	vVsDM5Eb3zSOhjDZcraex2nVweVANN1ovBb5DojWi0TphX4QaAIUsL5xX39AFzH64HeF62yPHHe
	RDuwtfxq+uT8mWYwpvmK8SIug9BL+JFtLQkPh7jlP3UgtCdIRpjOT+xuhv78N2pU7sSbgrg==
X-Received: by 2002:a17:907:6e8c:b0:c29:5172:6151 with SMTP id
 a640c23a62f3a-c49bdfdf3d0mr122319066b.45.1793173408903; Wed, 28 Oct 2026
 00:43:28 -0700 (PDT)
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
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
 <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com>
 <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
 <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com> <CAKEwX=P_3W+MAFe80MZ5FT0mytv-UDzfmbyBiNsYR5XjC5emSQ@mail.gmail.com>
In-Reply-To: <CAKEwX=P_3W+MAFe80MZ5FT0mytv-UDzfmbyBiNsYR5XjC5emSQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Oct 2026 15:42:52 +0800
X-Gm-Features: AclHuK-cU-BwWpWyYgAak_kB-Mx6gRxkfBQhQnfBmZqza-WmMuBHvINcokofiDk
Message-ID: <CAMgjq7Bie8raWzLB9H+u0eX=FrUKw638mXcRQD-Qahe5qCiMtw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
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

On Tue, Oct 27, 2026 at 12:01=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Sat, Oct 24, 2026 at 9:22=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > Rik van Riel <riel@surriel.com> =E4=BA=8E 2026=E5=B9=B410=E6=9C=8825=E6=
=97=A5=E5=91=A8=E6=97=A5 02:16=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Sat, 2026-10-24 at 23:50 +0800, Kairui Song wrote:
> > > > On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.=
com>
> > > > wrote:
> > > > >
> > > > > On Fri, 2026-10-23 at 10:24 -0700, Nhat Pham wrote:
> > > > > >
> > > > > > * Swapoff: this was brought up as a request, but we ran out of
> > > > > > time
> > > > > > before we could discuss the motivations and use cases behind
> > > > > > them.
> > > > > > Folks interested, could you explain as a follow-up?
> > > > >
> > > > > This is one that I really don't understand.
> > > > >
> > > > > In my mind, we have vswap sitting as kind
> > > > > of a swap VFS between the rest of the system
> > > > > and the swap devices:
> > > > >
> > > > > +-------+     +------------+
> > > > > > vswap |-----| swap cache |
> > > > > +---+---+     +------------+
> > > > >     |
> > > > >     +----------+-----------+
> > > > >     |          |           |
> > > > > +---+---+  +---+---+   +---+---+
> > > > > > swap  |  | zswap |   | zram  |
> > > > > > file  |  |       |   |       |
> > > > > +-------+  +-------+   +-------+
> > > > >
> > > > > When a page is unmapped from userspace by the
> > > > > reclaim code, it goes into the swap cache.
> > > > >
> > > > > The vswap layer then decides where to store it
> > > > > at eviction time. This is configurable by userspace.
> > > > >
> > > > > If the zswap pool is shrunk, the vswap layer knows
> > > > > where to put the data next. There is no need to
> > > > > change page table entries to indicate that the
> > > > > data was moved from zswap to a swap file.
> > > > >
> > > > > If we decide to disable one of the backing swap
> > > > > devices, the vswap layer can just move the data
> > > > > into the swap cache, and the page reclaim code
> > > > > can evict it into a different backing store, if
> > > > > needed.
> > > >
> > > > And in this case we want to disable vswap itself.
> > >
> > > OK, so you are looking for a way to totally depopulate
> > > the swap cache, in addition to swap files, zswap, etc?
> > >
> > > I think we can accomplish that by simply keeping the
> > > current swapoff code around, which scans through the
> > > virtual memory of all processes and brings the memory
> > > out of swap.
> >
> > Yeah, that's the right starting point. The scan itself can also be
> > optimized to be cheaper or better later on, but that's orthogonal.
> >
> > > > I also hope there is a way to release swap metadata completely too.
> > > > e.g. for fs, you at least have umount, and can rmmod the fs itself
> > > > afterwards. We also have many ways to bypass the page cache. In cas=
es
> > > > where a virtual layer is just a burden, we want raw physical swap,
> > > > and
> > > > the ability to swap off that too.
> > >
> > > The VM cannot operate without the swap cache, though.
> > >
> > > That is very much built into core parts of the VM.
> >
> > I never meant to strip swap cache out of VM... The opposite, actually
> > :), most of my work over the last couple of years has been about
> > removing the paths that bypass the swap cache (e.g. the
> > SWP_SYNCHRONOUS_IO fast path), to get a simpler model and better
> > performance.
> >
> > What I'd like is for swapoff of the last swap device to return the
> > system to its pre-swapon state: no leftover swap metadata, no leftover
> > per-slot or per-cgroup data or statistic, and ideally no residual cost
> > in the fast paths (e.g. minor fault).
>
> So basically remapping? I don't think that's terribly hard to do. I
> mean the swapoff code is still there, so it's just the question of
> exposing an off knob, basically?
>
> But wouldn't MADV_WILLNEED be the better tool here? Or is it not reliable=
?

I think I've mentioned it above? You will have to iterate through
every process in every container every namespace, from userspace, and
do some remote memory access / control on all of them, which is really
not a good solution.. It's not reliable and is really hard to maintain
or deploy..
