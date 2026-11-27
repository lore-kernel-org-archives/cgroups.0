Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795808514;
	b=g/oW4Y8LRjSU8bZ0C6M7Z61trnOCXn21dLY0B/y4LEdIYoKLDxxjSI0CrztBw5jIyyZS
	 nE9Wm4CRWcig997Z8wYFo7oA/2gEmVhMq8gNuIVAXP1rXdfSTR/cGll4/ygOXsaCkRcyc
	 5DsbZEejaGvChtRSbL0oX6tKZouDdkziq/kHQ5IKRNHhZzuTasljVg/9GzSFkhqmSIgpI
	 37cPCwcZZirlskWFiunPLJwk4st7e7o1dGjl3M2Q4KAbLsU7uV1ptaRx5t/pHOTVhv/BL
	 3d4S4SeRi4xadstMQCguhnDUE8bcqtuv7Ejc3094MOt6PTkjlXUhb7c+8HfeZnWZK+A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795808514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Hh8eaml/yBFyozdjvUyyf0twA7kkmRnJygaFP+0NC2E=;
	b=mr60FOCBxX3UfhbqIwvxf6GrO2zKcVBDwCr3DpbWM5ybd7V1mq7q+0oc7ivdHNlcEyGw
	 Q1eFcBKGtHbNHhS++ONdjReutx3d3XKObJwtP/CTw1FGQH9NuBa8mAakdjHSkYrhlZivy
	 +n5/laWB6Lh7h+aFHC3/PQDz7FrAff+iZdUSbDZeVFWE/716HbbC3LQNS2WWpoqTFvXLV
	 yY2VrCvwWE9ZU45NMme73CIPbzic1vn9JzjCYZwYietXoT7xGksYlQOKYTgtK1T8FPZpP
	 lIX1Q+9ouwGVRfmdQiVxBsIxBvJoa71tG+N7GFYqTYxXE2IVSdEsbPwikGRJCNCyIuQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nQeZQVwz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3EE606A31F
	for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 19:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F3EE606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nQeZQVwz
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c51bf011392so357420766b.3
        for <cgroups@vger.kernel.org>; Fri, 27 Nov 2026 11:41:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795808512; cv=none;
        d=google.com; s=arc-20260327;
        b=AY8qYXEV8qJGOOS9sPG24nFHB6GFJGtryF76N4IEm3axq3O7SONDV/VpauVYoARX1+
         lYyAoaCRYULtx9nL/b5g2JkTjymezkvU74PZV2YtHLiiNcXopdaK+JN6FD1BoL3zRXyR
         bW2HbQ3gKQtHHuz3UHY9bWnrPnoyHCcoVaClwxJ+2P0cJggmTMBkWxTnNfIUPQ4QaFV0
         3oFh/08iZZRZoW0vVhFwSirab91DXFigWWqXa3yuDgLaUiK4Vje7kOcXkJHDzc4MvSTE
         XMx6/EJCjErZhO18B88TEZQ3Lx1U1gcArvPrfgNRmofcYuWTMMo3s4ZtlHrHvKQtj6jP
         o+Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Hh8eaml/yBFyozdjvUyyf0twA7kkmRnJygaFP+0NC2E=;
        fh=x/4Na2AlAL+2NIvBTTZyk++7s4a51RNfzSaC8fxoKDQ=;
        b=OBpqsFN78jthzYTnEOfJj9YsG4eOUaH2N7roj4lnktS2nz9NaRmXujAkRkbqiisBvs
         lr9q00zG4OTy81uObPwcx2fsqys7M9l6TQebmpeslQyOi8IHR5r5Sr8dfzksk7xYrlxb
         ONUTpwJf+TKtoj5uFC/WY8iu8at3a4Are8m9OcGio6kF54qiHQMwINXpCrW8BXgKodcz
         o0jukTPL/rhg/P0RqtjwUzyptrms99gQ44XX1lcom0ErLOPB7FrtScFQvvll7Hz2frIa
         PdBDiWjYf2c9qdDPGoCdgLT2GzvOUUologWJ3jUq71ZQU640YXGkyumwpMWa0T7uMKiB
         jroQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795808512; x=1796413312; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Hh8eaml/yBFyozdjvUyyf0twA7kkmRnJygaFP+0NC2E=;
        b=nQeZQVwzoNwIOmsp7E8zNRbM/ov7Ad5OI5Yt0HPNQ0Nw4Yp/NH3tyj+hDmKisTquOj
         TiY/3N8KLBj2wdz+up69Y1jrIcK4u5FKwuyGbKNd2oqGJ54Wa58TConqwqf04aL5pIs+
         xnpaJ3GxWqeJBlygJxol5O9UaE6qWhFw+brwykOBnLcW4ulte5apcPVRiyqmtzzVz2hW
         ikTDzjABQw0ss6jFdwcwSSnWkt5JC0ukU1SsibCM1einr2k1tym+q0j5t4dhzNJKFuCb
         y81x0qsycwIJ3QTl5addiAW/7hj8qWsA0IVd3kstpQ0qjg5nsNjN2qM2hgBIfBfPvCOh
         Ynpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795808512; x=1796413312;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hh8eaml/yBFyozdjvUyyf0twA7kkmRnJygaFP+0NC2E=;
        b=BcQEjJDHcIFA1zraEWO5VZljJe9A88IVR3Gxvc8TL3VerEFIYlI5dO960lCLlcPOWu
         r7miPTzs2kfUoy5CFI0/W1YKh2VM40s9KnrtJuoS3BbLs1TV1pMGq9BlLCO5CvAeNAiP
         +oZ4HZVTVJN9+E6CqJ98Dw/Mlbif3eRZsc0HYE6WstQj2DE5+BpKfrZLHc0X97QTl4vT
         kflW06mG3skTlQsMy8UfL4yxUfxNNVJKpNt1pbt3wgj/7WzFL4X6ZIhcRy0Us5GsX1vK
         9WckeCmxVoZQQZYbJsEPmyeZdATJIQyxYC0fsBJtdO47fhEkYoYzZ21oPv96aMSx/b4p
         4cNQ==
X-Forwarded-Encrypted: i=1; AL+hErE6XaJkwVa0ZRLwodZKGcta12SQslBwU9lEj19H6lycoBafrEHCIJCjeJVZa6y5dbjyas4vkQ1w@vger.kernel.org
X-Gm-Message-State: APuU4Z8lhKAibUKgANX9z/3F8/0dWq4tIkrcYxbGG3GOsqiILc6mgWDL
	JaPMN+ap7LPUFJqk57KYl6HqGqJQGilZwdyZ8fEeglRnayNZFfyu3lcUz7qotsKO9tdl5p+uaQS
	iaoPua8oCsZDDcor0y73HBjofvcnt5Oo=
X-Gm-Gg: AZFdTZcvXi0GYN1A9AcNgdmdb4nfv9tR2kPOTiETZ+wDfJ2kIgBucBgJYJBiSBXmcaE
	M9gcUi9dq1Sbg9cP2nfT1m9mg66UrJ7Pp8lhKK8o3+K+Tw0kS5rER40Cyrq4kv7UabWV/qIijoH
	0Crmm6sJc2fRw7101HSF4apcqk0ZVrDbv0vBWogaYv6SLc2BMuWDdDkMQIOLGatibB5hn+lrKVC
	cYxtatRFhgSzCE8FRfmHcxrHbxPnmANvNTz399tKiYEqnbXzArVUZPgvy2754eD4yieoCU43+zt
	GzPWKwDixNuriqDs+ynq4AR9CENOit/b92/Ol9EaJLvjXj9vY/uu3aVj47iIRFUp6O+XiXAG4nV
	St0tQoQPCescH6xoa3Unhaw3dUEAwyYM15Cb4f6ivdQmzVG8slU74JouVac4SHGMhinOxfg==
X-Received: by 2002:a17:907:7b9b:b0:c4d:3208:5781 with SMTP id
 a640c23a62f3a-c513a4b1c1fmr2320437166b.1.1795808512384; Fri, 27 Nov 2026
 11:41:52 -0800 (PST)
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
 <CAMgjq7DwCNbke2G25Bxfj3bi5aRp3_qkGeYmCTGVGv+Y5XzKTw@mail.gmail.com> <60e890bf-d5c4-44db-9f90-ae7970b5de32@linux.dev>
In-Reply-To: <60e890bf-d5c4-44db-9f90-ae7970b5de32@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 28 Nov 2026 03:41:16 +0800
X-Gm-Features: Aa3M54q0GwKlgENV-fDrHnc1e8ZIFsqPaG2vdLKK-3H09a0TbqTlTAM4SzLkpj0
Message-ID: <CAMgjq7B9r17gQrOfxffRBiTSepitThjLAUbnraFFjze35t2P6w@mail.gmail.com>
Subject: Re: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count
 a generic API
To: "David Hildenbrand (Arm)" <david@kernel.org>, Ridong Chen <ridong.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
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
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2026 at 11:33=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
> Thinking about it more, the header move is not urgent, while this
> series has been iterated for a long time and fixes real problems, e.g.
> the swappiness 200 regression you mentioned. Making it depend on a
> code shuffle would only delay it.

I also prefer to land the FG series first. It's not just a feature &
optimization, it covers several "bug"-level issues for MGLRU and fixes
regressions, which are hard to solve without a rework like this.

> So if David doesn't object, I would suggest landing MGLRU-FG first,
> and doing the mm_inline.h split as a follow-up on top of it. That also
> avoids rebasing this large series onto a moving header. I am happy to
> work on the follow-up then, keeping the folio refs helpers in a public
> header for the fs users as you said.

Let's see how others think about this :)

> David, would that work for you?
>
> --
> Best regards
> Ridong
>
