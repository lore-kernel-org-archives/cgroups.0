Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FDD383C85
	for <cgroups@vger.kernel.org>; Sat, 12 Sep 2026 03:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789183705; cv=pass; b=GkGOIHw1L7rKXFFzkiBfnuNquHR7qqGX/i7ahAhOiRUOJjLfChUFHWFcQDhuQ9NCt1x5OpOtVfPj4ZtbP1dAsT578pZ7YwV17FkvBNr+YIbXsCRc8K7k77ZICuP0jxlJyeDit+Y1uONFkecAbApOH4FTE9q7EZQgP43D9qtW8Ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789183705; c=relaxed/simple;
	bh=1AXQcspMBuO/2Epym4NXCC9r0j3nKkronOgim6RObNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jMAcqoihL7XgXVPRPXlsOe0APwtC/UGglyYQlWIfYr+bGceHiWeiq7C0zL0jKZ56MS69WmHEhmZGzC/JKVNnxJRl4lVZTDRQRjEfAmydgFwfkP0mctZ3T5G2ogINozfNymTWxKX13LYL27gXHa0kMdVnQGyJN8XKlKE6Tjk3xVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eXdy+M9g; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eXdy+M9g"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c25420fe973so267032366b.0
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 20:28:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789183703; cv=none;
        d=google.com; s=arc-20260327;
        b=BRQyydGXiHn6yr7wj1pwlxnx0HoM3kZr7roRvuxz6E8cY6EY0QpScPhhumc4O8bj72
         fYbGn5nQsy4w5EgL3xZy7dlPRM+3Pyo5SFI3iUpmCBxsXKkPZLqcADBIjkMCdq0GNSSD
         5jJsHKnkVkGvBgznorgoN14m2EkYYBXnRdQG6VSU2mu82rvYp3MmKFfpf5evGTD6cYm7
         LWMHKE3kBx6MekJA4PoAy70rKkHzfLpNYHlN4CIkJOQrEzDS3lMICEeFsdSI+xl/sF9f
         /lXTxnSa4DlCFhAC14pR+9uwJpkeGiHHVXtjWsL49RuQmLvIFm3hG1x5zIjIH75as1L8
         Mhaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1AXQcspMBuO/2Epym4NXCC9r0j3nKkronOgim6RObNQ=;
        fh=2ugYO/RDZDzlz12epCjj8pygAtV2ovtyTb8J6O1j7D4=;
        b=mEatfb9sC7SCbHsQ8d0t074K60mnZgVXsUT++1RLuKbNowaFQIJ8R+gVhCapjxv6tB
         qZH3x4Vic7jBjxgmabtkO0pU93lMdJjwtN/3gEJTvKcGUuzS/HF0OY6HRYc1yt5WTwiL
         7zRgbQpCGJE3eqElo1TA6h7owNQph6kWVR0hRRbEDJsD/v/Y2lfps69jX9njEnU9r22J
         L4i/2+P1ykj0z0PDF7ydWhjoGikPHws483eXpVaQYBBX5++fVr433/iBY0knebNys6Cp
         OYzPLFXNfutzZAoxSDIk3/xuuIfJiWppbP7LspHpVb9u4ZImp+/GHm8KCergbNewVz1A
         D+/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789183703; x=1789788503; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1AXQcspMBuO/2Epym4NXCC9r0j3nKkronOgim6RObNQ=;
        b=eXdy+M9giY6OWfTXYgGwtLUhrm/Iqo+edSs7jzJpU2mZf4VIHh5lZ06ASicaju1BA1
         exbpigdhK0b0HYWr6XlpLvysCpw2gsawwLiBmqmdA1SGPycscTfFlvgC/94VKAN+bWQW
         VdGO988kzEz0/qKO4w/XpNsSU3QemkWrk3YR2CgB4aln75zoAJOBEp7bcBrTD2JWjg1x
         LNhPajP4OFaxCQv0+mXMFOdYSZVGZ+1Yj1XKhhLTkj+ZNV3hRS/Ozz2+q9B9/wygYJ0h
         YO1+YTALwDgoFK1rcr6cQypoGKd3gp5Wh0iqKWfngSYyB542/T30pQBa3I0eZm4DJ/xq
         vQzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789183703; x=1789788503;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1AXQcspMBuO/2Epym4NXCC9r0j3nKkronOgim6RObNQ=;
        b=elCwZS+LxdRSlBXvOE9bMtsw7H82AUS0nB2xd4Tc9MnfwDMu82ji9He07g+pyNKNIy
         C7ykRkA0++b+UxxYn+7aPnc04LTglvjr59PaB8QVQPP16jm5iKX1zjg5Q8yEOon0OF5Q
         MJx51bvXiULaaLHEnP+OcdDd3J4PKJJrkGCRAC7mNihyGx76ia1vLekJeKCw/tfaGG0I
         FGQUdmQ0nmkDmT4mzyjI7f18VtjgMNIFmEUZN6nD13J4xCYHim+yntPJy1QONteBkIHX
         xt0VYnd/gJXnVy9oOuXdsM4mOWqpgBXSKbs2z/UOE/34uMkn/TnU9vS+NYMUyPN7jEPi
         0xZg==
X-Forwarded-Encrypted: i=1; AKwUvBxoixUdygJMXEMVbJUHcBXtBYb5ILSRMMOIgzYJKrCiRkI9+eB01lz1LMXoX9a8r70m2SjMtf0u@vger.kernel.org
X-Gm-Message-State: AFuF++lZeuvBYiuAD2AwPgPdDAo6ZYe9cZRl/4naHz9ArzQ9xkWjqwhk
	/S1cO02dgb9QEvPjhS+FuPcVxZg2SXwWXeEx//xeZxyawhardW0b7ZAbJ0bD8LOUFgloMp9qcJB
	UNVXC9w+ripxMG5D8yGNK/hBYQahVySOlwW5aJR9Z
X-Gm-Gg: AYBFou1bhVwQ7KF06Hu3V32IVVCRNFF2L4NUWvHgmR48WViFF4Wnj/+cdZ5Ng/IyPlJ
	y98ZClmpKy32+tZ2JWLdXD7xhG/5uHxvU/cr2M7GHvwhAQo5itDvQTAPn4mvEuNS21b+LQ9aMQz
	ltK772t+aGbGWehrmGfv96ZRIyngJxXBZuJX/G5Xy4By67AbTHElSyGg3qbhnR9iADrTmtbDfDL
	g5NLMiuj0GUVQ6BmoVJ8maAE0lQ+9FPSb+1LBIHfOUDXDY+TqbX6ETM4eg3+pUuvdRfnLqmryvd
	zFq7hf2qmDli01BOC8tL9/NbMKWmlP26CeR/PxEGcauiOwRJtp5uWW0=
X-Received: by 2002:a17:907:73cd:b0:c1c:2007:298e with SMTP id
 a640c23a62f3a-c29666bc8e7mr322816766b.24.1789183702219; Fri, 11 Sep 2026
 20:28:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821050507.2161607-1-shakeel.butt@linux.dev>
 <20260821050507.2161607-5-shakeel.butt@linux.dev> <CAB=BE-QMyzKT-o=gbhdp3g8JSqQgRiTFzxTX9vEBmCttABrmdw@mail.gmail.com>
 <aqRWuffGKczUhegT@linux.dev> <CAB=BE-SjW76gWr0kZcPnEjXOwt90vCV0TJeFuYEGV1Kt4Y1HWw@mail.gmail.com>
 <aqTB1AVmFVs08T19@linux.dev>
In-Reply-To: <aqTB1AVmFVs08T19@linux.dev>
From: Sandeep Dhavale <dhavale@google.com>
Date: Fri, 11 Sep 2026 20:28:10 -0700
X-Gm-Features: AcwNN1VO6EcQR5hpLcEQjEGDOjZUhnBSVqjAAjK3VKqqwhWLJwfDUgsFug31q_Q
Message-ID: <CAB=BE-S-fOqvjj5s=M588tdUDDgDMAxOF7SE6Sm-9vara3=snw@mail.gmail.com>
Subject: Re: [PATCH 4/4] kernfs: Remove kernfs_rwsem from dentry revalidation
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, 
	Christian Brauner <christian@brauner.io>, Meta kernel team <kernel-team@meta.com>, driver-core@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Shakeel,
> I don't see how reclaim can set dentry->d_inode = NULL for a dentry with
> elevated dentry->d_lockref.count because kernfs_dop_revalidate gets the dentry
> whose dentry->d_lockref.count is elevated. Reclaim specifically skips such
> dentries.

Thank you for your input! That may explain why I am unable to reproduce led by
memory stress narrative. Let me attempt to reproduce this first and I
will provide an update.

Thanks again,
Sandeep.
