Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C9434D3B0
	for <cgroups@vger.kernel.org>; Sun, 13 Sep 2026 15:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789314427; cv=pass; b=sAFGbsdz1+wYM9s1sftkSKpnjAmjYtKRBFAxxoYGUeMmb0byHy/QK/OBx9xreVQviJe/6KKQZiD0ZVRwFaW2H28FCMOzvJiqllNUR/xsQz2Oxs4+L7Z5S0PVAKPXVCtH7zkbBpj62RpujhDtwS97ylR/abiQ7HXm/VR3gMKFjYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789314427; c=relaxed/simple;
	bh=KFkEvrKDNmPhRyOa4UUB93A5JAqNiBMds7vZAclPLSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pKxqZxAJZnH8oOSp1g2+8VIc0Qi6+PlpRRKlJzC787VJj0ubgjvKyTh+Asa/35SYSH3pYCyU72X33f1XRdRBw23xy51Q9DexKPH8BUr+zTPJ05McWAJ0qvVqJEEuiu8ZIfywG2+REoOaTljmUsovNd5rnSJxc/Y8cdROmYkESDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B4C+vwZ6; arc=pass smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B4C+vwZ6"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f13d76so1337921e87.3
        for <cgroups@vger.kernel.org>; Sun, 13 Sep 2026 08:47:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789314423; cv=none;
        d=google.com; s=arc-20260327;
        b=BBJ0zAg+f5T6j8DMTkHgKwETTnJ8ZH8xbw92X+c6H6Rqpa9ApJtOs1/PUdJ51F47RJ
         coIow12c2tweDaIFUjVBX3wBVZLr5ptJR646XrGgt5m6QZEiUqv/9h6ZsM8UaBEEtoHe
         MwJZv7zBA/AFXizQtE7ygU/azmp8wvcKDquFNp4faaztFmUrA6i19j3s1CVmyqM/ayP+
         3rFtbs/dPmp0EU6EiBT9LSoDh+Rx3H2YBwWqCYZ4k2HShj2gxCw5CH7v6kX0KpXP5cpS
         RXWuMDWnte4P1019XPzdAngrVXyeeVWyQjsKSd59JE1jnEtydADAz9ZjyD+vEJ/xToGR
         uRJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KFkEvrKDNmPhRyOa4UUB93A5JAqNiBMds7vZAclPLSg=;
        fh=CK7ERtJzmPeEdBfpnziVQNcEuJNP3/nXHyg3U65CRa4=;
        b=CSIEVTg9/aqg/mbsjnH7vxFYWf0DeBkJSXQYqhThFyHrTgCtL4ylUULql03frJ7+d6
         eYsQd4sv7O2xUNGppNi5pa+RvbhLAid/6pLEVk4+26mHN+eCQfuJGfuSOZ5oEasPKRAC
         VwtKrdhP7AoZQz77/AOxYWLbO4kxv3oqEfhzgA+WnHM+4a+NFjWkwBmifV3hJGETnNjm
         n2kkbXtJhXJn/sop6MSdjQtjIvFClRxxIrmYNr59jR/pAYawaQTUmKGLQ9cjJ8O7YxfH
         Qdc0rpGyCBh2gRqN9eDhVaRWsgkJk7ha9cUajWDhmrA5bfQDNBqDOcYU7SYebxrWZ3TZ
         qCMA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789314423; x=1789919223; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KFkEvrKDNmPhRyOa4UUB93A5JAqNiBMds7vZAclPLSg=;
        b=B4C+vwZ6TOxVZ7ImvZoKk5Hd10wiJz36mN6RVG3XgnpDSLdPs/zcyQLzzWbiZI6TQl
         yaFVl6djzq5UKT5MpXKBWM1xayrmauqFr0T4ZF4TmzjiXkkNtaWUoW4ERevaUrenW/VZ
         ue1ZE57SM5/+SAmsaxUMtpSd5XR322tLxrjiBDAWs/b3+ieq18QpzkRVvxT+QprI3LKf
         LrBerA2o/yfklNeFmLc5C71B9Np8gEvdCCvzbis7F8xU/KQwtzchU7BSA9sgzSPRHWzz
         2aKNtA0ufxfgz6Rt/gajkkCaNpMyVxasPPkcPmDtAV56Xq30iqcrsSzAsF7mA5itvH/9
         0Z4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789314423; x=1789919223;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KFkEvrKDNmPhRyOa4UUB93A5JAqNiBMds7vZAclPLSg=;
        b=s8B37Xf58BOdbwNqqLPb+l8SB6aLG6umFCDFu1y10qSqEceFniK11LqAFg/j43U45D
         NwLKL/Ta+X2TE2N4YyYYK0UBV3yloaZ7Gh8N5hBS65QeyKXIFLtohjl596miCeGg2c2r
         3p74VistG60SKozkWGRWKBKL40vMHOInqAITpQifagiMjCE+ECAkP4d5FqKib3aoGAiz
         8GZ52vjy346kRMkuTRdRQEDDhXcgPrSu4h+pFk//ZtTNyS4q59n0duMMe4rKA7rNZsmd
         VWUWo5aAiv3LKsuKGvRm9DHTGgqJqE3pgMsqtQuFTrbplNOzEfNrbkUeJ0X5jESPACYv
         6Byg==
X-Forwarded-Encrypted: i=1; AKwUvBzM85RbYDvGFPXWG8YuPCvxdMiFmIvNsx9aPKrZLGY9zxM9OErs0KyTiziQ+gytoCtVj71TXrRb@vger.kernel.org
X-Gm-Message-State: AFuF++ngyayCTNK7s05a/NQvyyeMEZoMQvdBixNpF/L5Qqd9JFaLyle3
	U022+HmYQ5f2fN/4pt2WdcXkYQsqubAqHNN4rghptwtH/wjcpDi+57zjWhm85fxO3EkifOFEnm8
	bOrd/RD58tdTRVmhz/urmSt6QdAhg5Z4=
X-Gm-Gg: AYBFou2/pplUFtPea93r+VyESSXQI9MaxvFIPwTyJoKQGV5EmbhY2o2xZbPMu0Tu58H
	g/DoBmis7EWaQv48Q+bPaJdFm4cksoyyz+DTZyei2gLNVfSvhCWqjSQVuzROdWiXFW4Lk3opm41
	pxFpcYS9zpBDoDvTMXxhex4e6GCEMcnmons5Hfy9vKtyf3jE8mVMPZH7UIhXo06FplcQtDgORLf
	CXYIBPkbm5lbZqNzoimdmIZ2ScPIEZYxymRvlUqszBfWYtwu4E/2Y/xpjZ4KVAtktWAeXnknmDy
	DGPAJPzHFG6oeLwYQ2AASubJtB1q2EjyMiIFKvtMDE3aWJRNG87BGsR/8lERZ8MqE6yzSC9BT5x
	Dp2mF99XVVHnrqg==
X-Received: by 2002:a05:651c:154b:b0:3a3:7681:6d6b with SMTP id
 38308e7fff4ca-3a5b38161b0mr10553231fa.20.1789314422665; Sun, 13 Sep 2026
 08:47:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANGjgdn=H50AaA-+O_GA-hkE9UwLANmkjx1zRsKUzxF5za8VfQ@mail.gmail.com>
 <aqa7KgIJYGgf7INk@slm.duckdns.org>
In-Reply-To: <aqa7KgIJYGgf7INk@slm.duckdns.org>
From: Chengfeng Lin <lin2530632123@gmail.com>
Date: Sun, 13 Sep 2026 23:46:50 +0800
X-Gm-Features: AcwNN1U3jyA-1tSNpP-D9guvtV6T3al2eJNkQEtzf0t-dPsWgp_KnaGhqsq7NoI
Message-ID: <CANGjgd=f9n7zEZS=xi71y_dY6Uk75_qgP9qVDkYBusNz9sp2sg@mail.gmail.com>
Subject: Re: [REGRESSION] kernfs: empty cgroup rmdir latency after
 delete-notification changes
To: Tejun Heo <tj@kernel.org>
Cc: "T.J. Mercier" <tjmercier@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Jan Kara <jack@suse.cz>, driver-core@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Thanks. I found this during research into kernel performance regressions,
using a microbenchmark of cgroup creation and removal. This was not
prompted by a production issue.

I reported it to document the added removal cost and ask whether some
of it could be reduced while preserving the fixes. I agree that the
roughly 3 us increase per removal does not, by itself, demonstrate a
significant impact on real workloads.

Thanks,
Chengfeng

Tejun Heo <tj@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=8813=E6=97=A5=E5=91=
=A8=E6=97=A5 23:03=E5=86=99=E9=81=93=EF=BC=9A
>
> Hello,
>
> On Sun, Sep 13, 2026 at 10:43:04PM +0800, Chengfeng Lin wrote:
> > I found an increase in empty cgroup removal latency across 507d8ce13f5b
> > ("kernfs: Don't set_nlink for directories being removed") and eea5d2bb3=
4ba
> > ("kernfs: Send IN_DELETE_SELF and IN_IGNORED"). With sched_ext disabled=
,
> > rmdir() went from about 6.5 us to 9.6 us, an increase of 46-47%.
> > The result held in two independent runs.
>
> I don't want to make cgroup removal unnecessarily expensive but at the sa=
me
> time it's not an operation that I consider to be a hot path, so as long a=
s
> the operaiton can finish in a reasonable amount of time and single digit =
us
> definitely is, performance of rmdir usually isn't something which is high=
 in
> priority. Can you please detail why this matters for you?
>
> Thanks.
>
> --
> tejun
