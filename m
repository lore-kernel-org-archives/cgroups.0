Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E63480950
	for <cgroups@vger.kernel.org>; Sun,  4 Oct 2026 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791137653; cv=none; b=hDsv0qZnG/j4delaUkrnKm4rpSzSbXh6d+m9tMWZuEYr4WrME3KENi8mLP3cB6uF7DX6vLdmOyFWArTnbrBuVn2tAyn3PFeBIFR0yJOSzEsUedgQBYyABGPm/RtK0Rnn7FOtLLIWBLkNH3XraCG46rWYy0ZKC+TgVcvMn/6s6M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791137653; c=relaxed/simple;
	bh=sjH5S0CNZClDmqdFY8S86gTYCINMCORIQDzBcILuZbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CqbqAQMgEk+NfjI6O+OIFyWG4dyWCehLZXpVLNxdUE2Xk0arJDz8mPHXWd26a9zkGkdO4WB/kGudYfuZ3+IfPwiO37/zsuTt+5M8wmUyjgnIPA9DrMPSFXEqLlFobnP0gKhKngVSQ+rIRDPGfY6iVQC0B0bneU6VCjJQwlqYLTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K4Sa1s33; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4Sa1s33"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccc02279so588653a91.1
        for <cgroups@vger.kernel.org>; Sun, 04 Oct 2026 11:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791137648; x=1791742448; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zvp184+VDrAAELa45MrIVjzHZuD6h0h7teUaAj2z138=;
        b=K4Sa1s33e0topBLGrjJINZJoi62x44og/j03tLJmjWt2c/pJvzX2HTGqfrHcMxLOGo
         KxzYBuopU972XPuBVEcR0ycGt415fw4raN5VEPo2z6muL17lWZ/HIG88g123LWJTPd9Q
         rirdz9jjIW7qf6CNJ02pHhxBu7iA1urwiQXBk8Wvo5pIeMbSY2jZaZ/D1EBhVzv2BTh6
         jqs959cePI9HiTQN5HMLqSTDbZ4rKf638sNEpvZ7ucTiJSi0gF2+JfvYODsxEmFKBRLK
         o8+oSJ+fc86F3abO3LxElskwxBc8NX974Oso3GKIkN2Vqx+k+AED2wHfPestHNGGQ+cW
         BnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791137648; x=1791742448;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zvp184+VDrAAELa45MrIVjzHZuD6h0h7teUaAj2z138=;
        b=TD3fmPQL/PVTq/V6RRyNQ/Zo1/HvN3VChiu62tCXSiteklxELMfdg0bJaG4Vx0Rwu5
         m9OOuGGzg5WDVH5ufDhCU+XoBUogD5ddAQZcJYdpCfwr25vKWXZngwvVmA5Za9/SrdiF
         4X72KustqMsqLIgm5+9MhOY197bH243t1jaiHBDoU2Z8qJXZ1dQjgtcOT2L0ztXsEhxu
         DjN+cpMtkAgUqRSLZSvd3BFmWr3NvRIw+idXO2aX97xgIppLPKjFGKrEi9jo8baXJz55
         1dHQmYlDrYCD3CuF+vANry1Co5sSKqrl6DstFI4UX7OqKA0NhopQf/xlv+AJul8QiuR/
         CTPQ==
X-Forwarded-Encrypted: i=1; AKwUvBxQUXM+RJgDLmyFRuDdKotihluhJl2oCkn1A1Cn3iyvmoEzyTU+dLWxN3YmS9c8A41BgqfoPAao@vger.kernel.org
X-Gm-Message-State: AFq9FYLnWomKklqZuU25NXuwewbqeKgmHUUmB6DQi7T4PGUf+BXQZ4fy
	sCGlZQ7hZzgb3mhPdmQMaysS3/pUxlwtvgci4Oo0izxI5Jo+Y+eC2Rc3p88MQ8nc
X-Gm-Gg: AYBFou0M0mB/HQ3d7MFjkoNP2BcfvTD+B/csDs99zWFPlN+HrX93akdYim/K2On1Xr4
	AQ7Jw1sKdRHYkFC4MoJ0Z89ijIb0EN6gKSh7gh+cjb1exqTJsPaXlsE3GwIZ0TPRvMur8+sZj4X
	gkqKEf7n12NKtibCwUjATpZv2qagyNJ6p7Mtd9J5jAVb/1BEHNmewQckIHX3+JCbkr0b9uPQ/V3
	sG5lzd4uhXO00fz5GGckGRMblQVzcmjRsvWZ4u+joS4hz63236lvtp89oATVHxBF4U5h8A6iUdH
	s3+DdrdcrKLnG1fu9+MvwOfA4Xgs6iqwLFqKUe8mDvOjg8iMWjog05/lhC73rbVIJ2P/ugdoG2Q
	LqvtMf0Df+HXBUnB6qam01paNscVqIZCflel4cwDEebiOW6Up3e3k9H14WI7UwfUBVNMwKmGVZO
	FO9THRsPGyM9y9h3oKxXDYCT2A6835lgxLWbaSJQawqh+h0yMMEDHVOxrwbIlE2+xT8sM9P4wEv
	NkvFIP9HC4tsinXfPMrDcsdHjdFSpSL5T9bFpABbw==
X-Received: by 2002:a17:90b:4ac3:b0:3a0:a781:2c39 with SMTP id 98e67ed59e1d1-3a6ce3a978dmr7662178a91.7.1791137648512;
        Sun, 04 Oct 2026 11:14:08 -0700 (PDT)
Received: from gmail.com ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78d59f1cdsm7460304a91.0.2026.10.04.11.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 11:14:06 -0700 (PDT)
Date: Mon, 5 Oct 2026 03:13:58 +0900
From: Youngjun Park <her0gyugyu@gmail.com>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>,
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-api@vger.kernel.org, Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org, Karel Zak <kzak@redhat.com>,
	util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate
 offload
Message-ID: <asKXZv5SxBtxQxqf@gmail.com>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
 <CAMgjq7B7jem_dwtUEX7ZJPQm_pKBegR6WS9+B7nFp-gZugpUng@mail.gmail.com>
 <20260928151944.2686626-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928151944.2686626-1-matthias.goergens@gmail.com>

On 2026-09-28 23:19, Matthias Goergens wrote:

Hi Matthias !

> > Just like we already have a "swappiness=" parameter in the reclaim
> > interface, perhaps adding a "swap.tier=" would be better and much
> > cleaner to achieve the same goal? Based on Youngjun's work here:
> > https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.com/
>
> Thanks, I think that's the right base.  I tried it: on top of
> Youngjun's v11, a "swap.tier=" argument to memory.reclaim is about 40
> lines.  In a VM with zram at a higher priority than a disk swap
> device, and a cgroup whose tier mask allowed only the disk, ordinary
> reclaim in that cgroup stayed on the disk, while memory.reclaim with
> "swap.tier=" pointing at zram went to zram only.

There is an earlier attempt that may be worth a look.
https://lore.kernel.org/all/20260618044857.69439-1-jiahao.kernel@gmail.com/

If you go this way, the discussion in that thread worth refering too.

> What it doesn't cover yet is reclaim outside any configured cgroup:
> under global pressure, a cgroup nobody configured still reached the

Right, so for now every cgroup has to be set to exclude zram, unless
another idea or more code covers it.

> zram tier.  So for v3 I'd like to add a system-wide limit on which
> tiers pressure reclaim may use, on top of the per-cgroup settings.
> I'll wait for Youngjun's v12 and build on that.

I have looked through the whole series, and I will keep this use case
in mind while working on v12. :)

Also, to share what I had in mind, I was planning a sysfs interface
for each swap tier, /sys/kernel/mm/swap/tiers/<tier name> (exact
naming TBD). Maybe the system-wide limit could be handled there as one
of its use cases?

Let's discuss it in more detail after v12.

Thanks,
Youngjun
