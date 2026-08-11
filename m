Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B4C3F9F22
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786466497; cv=none; b=mwLQwmth+lou90v9xdyOxVEP4pcuZ5j7lRmfmg4zf/lxbuI1ZyitzWS+0zQY1XHQ90bW+AcGTQK+F5cHFiVPQS57LjwhoW+KcjADScm83/3l0HJfK6uiM1qlfZiHqiy9ivu9tHiTov3xGVyaT0EwfmX8US3SO12XJmjOflp4cnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786466497; c=relaxed/simple;
	bh=x+Epx2wcjNexkVxBVXOqQ5cvsB3ppFKz/3DXfzrT9Jk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ofsRpjlX8xUObj2KOOnHLw4g4PACJbk2NcER6WSxLKdg+ctoasboo9GxbKIiTqSLX4wcIxx0ELZiL4jKS2WdwjKkHHQ1Ss5kssgzFmyaKXUWmu1jT5PcXLiHgodqv8NXeZdEWCpn1F47I19tKqAQ83PWxeG9s7cF6yGJlIVLIVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTpKkC4R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTpKkC4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0481A1F00ACF
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 16:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786466496;
	bh=x+Epx2wcjNexkVxBVXOqQ5cvsB3ppFKz/3DXfzrT9Jk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GTpKkC4Rq+5o1GLM67JrgD5Ts2W14rznWSwUh7c6Sg0ce76FoteLtiJimwgpdwR1R
	 vhJ1dpIXdCmcNKrfF7tvG6J9trkTfyJyo5dm+fmQ/wRh3AAhzR/izfi9cGhUwmnVFf
	 M6aVZBMrjMRqPXKq3m4UMB31d6enh/3+wqqPB9lXYjHMhdkBOoBnC6Pb50Pd0I1iET
	 ynKQ04DjY3yxYtvn8MpBaECWT4hVVVilpiGxds/0z1HVJB8P6gDEdpxbnIHh3PdKEt
	 eEoVxoVg3haiTGKfidC2aqkWomiWcNHs5O0yEV23q6X1o911qySiozztxRtsiP9EDw
	 C6g7V9Otm5PTg==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a10b20634fso12029a12.3
        for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 09:41:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqnk7IQ7IPESuqZWdmjAcE9xVaT1SbP2BU+G34Eq5dXlt8EgPfUV7VXyWS1GlC4wYZDao8s3POG@vger.kernel.org
X-Gm-Message-State: AOJu0YwkC9hSsVYnZhmzBVoD61pmE1jpfD/K196+AFBWzm1Y+zXjAXTV
	3ow2s1Ao+N6x8b6qQbKFkOHQ8fYqdv2LQv1zUTbPSauZqw0+2hb0xtCXjDsn/lz8QHlpJuTuun4
	Wlrx08qcQplmyvGHILVSe3nSbLOdJNPM=
X-Received: by 2002:a17:907:d23:b0:c16:3074:657f with SMTP id
 a640c23a62f3a-c20eca2225emr84178166b.9.1786466494869; Tue, 11 Aug 2026
 09:41:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260811051434.3805648-1-wfelipe@google.com>
In-Reply-To: <20260811051434.3805648-1-wfelipe@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 11 Aug 2026 09:41:22 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM0K_--=jMxuapkFxnbqBj6zqvz3GB9wmEjgDThQpzZkw@mail.gmail.com>
X-Gm-Features: AUfX_mznkferW2-XpPGZ2Jv6GhtHO1zTusbpGxdHEOAp7Q0jgcIPVx3r3MKO9os
Message-ID: <CAO9r8zM0K_--=jMxuapkFxnbqBj6zqvz3GB9wmEjgDThQpzZkw@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/cgroup: test_zswap: skip test_no_kmem_bypass
 if debugfs is unavailable
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10, 2026 at 10:14=E2=80=AFPM Wilson Felipe Pereira
<wfelipe@google.com> wrote:
>
> test_no_kmem_bypass() needs to read
> /sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
> verify that compressed pages are charged to the memcg.
>
> When running in an environment where debugfs is not mounted or
> CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
> loop to terminate early and report a false negative (KSFT_FAIL).
>
> Selftests should not fail if debugfs is unavailable, and it should print
> a message when it is skipped.
>
> While I'm here, also add a warning message if the test is being skipped
> due to totalram size and make the check for totalram more readable.
>
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>
