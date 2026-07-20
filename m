Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8933D88E3
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784559693; cv=none; b=rbfthKZqfWvSXLIzcmZjAvEgZn1A3zvTA/od1ZZkR6KDgkuFLtHfACQX5jdqOQNc3C/CR6MrxWMDbsXPSWVlpYlWSm9Xcv5MNf3gXxorpk7zaPnlzqk4HP3xuwBgWB0eGirqIum8Wxo2l0OHWg7tQIKFRytfsTeAysHkGetUNi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784559693; c=relaxed/simple;
	bh=/adrxk88ue9QZdaMDnxlrYJjorXsMzjdAQoGR492+Qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvp7j4tV093YGqE/rGOP8I020p0rNE/XPPDnNKEzgmvVl5U8lFsWzNIIXlmb+yZOIe1h1EsmE9KA/oq/D3DDlxN0chFfnbVeHVDA9kSqVK8mZJEWJxbTIusjPSP7N7HQkFmed2vqF/9fDSRLwrI8m6+Nf8SKQs0/SlOi8QyDYdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A79W5mDv; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A79W5mDv"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49557167508so17799845e9.1
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 08:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784559690; x=1785164490; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u1b8/cFFL6YY9kDs1t0qAstCmVExZsKMqgR0pyeRNAI=;
        b=A79W5mDvUyz61Ff5WOX0SElycdgDhMMQVrhDSxIvRl15CG3G821T62wKBjDezO+0kB
         Lqa3dFkH9zpOHhJT63kFTagtW2VEnC3yOQ86JhGAfudUkWUGBdM5HtQNY2xQ6AAvzNWh
         msaXNJPPP9dUu9xf22t1yQHidTbRpK+pXB6eYeNTK0KFOCUU3JXVVvzbheAw+9n22LRg
         Y/pB0IAJ5EDoCG0eh6Bx5cGbmGQP3Hl9B9BaFZ6lA/s5lmm00Q4eX+2b4TFs618W8OPO
         xvoS86vojafEaVhreBpoisLXTyoahI0NDWKL3hyQ1MCNDvA1cvUBkyxGuwvjd5qo7ViC
         bhng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784559690; x=1785164490;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u1b8/cFFL6YY9kDs1t0qAstCmVExZsKMqgR0pyeRNAI=;
        b=KCJvc14IwAGLHE47FZ13/7fuNRVkG/xn95FdUpl9Mk0/EeiHqD3QFINhuKwxmxmnne
         fnqXZ3S0iIQFbAx1FfMFMvftJChlOzyvSKY/K4qp2fnkHIIoM6kwaKKNVw2k8S5VTFxa
         dyYjO/dAvbQgSac6f9dSCUxzBBCU0PdECIHVo/bGhDpxlfVrXM5vcA09DiRFSAvjokvV
         N/Y3noOjvOBIAnMQUsElR5dM88e7MWEUzl+3K3UTcpGPBQ+WtU9TIsXYjYggttTvS6LT
         JSPJrXXNdyIg9R6AHgWosCPZEStWV81A9UdqXBLgnVRT2R4cObYWwgRzE7injbx/TCI0
         bUDA==
X-Forwarded-Encrypted: i=1; AHgh+Rr4k5k/fcIMMbw9ScKjRE3oEy6EYlVFkqso+83VS4Ha0257QgIax597Af7KqR8AX0hIfCrb00PS@vger.kernel.org
X-Gm-Message-State: AOJu0YxWUTiytBQm1YvWf7p4ng3kcnYZyaJo4O12/2HaFswqbwfSs2d0
	JzDDtwIQ8oI9xIRX3bhY3ArDxYnPpGA2RmHAULkLbe8gfWkgyxG46lHB6ABD/gJx08k=
X-Gm-Gg: AfdE7cmoIMprvub0zc8McHwVFE4PZyY9MGmHU99KiRkqHThOu7h+Q+QNicAE8zySlEW
	EKtmJh1Cbp4GDub/KVfNX3XajNoGaPt4ASyYxZnKlv479IlJSa2Ij8bPMA3c1CXhvkyrNkMMqsp
	vl40V5ntINNoAITEJ5hMFaY8GPthTZ8wPAiV1tYNjl8G3xDAOON3CmdLhOCKfH4OSbsq7UAcXCQ
	h5MdjFinc6lVdvT4HIZZ0OGfN3aRDpo9KuIfTF7+4U23LnGMfeDLwfLrm/Jrs9FQPGqwN5AFiyA
	OYCB0DlCV9aPKlUD5cJ2oalyp8OUkXNlbSCmVMKMj1j7OU+mN39LnY18iGwzP63zeZ8TqNj83gO
	5FSUwTt2HKPko61eVxBz3LkOXgI/8jMgj30l3lBWrnM0AhrKvOjYRRDgPwNj5nwngEPmJOra0u0
	H5/2Hvkw==
X-Received: by 2002:a05:600c:e547:10b0:495:5420:bf9a with SMTP id 5b1f17b1804b1-4955420c7b9mr71637045e9.30.1784559689657;
        Mon, 20 Jul 2026 08:01:29 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4955dfa81b2sm59596425e9.4.2026.07.20.08.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 08:01:28 -0700 (PDT)
Date: Mon, 20 Jul 2026 17:01:26 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Waiman Long <longman@redhat.com>
Cc: Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH-cgroup/for-7.3] selftests/cgroup: Fix minor defects in
 test_cpuset
Message-ID: <al4tyJ2lRMj32Wpn@localhost.localdomain>
References: <20260717191814.989215-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fv4t7rj5joy2f4tw"
Content-Disposition: inline
In-Reply-To: <20260717191814.989215-1-longman@redhat.com>


--fv4t7rj5joy2f4tw
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH-cgroup/for-7.3] selftests/cgroup: Fix minor defects in
 test_cpuset
MIME-Version: 1.0

On Fri, Jul 17, 2026 at 03:18:14PM -0400, Waiman Long <longman@redhat.com> =
wrote:
> With commit 98149f542530 ("selftests/cgroup: Add test for cpuset affinity
> on controller disable"), sashiko [1] had report 3 different issues with
> the new test_cpuset_affinity_on_controller_disable() test.
>=20
>  1) `cpu_set_equal` iterates over mask bytes instead of bits, ignoring
>     CPUs >=3D 8.

Inline comment

>  2) Thread synchronization logic allows the main thread to read
>     uninitialized stack memory, causing test flakiness.

Hm, I cannot see it (alhtough I don't see it through), what was the
stack memory?
(test_phase is static, then re-initalized)

>  3) Test fails instead of skipping gracefully on uniprocessor systems
>     or when CPU 1 is unavailable.

Interesting catch.

>=20
> Fix the reported issues by:
>  1) Iterates over the bit size of the mask.
>  2) Test the new ready flag for each thread to end the wait
>     on the condoitional variable and eliminate the now unneeded
>     AFFINITY_THREAD_A_READY and AFFINITY_THREADS_READY test phases.

But the symmetric synchronization with counter is easier to reason
about.

>  3) Return KSFT_SKIP on "cpuset.cpus" setting failure.

It'd be better to have same style with test_cpuset_prs.sh, i.e. a guard
at the beginning requesting a minimal number of CPUs. Next time...

> @@ -251,7 +251,7 @@ static int cpu_set_equal(cpu_set_t *dst, unsigned lon=
g mask)
>  	CPU_ZERO(&expected);
>  	assert(sizeof(mask) < CPU_SETSIZE);
> =20
> -	for (int cpu =3D 0; cpu < sizeof(mask); ++cpu)
> +	for (int cpu =3D 0; cpu < sizeof(mask) * 8; ++cpu)
>  		if ((1UL << cpu) & mask)
>  			CPU_SET(cpu, &expected);

Oh, that was my braino in how masks are stored.
Thanks for correcting me!

It should also extend the assert accordingly:
  	assert(sizeof(mask) * 8 < CPU_SETSIZE);



Michal

--fv4t7rj5joy2f4tw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCal44QBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgYUQD/RwFDPT5dojDmOi5yECGJ
IprD9iM22xQmyH+OoCnBNI8BAMIwfQVAJ5zs9gOhHp1zjsXnYdcyT9zILSDImEhL
3EoH
=xCZx
-----END PGP SIGNATURE-----

--fv4t7rj5joy2f4tw--
