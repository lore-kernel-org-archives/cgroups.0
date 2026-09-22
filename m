Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73DE54145E
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084685; cv=none; b=sM5ETTpROVANGmRVsnnazhbP/hj9BfdSKNa8aWx3H9l0RFdYKVTwBvOz+lUuSsywoU4xjTa6ANteD4fHeoDeAw0ku9MPQpgOoCQhfMJ3SpqywCePyIGB5XgMhFsqeikop02tYnmr7hK/i+YdDvhh8+AaXWOaX8+IWd9v4JDQhE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084685; c=relaxed/simple;
	bh=0SFlIh2a1t3j3rT/bk6IJh8ffwrgGJ66xEj1bDplnm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qCGpzc+Ey5gfnEKrz+iAr06dMJWv75MJVvLCxvW9hrXdqMu1HdYrpVbjAHMpLZyapIP4f9IcWGkXnsvbOyKSFiED5sfW0tYmVhBypQ04oaOWCkHg7iymXQXk5CfZU6dUFSHXMFJM6oSHyxK57MAbsEp4igmBDdeVas0tOdkwc5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FG4fpRXF; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FG4fpRXF"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912df756so29004705e9.3
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 06:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790084681; x=1790689481; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4EtP8Gib+oGUfFDioYcMAZLGT/7xIaokAymk9C8xEMA=;
        b=FG4fpRXFBPatSwHxsYfQSy0pnlWABIGE7/vTfeI5uP7FQoa6mxknWHjLYgdRO058e1
         fcgqXSB7kMUphrk21mipLbo8VZryb36WwtcH1zQKj0AMCcMUJFiV2dzC2w3yb1ODJ4hb
         kgT+cW6LvXNvOfDcofgnG2kSQpkX5XSHb9Pjxq2gCUMm0YMwuFy/QqzxDe3OHjKEZiuQ
         5fo6yOe30L2MUqtG7fjjCJtUx3oekSWTDubtoPEFnprtEIc7k/ktYBjhlwAIy956C50P
         Tks9iJsFgXFrU9SiF7t8ClxvP0wqEjeoZxv+SYAPxARsnji2dvghLBR9LHhnnT2uWNdl
         54ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790084681; x=1790689481;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4EtP8Gib+oGUfFDioYcMAZLGT/7xIaokAymk9C8xEMA=;
        b=ILlRXZiQbVG0DhvxIxjiJSoM2IxYSGRgCS+uYTpjTkUvHUuU/ozl1impgoZq6Zzh9w
         eIbHAQJ655/FeZ7GJN96f0fftabFIU4zb/nIu7xZmwPIHaODhze7RUBgwHw8WCdCz2Gu
         HE5rN5E6nBRPvpp7oiU1vRwBRh31lHu2K++fLp7ZyQviLGweicHGP5Jve1QcSLPn4UBH
         gWSuAv/UZ/hsAAS8edGwzd+fKnwaULVvRWo9RfhkA2A9NgPFn1Gx+Q4ix3Cg5Bqx7Fqo
         jnWszXQW8hDW1SiNtc5RS2k/ZBZQal73a9H7VK/qNEUjoxHmzdkRRJS4ZJdMAMm9pDF/
         mT+w==
X-Forwarded-Encrypted: i=1; AKwUvBzLrE5Ix+16wv29Vib1gGFcdX6HJKxY/Ta++k7atAb1vj5/Ef4m2UbOqWQ3mQoyMENhVym790xE@vger.kernel.org
X-Gm-Message-State: AFuF++miOUVTncI/1wXwmq3Omrw54tXGBO4BLoMTyKyJ6DKFFNcptewA
	XCP64pcYD8SwQQlhCFsPePVehsyBIeJBylZ51g5R3Yzo7ko9PrCE/BglR/2rTPdsCUg=
X-Gm-Gg: AYBFou3uNN1howTNOr/W5EU4PqDiGXhzjONukUeJIetSwZWTOV3GsKOhG0hJdTTl7ho
	ydgoXwo/BgLT1XCoy4plj/OGyvkOez9+mcaiZL/a+30bmvKo2vSXfP0h8E1/ghlz2ZmpkNVduPR
	CKqGwFMOf40F0tAEdzeLSrgCpwE+U8mnSU0xiexpvtpY3UfB4AnwWXkWFHTShluLXr7GkXYITRC
	9xh6qASKn5ZqKJhFa+u1ceI2+VX6BqgGaL+g9UEE77NJqZDb4JucLqJqIx/fawIEE812doWOzZQ
	La9i7h3IZBv1g1ctSnEz/LSaaQAQ6aMPgYwZpyDwLPeB3iRNh0sXwHkz9epo3kMgHMgyLGniQAp
	JR1uZ+gRvmQldtmQ+Z7jRFOvQ/zWoAIupvxMEXodCVxMBlcSUu/oCq0sD8Z+nLwn1PS7Cwn5a9a
	7ckmti7x85f/vvj7pU0OnofD8uv/8Remm2NvAFleKGm8ci02KRYavy31Fd7Flf6rTf4fIDIshWv
	Q==
X-Received: by 2002:a05:600c:474e:b0:49e:7cff:f8ca with SMTP id 5b1f17b1804b1-49fc5743c69mr189508785e9.29.1790084681055;
        Tue, 22 Sep 2026 06:44:41 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdad2a3e0sm72269425e9.5.2026.09.22.06.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 06:44:40 -0700 (PDT)
Date: Tue, 22 Sep 2026 15:44:38 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	James Houghton <jthoughton@google.com>, Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/cgroup: Make the object directory an
 order-only prerequisite
Message-ID: <arKFe3JRF3n2h-26@localhost.localdomain>
References: <20260922071945.693714-1-fuad.tabba@linux.dev>
 <20260922071945.693714-3-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wz67vp63rqm7k2iu"
Content-Disposition: inline
In-Reply-To: <20260922071945.693714-3-fuad.tabba@linux.dev>


--wz67vp63rqm7k2iu
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 2/2] selftests/cgroup: Make the object directory an
 order-only prerequisite
MIME-Version: 1.0

On Tue, Sep 22, 2026 at 08:19:45AM +0100, Fuad Tabba <fuad.tabba@linux.dev>=
 wrote:
> libcgroup.mk names $(LIBCGROUP_O_DIRS) as a regular prerequisite of
> cgroup_util.o. The directory's mtime moves whenever an object is
> created or replaced in it, so an incremental KVM selftests build that
> rebuilt anything in lib/ recompiles cgroup_util.o and relinks every
> test on the following run.

I'd expect the other test would recompile stuff in lib/ but not in
cgroup/lib/, however that distinction is likely lost when $(OUTPUT) is
expanded from the included *.mk file.

> Make the directory order-only, as libvfio.mk does.

Sensible approach given that vfio.

>=20
> Fixes: 2c754a84ff16a ("cgroup: selftests: Move cgroup_util into its own l=
ibrary")
> Assisted-by: LLM
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  tools/testing/selftests/cgroup/lib/libcgroup.mk | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--wz67vp63rqm7k2iu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCarKGQhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ah2DgEA8Xdl3JGOJIGtK6hwQh4u
Jb+PcelMIF9Zbpm+LvcVQysA/2EdCxDp5Lq6779UZxftUj9At2iFIuFnLA5vHe4p
ZbcI
=BJVd
-----END PGP SIGNATURE-----

--wz67vp63rqm7k2iu--
