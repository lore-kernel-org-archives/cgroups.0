Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7044399CE
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 11:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787226207; cv=none; b=hDhQn709KjeBqv+usqCZ6EQo0f8b4KYBhdlZ+uneV1UccQ7rgCz6vQOsEbs7wcA1f52dyOThLWmQ5dCv9JMb+Nv0BWfgRimZN5LBAfzm4mCaa3LLeUCrBjGDhAYMIlJ6fYKZ9h1y9xsnFrCwU9pQ2VF7Ww+Vcu5unB28HWaJitI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787226207; c=relaxed/simple;
	bh=6Hy36tKqtpWDaWpvQ0XRRybVqYi3B32kl2Aie52EHHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRhYAcK0cIWPQFKrpqQVBHIVm7oH1F5yWAN+M4G1D6h9wdpem3iIxNvV7bXAhaz9qPay3e/kCg0b082ONM4k/Q9WAB9QBEBxnmvrhNvWndow0+9PlJ9atR8HidCA6cYtzNluqw3NFHuu6vXkOOm+rfgbrTo43/SB8r93BihsRTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TuPs/9lN; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TuPs/9lN"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so12263365e9.2
        for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 04:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787226204; x=1787831004; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9V5vN05xrZ88Pts7+MbgysCv3/LZ3VVMuZVNPdkuC9k=;
        b=TuPs/9lNAxnQECGWd7Q41+BTakiLJH9upC1PIfHpPDEIBBVDnHYueE4a9jTh+pIwo5
         g3hJzb7Cbw1kDHYsGdbbIKg7XBjANoRbIZhcYqyT1Wbe62o2bK2DCbstQhvYB9iMzV8Y
         LfeKfQkViT//iipLEXXQ6y+P5idvGw4fSRNRZs6h5rUtsx5YDwyAOapmPcEq4+ZjM+/1
         Tz5bigsjECWo9dYVWn8VrB7xSfba3u3C6XfyilDEk3rBkFs2cTET5yZ7qHkcif1Z4FpB
         TLC9JNsZRj/wxkBMI3Idv7JCgL7rXOOcIkNuEDqAJC7LXRyVhiRnHdgW/l6w9zS57ZRZ
         a7dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787226204; x=1787831004;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9V5vN05xrZ88Pts7+MbgysCv3/LZ3VVMuZVNPdkuC9k=;
        b=Rl+zQcUoo3SLRZ97lAABym915mx+MK1dhYm0+hu/2DSdEiDCp/a85WR8wzZA67rNY1
         Qvg3VAlDzaYVXTrvWMEwTbu5nzYT+xD74y10JgcPD4tp/Ua+kxRnxi57QTpz52p7uXge
         n17FlXqpVjZd+AfWVo79W8uEQSBGy2BgISxWSStKq0Ff90olTwZAfQcs8JO0SiVE5QPd
         MRVVTFDXwral09j0cAlgh7ULJKSYd93HcOzWekijyWa7TIU03xBf01hHVl1F0cOqj5jw
         iVRWrdRxqbOFK7BFCkE7hp2EWj5nfPJSu9xcSvjb1/tqZ5dR5dZLS+XjzKbqa4dj4XJb
         iV7A==
X-Forwarded-Encrypted: i=1; AHgh+RqRvy57MCL77r1s5r8tf5FAPCvDbcUp06JlJxG3UTl9ZaH647VTv3kY+9vINO3lMUrmIsu5xJQu@vger.kernel.org
X-Gm-Message-State: AOJu0YyFAnoxar9lfvL+EII1Jj/r44eRr6qcignGiGGM0b3Rv/KXhKL0
	HWjN1vyVSB+O+wS85gvm7/VbmI3+kzLVf0z8g2T+DIqLQcpUQtRlHknc1vHWBZTk0Ao=
X-Gm-Gg: AR+sD13IGw/cCBkdh6Y6GHqjbb3X52JnGrNr5/qt7Zou/R7m7/6YJ0Yuh8iMpARZ8p6
	RIaK59aMrjknDA5VpnkCahD1U9rlkLPJ6xlhkM0UZmClFuDdSlGdfr5/7fu5Gn3J5NJeyHJU5Iy
	gzo+qnn9MNcoljxaIC/gFy5awhp8zW6T9/kBMdnijKVGNa5vFNogiIsBk1oekN8cmWRFneV64jH
	MzwfjRO2YLJcIywObMTJhR/XS+gaB77pcNMaXiPq0d42BfB8D5G3utKnfJvgqiEqtDXpoIBJb7r
	pWz6bRD7JseG7Fec0iK+zAMdebNpbIHarreo7kcEpQly6gEJyP7tMvLU9XH7nsrjeWpSb7p9m8+
	VhhZl2oJ0ernN5SV/5FKIkdB6z+oCt81aN/4jl52SPGLm9t2Gk6oxjKgnOFEUoa3nx5qsuDCZN5
	/nOIsdjI4rSvQeJrIhZz6tx4FJTb26HKPyatwXGdZhzzfl21mMGDg0Jp15VFRQt7g=
X-Received: by 2002:a05:600c:468a:b0:496:c9cd:e7ab with SMTP id 5b1f17b1804b1-499aa172377mr164276785e9.5.1787226203746;
        Thu, 20 Aug 2026 04:43:23 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa1111a7sm139337275e9.6.2026.08.20.04.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 04:43:23 -0700 (PDT)
Date: Thu, 20 Aug 2026 13:43:21 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Zhe Liu <liuzhe1@kylinos.cn>
Cc: tj@kernel.org, hannes@cmpxchg.org, corbet@lwn.net, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	skhan@linuxfoundation.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sched/fair: Reset incompatible burst on quota change
Message-ID: <aobnZEh1hfIBhswD@localhost.localdomain>
References: <20260820033218.214259-1-liuzhe1@kylinos.cn>
 <20260820033218.214259-2-liuzhe1@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ljyugzshyqxvbva5"
Content-Disposition: inline
In-Reply-To: <20260820033218.214259-2-liuzhe1@kylinos.cn>


--ljyugzshyqxvbva5
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/2] sched/fair: Reset incompatible burst on quota change
MIME-Version: 1.0

On Thu, Aug 20, 2026 at 11:32:17AM +0800, Zhe Liu <liuzhe1@kylinos.cn> wrot=
e:
> A burst configured while a cgroup has unlimited CPU bandwidth can prevent
> a later finite quota from being installed.  For example, on cgroup v2:
>=20
>   # echo 100000000 > cpu.max.burst
>   # echo "50000 100000" > cpu.max
>   sh: write error: Invalid argument
>=20
> The quota remains unlimited because tg_set_bandwidth() validates the
> existing burst against the new quota.  Recovering requires userspace to
> know that it must clear the burst before retrying the quota update.  The
> same problem affects cpu.cfs_quota_us on cgroup v1.
>=20
> When changing the quota, reset the existing burst to zero if it is
> incompatible with a valid finite quota.  Preserve it when it remains
> compatible or when the new quota is unlimited.  This lets a quota update
> take effect without depending on the order in which userspace writes the
> two files.
>=20
> Rejecting the quota would retain this ordering dependency.  Clamping the
> burst would instead silently choose a different nonzero policy on behalf
> of userspace.

Why not clamp the burst_us to quota_us? That's quite natural to me.

> Resetting it to zero provides the existing no-burst default while
> leaving compatible bursts untouched.

Like Sashiko said, the user configured values should not get lost, the
resulting burst value (0 or quota or whatever makes sense) might be
applied effectively (to allow configuration order independence) but not
overwrite what was configured.

Thanks,
Michal

--ljyugzshyqxvbva5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaoboVRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjoWQD+Ih8SefrHPjy8wrrXINmL
1u5UhSH1rtRrBGNDUF32XLsA+gPkVJm6O80wMNqFk2Qzcn5wiQvR/pkjhJ9IU9G/
OksL
=fx8D
-----END PGP SIGNATURE-----

--ljyugzshyqxvbva5--
