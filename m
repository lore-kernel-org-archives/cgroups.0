Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792433090;
	b=47ay/KAtC4JpmqCTSBcvp2uUGb06lc/Ay0qsVhcknish+X0DcXPshbYNS46P6GaqQypx
	 H0XLgXWkerm7gJ22uNAVmKNDGlG4o2JWP39e1nJQ0DVaYBB2bXA1SWCu6rdCyhoWTsp4a
	 6vy7jkgroIfvITP+PtnZUo3kCH4QWBl4JC4zlgDiV3AfBwIBD08X8zGJFnh0any3VwAkX
	 ium9utKEYla732j7clNL9CImD1oEJP1kipETDxJquIkt9fBLXExeXqHASb/NDdaO2JfI5
	 AVTmvXVTH/XZQyCGz8zKd8OqtIydmXYB9wd3/DkuEx6re00TnpJrK/nxVkgUCpNNV2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792433090;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=wrt+8PhfRlQSNIHgSD1lLTqm3eQcjLp2HLFlGFUSVTc=;
	b=v6ynoe3s0iVKUgDNQYARbfueJ1aufTJ4Rsqgwalgv4LvvCyVz667YjPdWP5worWkhMJS
	 lG3HlQGl9aAlgfjLenahpzvt+iurMdzhVdmOarJsSirAKbiR8+sHB0/7qa/t5Yu2ypk5e
	 aqonoh245UbiOdJnHihmEmeMeMSwIhk9rkZh/EkbKQKD0lVeuhNCyyQuUV7FoW7M0Si2p
	 Xl7fRG7Eqf2tDtSJIWs8ccwpSPCJqMab8H49AwymJmSUCphNe9dY1W+QVcqXUQRTkbN16
	 XRzaU38lQWhX3p/wgRGuV5HKkYtVundQA0+e32tSKVOZP7+isjp3fZqeClbwiV1T+DA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linaro.org;
	spf=pass smtp.mailfrom=linaro.org;
	dkim=pass header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=tql2y07z;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D6A606A31A
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 18:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1D6A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=linaro.org header.i=@linaro.org header.a=rsa-sha256 header.s=google header.b=tql2y07z
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a0a4aa99bdso2775169a12.1
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 11:04:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792433088; cv=none;
        d=google.com; s=arc-20260327;
        b=XKHn85sAfhKXn7PUS3yxgpFlpcV0+EDHK3dX98Go4bT7XRvBUwnYzJG13e2G+ni9MH
         4cIbCWwn+xGTz75QhmLey1FS/MrkiX1NjtIvCFfoCVD+fxDZ2MjugiIz4ggPnV6ce261
         q536drNtjRyGaeNQT6xOXlsykFT7+MQ3YrOXa3DxwzHZouIA+bcX19TV7WRtN/7wK5WJ
         RTuuz3RYbDbZm0bCK3iFE5xnVM16UKINYBxYVRcDg8qppDJ+RLY0yQVzP4hFJ4FGQnf4
         VM2pYBeap89MhMLII8iSAh6fbLv455xswgw2/F5r//uLGLwzu1fDNlK8JmJtBFuWFQrq
         eITQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wrt+8PhfRlQSNIHgSD1lLTqm3eQcjLp2HLFlGFUSVTc=;
        fh=A/sOuhXcsSPF4Uo/3aG4kchDDPx+PDIqeJ44qUFiZyY=;
        b=G0Dq/SQLUT4CNCsyGjjXiAXEfZU2GyLXciXFR5X/T7VN3fOrEAw2fTm5DBkZftaBkS
         3GiiSKzd58fhnoOhHFmb7uVsEuyRJYrENgc0WTi9F7ti3Pnh4i+NXa7S8EBV3Yosk61C
         swCm2Pi9+803tHn/DM3Ra1Fstv4mLf7BaLZmI5ptibON4t27HXNodd4Dkz3P19pONmA6
         vkIEDlGYH6XLcXQmeVkayl1hpGu0nlOBVMDisnC/DJHN/7rt56RoVdKYBOFuk6f/sAdz
         HJnknleIkUkzy7rI1JmeIazmZOZtaAP4CqwIeSdWItBhHRe32iLpsWSVK0H2jbjaR8Ci
         28Cw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1792433088; x=1793037888; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wrt+8PhfRlQSNIHgSD1lLTqm3eQcjLp2HLFlGFUSVTc=;
        b=tql2y07zDPVDJso7yMW3lsi5HQVfJQ5cN03e09ZN1YkZJ3zIiA0JnLqjtsJSlCiz+7
         TOgkKwg3TsMMzyTkMvLbvWqVmaREB/AGOkiwYpWLld/GryqRj6+W55AisKLzxdQ7TpPz
         hBWhFGKFj2sN9VGWx0xQvs+iZsO+g2cQ3j9TX4R+mjXA7zqjIKBRCvciXVpSOtZCVXQj
         Qy6xGp+eG7rSRANHwxz/upwhZRM4SWPc4G79U62j7HmgwAWX5cdmy45jOWVge9s7MXXE
         vud33UE9CPZ/DJzF0yuadtgStlwo0MgIurCnJotC3bUjbTZWzq9zLptPX5MaKUJfc7lK
         b5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792433088; x=1793037888;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wrt+8PhfRlQSNIHgSD1lLTqm3eQcjLp2HLFlGFUSVTc=;
        b=2qbXboiNdOKFdMgwZvMLq8VGhAk/5PJP39PGH3oSPbkQi29ONbOQ6PM43V1fVD3lEF
         dba31WV5fLoZqa+VE8ZPqQCGUuXuG0Npafrc+22MQkPXNP7yC5ji+h5+trxhLhLwdqV1
         tMsi3Lrah7wYJ47hLl7Lbnc/cOoVMm9L5aVIK579QC8jyfhRAxFEX35zUIoz9T8A6Y41
         bkmnU9FANouc5lz/odh184SMp8KcvqClfOY7y/ajL67e+aErxH4Ab7oVeCa2NDQOMCao
         ffnTFAeXL66XfrgUVhd8mn2N9/XeJv9pMCb/k365s3w32iji8wrR9colNb0BQf+KvU7B
         0ttw==
X-Forwarded-Encrypted: i=1; AKwUvBzXPKetAxicDlAwjfw5P19rmWWYWbt141GlQWQZV+HqMzESh33DKJBNAPq3cHcA3fWudWeC7ap4@vger.kernel.org
X-Gm-Message-State: AFq9FYKDLaJeRWfpdjAIHIDXR3FRdkcdPsaesi8yDbQ3/2VfL8axLY6/
	QOHQu+TCx5HJq6M8KGPW4p7flcqYb/nF5eQxHbEWgM9YOeWA7OYOYfCsYTLtYiwm+yEI0vlBQqr
	ZwrF3t8I9QdqhzQ6ZnV2zLqrgiMDWaj8O91m3R2Sj5w==
X-Gm-Gg: AYBFou2ILLUzWUCpBgvanahxW96J0EGfZTjWQ5LaoUYVZFMWf6i5DouG1sE+TXPgSy7
	UhaufOX+wCY+mEt4cEEJtAEH4v96C+0uQNnDZD3an8C2Cb6WRAoBs7lYHhgYCXp3hdk/K13bV5q
	7cPuwNPXBovEBinrvkoCNa1txiMNPdDp5v6jfzxK6hWLASrdyt4ylEmTXFk9HEN5x9WeqkLBxko
	3H3lly78LBp0MGlSe1o++w3BsOhTDhHZiWVP51jZuXCUIUSFfuRvWQ75Pb1xH3ZhzMzPZBZf5oV
	7c4rBi0QkcgEN05N7GXY7kCcBcVMC+q6Q6BLHDotH1od0PJOohMHQAswtSMKyFTP0a74veBIAcS
	aGL7iQsVgVwuxEPFkPTAi/Q==
X-Received: by 2002:a17:907:c008:b0:c2d:d408:5d9c with SMTP id
 a640c23a62f3a-c41a0ad38b3mr520648366b.48.1792433088240; Mon, 19 Oct 2026
 11:04:48 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260605105513.354837583@infradead.org> <20260605124052.227463677@infradead.org>
 <58dc8e8a-7260-43ce-aebb-8d9c29a6afc9@okonski.org> <b1002150c3e4f877d04790cd8e85d2149d17722f.camel@gmx.de>
 <atZM6uF0CqCNh__I@vingu-cube> <f1d0fc39-6939-4fb3-a422-273cd5c347c4@okonski.org>
In-Reply-To: <f1d0fc39-6939-4fb3-a422-273cd5c347c4@okonski.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 19 Oct 2026 20:04:35 +0200
X-Gm-Features: AclHuK-WA6ulW37B9epeQPoOoobTWCftnzK3P09s14_KqVaqbBfXm4ejwIcrbiM
Message-ID: <CAKfTPtB_gMM7axqM167_Tb=WiChskGPXFDgQ4YjVz4Bj+ZiJ0g@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] sched/eevdf: Move to a single runqueue
To: =?UTF-8?Q?Jakub_Oko=C5=84ski?= <jakub@okonski.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org, 
	longman@redhat.com, chenridong@huaweicloud.com, juri.lelli@redhat.com, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jstultz@google.com, kprateek.nayak@amd.com, qyousef@layalina.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Oct 2026 at 19:36, Jakub Oko=C5=84ski <jakub@okonski.org> wrote:
>
> Hi Vincent,
>
> Your patch fixes my cpu.idle test case.
>
> On 10/19/26 19:01, Vincent Guittot wrote:
> >  /*
> > - * Preempt the current task with a newly woken task if needed:
> > + * Preempt an idle entity in favor of a non-idle entity (and don't pre=
empt
> > + * in the inverse case).
> > + */
> > +static bool wakeup_preempt_sched_idle(struct sched_entity *cse, struct=
 sched_entity *pse)
>
> This should return enum preempt_wakeup_action. But with that change, on

Argh! Yes I moved from a binary to a ternary value but forgot to
update the prototype

> top of 7.3.0, it still regresses from 7.2.9 if you test with a nice 19
> spinner in the same cgroup. I think it's incomplete.

This patch only aims to fix the sched_idle task group case. I will
have a closer look at the nice 19 case. Have you checked the different
cgroup_mode with nice 19 ?

Vincent
