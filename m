Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A81134CF
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 00:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790467407; cv=none; b=kxHQEAt+3D+a2WJbN+5JQxzCi4+h1ICCPHLnSa4dtCHdf+BZuaOz5orpfJnkmREe+vDcYPJiqTSSCcNXNs685uqfX7pkjbRIm6I5Bkdfti8X2Qu508rsbyqIOTOdvMynbJmpCTVmCCaqUC3ZwTdhnSrrlc7BY/MYII1gx4KO6Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790467407; c=relaxed/simple;
	bh=dM60/lQJZNJbWoteFqu6uPH785ljbJ4v68GljKAZeM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TmAn5Fy3NgKJjd4qUgf+8MlIQ59ZdQiRqohZUddW2OaGnZM3aqg7QGNeiSrhZVnBFWC2QffhGKbfCql6aURLB9htl6ii6VWfv3CoEM/BLaEmGJpyyfIgnKXK/ejVMCr2Pbpis1DthjPzYbJymyDfIC3c4BcCTMoAIcnyyYyUkVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/5SmjLj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/5SmjLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54781F000FF
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 00:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790467405;
	bh=dM60/lQJZNJbWoteFqu6uPH785ljbJ4v68GljKAZeM0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=f/5SmjLjePvZl3LH6369Ee/UAZiErmbVU6lXrAbYe8NE4CaJWSkGPNzY4Lcv7x12a
	 55hDT4TwA3/WxLizDWvSaRTPsxLZICzsMNOTP/p5mDpjMfT/Lyabk9dWRluBeIpnDN
	 ikp62HRGBvtqqMDW4yWEaiv9mmFciTf1Z2PJ6Wtf0QwXai393RVogdrry0oHdlA+rV
	 X9/G7p+aCXHKyOMu5g+wG1ppLnlLEsPm2t0fIRSS49d85JsNrr1ixi20c8jU8nL+UF
	 Ujwme8BRAizGPecmH0uTOCV055bPXrMKzJj/vvj4/iB1w7G0utdP3YcRX3pvSPkB4m
	 JGPiAmlD8GAZw==
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aae359e2c0so2903958a12.3
        for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 17:03:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy7dTw0u4PJkpVocXe3WsVsp+SEeZod5UWt+hkkD5AkWcckFTyvpgars6Whw7RL+3Z/T5bAwoBO@vger.kernel.org
X-Gm-Message-State: AFuF++ki+uDhQ1v0e6AQFrkjzStWlMP3SkmS/h3fu3uygmk06AD13nGm
	dSjpDlGLOpNbNv6knbVLpmTQ98Tb0NYQ+rQvD9x9zTuCksThWALtgzG1pXxhkTtKX7B6pqMv7BY
	oSf+Ev1hqHjDFCB6figg673zDfGQDDpApcd6/9lgW1g==
X-Received: by 2002:a17:907:970f:b0:c28:e01d:1d08 with SMTP id
 a640c23a62f3a-c2ac268a3b6mr767904866b.49.1790467402757; Sat, 26 Sep 2026
 17:03:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926045517.3458413-1-matthias.goergens@gmail.com> <CACePvbWPLegjMtF4jYN4+_1ZeoEuBHwZuwNyMpYwPZaA0edO5A@mail.gmail.com>
In-Reply-To: <CACePvbWPLegjMtF4jYN4+_1ZeoEuBHwZuwNyMpYwPZaA0edO5A@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 26 Sep 2026 14:03:11 -1000
X-Gmail-Original-Message-ID: <CACePvbU_6o_9fEFU6TJ9VaZ=4yBsDG5qXcxFkrGHBSD69m5ZXQ@mail.gmail.com>
X-Gm-Features: AclHuK-ZyMX3KOF420HwXlAK4cpZeFQwMK0gQ_EG8K18s67LKRQ8CucrkEWbQU8
Message-ID: <CACePvbU_6o_9fEFU6TJ9VaZ=4yBsDG5qXcxFkrGHBSD69m5ZXQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-api@vger.kernel.org, 
	Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, Karel Zak <kzak@redhat.com>, 
	util-linux@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Pavel Machek <pavel@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-pm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 26, 2026 at 1:32=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Fri, Sep 25, 2026 at 6:55=E2=80=AFPM Matthias Goergens
> <matthias.goergens@gmail.com> wrote:
> > The series fixes zram selftest device tracking and error reporting, add=
s
> > the swap policy with DRM eligibility checks, and tests routing, working=
set
> > activation and retained-entry write refusal. It is based on mm-new at
> > 995829088503.
>
> Hi Matthias,
>
> I can't find mm-new 995829088503 anymore.
>
> Your patch does not apply cleanly to the current tip of mm-new
> mm-unstable, or mm-stable branches.
> Do you have a git repo with your patch applied?

Never mind, I have the conflict resolved on mm-unstable.

Sorry I usually need to have the patch appliable to use my own review scrip=
ts.

Chris
