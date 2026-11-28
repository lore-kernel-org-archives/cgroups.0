Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795870049;
	b=rmWOQc04ZnqYFwP5HvWvyueiIIlYUesDDXKNhORREqBw1C+an6R/y1Vw5B4L/3mN+Kdh
	 VGX1ybb+XVBilynzy08uJKDcVz21224DLz7V7ZAfxkezf7fVMcnUE+C3GN9Spv0rrkBJg
	 syv4z0+lwiLVsX9uTj2XaJtBrC6O2SkMUpxq8doccRXwKs+4SJ59BnqxUYmenxOKlQ+/k
	 d6M/6N2M22vhKD64ZbXvLkrwMgPfmrSvdl+NR51S2ylbGNgA8td6TJj2M1vYoFVMNQw20
	 zLMgyDVkBgjsbUPEXS4RkjjJZwnciSxglCBCcmCa3yU1kWcvzb49F/0EtkQHCfb6IOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795870049;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Neleil5nC8s9bt0MpU40WqwbR7w+O9HixUWBXPDe1yo=;
	b=jK6c+/PX9RMh+lwmwenK+QvraiUZ7xuPB3HwiB7glPQ4j4GC+NFgBc1WxWzCym03wUwi
	 SkIWowlPz8xHrj1EP+gLbDaVT/c+/DDbEq5YECqkxK4KjWDwylBu9JwLM6NwXnFVyVFoI
	 2LdvjQma8EuXN29Mucus5vh2XkKn8BptLemYb2heiJ/iJiFCPshlSCcMhLiPs6EfKl4v/
	 dMkC2Y8+Vzhf9c5MnHOzB7mm7lMJZYFsIT/HA8TW2D0BGJBd2HQSS7iuhCDrPYDsJLolu
	 RnJgp3Ft4+EHszAkx6ZVOEJx9L7KHn6ifc5IT+W/4yr2Qa9559Kji/Hb0aBJqi5dBRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IWTHYpLR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8696C606A323
	for <cgroups@vger.kernel.org>; Sat, 28 Nov 2026 12:47:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8696C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IWTHYpLR
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so80720875e9.2
        for <cgroups@vger.kernel.org>; Sat, 28 Nov 2026 04:47:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795870048; cv=none;
        d=google.com; s=arc-20260327;
        b=PZ2DaGbgqUbzi0uIYg/B11dk11st+ckCHDhnhLoE7hkQhgf70INZPXo62VLEJ2mLmB
         L+irdSv9VISy7Y4pWx2gs2NzTnVDvuKVpHKejbG52SLQf4GtydpbmKcluMmGF/j+O67t
         brxonehER7GTZeqfxiZSzlbs1w4gPO0M/pwn/xfmqx9h+gihPSj4NBrRKsZoeFASdn6q
         L0kggyGZZrO3mbRpuB4sT9f7hx+Q5W5AlvSF8z4kqueuXqRPD//LwUsmUS9y/LLEbk1i
         0ky84WANgze/PXcLOsPWmpqBilIvUZLYxkp2ZidoioHXufTxJ6uiQN8hcWrflAs8utKE
         2WIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Neleil5nC8s9bt0MpU40WqwbR7w+O9HixUWBXPDe1yo=;
        fh=hJNXO6UEI7YuQIxkBZVaAwr2geUm/LYg+YAzH4zLDFA=;
        b=Qb7QuTuMFbkFZB/4NU+NgkdOao1mjSSOSD81WIueMtFEVii9z5dqbRsW7d1I4r5gJD
         PGDr/1GqTqXOsHmdCHUkxDQ6emhiBd2fOD6lhBnCgmzNajp9fAtNXIf3uLqDrWer6Le8
         byibkKUIfvi5zL2H/UbNxyRe7zM+EM52rNJFHIgN3KZO9fBFpAYLj4M0PFXL4An/1j+w
         7iA1ULsgM1ey4+tiMwtdXDg5aCYBut1XS9Ba5nZogfMZLvZn7zHjbyPwy2SmqPeKamcz
         y5x7xMV57wFuHRpJ+t65PcToBqjLictrEL3ARLvUjEm20f6qWdqWbwtuPZEli7jfXBBX
         bw0Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795870048; x=1796474848; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Neleil5nC8s9bt0MpU40WqwbR7w+O9HixUWBXPDe1yo=;
        b=IWTHYpLRVilbZbTG6IWjaAeWqjgP+sIuMzicPDehF2Wq5ifxICQvgjljBm8aZsWWu5
         P1q8lKSZZ+QzG675XjXJfggQKDEueR72g6RudWpuixtEeQZw1LXddzEnj6SQ8n2BH7iB
         9IwGSfvyQzfs18CQQg1fwaPXLb9YvFHO4LhDP0wsIPcHPfDXlJ8B0dkg6X1O/mmnPbeA
         BbNcH5SUZezaJyVEFk5BiFxs6Wd2DNbE3olZsiu8CWmqOzjeSSH9+jYRi0I1V+aWXNeW
         MgqAY996GuJs1ONySZ6+Uc4vhosEiZ6vU+6xgLhoy5iOGx2+an5sUBNpf9lj+1snfvM2
         UQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795870048; x=1796474848;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Neleil5nC8s9bt0MpU40WqwbR7w+O9HixUWBXPDe1yo=;
        b=ILfuzFHnq4OpyZE90/xZ90meyhJnrSBJ4kt9Z/dHGPhqU2+kv07H5WGh8yuuEYSHrW
         7v2bXkSVbVIdIDKcfOjrYkWaYVtcN1BKNaYA1VIUk3xC+gmnkrsSJtBYSqEI3oD+LOZE
         FphYX4WfAYqHINdbRXPuwFc0nNA+GXITvcYzOuSM1AiTO4clDU7CMzq3Coxnth9+7FIH
         P8Y09VbTBYwJ3hC12K9W80o+AaxCiF8bggs7e3bvMZvG1KfNJkeqkfvhDFu0UgNKknM+
         CNp3yVnxJqZjGoiDADMGozr7ks6FczrR+hx19rW7MIxaL+VB/NH2zi7R8A40ifZRFbu0
         RGig==
X-Forwarded-Encrypted: i=1; AL+hErHRBlNZ9MEOTOLEGvi0V3Ai5mrH3hkrsiWe6uGapTkYPEDl7trER1KAwAADNUQ85jQpCWF+Xzsb@vger.kernel.org
X-Gm-Message-State: APuU4Z82c0TJWa1dPwnx9rybvUiAAXXI9UTSR1isSDKKlSI8DClYuaMm
	TSPv8kyYK/hIwsbvQIFjWfu7qsSDnmip3yWd69QXnZLmUqP7v+bwCCip86He+MSoW8feI6mqKgZ
	VBngKgSPR2bJxFpvroUcEXPv4/fftwOU=
X-Gm-Gg: AZFdTZd1BBE0VC1jmGnO4dwR4fgGlO/J/CSrEtWMcaZVMLUU17DwzUhNZUFbFKZTwYj
	3w5W0xCvgJ+bMHv74251FhgvKSNoxFs9luoWrycp8sHgU5gSkJT+4mv3CCjCawbzuLiMMnhgc8J
	sdpCCSed9PJP/YjDBAB1rGYZflCMmpwXhOTugE6gUaA7Itz14BIP/T/9MZTCLBcSTlskEuQzl4+
	pDbykXRk6ekXAtkfqB3EQu2SDdxDnyAc5ZDbyzpMVgcrLfM5mbB121V0mfHdvaAqctqvf9/LJrR
	C4ry3HZzAW7E0rr+0krVWvj10BJyfF8jc8WZ2ggQTpVoUjn6jrpCMqCjlys1vb9eIbwbvreZjGT
	bhU51F0Hlg1qK5ugXFZjWVd/G3PfJGpBDCJQeFJiO+li6NQP80h/HIXhrVoQ2FzJLOaKZoc4omT
	JRGClggfVMrujS39bKo6N2mXfixtBaw2RoV2+UsOSi
X-Received: by 2002:a05:600c:45d4:b0:4bb:6994:abf0 with SMTP id
 5b1f17b1804b1-4bb88817d91mr585296145e9.23.1795870047116; Sat, 28 Nov 2026
 04:47:27 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com> <e85a2666-9722-420b-9a60-9d4251fc3d4c@kernel.org>
 <awa30hwg6x82REoo@KASONG-MC4> <8ec3f3e2-5d3a-4bed-a571-88f7ba473b00@linux.dev>
 <CAMgjq7Ayu9H85wurRAUdmXEPWYi9BdLJW13BhK+LMYoBX_7fuw@mail.gmail.com>
 <CAMgjq7DwCNbke2G25Bxfj3bi5aRp3_qkGeYmCTGVGv+Y5XzKTw@mail.gmail.com>
 <60e890bf-d5c4-44db-9f90-ae7970b5de32@linux.dev> <CAMgjq7B9r17gQrOfxffRBiTSepitThjLAUbnraFFjze35t2P6w@mail.gmail.com>
In-Reply-To: <CAMgjq7B9r17gQrOfxffRBiTSepitThjLAUbnraFFjze35t2P6w@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Sat, 28 Nov 2026 20:47:14 +0800
X-Gm-Features: Aa3M54oCldtT2Qc6Xyokk6e6N_BkN7eNxmqD5B8ZoTIPwfqT_iCVOdBBMSKp3p8
Message-ID: <CAN_Opa-fUhr5cFDP8vr_47Zb3WOUnSX03LQyNo5c1uQtpyfBHw@mail.gmail.com>
Subject: Re: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count
 a generic API
To: Kairui Song <ryncsn@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
	Tianyi Chen <hi@tychen.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 28, 2026 at 3:41=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Nov 27, 2026 at 11:33=E2=80=AFAM Ridong Chen <ridong.chen@linux.d=
ev> wrote:
> > Thinking about it more, the header move is not urgent, while this
> > series has been iterated for a long time and fixes real problems, e.g.
> > the swappiness 200 regression you mentioned. Making it depend on a
> > code shuffle would only delay it.
>
> I also prefer to land the FG series first. It's not just a feature &
> optimization, it covers several "bug"-level issues for MGLRU and fixes
> regressions, which are hard to solve without a rework like this.
>

I'd also like to see FG go in first, with the header split as a
follow-up.

Thanks,
Kunwu

> > So if David doesn't object, I would suggest landing MGLRU-FG first,
> > and doing the mm_inline.h split as a follow-up on top of it. That also
> > avoids rebasing this large series onto a moving header. I am happy to
> > work on the follow-up then, keeping the folio refs helpers in a public
> > header for the fs users as you said.
>
> Let's see how others think about this :)
>
> > David, would that work for you?
> >
> > --
> > Best regards
> > Ridong
> >
