Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8394F419304
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 08:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788424835; cv=pass; b=ZzxFMzHX1CBOWaRsXWm8sWX9E9zKte9r8M+bxf0uy1i9ncyzfmr8dDFv2Mdz918ckdGDN0xlVPRXLYj8EB7oXf58GTbfkkNh6fEKiBV9W9Rm0JuIUaRBEOrEmQ2yQRK4C/cjGOyJFO7RJYHjS95+Sov+gyi1rt101hmXvxoUsUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788424835; c=relaxed/simple;
	bh=38BlAFziRJRovARe8JKhiAbQAS/6opVLEcnEue1dsAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l9Um9JOZ+1ekTFygbsMJ1R0epnJ44dctJAVoFLfiv5GJdtcUxOY2+olh1mVqnlX1acjaZJ5nzsf17tLvRMibBMRMSNdWi6SyP2A9u0R43rlJW9EwdQ4huH1Pof8c8t/lJJrrtndwd9xTtFMloeoXJXJmfmomcEtnHOtJwa/bHF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=FqHXjw+g; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="FqHXjw+g"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-85590c5aeabso1793144b3a.3
        for <cgroups@vger.kernel.org>; Thu, 03 Sep 2026 01:40:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788424833; cv=none;
        d=google.com; s=arc-20260327;
        b=F/34yuiWl8Hhf/Qor53uD41q5DNPJyqRIRSfOiYzlf5W4m1QlOzPKIlJLieyiN+mbA
         GfUEV1VcSlYLJ3VPvGtYvUJNwYkighfg8O/XvW6yDm02Y+3Z7JbUyvSNYhpycsUJgPUV
         WbhSo8S3rpFoSzQ6u0OYuK5nPG3rcum7hD5RNR5Caka0bCRUOMXAH1hXbeVK/lltxtWI
         5KdZtxk4j6h+lGoDbEAxma0VmLuRqqKuh7X6IanuxTt3lxM7p/iJEQ5O4CagkL1GNnQe
         qzLDCRMHAigq6hGIULsxHJCjbpq3Iyqu2ct/KSUcEhU2YnFYWo4/47KxZpWDNC6suOCr
         pgYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=38BlAFziRJRovARe8JKhiAbQAS/6opVLEcnEue1dsAA=;
        fh=czOsxGtk2NoBAsa7jaAzkp5AUsL30R57CAdKc2Sl5Jg=;
        b=rkszspBwPBkff16fUeXYfvn/S76yxM3+nlcCdKJ0NFIyHYBheJPx9T1/Te4TM91+u2
         2azEEFgIHvqZb1RGJ0fsj6yi4PfCpAPDnVVuqfg9geTqqPU8Ew7tPZ3/f5Vbu2kF5bBL
         XjkvX5NDzNMV8jznk7Kjtr3tZ0CBPmxc0c3E5fElHY7xRBJ2vAu03irdNNkehnXCucJN
         0SRekKVUmeVUYh062OANTpAx5RqoA1bahtReydeU0w1ScsrTZKWmOvZzABKa8B0ljszv
         M2LugQIeRIjq/AcrTsrQIU1i0XVnsyqVoo8sQoCdOMUSdrTQA1U7a18rxCgc//nFAPfh
         Bo4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1788424833; x=1789029633; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=38BlAFziRJRovARe8JKhiAbQAS/6opVLEcnEue1dsAA=;
        b=FqHXjw+gP26NvhFNMvNKivkaVsXxicY1DBNu5LHNRMIOHsCQZnzLsEEMO0NgiNyEPY
         8jgoCn1O27S+TomujvAjfLvtT3IBM0dtj+saBVXKXT3lWhJB5ijIGKI37I+XLYOMXHYF
         21ozc3hWILrhhKIVoz91tagXMwqH7lH0QfK9cpFHTqxXoJKdmUwj/VQM5qKS7/AnpdJ6
         Fbeqj/CioGcIEO2M/R1eguLTOQf0hK6Met/hcUQlBQTETtdf/oVPPZPoeDL6uZNgLn2d
         2MXcV2wwF2e7y2DCX3goQDU60/qhkqekp+CvAFzQBNrBX7Jmny6yosnE/G6vVHv1V53o
         WPOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788424833; x=1789029633;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=38BlAFziRJRovARe8JKhiAbQAS/6opVLEcnEue1dsAA=;
        b=a54BDxr0eS/8D5pxhvErP5j2foWVdNaJ+lyXDYGaen/rTHv8IdcGZQAE5jsd+1swnl
         XBtViKSHljQWHtaloxF7tEY170s9QWhWy8QdDm89/WPI2NeOyPIEiy6Xt9RvAc8C7bzi
         aSLkjoBozxKJ0c9RCXoqk4qMfEs9h5klpdXV4/K8EcsGFU54uKEMu+7ZJsNNL2GqohX2
         cy2LuesSoOOb7xNCA9EN1Jj5TkE/HMTQ7wG+8Eqe3iyBoitdZwLAQpbjXh7p520doWVC
         kZ+xP42NuQ/t74cDIo9JBpg5bgh7qyiAqCgyVgq370Tf3YC7BnBGVu2ntv8cKj2tptgv
         zKTA==
X-Forwarded-Encrypted: i=1; AKwUvBw4UCse9YAuSl9jplkiPSAoTMAB+nv/XiDkBQSt45VTKg7WZOL2RibkXwytzUJivBLsUKRTHicw@vger.kernel.org
X-Gm-Message-State: AFuF++kLxQ4BYP1FXEmkVlTlS3lynvlXDe2F1QZkURDoXEb6fzKJzDty
	I6OYNHNOKc1zSoqYkUKqhGGjOordcab8WXQ1fujEDZbpeBTazd5gOt5ABNK2mzx4dJfBRTuVrxv
	BJ8Nbe/fmc27ATsdXV1eYJZAcwqrVAmhP8mu+z+03
X-Gm-Gg: AYBFou15PxHzH6bWvDP79j7pVBaKE037REmCfxTvhNM4koJ5Vb3kUnnFkbQgDOlACIa
	n9xlaTxvQIUac8vLmaux890+wh3oaQ3veq9YXPuPrfhG7y4soQlyhlOMNHkbpox+NzB/lpkW+Wg
	ss4wlspZTXz8uXUrr2Rxq+xmSECC/n+f8abSZTwt3VHWtICRYvJXJMf848S4APWRV0PVzlG7uLW
	l9jT0jULGIbUQg+Vc5kWogkSbpgHX42/FTy2hpGfz2gG3nMDeDHzd4/ELu73U2HQjVLMFjWHkKN
	K8bxWfmeK3k24ZCvqp9LEE8wfIXhKdA0FO11MPPub/BsNOEgDdg/45yYivfYWLPn/ImvSg0ECUp
	cafmedYKAEciWbqrDvHOGkdZoVsYmIq0=
X-Received: by 2002:a05:6a00:4f88:b0:85a:bc69:bfc4 with SMTP id
 d2e1a72fcca58-85eced14290mr14693883b3a.0.1788424831665; Thu, 03 Sep 2026
 01:40:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828180322.730419-1-longman@redhat.com> <ba138f23-6972-44c8-8ce5-80de1f50891c@linux.dev>
 <85411b3f-bcbd-4a7e-99a5-49a465ca2df8@redhat.com> <CA+0ovCg3BcogTUuqZwboEaZW41dkcsAV3nWjENOHc5ZFGaEarA@mail.gmail.com>
 <fda9189a-93d1-44bc-8c69-766c687c0ed5@redhat.com>
In-Reply-To: <fda9189a-93d1-44bc-8c69-766c687c0ed5@redhat.com>
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Thu, 3 Sep 2026 01:40:18 -0700
X-Gm-Features: AcwNN1W9RlsfS8Yl1rcEPlrdH_DskMpwHeha43CLjrJglDGsBCBPibFIsGMnlDo
Message-ID: <CA+0ovCgvhWff6M=ta8wr8RSTNUhPcxfL5UyGQMi2bxo5LQorEA@mail.gmail.com>
Subject: Re: [PATCH] cgroup/cpuset: Handle cpu hotplug race in guarantee_active_cpus()
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I do not mind at all! As long as the Tested-by tag doesn=E2=80=99t imply
exhaustive testing for soundness and completeness, please feel free to
add it. Thanks for asking!

On Wed, Sep 2, 2026 at 8:29=E2=80=AFPM Waiman Long <longman@redhat.com> wro=
te:
>
> On 9/1/26 4:55 PM, Farhad Alemi wrote:
> > Apologies for the delay in response. Upon our run, the patched kernel
> > 388b607d107c07aaade04c7f22f344cab6bdccd3 no longer panics when facing
> > the attached reproducer.
>
> Thanks for verifying the patch. Would you mind if I added the following
> Tested-by tag to the patch?
>
> Tested-by: Farhad Alemi <farhad.alemi@berkeley.edu>
>
> Thanks,
> Longman
>
>
