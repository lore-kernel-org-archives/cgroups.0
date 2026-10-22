Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792652143;
	b=d1tdrkIZU3EJIyXbTu0//np4ieba6IV3YbsXcOFF+V5q6VlpaHmXKZxOEiTyjQOtGCA+
	 JvVm6KoF+ymHMIyP2jm2J7kBq/N/Ga7j0VmQV3ZIHoKDfoPxHzyIGoK63vaOrWbP230Qr
	 MruOUZWeMAWtPBUIfwyHDm/+eEZnw8naA2oRTR7FPHdMZ6Il17tZOhUK11inRgXsBqO9w
	 vdDTgz4R0CuoqNRwIA4NoJC9TM8/XxZVizhTJX5AUYQVGSYtaf8GpbwXx2hbddAGpjBk4
	 tNbqDtA/J3OV4nN/JPep/MGf2S15MFJNxEKu9tbThUZFqyL49oL5B5aK5hByKIE40BQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792652143;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=+qOAfSouOX0t5YZwWU2eSWaqspMZR2wrvfeU+oUpg14=;
	b=ZvrwTjmYrWGr2z8NdiSWr4nyf+hMbHTF6oqC2SLpF3+gqJ62O9MQx0hLqd9mGgI3Ii+7
	 ZK3F4Fy6whrwiyiuo+4iuXuZrVazLhDgMO17UHIaRUoUDEssk0KFPPIjA2J8p/Kwerp0p
	 q2SHmNasoBrAyqStyMEzLWpnNMz1P7+OsMRqq+HVzhyDmC/qO4+vGTgs8sV7QZ1zLnuEE
	 xXBmxC2G7nIHTHCjK/BJIGvMPkenNkwlo+HaeCd26EWlDKtmTqRueJxHZvyxBVgu/T+DA
	 PWaynaR+X6MTgMfkwXTezzsoW1mcKSHiCsCZ6S/Ia/rAom1SoHDs4D8sP2xWTAMX3WQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WXOt2KSl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.53
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A520606A31D
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 06:55:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A520606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WXOt2KSl
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-83bbcfba0ffso935259a34.0
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 23:55:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792652142; cv=none;
        d=google.com; s=arc-20260327;
        b=jK3mqf2YqKyA6gLRB4BGIgAZyIfgRlMKYLT+x0eX9/0qiGb3FtHbHsvm0zTm9Mim6C
         P25Fg5cak11mfEzmYkPDPF+CU9uh1YUMeATQQPKVu2xVodM2XqZki+P+ryuahdex+lI6
         YzdnWBTuQ5AH51kviLsrJApqI594zUoC9sKrUdhCVR03565ciG/h+RnsLi+GDFwCZA7/
         J+kAED8EnCFUEPXxXvFH6sqRUqlOrVHSWQHiZxcu1iYul6evdOx5bfEYjkUwnNnGpr4p
         iZoXi2yqS3XfdtFG5qWYLmUY1IaOe/HmrMpxtleAvO/y5avxOG5WeiJoxmPmqUPOGLIX
         sOsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+qOAfSouOX0t5YZwWU2eSWaqspMZR2wrvfeU+oUpg14=;
        fh=zlFxPYP+4XWhnGbzpoH5vbB/dmeJhBjskBMb4QoLtxs=;
        b=UeBwAyXyvwXDRt5PsDL3Owk/ZOPZ2zrwIcyl2ek3TZyXtPAqEOZyhSLH4IF9VIjFOP
         fxQ9rS9ScI5J6RnUHvbXIjL1EdHoGFoXTNt7qdVw2dusM0aQnVia0kOxfXFGWNHeC+Qe
         09nFG6h43VvcceKqAQdBB8clCFyGFB3tGbW4rhE0ui+MeM9YK/TZ3yRYxuDzpJX40iUe
         +Lg/1DFo/dHUXqX8WP03ipt2/vzuhZLKjsESoB2yBJktuGvwKN9tDTuuSAtEWuArfpK2
         5bYdkwtFGn95NlegXCBsx7hffiHDZp5Eg5dpytihZoGLOqvwhJ9jyUNxVafp8iJHTi+k
         69VQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792652142; x=1793256942; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+qOAfSouOX0t5YZwWU2eSWaqspMZR2wrvfeU+oUpg14=;
        b=WXOt2KSlIEx9UYc1uslEROz+hHZnlOEeHWnCzrBw59/M9zikfXJincp7fSqdCiP64e
         0AsgHWZUi+u8AFnL5GBv8ugm4B05v9sv/0eUxU5lurXBt7wyhniyT8Y4jBIUJgS097n1
         JtOhJGYOorBMxsZlR7qiMSQTmSeHrSkL5780k2OHgpEPX4RsPvEP/EpYvQ7AWdoifbLa
         iG3RhqzRcwqiwTVbSsfkZz8ApDLU/nJI3hT25h+ElUTcuKqnkp+JcSTri//SQuTh4Cs7
         tfYoY6Ngy7LQe9nn07r8QugwjLGz4evJxsgAxqr+BAW3DAqhP6bzuVk0ZpOR+vjxjlnB
         EjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792652142; x=1793256942;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+qOAfSouOX0t5YZwWU2eSWaqspMZR2wrvfeU+oUpg14=;
        b=kW4lZ2K1wWA0DsB3crvVnf5JEDZBVZFySGmQ4BNrKlAZOdvr6h3OHEXhB3XCVpiNoL
         +P+oBtRzJyZt0qG1u92MJ1uYm7R3FB3vCgKVPDY6m3CuBLX2u892yFqS0GBWW8ZFkwhV
         WG8vcG6BK1uRBw3+Ny4xjkIv1WiCv8F+NT8z4uBDEnUdKasz6KKoOh1ogJTR7j5V0Si4
         nTy4Idy9RUY8Q2uky4wd/6w74peTc+GYzj67W4hNNsWpPSNmRt/Yx6evwkkeot0qJS1f
         2mY40bKVf4VT0JGm+fQQbAxMbVykDNIIUKZq9Ec0s+UnZBNDcScxCbLjZ3R1AKJDHpQp
         G1gA==
X-Forwarded-Encrypted: i=1; AKwUvByeUswAgeQA2RkYHBzvGisV+1vf/z5+uEEfeJXJrN2wlv02IW9tp/3Yi8fwhNOgLdXZGwOWL8NE@vger.kernel.org
X-Gm-Message-State: AFq9FYImbw2xEu1b/DWLjGomkEFOGYh+2jUPiA2crxIoSvBspb6SA23q
	a0cMuCTR6crDZtI628SXLTNfnp/vkFTM1BEn5rGQO4PMjKwqdMFoXGQp5ux4hT8D1f99+/C/LAC
	18jvadaqLdsDPwvoZcp6xf3r59+40zlo=
X-Gm-Gg: AYBFou3oDuk49ny57Vm9SZAFcH4wfPVSAqOYX9j6cl4qOAV7Eiz4vExvcX4Ehsg6ehK
	kNSvzfLFB48ocMnHb0mO6YiI5XR9tpTlB1PllRrf/NT+QwMKfPONPkLOXrbeGQj9Zvh+sUepqrz
	bc45UNOysXYBP2SQCOsluTL90yV3hlGmzMm3tJfSEEv3GKyTvLZuKF4z/47+1n1j306P4ioExoJ
	FfFQ6sOiAzlt+egjW8TiHFEkCB5UOW8dSN6MBpcbECqMhTvoTNFlQmonIlb4khirkXHRfZnWAUW
	EwE7cOcWEs6qK4+hCT2Ds9HZv34kKVqv2OdYFHCgGtSgaMZZx2cJzvoSuMeDTxLThRVTkCB8FjX
	tx3TbC92CjQcqpEeo7Mv9da2/zXVuEwqiQZvpOUaTMD/CyJVZhN3J677rMUqjUi2cxgfEsR1B61
	JP1qnqJm74+FyFCw==
X-Received: by 2002:a05:6808:d4c:b0:4f5:e13:95e2 with SMTP id
 5614622812f47-5534f511f07mr3092508b6e.9.1792652142362; Wed, 21 Oct 2026
 23:55:42 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261002152821.410591-1-yupeng0921@gmail.com> <CAG3TDc1Ydhjx1GD7-ZCqmzYbZv5+DM0O7wPnzKLWJ1ycK9C2sQ@mail.gmail.com>
 <66f87058e7e811af340d920e654117eb@kernel.org>
In-Reply-To: <66f87058e7e811af340d920e654117eb@kernel.org>
From: peng yu <yupeng0921@gmail.com>
Date: Wed, 21 Oct 2026 23:55:30 -0700
X-Gm-Features: AclHuK8Sypv-7xRYs_lPJ7h3Nm6lMdPqTsjMnjk1hM_VRIlE-PXSuRDM8lifbow
Message-ID: <CAG3TDc1BgQNuCD75NTCcpmP_d4aLummSP6AN6JuxoAgeEBfmFw@mail.gmail.com>
Subject: Re: [PATCH v8] nvmet: add cgroup_id to charge namespace I/O to a cgroup
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Keith Busch <kbusch@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, 
	Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 2:57=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> Hello, Peng.
>
> On Tue, Oct 20, 2026 at 06:01:12PM -0700, peng yu wrote:
> > Hi Tejun, does this patch look good from the cgroup perspective?
>
> From the cgroup core side, this looks okay to me. However, the current
> implementation will block the shared submitter when throttled, and it
> would probably need more work to behave well.

Currently the io.max won't block the shared submitters but io.cost and
io.latency will. If a nvmet subsystem has two namespaces, one namespace is
blocked by the io.cost or io.latency, the IOs of another namesapce will be
blocked too. I plan to create a v9 patch, if a namespace has a cgroup, it
will submit the IOs via the nvmet_wq, then this namespaces won't impact eac=
h
other. If it is not the correct way, please let me know.


> Thanks.
>
> --
> tejun
