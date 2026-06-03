Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DC43F1ACE
	for <cgroups@vger.kernel.org>; Wed,  3 Jun 2026 18:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780511656; cv=pass; b=VVjn0Ux1ZJ8JjK5p6y+vFgInkuU3pDbXyA+l94G+KtJvz2aQSByN8bo0UJ4AnAzMAxRGSWdEPLO5peKrsavN4BGvx/lpnoZRc/AmeWQbZcvS/oQ+awXmN8oY/esImBbjjv/GYo5af5onzm0CG2On5MnS2ntt6v0/T2g6O3P4u4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780511656; c=relaxed/simple;
	bh=TH54AoJ4jB9hdDfjGSLbEq+o20RGSclv34XZcGmgbfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N4IQGOnL6+x7Hbcashb/ROVqSzyW7x2GflVqAoz6MTCqqoehXOKd+4/E2VIPP/bPnxJyZApdnCpRKNZTvXA6LQSr8rHts6tnlwhOfNLxojmKnDdU4vGkjmeWm/A6jMHhh9xeGxKFh15JZziYh1RS17BWdUSJDMVVCKxWgZQcaug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N+CCQv+k; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N+CCQv+k"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-45ef41adbc1so3982271f8f.0
        for <cgroups@vger.kernel.org>; Wed, 03 Jun 2026 11:34:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780511654; cv=none;
        d=google.com; s=arc-20240605;
        b=iZMQgSRWstSzxIDrBn9ErT4WmO21X85k2wrdU1/MjVc5R8wlMmFZjSLVDB92gtxeQC
         E0muvcOGvywq8b17FB89H6q22vgirsZFjs06fcB9Voye02hyLusVSq09BKE+eK9qcHxG
         hHXcA1wTmCtmFcp1VIWPun4c2vrNR7oT3zqRVxDGPAgctHYmRhshWLusCLF+3BqXDloS
         ZQ9bmfCF1fNtjCvOQ1TQyhudRuBlS1dRQkBpEBShSeYFSstdkUkbjG0ksQ5hbaD7YcTk
         qJAr+zde8/fq+RsMZuQjb+RB8vL8aJblpFZqc0YYYxdMPkG9p5r8ir78+264VVcWQ8VR
         S8fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TH54AoJ4jB9hdDfjGSLbEq+o20RGSclv34XZcGmgbfU=;
        fh=4bFI0lUfCLCMuzOEULBiI1gT02qD6tuOmYs7mnnlq1Y=;
        b=d3WIewzB7sDlVl/WNSi7/yrx9Y6X+MN6l/fAREGZEGNqodqG5wc5Pt8Od+aMH6FhW7
         bJxxAXbxzXoESgnptzoV6Cog5FwpJHaovSjCzo6hNuFP/xg4+zVOmvzl/3zn9CCFxOq3
         lyyYOKaSIjvFQIASPDxbyHbA/wkEe1sJnYSa9g/zNXg+yCt3gHSiHBkzYHVf7y8IZx1P
         TBnx9aCxz2Xy1n1IEOg9IGBcz3TvE0YMeS/7n01p7MXrzmb9hqDiyVoZOZZOfmWucVch
         FXBDx3VwwDA/1+alHuGh0gtCWStqzrZA7czRSzvxWgtxofJ++BV1i8yahmS/SjuBbF+R
         TQZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780511654; x=1781116454; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TH54AoJ4jB9hdDfjGSLbEq+o20RGSclv34XZcGmgbfU=;
        b=N+CCQv+kVKVKmtxRQK9EGeWo3HVrpQyjvH/4Fi81KTWnarQ0oTxFLC6es5mR/AuceE
         MLQCHXx3FeOs3qJnJGi3RVCWUFu1Nws/PCvdf9KyI+toEygVetWOpi9yQ7v0HTY7UCtm
         YjfeKa5FlkN+QCrj1Ji5PK3j4kuEiW1lxqQDv0cOfIFo0qpleismYYeIqG3UlY8B9p2H
         aZCJmFM5Kv5bqEaQQkX1l8EBbEQo3GinJQpEt2G1vEKvmHXiukdaiEcKwaS7pEYd3pj3
         r8nc74tFJIKPPEQor1dK3VDQXnEBBIlXD4OXDcWiBej9kWCPPuhFT7a/DWTarcYK5llq
         /JVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780511654; x=1781116454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TH54AoJ4jB9hdDfjGSLbEq+o20RGSclv34XZcGmgbfU=;
        b=Pmb3Cme+GtKU5vwBYnfjrCX+GXXWWSy1ZdDluE0+0rabFZ0FUaeqSqGwjBOL++61ha
         FLiRul/SpxWfU/3rZ3nrTZwf7pKBkEp1JUebc9YndGTICzPN2oxYIWyihkULUcX3TbRq
         VIez8JvktfnuQnLmoNZ0Gd20LtpcK5AWNKD+uM1AohzEmgg3D/1Q2KfBB5ak85G6Ew4d
         xr9+s7ErkerCrgZGeBSeiVY+F4ktkTrZXS9lG9xwQhsHNdUMHsJ9bjPk+I73elvyCBp/
         4/OzqT0KMcbPZvk4Lwp8kQLDAw75bsS/9Chpj0BH8X+VNPCyhkVQ8avSo30Hp9SdnRSF
         hc3Q==
X-Forwarded-Encrypted: i=1; AFNElJ/psK96KaZdRQc/nfz6dGcTmZKcEnBH35VldNNd51+qX5TlLnk0rXsXw2kN/SEfSsTxq2jYaDi9@vger.kernel.org
X-Gm-Message-State: AOJu0YyI0p1sf3W3tpqibrDMlhJJ2DvAdaPWWkNXB41gSUCww8SOx6/S
	OvCmGhuIZ2GRI3XAVWXbQDKJggYulWTvHww0wgnx2ePHcAup29W03KyrjrGTGw/qbKgwTT/j6jZ
	13IWvAXw0rotFd23L5Gees3QCaKO05Dw=
X-Gm-Gg: Acq92OFmRDRO0Y12BttFhZs5vBUYMT26hGSElG4xXpCzrKSrJWpZ3iAGTn1PVSryFT8
	7qbDlFeVdl6/wsE6jBiPdDegcUy5yD9ZnhWrlTNKBGHmLVQ5Gx4AvzU8XC+QoW1b8jqHdgsPYSm
	eAMoBP/PL0WLivc3ioQGP2gf8YFi2eIIN2j5XrfaclER1rxxs6Na0bqz7TSv4c2kSWCyBmln2nD
	tK7dSKi99HFowgtL6v3/VR5JPBB4mfBtBHWKkuU6Uh4UYoGuYIq/sJMalBUFqPcqJ05rsXE36Tk
	et0ymP8yxGGgBrcpI2g3KHvjMXlhcRK9yJztqGvRvLvJeQrGCQ==
X-Received: by 2002:a05:6000:60a:b0:45e:f4f7:7cad with SMTP id
 ffacd0b85a97d-46021980b94mr6753458f8f.39.1780511653643; Wed, 03 Jun 2026
 11:34:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <aho-Z6wshceTAYd9@google.com>
 <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com> <CAKEwX=PoBZ4ci30tKHQXs1o9=NDpPrtbe7RxxZTbnzVJf74ZYQ@mail.gmail.com>
 <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com>
In-Reply-To: <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 3 Jun 2026 11:34:00 -0700
X-Gm-Features: AVHnY4LBOBaSAnmMiBIxd2EE7a4jNLcFpjuYk3Z2E2kzH2esEzwrCqzQSkwrWXY
Message-ID: <CAKEwX=NQUqqrM9vdYE2KhWEZx-YwPc7YPhfz7xaBrGVDf824bA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 3, 2026 at 11:26=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > > > Is the main difference that we are scanning in batches here? I thin=
k we
> > > > can have shrink_memcg() do that too. If anything, it might make the
> > > > shrinker more efficient. Over-reclaim is ofc a concern, and especia=
lly
> > > > in the zswap_store() path as the overhead can be noticeable. Maybe =
we
> > > > can parameterize the batch size based on the code path.
> > > >
> > > > Nhat, what do you think?
> > >
> > > Nhat, since we now have the referenced-based second chance algorithm,
> > > should we consider doing batch writeback for shrink_memcg() as well?
> >
> > I just take a look at shrink_memcg() and realized it's reclaiming one
> > page at a time. Thanks for the reminder - I hated it.
> >
> > Please batchify it if it makes your life easier :) We don't reclaim
> > "just one page/object" anywhere else in the reclaim path, Sure, it
> > adds a bit of latency to zswap_store() if we reached cgroup limit, but
> > IMHO if we hit zswap.max limit at zswap_store() time, that is already
> > the slowest of slow path that you should have avoided with proactive
> > reclaim/zswap shrinker in the first place. And, setting zswap.max does
> > not make sense to me in the first place (I can write a whole essay
> > about it).
>
> Should we batchify shrink_memcg() from the shrinker and background
> writeback, but leave the synchronous zswap_store() path to reclaim one
> page for this series at least to avoid potential regressions?
>
> I think this change specifically needs more intensive testing (vs the
> other code paths).

I'm fine with having shrink_memcg() takes a batch_size argument for now :)

I suspect not a lot of people invokes the shrink_memcg() synchronous
path in zswap store though. Setting zswap.max is hard (as it involves
guessing compression ratio ahead of time) and induces quite a bit of
overhead (obj_cgroup_may_zswap() does a force flush for every store if
you set zswap.max to a value other than 0 and max).
