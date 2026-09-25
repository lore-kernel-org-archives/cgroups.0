Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95E63939B1
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790359545; cv=pass; b=DeR8O1Jq+30BIlWwVPz5YMCiNCzuIivwwSfWuejl5We3eviBpeG83zfgF/stptPXl7nlHFUKwptKU3cnXjqAr5q4jPI14gyHEf3OEwdTCUx7re2Voxn2K11ydOoZZA7xbd4QqfpWuofLHZiyaMlZbAJsgeoqutcmBteB9Vm4INg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790359545; c=relaxed/simple;
	bh=gfl4b7+zGwYXjBAY/2HSLJql1XSMJI3mCRWp0qvuwyk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gJrhgx6AukKkaWpvO/bMwcNZfyCElRMSN23nKUDOiVk39LN3//s95RHQlDZCBnL9VL/vBBLZCMGR09g35tUYrWgC5Ygs9iCIvxCtW2Y49xP5FcKasEZkThyjGsPIWGfIoPKzDXlZjnzLdMcKoAscN9H8hNWroHZuLZ7s0CC2Mo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KLa6lL+z; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLa6lL+z"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f63546c3so962908f8f.1
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 11:05:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790359542; cv=none;
        d=google.com; s=arc-20260327;
        b=nDoHoZ4IXYkcsXd5TfkQ+sHVMPxQPgwipJT7RawyLxwG4AFYbOMSB2o3+QRr3BdESI
         PHuhaORzEj2Q/xoLR+BUSgL7wYp76mdoCOHvlCWjHgZzz9K7Ih/TB5of7nDBLW1mHNIk
         809P47O6uStyPpjwmSJJnIovRZ3dClgntvpnJGpoBousmczMr068AU8uSnwLPrbULX1D
         DAE0UtkNlfsFFgu+7afG9GpdCRYFWy7dxyN/dU7sbyexWaxuKIEYzdmsHNxXjZScx7as
         3f7tX8jJfPEDFljh2WjDGesNZ6zbBH7mlX+Ndcv4OShk190o+buM3lx3MLh9Quut4qvd
         1Rgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gfl4b7+zGwYXjBAY/2HSLJql1XSMJI3mCRWp0qvuwyk=;
        fh=sxsp31dV59PtCq5hcsOGzlCcw2FlQxM2ueSGaRUV0jI=;
        b=kSBuhyeMyA6rrmLmkVY3YnwGOI+k8hbUQC+DNQDuagLZzH6DLGcgfHEZv9iLKW1RJ8
         vCCovETRkaV4Rzh2bnJrEwRxRuFqbv/cP6/FhAuEvsfW6agSX3gJpEkbXahYbE3dfjV8
         HzRr3dAjZQCGulm7IdbyghfjKBteRi8VTOPY021mjLArze6xYVvehxioewi+TosKTLMR
         CykkQiI1GWPoZPuISCIXgvE0g4BcGQse5Hjp7s9oBsykmBXMDVMcJF24cEpWdfE1D9gi
         oPEGuMwc/A5zbQyqcxATXmT1aI99vMr/iy4mBLhW3FLxeARifnYbfikQzMYDpm/3UT1W
         9/hw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790359542; x=1790964342; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gfl4b7+zGwYXjBAY/2HSLJql1XSMJI3mCRWp0qvuwyk=;
        b=KLa6lL+zPRyMOjuLiH/8JgxeU/fAGEsQqf4/nPlCjE3PJ8wWRNUw797EPyMYOTDIQ5
         C0tgmoI8GCj5fbRM6DHIsp+OagNx79Yl4A+FO4AZXXXtgdWRmyR1GqzBtyVmP/59ZG0E
         mwKAPNSpRtQTSR2lUdHX/bA6IMuZNLck4FwGrKMmmYIf2AJB7H8lWPf3Y0z6s1OOA6oB
         F7RgX3ZPO2iR/xKGlqHgeQneyqgLtChQw0jX4prgOgGGS+iSePcbcjXXRia319pVtijf
         QmNOmibxTcQW92MBWq6YHMaiOqk7uty6IODSQstj6DyIAnQluDHV75gAsuwJSSnf2ZsN
         dxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790359542; x=1790964342;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gfl4b7+zGwYXjBAY/2HSLJql1XSMJI3mCRWp0qvuwyk=;
        b=0ka48rUo0/mFDZ5XMvGQD7/H0lt1MeqFDG/XD9iQiGwMnjemyNixzCUSb0+ckArQiK
         QprLeOKKZ6+JsxLXUja28r9TSfqqpaGQpTSjGFT5VelobmuObHPJKeUQlPHXkZ+yyqIb
         CR82vNnWskxtuHtxUf0M+PzbnfSD8zvuE3asLCqb+CD0aKYV/ECXjP+TRaAXkJw0tOyE
         DsseJxMZjwDAk4NlWSsTmZLPeZxR9h4S6aJDTHmSH2ct7UnYg3T/G2O6luK6zilMiZuC
         gv1lYl9kqVb5BOZ4//E91sJMJ57TS6l9bHfQ3vvZ9XMCkCM/6xR+/nRWjsE3UPu811EL
         sT7w==
X-Forwarded-Encrypted: i=1; AKwUvBz0hz9wAu9/dOCv5755OrBHrvl1u5lwVqBdacS4N5pEA9EvjplyIh+vezB6NrIHbSlfNAyDpgGo@vger.kernel.org
X-Gm-Message-State: AFuF++nOM3HoKKcA6xvV4R1yKhK2FRR9ZCjCn/mR5t1LU10xMtwffbK0
	Tdajj5s7Vvg/VRfKwk7c4ZdES3ydtLjDxj4en9RScdvAmfE/Lg6WiIyUCA9Nyj3oXQeaeawHdrA
	V5YetVNAVRwIIZsyZ3q7MsMr4W06vrPE=
X-Gm-Gg: AYBFou37tGFx1XrZPMDY+nnkVJ/3a6UaqfPQ3IH0HN4eUefgOPzxGnYgQ9A+umShUGx
	BfmPer4fmphyJLaPZnenhRpbpnEoR4eDdIWGpzWxkP0mJJKTya4gmH/himzNO80bLJEeg1a/GAZ
	SKDZWNJ7HguF1F3Eej01BgkQV2zW0CmBUCQZDaHsBWQTdqS027A7QSN9M1QazpahnHruXZYhWpZ
	9o1BifNjqON16Qxa7BLgxGDrlqAhD/PBeAYK5go33VJE8IF61wtb2TQHQL1v1izOpphYYKp2e7n
	WYnnG5y9zCE4znTCJSkR01wdTVBzJHFqMD3ATVaqaKOc5sMhXSCTehkOAOesE9aQwmNW0EtrzhM
	i/OTezwwNXLH5Tqz+xV7j8A==
X-Received: by 2002:a05:6000:2284:b0:488:8011:6834 with SMTP id
 ffacd0b85a97d-48880116940mr4896261f8f.53.1790359541945; Fri, 25 Sep 2026
 11:05:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
 <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com> <CAKEwX=M8pJUYhmADfvdk+09O53EROyDRC+_b05vtimQE5VN=qQ@mail.gmail.com>
In-Reply-To: <CAKEwX=M8pJUYhmADfvdk+09O53EROyDRC+_b05vtimQE5VN=qQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 25 Sep 2026 11:05:30 -0700
X-Gm-Features: AclHuK-FobqVPyDTMFnDSZvekiS4h2oZG-GWPYqDDrJKQs4ZBSnYi2HsqkCoGUU
Message-ID: <CAKEwX=NQtWudSHhR7-bbL8PuwFEW3uATj39DhSG4LR+mLVSusQ@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2026 at 11:04=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
>
>
> 1. It moves the metadata from a new dynamic cluster struct and shoves
> it into the existing physical struct.
>
> Like, you can check patch 11 of this series. It's practically the same
> thing, with the only difference being ou

being our interface choice.

Sorry that got cut off. I must have accidentally deleted it.
