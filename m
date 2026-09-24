Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302AB359A70
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 04:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790224507; cv=pass; b=LAzkz8PjXvYDRht5rmyGLTSD2rsHxTDkk9p0tIRZMVyktfvzIJ8IhQDB2OyauWEDFS69lkacivWbq+pQCQi5YZDt8wrQVtEa/9EGGeA9kco2GztcBls/IbUR0xma3z1bUaGj7CQUBrIqnpyjTzOYepd6AX5wgVoZgHkbLk/MGAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790224507; c=relaxed/simple;
	bh=th4Y241gR8fKqXdszPTrMDgI2QzkfuYH1UjS4q/XE0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JFDVcRJWgxTUx7hB2iYKPRWYp9mlB4lBAFBgXwPdiEQX6Ox8elwg+3kN9cl9ajTKO/6BQKNpOHgUvuxKuF+D5RSDmFPSpK+1QhpICV7k89KemfNTZNvbol3ZWlvT7ZRJamPDiC96iF7g4jcoKKfdOl+pSaobD9tKT9MOfzCpVVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yn0yF/PV; arc=pass smtp.client-ip=74.125.231.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yn0yF/PV"
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4b37a3688a2so1321740b6e.0
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 21:35:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790224505; cv=none;
        d=google.com; s=arc-20260327;
        b=XkIM8elvRzI1P92d5ZIEMtcYryIR3iqj7bnAmtzI0YMxQU/lDD7+f8PRMiPLXyt0hU
         FFarkgtc+AkUH1QW4Jl7CoCypNOARPHaJ0aY5qDaMnQAUftJQ8kH4v9Dvm+Xv1bVMeCn
         OxSKO31/joUYQWRorZ5IcOH92UNl1hQroq5DikZVLEGFKFsVqBFKp3+94aPrAmYomXWv
         iyTwfg2k9cOsYPrZrKkf6mNQvQLYNaFNLOYW12mFwa0dse62Q+GD+ZEEXCGEa4jFdRF3
         X2UpHVQJdsBzpcjOq0GMqwe7EgRcE+X4WYhbdNyPBi8aewRPfIdkbli6TeH+oPLn/6DN
         42fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HgPIQmEvwYaItDda9jIvvcgV4nx3Zf69aHXsVWLINFs=;
        fh=szjJXMZWrdGRFJQGIfPRyaNCmK4drijeyj+tlQHJdqU=;
        b=aU8+tUiUukl179vW5vzzbr77HOJ196EtmDHfn4wQfFD92/OZJ8iy2ssNRuD8soMV0a
         k+sZv8l9lahm/CmgH4LenMBB4T9eFBJEmEogy+NROwVpSZ0hYKfCfVr5nNScCDcL+MBN
         9bZLabh7M2m6bssVbcHUzHMO4ndtZUXwYqqyCZJ8P2JIYLgGlBPGEopf5vFlFPS1TPZj
         wYUptpMfuhoD3+1BfX0cZquJfIN3nUwj30CkLMkoK9HzTrvoIsDVqQOsAdYTEHFvNsaZ
         1s9sPpkc/+6vbl2WSV7gjREhMi7iwHShf/hBypJE+SAIndudw+hd0BylmYUgpJTv8F+U
         ciMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790224505; x=1790829305; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HgPIQmEvwYaItDda9jIvvcgV4nx3Zf69aHXsVWLINFs=;
        b=Yn0yF/PV+g1RlFbDOnz3BVwuIlFOiZkSVx9KP8g9JJeaiPf/TB7+EAkKOzB80b0Iy4
         ZWASIaRpVAjMSxa+V80uzprm9U65TszsVkBeT8OgaGR7QthwnFstQHNT2W0AbkhyKp3+
         yit4S/I77KtNKm9MVfYwkL0vJ5lLO6dTffb3N5Q2jEX6lldmUZ/6SEe82WdSzCPyxoc1
         A+/T7jTV3gL3zpvS799EPh34D2EgigO5yP9P9iUdOnykei9r+IvIw6Kq2UE0dDFE2DMZ
         qeUdj6ms6Gez9aF6jCdHxQfj1O6IKHUpPeML4ge7l49SRhtEb2VIigkauQB6FqexXzIH
         x3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790224505; x=1790829305;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HgPIQmEvwYaItDda9jIvvcgV4nx3Zf69aHXsVWLINFs=;
        b=hM/9tMIzZ4xjEa8H4bMIQrtxQJE3AOPgR9HYoiCJNdHnZEEj09GYDZZQ7CNVbi0CgM
         HJ29wzR5eeqazM3DP/Y/ddRzxatRGWH91FR/qXron4lvBSK7G1qunqrDx/PI+ZSRW8a2
         S1arR+VZdHp8ok0ZwPgocaUQgX7eh+rId3aVwQ9EjJ+1Kkz1sf4LuFAAQGqhPwvCu3zb
         mW4rldp0U0kzEnEEpJfOLE5pPp5CUzK+INaBeHRbskpSNEG2Yvf2obDaiBm4ADt5098L
         CJJoxcj6OalL+oCGGOUPmcCpxPHI/MK8en9wVoMZBlIUQbTBUwlNhkdqsJw7rDvQJ855
         qMfg==
X-Forwarded-Encrypted: i=1; AKwUvBxdZFzI4l1rFYTU21WOzDaC0Z8FlH5nmPHy1pTjbK1PPW4k5sOFssyPMiOAxRJXcZKeZE1LE+Ez@vger.kernel.org
X-Gm-Message-State: AFuF++kN5HwWCtAtPTwqS9GfL18CQRxy6FZx0OfqVsHSkTemTR3f1pDJ
	YSEsjTPKGY3bRehzZ+2/BpTFKPcTd0npSdYY74FAhnZHySkqBtY0KoBjVQFaeBtQ+oyv0t9QNHe
	GK9kyMg0kkVbQm80iVsDb5eDDv3/xN4Q=
X-Gm-Gg: AYBFou00yBxflT2jotBEHInx3CBPCOjaB8jpXJFDwC5lY2yoJrOMwXDzEYHGMhbPiwT
	BoBeGsGZBmwoBybhm4HSTAJb65YZSSR6kKRTgRik6EupT2ruW1s0ynWshuPFnzwBEjXSfD0lCXp
	Lpc3CvCE4M/3qDTcwLEBpWXqNd14yDMkXdPYn/Nm44F8b9N/1sggOPaEOZlzGkMxdJWm4YolphA
	vye6Lb7mxDLUIjNrOUvBZBRnqdS38ONZT6pSuKb6z/qZJz1x/kS1NkPr53xS35KyJBiahQipXjP
	Lwaq/tORTeOHPXAkcczBmomFAJGFpoQhgZh/GP4gtZfAn0FahNqNZ9gpt7rteb/xQGsN1P1MNIs
	v7qn6gnKRJEQ=
X-Received: by 2002:a05:6808:1992:b0:4b2:98a3:a567 with SMTP id
 5614622812f47-4d72be39068mr1776744b6e.4.1790224504958; Wed, 23 Sep 2026
 21:35:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260923152653.40953-1-yupeng0921@gmail.com> <arP0TmdK3FnNfbwH@localhost.localdomain>
In-Reply-To: <arP0TmdK3FnNfbwH@localhost.localdomain>
From: peng yu <yupeng0921@gmail.com>
Date: Wed, 23 Sep 2026 21:34:48 -0700
X-Gm-Features: AclHuK942CAMjDTV2Zi3exg6L6EKi3Q-gOuQhHvB5LNabYOBYKDQn8SWx2V9lpQ
Message-ID: <CAG3TDc0bQJATmJR5dF5j9RoDp1ti-tbAiUkLRGq4zX2CYD3unQ@mail.gmail.com>
Subject: Re: [PATCH v3] nvmet: add cgroup_path to charge namespace I/O to a cgroup
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, 
	Jens Axboe <axboe@kernel.dk>, Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 8:53=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Wed, Sep 23, 2026 at 08:26:53AM -0700, Peng Yu <yupeng0921@gmail.com> =
wrote:
> > Scenario:
> > * Create multiple nvmet subsystems/namespaces.
> > * The namespaces are backed by different LVM logical volumes.
> > * Some of the logical volumes share the same physical volumes.
>
> Why are LVMs mentioned? (The test scenario doesn't seem to use those.
> And the example is backed by RAM, so where would be any IO to control at
> all? Note: I'm only giving this part of my attention span.)

The LVMs are close to my real use case, so I mentioned them to explain why
I need this feature.
When I write the testing code, I try to demonstrate the usage in a
simpler way, so
I use RAM devices.
Sorry for the inconsistency.


> > * The subsystems are exported to different users.
> > * We should provide each user a specific iops/bps quota, thus a noisy
> >   neighbor won't impact the performance of other logical volumes.
>
> Why cannot you place users into respective cgroups and configure
> appropriate per-device limits?

I export the devices to nvme target. Per my understanding, the IOs are
controlled by kernel threads. The users are remote users, so I can't find
a way to put them in a local cgroup.

> Thanks for providing more context about the scenario so that I can
> understand what's the goal and obstacle.
>
> Michal
