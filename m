Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E76037F8DB
	for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 20:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781640540; cv=pass; b=ODL/hPME3kxh5Q0Xdp1AhpjpcMqyAEw+lqfoqgr1gmXZrsmXFAn/lcPNHklczEIqhZ2TcZBRCpFctgRQeUC+zFF25P6JjTMnTtAs81NHyaT2Z0cjrS+X9NVXmwweIHDs34axIiYR/U11W9hCBEEkYxh+5ZiSFszO0nZaCW995sg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781640540; c=relaxed/simple;
	bh=Rnlo4U+8XVQcpe9elBQDCdpqJEQyFEfgWsDtAuY9ZpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L89cO7rcbCkfoVz9A1NZUeRXP01ptQNeez97194osINL2qSQnhM5wiixeujQTeMU9kyHxejiJli1p+x0JdaWoCSrJWHg/lrCYWO3mfx/KIEoDtzl9bhK3Kq0a3XeoDhDpRIVXYuih9UA7BJ46B0Rl6ImtjZiXGj+hvdIzyCx+YI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dnW95QxI; arc=pass smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dnW95QxI"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490a76757e5so36262675e9.2
        for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 13:08:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781640538; cv=none;
        d=google.com; s=arc-20240605;
        b=CT+BpL0CGMGTK5NP1M4jSqpJxJ/qB79fAefRUce4REPCMUZVg2rfmD4aBHE2elKXAq
         YYHqmQKWrFyHYKUcR/MoYHmEKUiT/CtLfjt6PSu6IEgulf8HXYsn0Jz41tlAUyj00TnX
         /AGkZmJcABq/59tqnmk9HrZRtxQ+WrvKaWCUXsNNULONTUkfBhfgKbNDtaeZAbHemtCf
         +qN/N7Vm8CSDo3FoOfpj3IWwMnMJGPLyi3emJmKYBQ9dJ+9vTx1m9M/Mvt0HyIyxSxnE
         vSi8g1AXuPAdltwBNjk8W8uz9gicbYHBfSxIBj5UIcFo9oZfXHHFerqmTKqiV8Zi8TZq
         Is/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rnlo4U+8XVQcpe9elBQDCdpqJEQyFEfgWsDtAuY9ZpE=;
        fh=TBiVWU/cTQcMgF88EtiOEzF6F/uRE3gQrIRDcKqL/xk=;
        b=DzSJLX0TeYpQdBo9+Xuk+2NO/A1UYIzOJP33gNljzvzIDvHy3qfvFcTOqWbFUwrt2W
         15GPTMNdjhaPqDWqMv4XGpfCiQ9jb/Q0eYUFYazzr2N0VKS1dDooYi+rLqpuTIpVfdrQ
         z8rbCZ+s4a/jpZGDeSd2rGz8ut/Rf9HTUzyI2Sq+W4LWEE2uDqTu4JB8KwFRc0WEVyKN
         14gXUo4gb61ZEC68Bt0h6psfeUes1u1uqxTOJYO46FTNG3YlUfnawPEq6GTwqYkmfBeu
         QHqMEFcDB6XKeiSU+XMKQ6ZKj+v0qNr98qiIxLcz1huKyyOOqv5mU9eOCa+P0PX0csnH
         GIXQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781640538; x=1782245338; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rnlo4U+8XVQcpe9elBQDCdpqJEQyFEfgWsDtAuY9ZpE=;
        b=dnW95QxITeeI/9lxIY17fmj+vdBkrrlzr9kED70mZ5bZgTKgI1iBkXoF/1MBEk1mKj
         jtvf+keNYMHwayd51QQFSvZ9HmagsOvM1EMm5LeGqt8oAIXZ0mlIKLIhYYw7pGkV+WXq
         4kpGSv1e7W8YIHq6VDHqDyLfYUexX+ISyOY0K/JyNBZPIDW1f3hnhNh3//6BNzA1z8Pw
         M4TJLXtaneJL0tfCQaKTgKGQGiiqV+r4DLsFGRmY7E91TJxmbPCwIf1uGOlz9W1XSOIH
         ecZdhjCpTRMmjaY/vOQIMBVTxNW3TKXsrdGSG7N7JyEasToJir2jpspIZi34Dn37dbOk
         JHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781640538; x=1782245338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rnlo4U+8XVQcpe9elBQDCdpqJEQyFEfgWsDtAuY9ZpE=;
        b=PZdPuObAI5x9ye6lel9lP9hzpuXbqkiPnmsimxM0EoZS9CzI5IFelmyBYbwY0cLOiH
         AAWTjjGdMF8XxrmxxpumSCXTr3wLs1Av5njdRjWvkVJc07iyuojnssh90SZQP03HneGE
         Eh17dSNUVG9rXJ9oA/MPkTTd6ySbHxDi1Tt04sfu+MouKc9p1wMdy4fl/Oxr0NhkX6i1
         IggX3PwKn5pBwlQgKWUKAdHis8mnIRROv5FWdhmt138s+X5JyV0mKncA8CiJ9W4ChFRK
         eAedgNXvgpGkRU8x8ku1MkvhA46Rtt4/GGf6C/SqZmf1cMV6SyVghRkG49LazmVvpPfp
         BikA==
X-Forwarded-Encrypted: i=1; AFNElJ/7v1adsZWBcSFW82LIgpYwNd0/DpbrGTI6iSNHmiyqBxZLEahufC4uVbctB+RbIgFzrUIQ28BT@vger.kernel.org
X-Gm-Message-State: AOJu0YyXuXTbuBWcy8sjvW+FmIIVywyLTKhow2x9nrT3MTQ2q7UMR8nm
	6QPFhhEsuIJtwHX7sNHdj8n1fjlcJCQKs+wek+hV6T3giNKqUzBPTlmNHwM8ZD3YPwtb1pkY6v1
	vb2iLYPLfE27eOwHmbA1Wm0RkKLymDyI=
X-Gm-Gg: Acq92OFhOzlSXFbA4zf0W4NtCOM/p1CkShpBjHqLuP9T/wzfvOHd2vvwtm4+64cGdog
	OnCtKRpUgeixY961VTxNrcTNHIqQIA6maJr7UZ6d2hwShg4dHhg84BRON4QccvChCYBcUPWAmlM
	HSzLOn/dnaw9JO65nbfmGV8PvN+IlSWVTGSM53K2GWKlqR3W7IK4YWQxDoGDmSt4SlbhzRMibx9
	Ot3NUmlrWBKp7dGLDn6/u5nw3W7yM6iPR5JO2kXXD75yTdHeI18KI8vt6r+yXTNKBS9b2DcH2l1
	UUuEaXRzqrAd1i6xypUGBmfjMvjLYUCAiSe86kklajYt2VG9jn7Joeo=
X-Received: by 2002:a05:600d:8443:20b0:490:b0e0:3de2 with SMTP id
 5b1f17b1804b1-492333f7715mr12498135e9.33.1781640537700; Tue, 16 Jun 2026
 13:08:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev> <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330> <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
 <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
 <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com> <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com>
In-Reply-To: <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 16 Jun 2026 16:08:45 -0400
X-Gm-Features: AVVi8CcJkF64DjJPscg6dRd5pZugnnFWUYYuUhZo9kqIJ3vQ0Lo_eZdOtaRqDxM
Message-ID: <CAKEwX=N=Umi94wdKcLxEWOqUwhz6=Lj909pc1Pr_5ivVnZmdPQ@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: YoungJun Park <youngjun.park@lge.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, 
	kasong@tencent.com, baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 16, 2026 at 3:54=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Jun 16, 2026 at 11:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> >
> > TBH, without vswap, we should not allow setting zswap as its own tier.
> > It's meaningless. Maybe makes it a no-op, and warn users what they're
> > setting is gibberish?
>
> Why? vswap is transparent to the user. Why can't zswap be its own tier?

Without vswap, if you set zswap as its own tier, which phys swap
device should we allocate from for the backing slot? :)

With vswap then it makes sense (and would probably be the "default"
for zswap setup until we enable zswap writeback).
