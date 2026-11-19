Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795063972;
	b=EQl6vI5EJGFOO+6MlsuZ5ep/W5TciMyu4xf5M3yugeRW0kgvMkWTY1TH6iU9R8QwJQwf
	 XvSZjjflyK+GLv0+NGiBsEd8acrB18EphNhaIwYWTlLb7B1qu1Si4a6rEO+O6LQkrMM9y
	 2C8SZRpXD/O95pnqgEDtHvhTt2H1F8qrEkYLRTD8hY9mAmJTV3rFKNtwpQTGGk284/4ON
	 48rp9LFlLrA37P9+DzNqn+heJmaOD+jExuyqolDVfN/a9jOeJUlp+I2+5dSXsENMk3cyh
	 OvgukGykxYHRGkABSX2Y++CkQbFLOZtJBOOV9d/EZs3vU+dgDHPp5C21SrHmOp2odAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795063972;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=9i+UKZPZ3OpK5ILgjI5giVoNBCsGXWxAGZS6reZxXwU=;
	b=E/uz/8ynhXRDrARTjvvIaSSu0g3lah0HXGmFgmD7bDGIJOV55Yevz4PpM9Dr8vzGrYJZ
	 EKAK/M5vgjkSQMCTlEioDkg05G5UTwWRSL/LBizcUwjj3c648qEr4VEhdTxJifmbRbA3j
	 QZo5o2klfzPwq7j9uTiey7kamYkXQN0dZZewLDVxQIhLYKRF9/DD+bbG3WrTs6S5Wkku9
	 GiZyH60jpzz1LQAo6XUCwAn0ieRRwg82bvH3a9eSg62HBPJWOMd8Ud5o7xPFOamZEDwhp
	 D+14ujjwihhmCecx11JP0zxrSGkYjSvUMkWFcjeHAiPsr6VSqia23sIS9RR1dQGrQtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="O9/IEtKF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED199606A320;
	Thu, 19 Nov 2026 04:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O9/IEtKF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554B31F000C4;
	Thu, 19 Nov 2026 04:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795063971;
	bh=9i+UKZPZ3OpK5ILgjI5giVoNBCsGXWxAGZS6reZxXwU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=O9/IEtKFhAwxtSQQ20gIkbGS6jtMNiV9GameG4+c4WUkp0KXzIoV56y3DUCygFCne
	 fLOud+eFCn0vUUTKCcGgs9SDjzHj3MKrR6vyohE+DDLorBYe6DssRYEfq0rgAX0Em3
	 6y+r3abPLOZCLeXqdFTHbzKnqW4fCjm/eYlKSIaRDVGJgs4Z5XbZA36SFNeZZJEskZ
	 01aM/ZQl8wSimCP9er9CJuwHazOkfp89Q/0VDE3Pe56NEroDcQy05tSe1gwi047e4D
	 RWBycPCqVyiiMLFUxjkVeBaCfklppnp9a/xnU/HVQB8P0iwFXchJbxAD4BWDUX7j6y
	 v617XEMvSWjDQ==
Content-Type: multipart/mixed; boundary="===============5775708092211357052=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <c90c3d1dfacea3d6a30445bc33ca8e0de75c9fae953a4b9e842dd3dc887a3dce@mail.kernel.org>
In-Reply-To: <20261119040705.684987-3-atomlin@atomlin.com>
References: <20261119040705.684987-3-atomlin@atomlin.com>
Subject: Re: [PATCH v6 2/2] selftests/bpf: Verify task_setscheduler LSM hook parameters
From: bot+bpf-ci@kernel.org
To: atomlin@atomlin.com,tsbogend@alpha.franken.de,paul@paul-moore.com,jmorris@namei.org,serge@hallyn.com,andrii@kernel.org,ast@kernel.org,daniel@iogearbox.net,eddyz87@gmail.com,memxor@gmail.com,mingo@redhat.com,peterz@infradead.org,juri.lelli@redhat.com,vincent.guittot@linaro.org,stephen.smalley.work@gmail.com,casey@schaufler-ca.com,longman@redhat.com,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com
Cc: ihor.solodrai@linux.dev,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,chenridong@huaweicloud.com,dietmar.eggemann@arm.com,rostedt@goodmis.org,bsegall@google.com,mgorman@suse.de,vschneid@redhat.com,kprateek.nayak@amd.com,omosnace@redhat.com,kees@kernel.org,atomlin@atomlin.com,neelx@suse.com,sean@ashe.io,chjohnst@gmail.com,steve@abita.co,mproche@gmail.com,nick.lange@gmail.com,cgroups@vger.kernel.org,linux-mips@vger.kernel.org,linux-fsdevel@vger.kernel.org,linux-security-module@vger.kernel.org,selinux@vger.kernel.org,bpf@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 19 Nov 2026 04:52:49 +0000 (UTC)

--===============5775708092211357052==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> selftests/bpf: Verify task_setscheduler LSM hook parameters

TL;DR: Nit only, in the new task_setscheduler selftest: the restore_sched flag
and the saved_policy initializer look redundant, so the scheduler restore at
out: could be unconditional.

> diff --git a/tools/testing/selftests/bpf/prog_tests/test_lsm.c b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
> --- a/tools/testing/selftests/bpf/prog_tests/test_lsm.c
> +++ b/tools/testing/selftests/bpf/prog_tests/test_lsm.c

[ ... ]

> +static int test_lsm_task_setscheduler(struct lsm *skel)
> +{

[ ... ]

> +	int cpu, saved_policy = -1;
> +	pid_t child_pid = -1, waited;
> +	bool restore_sched = false;
> +	bool restore_aff = false;
> +	int len, ret = -1;
> +
> +	saved_policy = sched_getscheduler(0);
> +	if (!ASSERT_GE(saved_policy, 0, "sched_getscheduler"))
> +		return -1;
> +	if (!ASSERT_OK(sched_getparam(0, &saved_param), "sched_getparam"))
> +		return -1;
> +	restore_sched = true;

this isn't a bug, but since every "goto out" happens after
"restore_sched = true", could the restore_sched flag (and the
"saved_policy = -1" initializer, which is overwritten by the next
statement) be dropped and the restore at out: done unconditionally?

[ ... ]

> +out:
> +	skel->bss->setsched_deny = 0;

[ ... ]

> +	if (restore_sched)
> +		sched_setscheduler(0, saved_policy, &saved_param);
> +	return ret;
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44458173002
--===============5775708092211357052==--
