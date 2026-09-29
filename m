Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2DE3E7647
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 09:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790673385; cv=fail; b=gbfiYgH9lYgBY9muesKy26YEKawdXTxlQl3DzA6k57nqsH48Fy8gBoqjjV3PwuEWyKUbYgp+EcujdnCbLG5UCxPrxF8jdW0icNJJADiEN7dzDkAtXDGd8COB92zgckU5uxLkQDz0anM+d/x4pDxJVAWRfackGe3osCyon2w579Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790673385; c=relaxed/simple;
	bh=BNVccYi1LnLrZu/mffNsQ0VeGIIlEsAHZtAlQgUKSho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iiZoez4U6Da8Xcp4FRxErwBQ0q6QNOLBrGNrgclHcXYhNZp1CDTsSC4MhNFR6H/OWXmv6oNxsOE/B5lAcnsT48WaSS8V4A8QEvjeB5KtLM7YgY6o0mbZf+p98oi96csMWKFQMvSfgDaHxNZKh4Bv5UlRg3HHY9WHFL8XRHJdEys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=KWF2oOLW; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="KWF2oOLW"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68T7UV2w079583
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 02:16:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=UXOt0DR/qucJrjzcbWN633PqrJV6/4ZYqTTDG
	6UnQU4=; b=KWF2oOLWZqV0qtVOV+RAoOj/bKInEHA2dCJiDhdsxUn/NCwq6IWJK
	Tz9cgDhv3tNVxM3VJLUJOe4yxCcEK+JG2p7LZE30TQ6S+jz4iogQ/XPcGPCUoHpl
	n2OZjxjDadiP4BLSbClNOosKwfwSyLfPFHvexb8nKGF1xK7HnOT/hpbdziidMu0V
	eQXF2tvCjJaQ41VREWyRlkPJTDNG+C/OAxmLb/QCFg+CQzx5lSmaJozJIeLxDsN0
	KEdLb0JNvn4tAmjuRaLLGTRdHr5jcwsnR4ZmzY89fKCoj2cdHLguRjp7XGPQw5D0
	PTPMWHscS0t5Gai/UfjzDBFfpPbvpuoUA==
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by m0001303.ppops.net (PPS) with ESMTPS id 4gx9q8ud2m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 02:16:16 -0700 (PDT)
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c29959eb71fso405352966b.1
        for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 02:16:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790673375; cv=none;
        d=google.com; s=arc-20260327;
        b=c/D++4CivaD2bTifP6s8awUalwq0PURB2z0scgY355gipWNx/ARPlbJhyOhGc2K43+
         IWyavCwXWPdH+vPOmlC+1OMVyU8YkC7/P5pIZrFF4yICPqqP7CDWYeoW1wTLC0r/i15Z
         h6hXpVHOHMefl4Aj//4SRwdQ3K9gueWaVo+jm8LIX0IqwZtl8t4F8mMymRpqPN337HJw
         Z3MUO8OX45kf2A76dyrqG4BlgpwqHcrP15Ikap6BR7HD8RXHMtEMCJ+ELPQy80D7nSvg
         brwvgEL1CKSxyIpqAt2KlVMlLkC2lxHdPPrHvVtY//0fH9xNPLFSCyuqA5AbP8EpHoJs
         gWXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=RutqN0XzeZ2DQTMI7Gduqm3yztWbS2+NpNwUibf3R/c=;
        fh=cTWQPT8k/AJv5P4pcp1e3Cay9M2Ilo5xT0adeSNnPLQ=;
        b=RiGDFPf/kGQue5rVY1cyEZ/KxW/jRbegmlEgyIuB15SRU3p95NRb1jnFBbW7CUmSQj
         hyzjBtIU/DCKLdg7rLN0uNCSbkRRLmRzPp8qIcJNQaLdJ4Q9n+KoX1LY7FYaJmWNeVvm
         nofgUvfSkB3eRvJF9LvHhHetiE2t1WJ6NcRTY2XLtBo4emiPFG4eJnGcZqNlrKNmCNjR
         Ytno1IDh81VqgMkkq4VhDwAFGll26bVYWrJ605/x5xnhq05RH8J3RjgILIN3YQtpTIzT
         PBBGUx2B1gSUIdcnZFT1uC18O0M002OcsiarIMv6O4QEEkGG1FLNiRzGe2hEfSanOLgw
         GvIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790673375; x=1791278175;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RutqN0XzeZ2DQTMI7Gduqm3yztWbS2+NpNwUibf3R/c=;
        b=I72t0tUhpGpboMhrIAeIkKthmdUdkJCRxFWQKt7uAftZhxX4iURD8XTeofgFR/IJSK
         3KP70ajN6lLFyltfSQrjSWo0pLUwPqwxig6QWsyri+hxdwU266+Dn5YuLM+90fQ9KlT4
         63rb9Z2J6zvxNyx81ZEEgpcE+xETdec6r+9cOak+UbPVKTy/DEG06KC1HstGQUiHPev3
         tpxu3RsPKPqTMUZksPq3WNc0aAd5oGGCg2zMbo+j+DAr26qlyf6Q8O1zljVYdVFi3Yww
         6/mTe2aRfVjkJmVAXV8JuzGi4UH12VMfutPgQ7wql8Ii6buNtgj47jd8/KRuKRU7uUUX
         fM9g==
X-Forwarded-Encrypted: i=1; AKwUvBxxbRTmYobvFAizj38P769Ked70TIeEji1aC78g+1PnS3niZ5dVs4YdYbAS8wWFnuj5WcZB04VV@vger.kernel.org
X-Gm-Message-State: AFuF++kRl+rlzUfksMW4WVZBluaIqEPkUUnCKVWDFInz+PUwdDJrk7nd
	IlDFWEU332vOJwIyYfKOjCboAMKpp0vdpMBRUzcY1Ls3RTbFrHwQ6ooNDn7YgXMudbFpwbyNKLa
	DdBmdaly0rGM36+0Yb7vpixVr20hVSut3EMYVoDHEzNT5ujCYtVZq8Dj37fLC8KLZjDYVdKoI0g
	VIqsGL9sGmA8ssRduinGVJK/yk81sbIzzl
X-Gm-Gg: AYBFou2eXXK0bwdiAhZUxysc6Bdr62smKM43BxNZzpdat/juahWbtKrc3Qrpt1S2FJm
	usOz6cTMSWkwePGBb7qie6C0EoD6BJguOC9KJqNO7Ow8IbT/VBuVQX2QSkrv2KyFGrfhDfq+hNM
	35vnjv6DtMj3q0y6yEIZLbzIr/sMyr91ioSOjvWRUru64g02QcBvGkpxCkvKI/eL6CaWXd06H2C
	uxpQ/L21kNPWBgXfQ==
X-Received: by 2002:a17:907:6ea3:b0:c26:1649:47af with SMTP id a640c23a62f3a-c2ac53cb0afmr1291010966b.37.1790673375128;
        Tue, 29 Sep 2026 02:16:15 -0700 (PDT)
X-Received: by 2002:a17:907:6ea3:b0:c26:1649:47af with SMTP id
 a640c23a62f3a-c2ac53cb0afmr1291009966b.37.1790673374768; Tue, 29 Sep 2026
 02:16:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260928081900.4187482-1-alex@ghiti.fr> <20260928081900.4187482-2-alex@ghiti.fr>
 <aro28ZGuYgmNg_n5@infradead.org>
In-Reply-To: <aro28ZGuYgmNg_n5@infradead.org>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 29 Sep 2026 11:16:03 +0200
X-Gm-Features: AclHuK-D9BofbMEsWSFPaoMRP_iu1F-Wj4thWHCh7PID9jFqkf7sbSb8Hc_0i2s
Message-ID: <CAEmasaX-6v_EpwAxHtnhA5SXk=jGW8+Lm4m8zAC=+f0yXmiCxw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] block: do not issue background swap bios as root
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        david@kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: afv3Dx9nPe0kurVhMX8Wfp99YrRILCq3
X-Authority-Analysis: v=2.4 cv=Oc0NnRTY c=1 sm=1 tr=0 ts=6abb81e0 cx=c_pps
 a=Ak8bExYEjeps3Jj0Zi+cTQ==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_78whYxrdx1mplLwxq1U:22
 a=JfrnYn6hAAAA:8 a=gdocsb_8Clbhv9H3gegA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDAzNiBTYWx0ZWRfX6vW6i253/QST
 mxaB9I4czHeNjatD4lrQ2MiX+DGFoNhjhaAkMhI228tzYJH6HJdNrwd2W/da1aZRULwVPQ5Uf/t
 s9jqTA9QR4h5+DNbMgYOXC10jwdVntTiBLh9FMC8Gldcrf1T9XPkugkTUlnFQHUbJgtCCgsIa4F
 JWi9JokdCHmh+ihq5QDDPOkPgs/tXHfZ7yO1SMnMaMZ4AF9fImEk6bTrZ1GHlaY7iUxip3lPMYV
 A0weC1HL6zEuP6YdmJBGqNIVoqdbifsJvFVPA4tKp0h1TaCaBjGZYQBuCjvOBZc/RmwJImxaeI0
 fUFQwwyRmTH3DmqR2XM0+NLSfPHlHV1HnRRi33PuWYMElQZV1cJCKJmFGA3eXJumGVnKusnorQU
 1cIB74aZ718hm4wVTWXywgcCkeWOigu5Xb3J733sF/m/6Tcw3EC/lF4prHuqP/Mp3V0OCKDxXWQ
 e591MhJpzAnvTXXuwAg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDAzNiBTYWx0ZWRfX7zRzpe5jiLFM
 6SYrBu4vi71Nqnp75znvSkftTIT74rtMGxbT6j2AIrHcEeJ7k2KDFi2s+5RhwMk5HECMsQY7WPX
 W5bBRGOr94lsFL0OAUzBS8jPRaj/Yz0=
X-Proofpoint-ORIG-GUID: afv3Dx9nPe0kurVhMX8Wfp99YrRILCq3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_03,2026-09-21_02,2025-10-01_01

Hi Christoph,

On Mon, Sep 28, 2026 at 11:44=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> >
> On Mon, Sep 28, 2026 at 10:18:36AM +0200, Alexandre Ghiti wrote:
> > bio_issue_as_root_blkg() issues every REQ_SWAP bio as root, bypassing
> > the cgroup IO controllers, because reclaim cannot stall indefinitely on
> > swap writes. Some swap writes are not urgent though: zswap writeback is
> > best effort.
> >
> > Such a bio cannot simply drop REQ_SWAP: dm-crypt and dm-thin rely on it
> > for limit_swap_bios, which caps in-flight swap bios to avoid a memory
> > deadlock, see commit a666e5c05e7c ("dm: fix deadlock when swapping to
> > encrypted device").
>
> Is that true?  REQ_BACKGROUND very much implies the I/O can the throttled
> and thus better not be foreground paging, and thus the caller should be
> able to tolerate a failure.
>

Yes, I agree, zswap writebacks are only best effort and in case of
failure, the compressed entry still lives. I don't see how
REQ_BACKGROUND could be an issue there?
