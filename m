Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94FD43DA4E
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 14:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978485; cv=none; b=SEiXAabu9c/XBxAi6tXviR+Aj4dZzFjb4sC1GoazVPpLI56/EnhNpOg2lgKvMBgOBzzbbk/7vPc3z2Jn3XZBn1iLzQ0yiXTv8D1gF2JGIJK8fjhAs7WPJ2HRDvM2PKCSbfhsJW7dh/12ejE5t8aHe3qjkxxj2EaFyodWg3aPXYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978485; c=relaxed/simple;
	bh=DvmBTxt+D3RgK45fcsGPfbTFZvvFhGT9lSctjsN91j0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q23Yl3EogH+nqrpSegKvEaKFFNnjMgu5B8J9RITgZNoTiQTYBlTIIUyJMBy/dgJZTKWkUtLodq13aP6GZTVYGKp0TLM0rfi2poIStmAbbfzujD8owPfMg0t49zFdhqAfrGkpVDdRPkfWn3Q1fGXTx3DGaYuMyD34C/SwxvWOP3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X7bqfEOe; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X7bqfEOe"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47fecbb7000so1868108f8f.2
        for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 07:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786978479; x=1787583279; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DvmBTxt+D3RgK45fcsGPfbTFZvvFhGT9lSctjsN91j0=;
        b=X7bqfEOemfX3Z8rOTF3GciiU2Ow69MGQQluXnEPLspL9vNjAew1+LFIB4wwVK15fgl
         08G4KVvuiEwClfFlsiP1TtvTCQfw7JKKKXi5mMi3b7hzyuV6GcIYEjboppAa4cXmCrks
         JalX4C0APEBjmJInFc7ZO6eibEFnF/NRM1O4TlguITbgXpCxcVpF/IkqREI/L9rQCyPa
         VUp00g7JjXqFx8iAp2l0wjoCCFH5mtLmb81CgvZ5BMaXmf3VBKmpQnvI+u+PtQBLmCbI
         ETVR2e/pS6oErjl/lXkHYVS9X0TpSgywPz2yW07Z9wulItGGf81X6XWcm4KtoN0FUBsF
         Fl4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786978479; x=1787583279;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DvmBTxt+D3RgK45fcsGPfbTFZvvFhGT9lSctjsN91j0=;
        b=RoN/4YOn7u9GmMPGYQnOEDz6lJY/7A23Ubdag1sA8hsa4rzUlyXv8+tdBb+IHjFZ7C
         5RpLE0iOnNB3ufwK9JAWQkOdwm6upKJWSTa/UYhptl7Iy0Tx80mMvVI/RaqmoARoMPb6
         ldvYSi5L8S4qadHzQ4m4KAP426zmNtePPESvVRioS/NIFgjRrje3ufM5xGZ48UIDPreT
         EAlsBV3p0eiuHporWnKJls798Ynb2SeZH4c3GdY2B46cU2HcPu8g8yDJmhAj93p0BPJm
         zAZsxjaWB3Xw1vR2pUR+Igc/KqIrv/LzxwmecpFr1yUqeFMs0DJeQ0SqHfr0sxARkvS8
         KTGw==
X-Forwarded-Encrypted: i=1; AHgh+Rr8xWgiiCgpZUXMAiiknKMG6TkM+ztS/x/axAJpf2q5Zqvkw/0OxJIdzrhFrsZ8nkeivNRUVlXl@vger.kernel.org
X-Gm-Message-State: AOJu0YygT2S165xe1jgWh9yMLqpTwZnaY2EkPiTRBQfVu5rUiDeJ2u5C
	/rq4QsqgprWTJp5mV8ysr5SZhF8VrOivAZIpJTAmcF/07Iq6qZuZCBd2m1VbV7LZdGk=
X-Gm-Gg: AR+sD10MLKeemH3cUvpPLg1Tnb7ZMM2noNrKpadHb+tt5ow48G7JHwmqna2IZ/Mxgsp
	eNmeJDSFjb+ihpGjsWHa6V/+d/XeNx+wWL6avd9rDV7rNlGuatkJ+ldM1FRrGeRa/QLl4XdFSdN
	zb07Xb+ZuyECeq8/yYI2E0E1lUaVA16CScvFkyPiIYazih9lKFBJEFCRCkoQ3lCfYotvnlW8AoY
	WRQvjP0e0EQLLtt/YDahDUt4GXV1Mv8RIVqCpjSH3hMhYhQ23kq9HUCUw4I5ki69UvnXH9zz7JM
	TvETbVgr6AvJyOgLZmmKIueP+FiEUcoQxjrT1vRr6UpBg+0I20gbHPEOe7ApfbzFpYaQ/Ez7zys
	12wcKhNYgVegaa91fXAbG6/lLstmaIsU3kyIFITyX8ShF8XDAksQSG/SIlzkj2061ShS3pyJeKL
	GRg9OGPxpfgDWtx1abDA888ZBljlwYLYy0QpcvdmCPAYbpIaJl3iJah+q5eblaNUM=
X-Received: by 2002:a05:6000:4718:b0:481:568d:f118 with SMTP id ffacd0b85a97d-4816076ff7amr42575589f8f.30.1786978478922;
        Mon, 17 Aug 2026 07:54:38 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a31543sm5347627f8f.4.2026.08.17.07.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 07:54:38 -0700 (PDT)
Date: Mon, 17 Aug 2026 16:54:36 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: shisiyuan <shisiyuan19870131@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	shisiyuan <shisiyuan@lixiang.com>
Subject: Re: [PATCH] sched/psi: add cpu_prio pressure metric for
 high-priority task stalls
Message-ID: <aoMf0P5L2QmOMOP0@localhost.localdomain>
References: <20260811104610.100617-1-shisiyuan19870131@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qu27gvil7scj6yvu"
Content-Disposition: inline
In-Reply-To: <20260811104610.100617-1-shisiyuan19870131@gmail.com>


--qu27gvil7scj6yvu
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] sched/psi: add cpu_prio pressure metric for
 high-priority task stalls
MIME-Version: 1.0

Hello.

On Tue, Aug 11, 2026 at 06:46:10PM +0800, shisiyuan <shisiyuan19870131@gmai=
l.com> wrote:
> From: shisiyuan <shisiyuan@lixiang.com>
>=20
> Introduce a new PSI (Pressure Stall Information) indicator that
> measures how much walltime priority-sensitive tasks spend waiting
> for CPU, exposed as /proc/pressure/cpu_prio alongside the existing
> io/memory/cpu/irq metrics.

You can "just" put the priority-sensitive tasks into a cgroup (no cpu
controller needed) and track the per-cgroup PSI values.

HTH,
Michal

--qu27gvil7scj6yvu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaoMghhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjpSwD+NKU2R01cwLlTMNBxrtTc
+P6kokVooPs1htIXqDBrC6YA/1vu0Ia8h9JHA9xofNvUo55BtiT7X1siVWbcVXPQ
WWUL
=A4KP
-----END PGP SIGNATURE-----

--qu27gvil7scj6yvu--
