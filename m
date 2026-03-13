Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EAD34D4CB
	for <cgroups@vger.kernel.org>; Fri, 13 Mar 2026 16:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773418407; cv=pass; b=kOuvAGJPmP+HEqLtbpMOPWejsIeWJC46kEn8qwtE2JAtQ1n+Suh5eSxwiB3e+atIBZDIo0kLX8ZGbeeRSDK7771qP78DEZJu3Qb/RK8pW8U5LMG8zXdIaBTkOD9mnrnETSG5TydV1AZn542n3pTVPcvCCLsN7CV+TsabLJkNR20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773418407; c=relaxed/simple;
	bh=id4GH/npJy6jS2u7G+5krgbEzwWItVyVTXnX92MsqJw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gBhIKEZpefz+6LJrPrwudL4TwlK4W9ivPdKqlJfM4L2LXjhhzaerBBzZpIlzQSs/X1THAdzWtBp7r1H7Oj9dKt2oIcyNP9xDL3Qze/xbeZoyIFKfLezdlD7nj7Bnbm9Fyx/dVIYVbVHW03tvuCCDnN04PU/ZTh8wRcoM4HTVaP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=T+bFpeO7; arc=pass smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="T+bFpeO7"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a13d1c6f25so2473121e87.3
        for <cgroups@vger.kernel.org>; Fri, 13 Mar 2026 09:13:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773418404; cv=none;
        d=google.com; s=arc-20240605;
        b=fKIWvJyQbX6gNBpE4pR2jh8dqCAdJ4LO7tceJ1wJvDodqU2QRExEGu7bFFmDMFEbgN
         nwZyNm2FL+M8BvU+y+VF2nPnoqsA7swCf0cOE/CbDpGrs99B1o5kMxKaKfKQwxUn11dv
         dtDrKV6WaTmUzDYZedsiBmZvq5PS3iIPHLggcukk7q9JdnYoEMAIz6X+NL6zZ2eBnkOf
         1iYLrfIT7sLxYzRDzW2hFnNv6ndjIz/UbzQyIMxdG87APJm++Iw+ipdGAzgqTWI9gmlr
         mplCKZ56FkEVC6gmtiqJwPMgvP/0zxngSryHPhkgwG11fHa4W8fXIJutjIVnoCktbxd6
         6fdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W7Hc+3jBOAZVSVOSxE6vz5APIZ1uejXRfbKvQ4/dcrI=;
        fh=id+w151wiTNw9R1NaOW8zOSWUKSD6FRPwLjFjAGwius=;
        b=AuyG5ECY+tshYcBRH8sC+46utO3noVEAD3O9wt8IKS+P8vzf8qZHs/lL5Yjg9UorNJ
         hgX3hIwwRnMnzP252wlort292vCCTS5nTOfjqJ6jKgS13pE9pHhUnd5+i7FvoTM5DXMw
         SEimsmL2J6I+OobvJIXxK2RNN16ZUpiXC/32/tschZyShGFsq9JbEuXbMkSfQGaL7hCA
         itlaPvZ1y8QVTI6v3eZoyMK6KUMb/yQmNJABx/DClopmCQC9BPpCkDClIkZRSLP5vAQA
         6aF0NlWzaqffiRuHa4EkXgjhX9tTFA1xnLtJqX/3i/FCmlPvUQHxkRXh6p0EDR8FJaDP
         cx2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773418404; x=1774023204; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7Hc+3jBOAZVSVOSxE6vz5APIZ1uejXRfbKvQ4/dcrI=;
        b=T+bFpeO7eruwEydPueueRDVbkn2uYKTSvBXbT2N/Ne5FnTRxrpEW/7f+Fy9ugqh0iK
         3Ffv285wPqzqln5RxxuPshMcIC5xmTYnzMegm+ra4DESKn1mrVPD7vTk+pDwupb3XnJk
         ex2tncoM7U/9vWoMOZ2n0GytyjR5rnS05Pnv8Gg0FzvZ/2K4heDEIf2nBmpoVX9yqhl5
         oMALU2hMpQPj5TjahXKjKwX09HAjwpiRgEbfl4pRegu/T++1Ws/Y9wVt8ZTuV/qc+NLn
         /Ej6mg6CY3u4Z7iFS9mWcODGsGXTIqI2ZxEzxD7FKxHOdVKqE6QaXNZ9GdvneopyxwMF
         eSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773418404; x=1774023204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W7Hc+3jBOAZVSVOSxE6vz5APIZ1uejXRfbKvQ4/dcrI=;
        b=LHth/Vsz440xlCwTRyOPj+5nRpSwxis3RITDVd16buHunuyN2DSjQrC6FS1WvTM2x2
         2Fakjk+3JGNyt9L+53D7SiKOWbJ8ZFecbeQWjNVLs5pgosDj6yXxx28I8mEsjNywYGoA
         +lKF8Bh7ySnGaeY3y5E2PFWLWXFan7MIJRCPB25J4Ga+nOivdLGG6LIhNtpj/8EJq2Qe
         iHAmaW4h2j+R65acKLR3m0PTdtBoRfSUyNt3bk684rYqPjh8Otjaunw8XVTKOAA2Mi3r
         rnJ+FjkD6h170tdHiqRPFmSguUSHOFyJ99wvSYzfTDkCMWqpYsPDC1GkFc6GOveheDGN
         pNwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXm3DAGCuRlXxZLkutrHReG5TDeUsvyfShHXy6lrAZeJIHdkZvCEj4woaKz71AnZ7LkCVGaJuJz@vger.kernel.org
X-Gm-Message-State: AOJu0YxAZKb/jpXMnRG/Nsm83QLyS6snNKcbCiEFBxegVxGnzXlAuf2y
	D7xJTSryNQdvBJYLZqFpxXI+FaWGu3AX6ELyHZMVAi2ISJlM3vdGXkT27wC/8s6AT4DUqbuiG8A
	uP0xt4MdkymCd08b0jmOYId3HPMXiwe7ZO/BhXaYIAQ==
X-Gm-Gg: ATEYQzyLZ76yDvyuY3sGtzBEsG2wHf48Mb8eeEzRm/HyHNnGkjf3HNJLGybJVGYpF4W
	9IeLR3wzkzzjSPPXZIpIieR1wCNCYzh4iwDzULjRfjyDWBER+m0J47DrsK19xddoWTafo5oZuZP
	BbccohQk95JQP9F4dTT3swehWzLTrsGHYDr3Xsa2NPUWP6ler5zGngDIPq7T4HqVc7sKoZbUiP7
	+DQO2QEg4ox3TblOzG+KrqK5IudspWE6Wt5shYViGabvX4CpWIUBtA3aXVFsc47c/Y8DIJR0zem
	r+x8fc9v5BnwZNG3N3G0tu0oEE4DevvYvAHhqmT1
X-Received: by 2002:a05:6512:155a:20b0:5a1:3ee1:2756 with SMTP id
 2adb3069b0e04-5a1626f2ed1mr954035e87.4.1773418404230; Fri, 13 Mar 2026
 09:13:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260313154520.302888-1-marco.crivellari@suse.com> <62813cce-36b7-4255-b748-dc450d83aa3c@redhat.com>
In-Reply-To: <62813cce-36b7-4255-b748-dc450d83aa3c@redhat.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Fri, 13 Mar 2026 17:13:13 +0100
X-Gm-Features: AaiRm52XG8novgqzi-5ijI1D59whWx29g1fs8hJ7LtWjsI3e7BF5n34TDZpxYy8
Message-ID: <CAAofZF5CrNGbJ+8Ne-m1LCB85WTu7TeQQ+EtNNiG32RpaQXo1A@mail.gmail.com>
Subject: Re: [PATCH] cgroup/cpuset: Replace use of system_unbound_wq with system_dfl_wq
To: Waiman Long <longman@redhat.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2026 at 5:01=E2=80=AFPM Waiman Long <longman@redhat.com> wr=
ote:
> [...]
>
> Thanks for the patch, but there is another patch that makes the
> same change as part of a larger fix to the cpuset code. See commit
> ca174c705db5 ("cgroup/cpuset: Call rebuild_sched_domains() directly in
> hotplug")  in the cgroup tree.

Aha, thank you!


--=20

Marco Crivellari

L3 Support Engineer
