Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAE317B505
	for <cgroups@vger.kernel.org>; Fri, 31 Jul 2026 09:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785489524; cv=none; b=bbv43PE59aidno2ayuAGb9gt98Bdnz108yF9JK1lYjMTpjP1acIKzAvcAW9GK8l2H+NVqkSepCM75FntK5L9gzWpf9JNvyUNPA+D7NIGzMlDUXWaWoB6efRLEs7D/vLd4SeCtT8PZm3lmJlCzMyULBaKLCw4aTCSD5ASDUwMfKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785489524; c=relaxed/simple;
	bh=bwHfECC55OnCtvP0E7IoCPnJ4TAlc8AGp6+ZR7/YYSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZiXsiWMfFC8xdr6BamVFu7CQdgTKWPEZ+5aeaqGPJuiVuzvNXAZkRQLLiNVgdH+gxzbBvIvL933pOGdzv2QQtnu74dfjyfppXDJLnRi5ZGjj27VX52jIgnKdTE+gD9rWBtnwY/1FJ6PtJFEgWMaohRwBBX9MEzHHfkcAoZ5hyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TwK1+eid; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TwK1+eid"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f84023916so768672f8f.3
        for <cgroups@vger.kernel.org>; Fri, 31 Jul 2026 02:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785489520; x=1786094320; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ru7vgSQnsNbpoP3wPkVpdq3kmKPHaB3aDPcV1egDXRU=;
        b=TwK1+eidJMI0jh6WrIazODH+oknm+ehf0/ocBJQijaO250Hd7SsJzIWHU6YPjLBzLn
         wgkkDa3s3yIHTIiPu+dauqC91l38lWUlNVQSM9DJr/ttaO0BF+KtPVp89Fsxej5Q8B2M
         HUGMKQs8DlMLAX9ywtOuKKvRhLaJqqpksCYb81YNHJp7oQhsztOxEItzrwL57mSGV5nm
         qVxHDQyY2CeoydbbppoPjw6hFLjYL/WGEh1xDcXmq+Qdo9PJgeP2FiPNEZQ29KH8Gwz1
         /D0JLmV9bdJiV5Yq1tf48jBqUNyh428fuV+pGBe7sbvsP1Bd9VwtV9n6BBuOpIY8II91
         XWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785489520; x=1786094320;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ru7vgSQnsNbpoP3wPkVpdq3kmKPHaB3aDPcV1egDXRU=;
        b=Y114DlApNm/+4g84okdcZVJEu7R0vo22FzO7atWNh8jaGLGV66mWNu2eqgag09K/Qd
         YeX9CseU0BqyKaXZ0RiUoB6RBkw+fkRhLcN5V90PS/tOUw0LgfNSUMydx2d763AEsSy0
         P45C+WyZ4iwtc5j074kDyki88serm6xCf0A5e0cDjnmm/a/gCIw95j4EZ4o0MKLGSFQl
         LL9VyfEzhPmMt7O0SJ4WiXM1rQRarGFTK2+gtVn11ppwfSaigvNpL0NoYJtLqadNjLbl
         DwuLOkFzBIdraq6e+3ypO03CoimIR4hvwIxpuOLUgL0GDeDI7oHg9DgCd+uaTaM5fO6p
         iA1w==
X-Gm-Message-State: AOJu0YwGPeS2/M39UZYre0gpVysNpqN8b/UXkm1TNm0xwX1eFPv6jXv8
	CdmFxebeyNfw7A+Q8vU8PHelm1tfbdmi6hYX1dooqBrHqd4GGGMA2Cqg6UlWTlLTNC91Z89Y+Fw
	QUW8+LGwM3w==
X-Gm-Gg: AR+sD11q5FceFYMsBq01hLk2FAeeOQXq3NuJ0q6G6RZBMB0hCy5paldC/kIHrYyMOcw
	GFW+XtHyHIwPJNMLxqLaF5p027gJE2HYvDSW6tuxwGvGoIk4AbHf0pKTdRgtE3naC7TI7f3mtFJ
	VDJp7ihCDzmUwgLJ6yw6j85Z4R1niiH9p/HsN4Zz1tn2pnLbj5WCunfPVgJ9zj32ZYPD2ZipfKT
	9EjgYx3c2hd5QkmD8qxol0x6Rq8r4f5rhH/g7Bvg6SnHgGcDmC2yukQgTEdkakFHCK3q4ZkBdAv
	mMN/SySnuYKv+LJ01m3PNQD4Pf9qpXSx0kILGyZXC3IV0OJYWNOcpWDdDKs34LMNc6y0DImmzyq
	8yqnl/MVX10jAGMsKEjq8N5RW9yQeYze6QpJVNsFzGo+jYwZGotNMZkqtjTONprX3jkdpT7jEle
	vxDKXxNS9PwRoSGdsqTspe5ch/HA/ffU0kHLJMGL5cidBbnRDAODWmE5jXwVMw9mzfWlz06hGzn
	+c=
X-Received: by 2002:a05:6000:4808:b0:47e:9f03:e542 with SMTP id ffacd0b85a97d-47fd2b679d9mr3015237f8f.45.1785489519948;
        Fri, 31 Jul 2026 02:18:39 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd456262bsm2209203f8f.17.2026.07.31.02.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 02:18:39 -0700 (PDT)
Date: Fri, 31 Jul 2026 11:18:37 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, tj@kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: add user_usec sanity check in
 test_cpucg_nice
Message-ID: <amxoWCgc94e9E6kb@localhost.localdomain>
References: <amnqUlrPxhTobE1E@localhost.localdomain>
 <20260730130717.1236233-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tnxx3t7cpk6cygju"
Content-Disposition: inline
In-Reply-To: <20260730130717.1236233-1-sunshaojie@kylinos.cn>


--tnxx3t7cpk6cygju
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] selftests/cgroup: add user_usec sanity check in
 test_cpucg_nice
MIME-Version: 1.0

On Thu, Jul 30, 2026 at 09:07:17PM +0800, Shaojie Sun <sunshaojie@kylinos.c=
n> wrote:
> In test_cpucg_nice, after the child process exits, user_usec is
> read from cpu.stat but the value is not checked. Add a sanity check
> to ensure user_usec > 0, analogous to test_cpucg_stats(), so that
> the test fails early if CPU usage wasn't properly accounted.
>=20
> Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
> ---
> v2: Instead of simply removing the unused user_usec read, add a sanity
>     check (if user_usec <=3D 0, goto cleanup) analogous to test_cpucg_sta=
ts(),
>     as suggested by Michal.
>=20
>  tools/testing/selftests/cgroup/test_cpu.c | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--tnxx3t7cpk6cygju
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCamxoaRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjaEAD9GI3/HmQMFyz4zdT8cIiB
p9Vql087AqIUXZiczHDlf1YA/3ZACeKyH+gzAyxyuHI8vnYFSBQVd7zAUYO9Mjt5
NToL
=l2Dw
-----END PGP SIGNATURE-----

--tnxx3t7cpk6cygju--
