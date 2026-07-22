Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8858E3F3295;
	Wed, 22 Jul 2026 16:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784737801; cv=none; b=kxZEViIY6stCqrP8rEaqt0oAuULCi371QODfjUrCSB7pPiCfODfetonRdQyZbF3zV0E+n5DuIdm/ZLdAvZOLdbvpWVeKXrFSqRN2tBDlI7qHbMDNUMVF1jhqeAacbchmq1MOM77NC0uDFzAP037G2FRHWUECaASLtDcIIR3n3G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784737801; c=relaxed/simple;
	bh=aMM/vNOboogkoZh2yQiIqH/EjZ7Zy72+CldEaNj7DiA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=QERn3Hbw4mDd2otSl2j2PIifgEK8sSORC/0Ga338avnBsOaN+6RXZwGYPsxX8sI+h1GVWvw4rKpmxI1W+WlAFLi737nmTHNRk4pJFq/2rJrE5ig1wArvO7L+G/saqkuZgeQLxqMuklgnUq6HJZcqXpLRmhGaLYMPM+XK1GR0U84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=XgXMC54e; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="XgXMC54e"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net BA6AE408B4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1784737799; bh=ykJFhFb2lMkt34AUT7+/qCXmaKy5AGwqKYWzTJfCU3c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XgXMC54eq2XWYsiz6UFJCjgbWQOglYWWrtapkyqs4rIbuldg7rWllwVUgmC5miXLC
	 iiFxKmg8HWFHC7v7+kksaDcN0WUhs7mGpC2hwjrSkeURuz8dDtRUvQb48nwE2UpJH2
	 1E9kwwLfqjq8vNeWc31evlUR+fuwrrm3BOEYDF7AFIck11r5dA46Ch2qXTCCtIkPLp
	 XDORHwe/WaGDpWCaVJR1d11kjOm7s4pG7Camm6m6l4ux9/QrTtmBFfpgi+glXlKn2t
	 l1QENwajMCZ+eIkyFkRfH5hCNZr0g/+aW/EMdNKgYkg/oHg22lRvCnCHj/gHFHXhrs
	 sRfMw1UE/lgqg==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id BA6AE408B4;
	Wed, 22 Jul 2026 16:29:59 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Yahya Toubali <yahya@yahyatoubali.me>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?=
 <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>, "open list:CONTROL GROUP (CGROUP)"
 <cgroups@vger.kernel.org>, "open list:DOCUMENTATION"
 <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
 "open list:DOCUMENTATION PROCESS" <workflows@vger.kernel.org>, "open
 list:SOUND" <linux-sound@vger.kernel.org>
Cc: Yahya Toubali <yahya@yahyatoubali.me>
Subject: Re: [PATCH v3] Documentation: add SPDX license identifiers to RST
 files
In-Reply-To: <20260718165618.1923627-1-yahya@yahyatoubali.me>
References: <20260718165618.1923627-1-yahya@yahyatoubali.me>
Date: Wed, 22 Jul 2026 10:29:58 -0600
Message-ID: <87y0f3asxl.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Yahya Toubali <yahya@yahyatoubali.me> writes:

> Add SPDX-License-Identifier: GPL-2.0 to RST documentation files
> that were missing it. This aligns with kernel documentation
> conventions.
>
> Signed-off-by: Yahya Toubali <yahya@yahyatoubali.me>
> ---
>  Documentation/admin-guide/cgroup-v2.rst      | 1 +
>  Documentation/core-api/housekeeping.rst      | 2 ++
>  Documentation/core-api/memory-allocation.rst | 1 +
>  Documentation/doc-guide/sphinx.rst           | 1 +
>  Documentation/process/5.Posting.rst          | 1 +
>  Documentation/process/howto.rst              | 1 +
>  Documentation/sound/designs/index.rst        | 2 ++
>  7 files changed, 9 insertions(+)

In addition to Greg's comments, you'll want to split these out, since
they need to be judged by different maintainers.

Also, have you verified that GPL-2.0 is the intended license for all of
those files?  I wrote one of them and big parts of another, but you
haven't asked me...

Thanks,

jon
