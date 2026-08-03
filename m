Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12837422556
	for <cgroups@vger.kernel.org>; Mon,  3 Aug 2026 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785778315; cv=none; b=bqAbFxmXlRHckzxofItl/mgFeslOlDlId76lgFAdPuuV0nFnUKOhMkaqt36XKpE2zx3FSxJvgUhj+2K1uP5W0bPEsli7ZHwC9Qs7yHYpmWApFiwaGQvmU1B6AiPo+nGHu6jzEI6feYoC5CtC8UJyWEIVK75VkczjkygL2otgTdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785778315; c=relaxed/simple;
	bh=T5FO2gzUq2TJBXqsHZoZ/FLNnkOUkZbdb2H+bBi1wYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j654pvkLQ8hIK4ssHpqU5oPbWzWKMH/LemR82b9Is6A8NaM3aAtG/r0FhYE0C2Mxd21rG8tNq2QP22E+NngSdrk2O4O459m09tiGbcLAUdxl0gxaHrCv8hmjYReH2vBwt/KYp3i9LIWLnNkD50nByfWsCK9/ob5hepp1V50JOjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6LhpyNa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6LhpyNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A368E1F00ADB
	for <cgroups@vger.kernel.org>; Mon,  3 Aug 2026 17:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785778313;
	bh=kP/as4F13JIZLEq7A3z9xVybs0LHJUVnzLyJAncMekY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G6LhpyNa1Vhjx5jvqEQrnshyjhLapNMnrCCk9UDAELk1mM2usl8xOnPKb2erTrypf
	 fKBzKmmjgC4iVC+MtyCY5Qj1qhDpIpMfuYD3uOx6EQLftQjF4//Cw1zvMgBCpK/HAy
	 Arj55ZvVpklCrnpkSGhGGQUApWcywzz95WP64h7Ry32gycTLGDsD+eLkHoFqD/zo77
	 zQex9keMt7n1Bs7Sv2I/0SDmg/3urwhmHHQKHsBv5wAZ2mGY1+Q1onwAvpNrjZmW2y
	 EOZKGmAE2GGSuU4xYwUC85eT6ZsujqpuBdavjIwR9uGot/4vyrkFLqgnogErVUFgtn
	 Ul7vCmfV2Rzgw==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6a0a4aa99bdso4256039a12.1
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 10:31:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpu7SKA8a/pJbVcCbLKedshwozxFsdl7UAhTFxaYQfzmZWxneYVfrVK4WifnrcH+UP06APme7ZV@vger.kernel.org
X-Gm-Message-State: AOJu0YxanTRU+Z10RCGRREsVQXlLihUFyHU8KGSIqMWMSVCKziSZCPbV
	MIgnbC9MwP/a/1mbdXCntGI3gNWxwgbx7smnhPECQxHeOzsXRJ0QvAfP5g6T5cPTlCzJpCuDaCS
	6kWZ8OmRocuMDb/f76qGtEb6xtNJF3I0=
X-Received: by 2002:a17:907:e1ce:10b0:c12:9e83:643 with SMTP id
 a640c23a62f3a-c1fe80ba536mr626054966b.10.1785778312482; Mon, 03 Aug 2026
 10:31:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260801041255.752039-1-wfelipe@google.com>
In-Reply-To: <20260801041255.752039-1-wfelipe@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 3 Aug 2026 10:31:39 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMRqS4JfqMPVc6GEDUFEVh0iGJ-aJ1Qkyc6HsZrX-5fqw@mail.gmail.com>
X-Gm-Features: AUfX_mxohrESAVBn6B2CetOPgdBGq9v0PbqUo2sqAAkMgwT_OKc2RepE-CGcklY
Message-ID: <CAO9r8zMRqS4JfqMPVc6GEDUFEVh0iGJ-aJ1Qkyc6HsZrX-5fqw@mail.gmail.com>
Subject: Re: [PATCH] selftests/cgroup: test_zswap: skip test_no_kmem_bypass if
 debugfs is unavailable
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 9:13=E2=80=AFPM Wilson Felipe Pereira
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
> Selftests should not fail when if debugfs is unavailable, and it

Nit: I think either "when" or "if" here :)

> should print a message when it is skipped.
>
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/=
selftests/cgroup/test_zswap.c
> index 49b36ee791606..c4f7b66f1b206 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -566,12 +566,19 @@ static int test_no_kmem_bypass(const char *root)
>         int child_status;
>         char *test_group =3D NULL;
>         pid_t child_pid;
> +       size_t stored_pages;
>
>         /* Read sys info and compute test values accordingly */
>         if (sysinfo(&sys_info) !=3D 0)
>                 return KSFT_FAIL;
> -       if (sys_info.totalram > 5000000000)
> +       if (sys_info.totalram > 5000000000) {
> +               ksft_print_msg("requires less than 5000000000 total ram\n=
");

The message is hard to parse, we should probably write 5G instead of
5000000000, and probably change 5000000000 to the actual number for
5G, 5368709120. I would write it as (5 << 30), MB(5 * 1024), or add
GB() to tools/testing/selftests/cgroup/lib/include/cgroup_util.h. It
might also help to print sys_info.totalram as well (in MB or GB).

Also, the comment above the function says 4G while this checks for 5G,
so maybe change this to 4G while at it (or update the comment).

>                 return KSFT_SKIP;
> +       }
> +       if (get_zswap_stored_pages(&stored_pages)) {
> +               ksft_print_msg("debugfs at /sys/kernel/debug is required\=
n");

IIUC get_zswap_stored_pages() can fail for other reasons, at least
theoretically, than debugfs not being mounted. Should we explicitly
check for the existence of sys/kernel/debug/zswap/stored_pages
instead?

> +               return KSFT_SKIP;
> +       }
>         values =3D mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT=
_READ |
>                         PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
>         if (values =3D=3D MAP_FAILED)
> @@ -604,7 +611,6 @@ static int test_no_kmem_bypass(const char *root)
>         /* Try to wakeup kswapd and let it push child memory to zswap */
>         set_min_free_kb(min_free_kb_high);
>         for (int i =3D 0; i < 20; i++) {
> -               size_t stored_pages;
>                 char *trigger_allocation =3D malloc(trigger_allocation_si=
ze);
>
>                 if (!trigger_allocation)
> --
> 2.55.0.508.g3f0d502094-goog
>
