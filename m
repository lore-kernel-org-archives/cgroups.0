Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B671576EDD
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788882949; cv=none; b=GFsN3VXEvLL/0UE81ORqVQK/rmlNC/lb0XbNqeYHz0pe1lEVE585SOJpkLrgseToCkAX2tWmBghAmRL5X3EQHBF9jvYHZvUZiW5oVA25xV5Q7D6jPve7jVclifX6eGze984Sf/yEBQUEQlcjXeKbkgIwngsFo7fl20QwXeO4Ab4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788882949; c=relaxed/simple;
	bh=AzcQcDujYJDMScylfG3Dek1ZhVg7b50dImiSr//5IuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ah42xkb11cbrefE4fGPo4RwWwERMIosGlxBpMWpJGwu72M6VRBsdnsCON5jaXT+2n6D2+TAN/RCApgnyBPI/KNkqFO+svRSKsgcMCeIcS5mkn1jX0CpH+hTsF2BMR8QR1VmcLnGu640r0f+dq2rdlRidyfh3y6hdliQoFnhWR2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=B954uWuP; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="B954uWuP"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49557167508so57093195e9.1
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 08:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788882945; x=1789487745; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uvYRoMu996lSKiESe/rhQE6W2Irf+NpUm8XBKk69vVY=;
        b=B954uWuPOYqiBOr5+PssQ3Ol4IU8jd7B2kSfmYHRslfdVmlCgSWcagS4GDpRE5GK6G
         tcPBVk3yKLgyKKnP3YrA35fSjgZUrhWYnD4w+W98n2isGFsQp3j9mip72e7e6rqkOmNo
         Z1iTVDZN39LZpBJ2v5LnNLHbysq3AAkVMjxT+2LiAgON7My+1OD8fa8gXGJ8QbSPqCe5
         6MQsTHI2xUGwfmmeuS8d1MTX7hJsJLVn2YpT1XgA09dJJsKPyp9jBHcp9yKI5PLqBB04
         RpqnnMEusVo8Ywlvuqyd8OSc8RDl7jjx19KTpjlPc4yCl/JloWZR5pxGFzmJ8PQd2ViO
         vePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788882945; x=1789487745;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uvYRoMu996lSKiESe/rhQE6W2Irf+NpUm8XBKk69vVY=;
        b=AUtx/Tj2YNxO06lb8RiyADaWoW/0GxtqC7WuwziWyyiB8HbsgvXhND9NTDcaP4StEZ
         Qisrwu+Idn1uU5etGCBTNfXf/ZHLdKnRkGssD22dwartraOijVpVthCLQR5WpDxKbymM
         dNgidQC2MFhQSUcozX8DNaQuOImoWLckTvJxUyeCGG2DhOVyEgHD9zyHdJ4Air4Y4T+V
         6uzLrCkdf9caIVmLlIBdGsJIPcPfgdbK+ZkpNCkhliMlpLGXqvmOcRdX4lV5DM829fcy
         JFSEuv6b2d0YT4+WzkfSCNjmgyJ7fYFBilMyK+3diMeaOAlbPRNppCfvFi/xlktG7e9d
         GxHw==
X-Forwarded-Encrypted: i=1; AKwUvByu97zFWnQeM67ddA8HyEstbufoihL6Tec/j1Aw8tCuSewe9s367I+k6Fc6HaXQJZlQdnAECjNb@vger.kernel.org
X-Gm-Message-State: AFuF++lj1PAmAF0C2GmdCwLwE/rQ8wO3LFqSQ+tx71HVbsCsHBYtaerf
	LRh3qL1mrxOw1+SFgfvdDzpizIWzYBL23Uk++krOYoYa2aBsT9rf38mVFeDC9c/gOKI=
X-Gm-Gg: AYBFou3WzwbhLqcDMYvFd174ztCoNIxxAwIG+TY0NDvXwv/VVdjWZ2+aZqpfZU2twC6
	/aiSPL5VGX31TO4mRSu2nU7Yc6zqC8/2iYREYwCs6NikX6/jPKRy2V4ttpszjn+3uHzFc9hjitc
	EdATzR0pWh/xCfkw6Czqo5PEZLzAz+0z7DcRQbKS6EQT81zDDRDLdrHHgihiGq2mc9o+QJASSp3
	LRCWor52vIQ5CDYkCi5rko8ikUZg85Swi0tfVE3TDKHakwxYMuv9wuYCXCZj5I4gJptujCA7b9p
	pQ6SdI1J0UkKg+E+MdEEBfI9TVNFSWpuhWKTV03RmibWYKuEoXgbQlhzqYMkJzSDxVYydF2aMPF
	dupFTge1v6ZviOObKge9/jXkeo8jFEDqc5WpDkO2ADDY+LisdEiLTJcx43Kx890oLo48RHRgOHj
	hIXOIqnQE0sPXz0MgbwY9fiT+otGg7V5xS0Uq9ePo1i0U3fpHYDPVvk8Y0NGYCTws9
X-Received: by 2002:a05:600c:3b01:b0:49b:4d64:bbc4 with SMTP id 5b1f17b1804b1-49cf81f1592mr513548485e9.8.1788882945317;
        Tue, 08 Sep 2026 08:55:45 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5f912esm501130535e9.4.2026.09.08.08.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:55:44 -0700 (PDT)
Date: Tue, 8 Sep 2026 17:55:43 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Noah Feldt <noah@feldt.systems>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, N.Feldt@mittwald.de, carnil@debian.org, dschatzberg@meta.com, 
	hannes@cmpxchg.org, peterz@infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] cgroup: Avoid iteration of dying tasks with zero
 refcount
Message-ID: <aqAtv3WVn51LN3E8@localhost.localdomain>
References: <20260907192723.72167-1-noah@feldt.systems>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zwoag2cpocblfvef"
Content-Disposition: inline
In-Reply-To: <20260907192723.72167-1-noah@feldt.systems>


--zwoag2cpocblfvef
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] cgroup: Avoid iteration of dying tasks with zero
 refcount
MIME-Version: 1.0

On Mon, Sep 07, 2026 at 07:27:32PM +0000, Noah Feldt <noah@feldt.systems> w=
rote:
> Hi Michal,
>=20
> thanks for the v2. I tested it on the same production node and with the
> same reproducer (the 2nd PoC) that triggered the original crash.
>=20
> Result: it no longer panics, the use-after-free of the reaped leader is
> gone. But the node now hard-locks up instead. dmesg is attached as
> prod.log (module lists trimmed); the relevant part is:
>=20
>   watchdog: CPU24: Watchdog detected hard LOCKUP on cpu 24
>   RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
>   Call Trace:
>    _raw_spin_lock_irqsave+0x3d/0x50
>    cgroup_task_dead+0x29/0x140
>    finish_task_switch.isra.0+0x238/0x2c0
>    __schedule+0x4ec/0xfe0
>=20
> i.e. one CPU spins forever holding css_set_lock with IRQs disabled, and
> the other CPUs pile up on that spinlock until the NMI watchdog fires on
> several of them.

I bothed the loop...

>=20
> > First, I replaced the if() with a while() loop because when one such
> > dying leader could remain on dying_tasks, there can be more of them
> > (matter of effort) and single css_task_iter_advance() won't be
>  enough
> > (we need to skip all such tasks before get_task_struct()).
>=20
> The while() is what locks up:
>=20
> > +	while (it->task_pos && it->cur_tasks_head =3D=3D &it->cur_cset->dying=
_tasks) {
> > +		task =3D list_entry(it->task_pos, struct task_struct, cg_list);
> > +		if (!atomic_read(&task->signal->live))
> > +			css_task_iter_advance(it);
> > +	}

=2E..and after I hit Send, I realized it might be unnecessary thanks to
implicit loop via `goto repeat;` in css_task_iter_advance(). But then
there's CSS_TASK_ITER_WITH_DEAD which needs additional care
(fortunately, this flag is not used by those userspace users, so the
if-variant would be sufficient to fix the race in non-sched_ext
scenarios).


>=20
> A LLM helped me debug this
>=20
> When the leader is still live, atomic_read(&task->signal->live) !=3D 0, so
> the if() body is skipped, css_task_iter_advance() is never called,
> it->task_pos never moves and the loop condition stays true forever. A
> live dying-list leader thus spins the loop under css_set_lock -> the hard
> lockup above.
>=20
> The loop has to stop on the first live leader (that is exactly the task we
> want to hand out) and only advance past the dead ones. Turning the skip
> into a break makes it terminate. The variant I tested:
>=20
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5209,6 +5209,7 @@
>   */
>  struct task_struct *css_ta
> sk_iter_next(struct css_task_iter *it)
>  {
> +	struct task_struct *task;
>  	unsigned long irqflags;
>=20
>  	if (it->cur_task) {
> @@ -5222,6 +5223,22 @@
>  	if (it->flags & CSS_TASK_ITER_SKIPPED)
>  		css_task_iter_advance(it);
>=20
> +	/*
> +	 * @it->task_pos was picked on an earlier call. A dying leader stays on
> +	 * dying_tasks until cgroup_task_free(), past its last usage ref drop,
> +	 * so it may have been reaped since and get_task_struct() on it would
> +	 * resurrect a task about to be freed. That last ref is dropped by an
> +	 * RCU callback queued from release_task(), after signal->live hit zero,
> +	 * so a leader still showing live threads in this irq-disabled section
> +	 * can't lose its ref before the section ends.
> +	 */
> +	while (it->task_pos && it->cur_tasks_head =3D=3D &it->cur_cset->dying_t=
asks) {
> +		task =3D list_entry(it->task_pos, struct task_struct, cg_list);
> +		if (atomic_read(&task->signal->live))
> +			break;
> +		css_task_iter_advance(it);
> +	}
> +
>  	if (it->task_pos) {
>  		it->c
> ur_task =3D list_entry(it->task_pos, struct task_struct,
>  					  cg_list);
>=20
> Same reproducer after this change: no panic and no lockup, the node stays
> up under the load that reproduced it before.
>=20
> Tested-by: Noah Elias Feldt <N.Feldt@mittwald.de> # while-variant with th=
e break

Thanks, factoring the live count into the loop is what I should've done
with the loop.
Though, the fix loses a bit of elegance. Hm, thinking...

Michal

--zwoag2cpocblfvef
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaqAv+xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjGBwD/f2Y2iVrTgbxg/qzozsM7
7pNj1MPifZ0yK1TvAtBYi5EA/iyXE0yNdFfYjuHLfjeGWW7DuKLIMxrJ0VDLy1xT
3hIC
=cwT4
-----END PGP SIGNATURE-----

--zwoag2cpocblfvef--
