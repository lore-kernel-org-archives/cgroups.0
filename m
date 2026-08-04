Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41058282F25
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 06:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785825569; cv=none; b=YCuYpqytyC92KvCcdHts+R9I9f0/vNiELAPqDt+L6OUuD70iiwtDd7nomjtiw+l8v895Puro8Sgeie9qGzj/J40xmGRyLWGeg5wX4vo+NvAGLU5O7PSFPRapDJqY+ajdsD4umFolZdqTJc1rg4wtqq/KnbRw0RFQ/Sg/JWDOAKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785825569; c=relaxed/simple;
	bh=pgVi1SZWaXZtqNRe5QAX3bGloShSKl9jFZpZkXPiY9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m/cwxl1vFEnUOeINcjSZ7G5iQ7SeVGEoUMhxNHX/ALJA450L+Bm/af/WimiBHUDkU1CxUYFwoVEptgkp7w7Hif8XtLRtKfbtNo1OwlvfHIxI6RmD2aK+4bXm05Lx9XQ1QLhOH7IbBd/dVSjxPg6QhWE2N1x1EmjXmDFxzgu6k3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lax2sRnc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lax2sRnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAAB1F00A3D
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 06:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785825568;
	bh=mU1jxAXIOnGCzCwaJcijbkm1YmngdrLG7RD1GBreZgg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Lax2sRnc9VYdS258yH9EUB8nLhx+azN89/95Mk6OdUaeaUplcrFRTpam3xq/TjP2S
	 L1YFfsj2nFvmTiiSc1Ne7fuhl25aJt+s1n56fIqloJLUYqZVoffLMDf7LeeJSBwM/2
	 RAYG2AhCirGLjA6bKROT8zjk3ENroq8W0G9DJjC98C/h3Cri87SKCsDpoT1Xb2IIrG
	 HCmxpBOiLJXobIcNyVh+IJSXojDndGAoCCKuwTOMDs9IoFj1AIOngKMPuwzqHx12zQ
	 rgzc7pORUoq+bHMalG7k+Iw24ajmonbXFNlv63Pxg19vpCsoWTLWdAIUXht/TdTBJE
	 UhLjcOEt3F1xA==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso1028847a12.0
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 23:39:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqU4jUNnVoiO2fW+dY+qiSf3MrJRMlPKZ/zS3vNz4ziq+emPsIo5AvVOvrZCiJpFZcb8gj7tgr7@vger.kernel.org
X-Gm-Message-State: AOJu0YwKkG8epFbWiAroJKeUka7ewngnL0NiaY6Ah4tuZ6+dj6D1znok
	VwXNingsD+ACUK6ezRDbubqQeE58NG6/Vl0CBkaVtlxvT3GDEOLfrM7e5+lLK2zGkd8mTy21U4+
	enIkP4a4s24ZN/dhG+U58HBjL04p+bGg=
X-Received: by 2002:a17:907:160f:b0:c1a:25cc:e585 with SMTP id
 a640c23a62f3a-c20245623e7mr287280466b.5.1785825567010; Mon, 03 Aug 2026
 23:39:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804042053.56940-1-wfelipe@google.com> <20260804042053.56940-2-wfelipe@google.com>
In-Reply-To: <20260804042053.56940-2-wfelipe@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 3 Aug 2026 23:39:14 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM9H8iMOE2FE-H47CMUAExf3VcCf04anT=_Ja=m=sbr4g@mail.gmail.com>
X-Gm-Features: AUfX_mx-Rb6alvBdGzN0qqGw85G49kPIP-4afrsul336V4PgR5cLjKtDxg-omjk
Message-ID: <CAO9r8zM9H8iMOE2FE-H47CMUAExf3VcCf04anT=_Ja=m=sbr4g@mail.gmail.com>
Subject: Re: [PATCH 1/2] selftests/cgroup: test_zswap: retry subtree_control
 write on EBUSY in test_zswap_writeback
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 9:21=E2=80=AFPM Wilson Felipe Pereira <wfelipe@googl=
e.com> wrote:
>
> When running test_zswap on a single-core VM (-smp 1) with 4GB of RAM,
> test_zswap_writeback reliably fails on the initial run after boot.

I see why this is related to having a single core, but I am not sure
why it would only happen for the first run after boot.

>
> In test_zswap_writeback(), after waitpid() reaps the child process create=
d
> by test_zswap_writeback_one(), writing "+memory" to cgroup.subtree_contro=
l
> can fail with -EBUSY. Under Cgroup v2, enabling domain subtree controller=
s
> is forbidden while any tasks remain in cgroup.procs.
>
> When a child process exits, waitpid() reaps the zombie PID immediately,
> but the removal of struct task_struct from the cgroup task list is
> performed asynchronously via an RCU callback (release_task). On
> single-core systems, this RCU callback is delayed behind CPU softirqs,
> causing "+memory" to fail if written immediately after waitpid() returns.

IIUC, the rejection to update subtree_control comes from
cgroup_vet_subtree_control_enable() -> cgroup_has_tasks(), which reads
nr_populated_csets.

This seems to be updated in this path when a task exits:
finish_task_switch()
cgroup_task_dead()
do_cgroup_task_dead() (in !CONFIG_PREEMPT_RT)
css_set_move_task()
css_set_update_populated()
css_update_populated()

So outside of CONFIG_PREEMPT_RT, I don't think the update is deferred.

Probably what's actually happening is that parent gets woken up
through do_exit() -> exit_notify(), then the task is marked as
TASK_DEAD in do_task_dead(), and finally finish_task_switch() calls
cgroup_task_dead()?

>
> Fix this by adding an EBUSY retry loop with usleep(1000) around cg_write(=
),
> matching the existing cgroup cleanup pattern in cg_destroy().
>
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/=
selftests/cgroup/test_zswap.c
> index 49b36ee791606..312d51887a1d8 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -407,8 +407,11 @@ static int test_zswap_writeback(const char *root, bo=
ol wb)
>          * Thus, the parent's setting shall be what's in effect. */
>         if (cg_write(test_group, "memory.zswap.max", "max"))
>                 goto out;
> -       if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
> -               goto out;
> +       while (cg_write(test_group, "cgroup.subtree_control", "+memory"))=
 {
> +               if (errno !=3D EBUSY)
> +                       goto out;
> +               usleep(1000);
> +       }

I would honestly rather create a new cgroup here instead of reusing
the leaf cgroup as a parent, to avoid any subtleties like this in the
future, or even split test_zswap_writeback() into two test cases. I
don't feel strongly though if others think the simple wait here is
enough.

>
>         test_group_child =3D cg_name(test_group, "zswap_writeback_test_ch=
ild");
>         if (!test_group_child)
> --
> 2.55.0.571.g244d577d93-goog
>
