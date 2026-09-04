Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA933513570
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 17:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788543234; cv=pass; b=aDLSLbDw2WpheAqLhGwDLUU1DWuiMcXD+GKrFkSLUY8r8T+pcKqSby95J/Sqt5y+1PAH3y4WNy8q4YfT4S/PtEslA/MgQWgolX48D0526tOAGiZFpTTwlOlXKexk3yTNpVrT9w2Bjd346zJUEpTxpcdf0n/RyGlfxdHPgINl0J0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788543234; c=relaxed/simple;
	bh=t1ktVxTbJlW2upQFhjIfSwuMOl5963W4/r7K4+ZZ0GY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pfi/hbZFXlC8l++rWR72z94D0RJAD88ZrHB167rkQGVwTp9/vXHkceqo69Ac8TTrCbPwHFXfNyB9okKN3uSOf0cjWSpA6yFJwD1Rh1XbPJ1eU3s/MIKGdM/wYHw7A2P0fXom1X1cNZzexKcXLri/zHh5GfTjRDK01cXYCANq1Y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vmtdgF8o; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vmtdgF8o"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cda5e048fso62055e9.0
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 10:33:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788543226; cv=none;
        d=google.com; s=arc-20260327;
        b=QAlZ0jbx+olAcreG3C5Pjsu+aci6y+gtX2WhHsYr8V392vFYB7WEuon5lsJkHXCcSu
         zxnL19pV5IoEneNwmURBAPfjeAh8zLtJ5HMyEPa2rkV8dgmNb6g7gIlOspDEPlLop2DB
         5G7sq+YdT+2hhdGzCAPMgOiwj2phqEEC85sEy8u+atjLoJaRFjDNV44cG+jHWO2YbJWP
         Qxs6Y5/9HlwWJBBGl3xLrQ/wWIPS0xVQk4LT3wAkKOatZo7n0F4+P9fiXhfe/nmgGlTI
         b3rUqIbiZcQf00i53F7PscQdgdH2FyBsVAMTzuSGs17vUhfp6A5OMFocLansyBPsp6vI
         fi/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t1ktVxTbJlW2upQFhjIfSwuMOl5963W4/r7K4+ZZ0GY=;
        fh=VctiXuTGJPXd+Tljj4YZFzp6p2vVp4dzDMeFLHPQtaY=;
        b=WmeN2Q8Mn5idQLvrgI5L2iGaJq4llrrj69M4lqwhRayP4WwomJ09pa4U8QN6RUQO8T
         04CFgya2szd5qM77Qk2KhRIV6pPomkLxD6/b8kO/jz1dn8fQPcLz+X6xc76axd4b9Lci
         wV4dOMa0jkVnEOlRwSrzfYKogKIfQ6ovMD2gAVFks+6OdiUj89DyAc9XJDdZ6zuIEyPA
         PzzQ0DidCZm1YcWSlMSX2GnlQlQU8QWFvwHtQh3pEweWBtwtWVSPSNOrPSzl80M3dpUy
         8wlUj7Ttakauysdu5fJmazzk4czw86N02eaFXRJeWq8/o+I73Zix8XqLiWYrT13kEF1d
         LaeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788543226; x=1789148026; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t1ktVxTbJlW2upQFhjIfSwuMOl5963W4/r7K4+ZZ0GY=;
        b=vmtdgF8ov2uBoqG3a0dv8Mdzk2995tbfWR2Bm6rAsoyU/HlfhTuBz/TUykRhS9AHsW
         AABZjdEB2i4TVr62kTdt0M/6NyxpHkEthbmMzG9wE6fj+lgOQYebr3EAczFMlwV3OKml
         KWuRSwP/bdVRKSwgDUxRj5lra+5BAhAQqvovsBcHK/soytqd2eCqqghc7saKAnv39gAm
         GfWa28oLfnQHJ9Ukn27/1UWQs8P+Rz8wk6jCJb0ZSNnKFG8gUSW1WZvI8BwdmFwrRUcA
         1sn1jSfBBi72hBs770W0kUJ0vjQibrk0D9NYzvAI3bSdu7RfW99a5QWIF7PDnzSq3iTK
         FbMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788543226; x=1789148026;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t1ktVxTbJlW2upQFhjIfSwuMOl5963W4/r7K4+ZZ0GY=;
        b=dyY11f/7GjVXuvgGZCRVuH+NhsXVR1U0imiK15bTvS81nxC+P+GSLH/SkBpoOWjEMn
         MAtdrlg7Dza8VmMykLf0D21zLI+xF91WDpIrbEcvnaYnTRfVjgOj+gfMqYKraFKWGQ2s
         ZHdUHSWRU8dIa2L6wmUt8YyzPRyjJUJceYy1Ck4IuKqS4OR5oJ6exjf7gF1CLzLHPD1F
         XIekPELN+HY6s/bIQJd5Tdlr70n6PeQAuGFLp6A/tOagglj1Sh2tSGW6bxJK9fswZakG
         K6OkB/lhWQhf3J31z9KWROeMeuGEXZ81SzvpszjrP/hO0zu8l8Hihb9160GMLsite+O8
         bk0w==
X-Forwarded-Encrypted: i=1; AKwUvBxZ94zg/al3nmaHfsF5O7n6zkEpgAcIMr0abZLfIpNHdrLMKvi+vV42Fc7KFBbiVtbln3u1cdl/@vger.kernel.org
X-Gm-Message-State: AFuF++nKlSO6Wwa0Z0LK2XKQ5lt5UEH0DVLY7FJ+IY1FfXFMWA28q4Zt
	2duqp5U1eoLKpYyaZK0o7lcPReDGLCQma8uvnbg6xqEkDH2JUXmOxqJ51WLMMWedmsB2MJupl/o
	hYRIgt01eY7KmlSeM5jRrXAfZal2TRJEN6iIMmJia
X-Gm-Gg: AYBFou3zbZNH2a+la4keFEn6rSk/PTjf9WarCK+t6QAJz32HJkfS51NcaXLrbEWbCPY
	PzCyJ6Z7roMSc73GbliIrqhLpltt260PsmMl9SlYkDa1oVXsGPXtS/AL1vmSGiZTi+JHk7x5GJe
	2AsddkRP8OoY2R3HViWvAdzRds4bBCvSE6X9cU9XqoEgAFR2O52dFKNToN5Ljr82+OV31qcwltw
	Udr8JSep4ZuO3a5MW57f5r/S1LvgscCFMe14rEx3IW0fXFCFxa/i2HjT9Ck8OpReiDYmti949ip
	vxyX+IO1PEiACqFcmJfQQ2xUeZZD0NvXH3hNcGajNhqkSq/3slkTo1ZZy1EnUmTzH3RyuEIfkGZ
	wZXplcv6gE1Y=
X-Received: by 2002:a05:600c:35d0:b0:499:fa56:f542 with SMTP id
 5b1f17b1804b1-49d01d85e40mr39325e9.8.1788543225025; Fri, 04 Sep 2026 10:33:45
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260831234339.280376-1-stevensd@google.com> <aprp6GXv8poXXad9@gremlin>
In-Reply-To: <aprp6GXv8poXXad9@gremlin>
From: David Stevens <stevensd@google.com>
Date: Fri, 4 Sep 2026 10:33:32 -0700
X-Gm-Features: AcwNN1W259iSlNcdOxCm33dP0lK-4S0p3PqWOSOPP-wtwD-84kHw7ZoHOPqUqY4
Message-ID: <CAOiLmNEPw_cPE0QM1Q7CbNC8owW94PvejKo71Hb7DF=QKNN4Lg@mail.gmail.com>
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is allowed
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 4, 2026 at 9:25=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> > Memcg charging can be done from any context, but calling schedule_work(=
)
> > isn't safe from an NMI. If memory.high is breached from a context where
> > spinning isn't allowed, use irq_work to schedule the reclaim work.
> >
> > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > Signed-off-by: David Stevens <stevensd@google.com>
>
> This is in mm-unstable and breaks the build for me :)
>
> In general - please don't rely on implicit header includes, if you're usi=
ng
> functions from a header that's not included, add the include because your=
 local
> config might happen to import it but another one might be broken.

Sorry about that, I'll be sure to be more careful in the future. I've
sent out a v2 with the missing includes.

-David
