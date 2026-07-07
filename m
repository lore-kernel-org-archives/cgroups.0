Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD59C48033E
	for <cgroups@vger.kernel.org>; Tue,  7 Jul 2026 21:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783460833; cv=pass; b=N0i0GBBGavYdn82KQLAP60vS3loB+radIXVlD4QNz1UsHaejHBGRPgA1cIKDqVRjfBbjb1X9uwg0b9isQA8Vjyz/RYYmIcWcaI9ixYb283F4To6ilTCRdjuCTpY+7UQuA6B8Q9Oq9PHhdZ4FdJm9c/rS8FJ3Pq9VXucVdMFKrlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783460833; c=relaxed/simple;
	bh=GuBq+aZYRE3FMuFwCfSCJSRf8onKcRbnKXv804YB0UA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r0vuXm0+aJXEuNE/CBZTrdmOxra1qzSO1r1IrxPSUl7UL+sf5UHD2GK0DuTF1xkRX81GasBXMwHNsiG8QEf9Rpvb0M6innukmZWf5TBzu0QqYsboCwdvoLzNgzUWrt1paxr+a2iPLoApW3/pCNKpSyg83qbBQatWtOvCWx92BNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KUJm2sht; arc=pass smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KUJm2sht"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-39b27812c96so382961fa.0
        for <cgroups@vger.kernel.org>; Tue, 07 Jul 2026 14:47:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783460830; cv=none;
        d=google.com; s=arc-20260327;
        b=flpZSaXzThJ/Q9CG10AGyTN9o8CulL566xAqcsJLxvfGCHHKl1rOySmtV/z3WYYKY2
         rrjoKxwrH4e9+TcTiamMCQ6aoSLr6SAvjsFTyY0/8PKhu0vQ6J6fhTzdKiMS7zOX2vST
         3qtoUNvNJLL7fsTGcz9iIAlaA1KapxOxForc2vKs+Vuzzy6vBM3GhSv+MDy1tZSB74XV
         pwzxwNgZm2TkYtn04MiRo7qINle+pYuOWBej7gMW6Gfj8zmSSzCsN+QKJNwlaT4LqfIf
         ELy3+GiDA68XEb+IDwzCBhuUxFlw3OD1cqIPNb6rrKELW7PUN+jJKtAV2ThJ2I9kIJwD
         iBJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GuBq+aZYRE3FMuFwCfSCJSRf8onKcRbnKXv804YB0UA=;
        fh=fXWSaREcmhgSQMeYmdZZsKXkOPmJxOOm7Hl9iGvBCUs=;
        b=CZdH/qse5P4q3TATxlnnPDT4dOHzGhcpkdNtBa6LV/ssysPxEFRqeMN31MRPWXzTIc
         YMrkGtYnvmwVCbm6oHtVHSbIbrQvQ7ZjjPVDHRuBDGvyl9iWlfSax1blq+heCcIaSj0t
         AXHEP3ERVqHhbr+1dY9Pg3IWTl2PTxAvBtae9V6XN/7yahp5Rzx5Cqi4iCJptu99L/Eg
         JIlbXnLZTZt+IThp09ZZt5TrQl32Dp8KGDqxxh2ZnP4bRduBwqF5aQLyGjYARFCiI3qC
         6hkZsgRuPG4Ej6avoEY6q3lGF408Q1KOozn5zB/gr0mRGUJmphe9BOH7lZVTJp/gJw7X
         N6wg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783460830; x=1784065630; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GuBq+aZYRE3FMuFwCfSCJSRf8onKcRbnKXv804YB0UA=;
        b=KUJm2sht03DI0fvPi0mnxchqTlBx1RGwj2VOnT0MEOLZJsdln+Xi3SLzQNtEmOQ7tv
         A8kg8kUnhwmIDpu2EFCm5OCWJFnH3V3rYPLBHN5IeuBJzuPSazCl1/qurxvtIPpRgbu0
         Oe7uJ408c0zlNoY0hsGfkvRGwzBHS+mDOfkKEnlXfMUxtDT6b0//rcWUZHE3T1LL8y9V
         6wbtkQf7c3ulUPxmfwJ1SQdjRAVFRHTdlR7/NNVRZqT5VQweleFhCpVvdFiiDw3HyEzL
         UkkwVKRo3H9781LymgVmhkcv5vFZBKJb5CNGu7xXn7SuTyytwgVIzzZpCmm0UOydgtvE
         3D5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783460830; x=1784065630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GuBq+aZYRE3FMuFwCfSCJSRf8onKcRbnKXv804YB0UA=;
        b=X811juihHkD0rxzAvMNPSitSIid2RjHB6AQc8I8rdJm1t2vsMXWuw2ct1GRp5mIDaH
         YLwYpL00w+OmF0mi2pQPOqrWakIl25GsfsSbxUiIEoeVy4NlwLgjAdVlmQCIiM+wS6FX
         VPgPx5LX/T4XEfEu0VdH8eIRdfKMJSejj2qSdW3oFToOH5f4qPM5suDZUyUC+pDJOI+Y
         4sBkI5oh66KSEHr7tkR4ZVbirh6g+sQe3VZOFJvnKtDnctWlD1ok49UUSMEh0PixnVYe
         LN5HJi+FiUjcBCBgxfIPKjZYq3drCxyuiGd9a96UoyJRy8649fDlZBp9xr6kTDRBJt5k
         SyFQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrx+vjpFjVP7T29tF2qgpDJHY4oGuibIKNU1Kq/oAjrHgQ5InvIXqg/MHso9nlRtMY76/oUEd8K@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy77lJ00uU3ty6mkPCvs2h/m4INXooqU92niT3AciboKQ9ouJ+
	yjRrchCntJ+A1sHZNBoC+a+hYUzX9JCIeo40rDF8oTjIYKcDNjp6EMSf28eyquuhCP9pG3CvZl6
	sXu+/psDeNtfrek7w5LpBI6H+dU6AiBU=
X-Gm-Gg: AfdE7clCt0b+T/ZfhSHtGplqG0eT8ZB7D6/pobea9T25QmL+IOL7USJuEvHoNeT4u52
	Dv/B1VVSTYrC8WNkEW7ILY5hS0h832fMv2uRjnRc8djTAlDzY5uMHbWAwuMoQxBBALzmCd7iouv
	QCmb/enDWEs9qBpGdHvvr6UyTPRNOQ6uoNMl1a3u/IhrKjHdPIj7sHLnCm9RKwrZYUpvxdCHnYp
	SaDXgWB0MHvw9aaa9hciyZDw53E+Qn5BcqZTU8bhXh89Kan0eBcIBjmV735me/T9Xw28z80XxUd
	11WW7owV8NSdaNg0+gbnU/yzIwMP
X-Received: by 2002:ac2:5082:0:b0:5ae:bf95:38e4 with SMTP id
 2adb3069b0e04-5b007c1f0femr1110065e87.3.1783460829726; Tue, 07 Jul 2026
 14:47:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
 <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com> <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
In-Reply-To: <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Jul 2026 14:46:57 -0700
X-Gm-Features: AVVi8CdOrDVPo69QAX-ampUYh37yFtghXiGRhoBaNYNkFWfhQkG5M-LvH_fSXDA
Message-ID: <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: Yosry Ahmed <yosry@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, chengming.zhou@linux.dev, tj@kernel.org, mkoutny@suse.com, 
	Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 7, 2026 at 2:36=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Tue, Jul 7, 2026 at 2:35=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > On Tue, Jul 7, 2026 at 11:25=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Tue, Jul 7, 2026 at 2:38=E2=80=AFAM Zenghui Yu <zenghui.yu@linux.d=
ev> wrote:
> > >
> > > We were discussing a way for userspace to explicitly trigger a flush
> > > before, which would come in handy for testing. However, we decided no=
t
> > > to expose flushing as a concept to userspace.
> > >
> > > Unfortunately I think the only way to "fix" the test is to allocate
> > > more memory, enough to trigger a flush on most interesting setups.
> > > Perhaps we should scale the amount of memory with the number of CPUs
> > > so that we don't have to keep playing whack-a-mole.
> >
> > I don't have a good idea for writeback, but for zswap out, would
> > MADV_PAGEOUT work here?
>
> I don't think the reclaim mechanism is the problem, but the fact that
> we don't have enough pending updates to flush the stats. Am I missing
> something?

Ah yeah, you're right. Hmmm.

Yeah it sucks, but maybe sleeping (more than the flush period) before
read is the only way. Which
is terribly implementation-dependent :(
