Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C7638425A
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 18:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788199343; cv=pass; b=WdVmPyC88LOaIV6MG1uiPrybJHDperz0QLUSD3JyhmEtdvJeRXhVC4e58fpbm5VYvrwmtVs1ttfhREvJsSA58d1aJEvJe+x1Y9b16KJmTpqOBWUNGlggCmO6umuIaC/xQ5lxRTj0bCRj2yrohxquNDOnOhg0shV3HTdi+tXjlUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788199343; c=relaxed/simple;
	bh=75Peh7ssm8phsUJD3ZkLZHFwYmM3QKn/tUwpbiHhidg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xnt0J+llqkVqhZenPs5GezZn3Rc97SweoGIcURumvoT9oF6F44kNe4nkGGQDV+53kSKsQ9EIKxzTh33naghfXXwpwj2NHviRJhQAWXuInLKPEeU6PvlQ5DuF1ofIksBVFKgmTfVwO6+F5kzfsYWdlITGesvuI5XNwsyAcejaAWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XvmSV75I; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XvmSV75I"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a5f9b036f9so1108a12.1
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 11:02:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788199340; cv=none;
        d=google.com; s=arc-20260327;
        b=kdu5MD137aYkKw6s9KriXwvEyEBda9vL5Dapae2cv/nR7axlatL/FkHbp8MfK7EzF0
         jX9FvHFkGK9wULaTDZ0uL/eGyRr7cJ/f+No5wRbDa+zIfYJA0jBHDjZ98qIXDXyFWI3C
         EDXVnJDp6VL5eZJusr8s4eXUKvRbnkYVUmlgmlwubgnWDxxglDQC5H/j3ZqXJGl5+FYe
         5HX6PxndqLnPpTMIwdHH2Gsn9JeZSIPOy+cFwFNS9YiBNWIr2yo/OnM/SB2vqEl1Pkag
         szuVpfYDdhGJvNnqU/r6cwyJ29Hf5riP+285pU2nlngYY5U1fynhJ5JMKzdUGEZXNQLb
         xeSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=75Peh7ssm8phsUJD3ZkLZHFwYmM3QKn/tUwpbiHhidg=;
        fh=BperLeuN1UoX1FvncCVi3iSuNjwzRbgL3iO7G/VM3OE=;
        b=nwyKVOK/QOwwNGOwhg6fKQlk+jMA2o2W2ild7whmFjjEuKzJYxvplsXnjWB94oqx8g
         W0AxpZYknrzGnkMRhVkmleiuJAWyt5/4aK2XZmCfCzhA1+/7HoYD3hH+n8WDfC74IjW3
         vj4bbBy9Sv/9bpdcN+wVBkpb9ukr4aQYDwfHwqvDFdeKmPqZ3Av/bK0JYvDFp8xYfc8v
         cB95Nsim9SYV/8Va3NfDiLAvM98GvI5CW4HkfhYfkqqyjPGHV75io/a2MnNy9uAMNQW+
         2s5ReHOFqTwJFsRCBTrGIgKQbApl4GSzQ/0QzIQfexoPqqaR4FwupP1TnHxfOnS1Z1jD
         CY5g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788199340; x=1788804140; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=75Peh7ssm8phsUJD3ZkLZHFwYmM3QKn/tUwpbiHhidg=;
        b=XvmSV75IGw/P5cvyNGDtsONwapenqLlDkfpkWchR8ps9lLd2rQ40bXF++IPwMNMq0O
         r1UExgWmn0seAhP/OozrlUh9194yb2hATqXzcJx9b0z4YjLxMszTH1eV7B63VxcTi4jk
         yJqnt4gbltW6mmNcBoqVsEI5pNicWU0YKrI+jPH8a/u1ZUrTMP4Hzum8yOy02iALDFZ/
         OVKa6WwR7TGtOMczxIGO5aM2YldvZE9uNUkPyAg7SGy/gp2doLvRFX5KqrspNusbhECh
         OwsS0hYSx7LSffb1INnsZjpNKsuEwx+yxs/9t6pxQzMqhQCx6XBINrnST/lhmhXziaz7
         0Lvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788199340; x=1788804140;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=75Peh7ssm8phsUJD3ZkLZHFwYmM3QKn/tUwpbiHhidg=;
        b=AHHQQtSpAIdWM8boTCEp8E2V5glZfqWWCltXUrG8Jkd+MERKdE93XI31s230t0UX40
         lu3lZNT0uxlf+9f27RxEBuL1k0Cxda+fKK7moQhO9MCO1GAZ8p5cIuCqpsiMsuUq6PCw
         FkhLCKPHCSD6PkHoMKU4J3C/+KnWrm10Kct2bYcjMwaZCPQ+maT+eEWDBNSzSpoGzgVf
         XZ9rsDyqTCEm/6OnNPFBf3D1O7B6G3Un3q1CsKDdTSzl7agF5U7ocX/oRo+iyZRclV1i
         YrPu9bf5f4As9wXLMy8jpqIRxyxbap3W9NrPyZsCWxxTFlPLkMSx41TbdvhxeH31zzQA
         4u6Q==
X-Forwarded-Encrypted: i=1; AKwUvBxOpOFRndGqNURPdG8t2hTuYZ/GSAaMV2VAVUZpaiC5o+d0F6LT12XJbIOJs5PxGWPceNtoCeo4@vger.kernel.org
X-Gm-Message-State: AFuF++k1BUgid5x7OAL5Gywjr0J3gNTm/8EaadZmLhvlxDF7llcEIxkJ
	29LIoyzDvlAK5mGPbiM9Ke1ZdM8TF5idxR8CWl4LDP964/0OLtrpTiZKWVIRqpV6j+LkG2rZH1v
	ph0eJ9HYNfLfMmQlSYs2CdM6waSvhqgWYuhsp3vN4
X-Gm-Gg: AYBFou34ZMwYTezfL2Wdtl8yrrq0aX3OiMkPVTWA0++qmqqFRvcdtWiDbdr8E431lD0
	skYeYB3kZiEAKDFeI7l2hfemmXAHPchoG1i2CkLD37Jp/rU3IlzGSToiHNP5nA2y+w6QrV+EjRl
	+cn1ogM81ztqH7N+0uFCBFy+P70CILnhaZeNisMidtcnR+060o8ZEmGRLe/e1Gpi0jkFr2ujbqO
	s98ERXv4rjQ9ggmtVbvTTfZq5gAZLvyO54z69yQ18C/e83qSp1VVUv1Gp7vzOUN2NcxXgkSAGQh
	kW3muH0Obab6sSiuxUkACvmBelm9RcX3YSrCInLea10mBJTFjsaigqpxcT1X0y8NivraLaFnnqo
	qSQ==
X-Received: by 2002:a05:6402:22d1:b0:6a3:ec9b:9dfe with SMTP id
 4fb4d7f45d1cf-6a66a17d251mr2710a12.8.1788199340005; Mon, 31 Aug 2026 11:02:20
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828215252.4126811-1-eperot@google.com> <ceef3a1e4e86deef2970e80d94925bac@kernel.org>
In-Reply-To: <ceef3a1e4e86deef2970e80d94925bac@kernel.org>
From: Etienne Perot <eperot@google.com>
Date: Mon, 31 Aug 2026 11:01:40 -0700
X-Gm-Features: AcwNN1UnnEGdSnQdQ17OP7lths-5KZ15H5ByB4zkfrtDMak_OBA1OLjNz_lVuJA
Message-ID: <CAFKBtDL9jBTy8BQL8poUCqckwmSRDByCQMfLyo3SMV3wnpaN3Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] cgroup: fix spurious SIGKILL of CLONE_INTO_CGROUP children
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Christian Brauner <brauner@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks Tejun, and thanks Shakeel for the review.

- Etienne
