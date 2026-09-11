Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A1D599A2F
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 21:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789161130; cv=pass; b=JQn+i6tHJguCORs+lJ6rqj/3uPYzWWC3WkgzOrDIlSwGOsl33Y8hV6n17X3VDIWr55JrdKwp8PwdHXeHG+TmbrH3y1eX710/8ZXVHoI7IY7HxeharLMOswdmh5JCkhFgWWi/ZugPM9708q+UaMFLMgf2baON/hzNWb5WEUCt24M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789161130; c=relaxed/simple;
	bh=euBz/ciJkJSclpUCQrD/ca+QSNLN9fjMpZ7nLoA7Ujo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AQZk/OAtfz3ALspfSS9+xmuPLbf5CO7gvo9JnU8qgzu7s8jIh8ci29iqisvpUC7polHZdChJqi6h63a810b0e7IzY3XA9iAkFU9Ta0/i5E6yCv/3uOMVk+pok1j9hD6/uoGEZa6f2ynA3yL1erlgwQ8oiZLen5qv1DJrD3gyHG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tab4gvan; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tab4gvan"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b1fso53397766b.2
        for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 14:12:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789161127; cv=none;
        d=google.com; s=arc-20260327;
        b=E7YVNYJc8mbUePus8f0FeKuXOeorS7DIRvnjUk8AFLug7q7KJi4nKh8wZo6F8EFw5H
         3ws7BK2T3jv0e9WEUwHCLR6FXy7Xk430jr+Yz1w8v5tvBVY+NF3+wFtnGV/IDdO614fV
         3eQxc7GgpwKtv8hX2UO3ZzQGQHbxUeNWsaQxM1Uw6/hP8rIEJaWkQizd4EZcPGwZfVvU
         nbOX60R1ln06gdUhdQOAknwnJiZ9fvRVZvGbKqSZDG1ZZTfo3h5VIQIm7s+MwAZET+aa
         5qEPbu1CTTVzJ3agZ8NT83nQUtdTqG20MvHP/4usEzvoqkgSwm5eJBU/xQvh+U6MtY+M
         Mjog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=euBz/ciJkJSclpUCQrD/ca+QSNLN9fjMpZ7nLoA7Ujo=;
        fh=9gEs10ztJp7Hb1ABYLHXQeaf8kiwsxffaFchV8GP5ls=;
        b=IVtk9WqWZcvfAUT/5doVjS12RSSC/uduQj3BGqIhjgKduBShAq0bVKnIAK80hIlGXW
         E6jpwZM7Rm71C6vnasSlT6SEOMn8DczIL8OWikb7IlovGKOGabLZ0lEeyxfVcq1ok8Aa
         fgugwJWgdHNjhYmC/Pbu02r4pGswWAZa7W6RQoIL8SJ2gx6NbDp1FEj3+AegO+H0Lmt5
         OIoADwNDur+3m1seVe9SW8PZpJGuN+cJDWTdrzJ4T7fUzf8Y0hVYenXhPnwDhRcgEQFd
         QfaK3E1fDpznRzH9vsOuSjYcuZPZWw+zePip1OB72ka3tQgIEOSxTMsCARbXAUcT6dSv
         iHPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789161127; x=1789765927; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=euBz/ciJkJSclpUCQrD/ca+QSNLN9fjMpZ7nLoA7Ujo=;
        b=tab4gvan26Lk8iSkXFMZKYdWvxPwyLkHVcOPb864H7VAY3JJKwGbGxUhXS5wgYjgdn
         Se+CBLEXQ3R7ILWbGpuYvaca4inykx6aU+PE2U72zGgpF0ruFmNy90/0Sof7SiF3Y4E2
         oZP6bp1cwU0uwdiPMZHZZ+9XTyRKeSWZF9VptYUT0GLSzxPn3P28H2q5sjoHoOHSNlXa
         eAFfMe6zs7z5kynF1KQ4iDf6YzrJn36+W+8QdlaXmYu2bd6iEnSq26pL0wLOHR+xU/AQ
         YMgt5pHZ5odDyjhHBjKvrLQJPPIeLLumFl5XXeXziiu2lfRE5llT7VzGwhb5DCBIL3OY
         Z44A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789161127; x=1789765927;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=euBz/ciJkJSclpUCQrD/ca+QSNLN9fjMpZ7nLoA7Ujo=;
        b=OIx39WvjjRbCARC2Cbmc7f4QqnAV+dmowTbyny5tbaXFL7dPWRwJUPhzmtdu85WjXZ
         FAhOkvtoCUHQ5ZkdSczrsdG0dJljCz2lxftZfb4XbIXCTGeiWCxWMGX217oNX9jsTEUM
         cySwBYPlD3Rp+eQgTOJmfy9S6e84JY7541Sg7E4OY7zBQETBJtTCF5RYvZeQ1/ak12I4
         qLPdvISjYjW5b1rhj5qwkEwTl8N1PZ/DlaSKz0Hz//Q6pE+8TG3kJWiNsJ8VpgIa148H
         xL+uNGR7Hu/JV+UebW5+0dEsC1JxzZI6JEy8zw2HSHR8DzDKzwfWer2HiXq9lWU/xiM+
         X0+Q==
X-Forwarded-Encrypted: i=1; AKwUvBzANbdrg3SbjPXmLeRg3AoT8V3UE3K+mT4fztYV/rdok8kBPTQmLRw2HiIrhwPdQXmqcio/cg8A@vger.kernel.org
X-Gm-Message-State: AFuF++mE5PJlmxknpPKa7+0QHvfZC70e/0OiPNl75IvRjXwU+YQex/FV
	i674Z2Oj6IBOc3BXHHhz2yFJlRpqN1dxhXaSEod/3LrGUuOFsS93q46U8obpUwnHIcxT0+nBfMb
	KvMFMn3DONsxwXPZrR7Mo4AGdKSFYQ5P/9QolJObk
X-Gm-Gg: AYBFou3Pp8O9ifPrWO/wzhHzXWXYbvhIrTA9y9iaBHnBbfBGWTzmHkasGMz6vATNgZ3
	6cM+5QJEnCMHHbv+rVKmPmleo9vOdjUgmBCYMw5nryBTYoBKJ95qvwWxkCJbOYB63Pso1nqzAfT
	usKI1BqX/MB8vf8pBuPXDF3sAqysJyPPyFhbbswfN5QdrhLhq5/Sjyt8zmEzYtmTI6AFZj8xhll
	W8W80IsOS+eMjUl5eZbn6NnHh7Iw5z/6WIRC099EXPoNVQ2gHEQ9hA3egAmXYXwwJCleDFaUrWY
	ml+oxMj5vvE8i0Oi0xYlWFvjQhywxFcLV9xhY8EJBJ7ep/Pelpc4Cn1XO+Li4R8J1vRLZ9hnSt7
	YumdiYa8n0wHCZyk2y2M7
X-Received: by 2002:a17:907:9619:b0:c25:8e53:45ca with SMTP id
 a640c23a62f3a-c29667578e3mr499344966b.21.1789161126322; Fri, 11 Sep 2026
 14:12:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821050507.2161607-1-shakeel.butt@linux.dev>
 <20260821050507.2161607-5-shakeel.butt@linux.dev> <CAB=BE-QMyzKT-o=gbhdp3g8JSqQgRiTFzxTX9vEBmCttABrmdw@mail.gmail.com>
 <aqRWuffGKczUhegT@linux.dev>
In-Reply-To: <aqRWuffGKczUhegT@linux.dev>
From: Sandeep Dhavale <dhavale@google.com>
Date: Fri, 11 Sep 2026 14:11:53 -0700
X-Gm-Features: AcwNN1Wh4xneWSvMXksn88XWYdkFKLDPGlOSXkSUkMRqjCCaU4JFTl4RQoJGSwA
Message-ID: <CAB=BE-SjW76gWr0kZcPnEjXOwt90vCV0TJeFuYEGV1Kt4Y1HWw@mail.gmail.com>
Subject: Re: [PATCH 4/4] kernfs: Remove kernfs_rwsem from dentry revalidation
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, 
	Christian Brauner <christian@brauner.io>, Meta kernel team <kernel-team@meta.com>, driver-core@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Hi Sandeep, thanks for the report. Do you have a reproducer? If yes, can you
> reproduce with this series?
>
Hi Shakeel,
No luck with the reproducer yet, and reports have been sporadic.

> I think first we need a real reproducer before considering anything. I would not
> add a check unless we have proof that it is really needed.

Ok, I understand. Do you have any opinion on the suspected call chain
which makes dentry->d_inode = NULL; ?
Partner report said it happens under memory pressure, and userspace
component was reading the CMA stats through
sysfs [1]. So I naturally looked at the shrinker and suspected that
call chain, which made sense for my 6.12 kernel call stack.

Thanks,
Sandeep.
[1] https://cs.android.com/android/platform/superproject/+/android-latest-release:system/memory/libmeminfo/sysmeminfo.cpp;l=545?q=sysme&ss=android%2Fplatform%2Fsuperproject
