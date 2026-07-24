Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E51041DE1B
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 09:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784886050; cv=none; b=Z8nRb45aW8Knr88mi00JZXQ6YMblKYt2mbCv1yXhHnRUo1cDhV73sqYs/9CPHsFLlihFArvtJXcdM1mv5k2v8pqU0DbZEywGHusguOUhabT2m9Zkenh+FmbsVFouIx/MbeS4Pii6W5tbrZMMHaZZ5BSrXMIf5r2yrRZQfbIEn5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784886050; c=relaxed/simple;
	bh=YSdpSfZimNZTzAZXpOnAKQCAXhVwDYB0C2zy7Ma27Vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ME6ttkAyCMPwaWRj/h4IMGhXTQV5X3P4phwAqpTm/cZZf8Kyi8ZgfD5go8Ag9hCAwrxI20rw8B6NJk8Y5yVrwPdG6yZbkSpz7bb/WHTPvK35xwaQ+euDV2HXPrOFABqBlGg1vK03iBz4O2VpHJkCVrKHv3BRKQs120exUKXsGRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LhgorDP9; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LhgorDP9"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49548aebcd8so1863285e9.3
        for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 02:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784886047; x=1785490847; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GBblqFHeSLqHh3ELu7CZ02o+RdQeBHJrzzE3wlLalzo=;
        b=LhgorDP9nz8yOi060u+meWRQjwF3JlItJLkl2Ys6d1+KvUmzM/6h0TVgzXAYWGLsVG
         gMIatXaCv8l2i0hnC0nW9iIGN97AW9OkFi4n9ShuXjEPAdq3+cVpkfm0LgNizDqIFocm
         hYGs6Q+Ci4R3ythaFolxM9pBhHwufkSZTJKeB/1v1OrE3nPIQpOuzg6GkYNVqPSbCWF4
         EwDdkl8oz16bbxwpNdl+sLO7libtbPbL6LkKriR/KX2DsrDHDjPaJD6AxLCGak8/GeTf
         PLIYgFYXqyQCCEHwLildkMhgD2156ud1ZaUIwH2gAbIQMakb2KRt2Pxaz6ZrVTriOryK
         E+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784886047; x=1785490847;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GBblqFHeSLqHh3ELu7CZ02o+RdQeBHJrzzE3wlLalzo=;
        b=nk/quTeunBfd6DJNJWGm61teSk1Ng6CqmZCxI2FK9DI3p5XtepuEPadQeHbYAS5v9S
         MjDSkLa3krWnNIzXTzuhWvl2tJRwRO9RFrQdHk+ydgpjV44YrvYNogCmyHUd4x28vrpa
         VmFSRijMDfwcmysgXwUun2A+OHNrDKeVOtKMPL37r8xfS251zLg0/URbB1vKQjIERy2c
         WKRknUj2ozsjNURrf07GGSiI/53jLoNfSC5sROWHqNKFSuIm5CASo0wGdRkr6XxLZ+1A
         8iEUT6SoX/S4GUbHt56oTf5scXINrPM3Mto0gwD0y91la664sMjo2of5zrABTQuFNgk7
         pBXA==
X-Forwarded-Encrypted: i=1; AHgh+Rpaj49tvcGym/HwT6s0UNDKLzn9LlbDMhlvIbtLWJz2ENJJ9KYc6EcMv1dYuF8rNHFpToh78gcZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzvTF+8bDBnC+20HP/IDZZyZIwUOi+rqBy28gqwTShjjmsgvCSP
	wDVRx0zpdrXIzvsvEniHwl+UP5ql4OT7Z8X9MqtXrbi+JeLegmejEof76ZHndJiHxcI=
X-Gm-Gg: AR+sD12y+5VWq1zGdHISHty7h1LMxJdLb2KOTVfbEPkc2IwR1jxr2+T3QRfrDAR1lJU
	yUP1LP3N2hd5ft/AVF9vzItzeO3EX8AH6uTren10Q3Tf2JnWVuSeJvFAZQq9cDDKaEFvgX6aIjh
	8dtJ2YYVgPN/hSRKWumV3JkD95eBL87Jy7UE+VqoBUUXHqi2S1JRhFHa0rz04+MQBohCJDQed7L
	T3i4K56F5btELLfJJRsEjT8LBW43Qf5tSxZnITJZBhMlx6dCiWi4joU65uEswwYiCaMOPTXWE0v
	6d4SFR7sTo9kg2+5MfRIWCwVFYSMfbacOnwikCYUP3wGaSlQGuvMm0AqFNIHNQ36gjaRf1YGEgz
	sTCw1zScSoaoZoHxf6iIUcV8E70enS4/X4zlDqR0laKfoYJHjM3xTENLZP7wkPhw9vsTqQ6hU4k
	7Yd/XNAw==
X-Received: by 2002:a05:600c:6d83:b0:492:6447:7a7f with SMTP id 5b1f17b1804b1-49573cbf8ccmr44272915e9.6.1784886046553;
        Fri, 24 Jul 2026 02:40:46 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957bfc2ff2sm36082445e9.4.2026.07.24.02.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 02:40:45 -0700 (PDT)
Date: Fri, 24 Jul 2026 11:40:44 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tao Cui <cuitao@kylinos.cn>, Ziyang Men <ziyang.meme@gmail.com>
Subject: Re: [PATCH] selftests/cgroup: add PSI pressure trigger and
 validation tests
Message-ID: <amMp5Dh4iC4Kol-I@localhost.localdomain>
References: <20260724025826.504586-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cgkdcasmpb4zrsus"
Content-Disposition: inline
In-Reply-To: <20260724025826.504586-1-cui.tao@linux.dev>


--cgkdcasmpb4zrsus
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] selftests/cgroup: add PSI pressure trigger and
 validation tests
MIME-Version: 1.0

Hi.

On Fri, Jul 24, 2026 at 10:58:26AM +0800, Tao Cui <cui.tao@linux.dev> wrote:
> From: Tao Cui <cuitao@kylinos.cn>
>=20
> The cgroup selftest suite had no PSI coverage at all. Add test_psi.c:
>=20
>   - /proc/pressure/{cpu,memory,io} trigger validation: a second trigger
>     on the same fd fails EBUSY; out-of-range window/threshold and
>     unparseable input fail EINVAL; "some" on /proc/pressure/irq fails
>     EINVAL (skipped when the file is absent).

If you want to test each and every returned error code, I'd suggest you
try adding this to LTP [1]. However, in general I don't think it's a
good idea to ossify the APIs with so strict tests.
The point of these selftests is for developers to have some quick
smoketests verifying that the functional concepts don't get broken while
having simple tests that are easy to maintain.


>   - cgroup.pressure toggle: disabling hides *.pressure files and
>     round-trips; out-of-range input fails ERANGE, non-numeric EINVAL.

This is a good test IMO, except for the too constrained range checking.


>   - best-effort positive test: arm a sensitive memory.pressure trigger
>     under a tight memory.max, churn memory to induce a stall and expect
>     poll() to wake (SKIP if no stall can be induced).

If you want to test the trigger, it might be better to pick a different
resource than memory (also why you sometimes cover all resource with
tests and sometimes pick only memory?), cpu pressure can be in my
experience (and in theory) induced much more predictably.

Also if you stick to memory & SKIP, could be expand on the reasons
behind selection of PSI_POLL_TIMEOUT_MS and the proportion of skip vs
pass results?



> +/* Touch every page to force allocation under a tight memory.max. */
> +static void churn_memory(size_t size)
> +{
> +	char *p =3D mmap(NULL, size, PROT_READ | PROT_WRITE,
> +		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	int iter;
> +
> +	if (p =3D=3D MAP_FAILED)
> +		return;
> +	for (iter =3D 0; iter < 5; iter++) {
> +		size_t i;
> +
> +		for (i =3D 0; i < size; i +=3D 4096)

This would ideally be sysconf(_SC_PAGE_SIZE) (see test_memcontrol.c).
Generally, this looks like something to extract and share across tests,
also check [2].

(But as I wrote above, memory is not a good resource to predictable
behavior of PSI triggers.)

> +int main(int argc, char **argv)
> +{
> +	char root[PATH_MAX];
> +	int i;
> +
> +	(void)argc;
> +
> +	ksft_print_header();
> +	ksft_set_plan(ARRAY_SIZE(tests));
> +
> +	if (cg_find_unified_root(root, sizeof(root), NULL))
> +		ksft_exit_skip("cgroup v2 isn't mounted\n");
> +	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
> +		ksft_exit_skip("memory controller isn't available\n");
> +	if (cg_read_strstr(root, "cgroup.subtree_control", "memory"))
> +		if (cg_write(root, "cgroup.subtree_control", "+memory"))
> +			ksft_exit_skip("failed to enable memory controller\n");

Here'd be good some skip-guards so that the test doesn't fail on
CONFIG_PSI=3Dn or CONFIG_PSI_DEFAULT_DISABLED=3Dy kernels.

Similar for the IRQ test and CONFIG_IRQ_TIME_ACCOUNTING
(which additionally would be IMO more uniform to have the IRQ test
together with others and just skip the "some" part).

Thanks,
Michal

--cgkdcasmpb4zrsus
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCamMzGBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Aj8mgEA/JppJjb2nI//zpHmb7hg
jIGtYm/9/YjhXQ2QNp2/ALYA/35bi6JpF73K8DUY0gGbNUhHYCBwO4ruPqNgXwUD
NocM
=UNWt
-----END PGP SIGNATURE-----

--cgkdcasmpb4zrsus--
