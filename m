Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DDF282F10;
	Sat,  3 Oct 2026 13:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791033677; cv=none; b=kzKXgj+La8pnrz6n0aJPccJjQD21nmEzePD3z+tKOw6s0weJuIK9wGUhgmYAJKGj5FKZBa2OXSEwHquizWerArAlGpzNnEU2XgvtOBJdvsdtJ5qgN6xM2jHCmr0IIu6IhP2vCDLG5NixgqRv/7sR0t/O/q2/Z2EjDfL1j+88Cq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791033677; c=relaxed/simple;
	bh=OgWRDCseSOcECD+VaozqY/IsmGTJFYeVL2pF7PjDCLk=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=syTRAamMUD1u0qHqSnMBavdatV0rjAVUwJtAYVVk4G86R+gWF/lNeRmEVh72u3xBfU8NvrLcvmYcLJ8OKrmeVh+3MrQ3sMGm2YjDqjDAuM+y1VXyK3c6NMToAhvVTUlrkQn70wXvxcFDIpnE8l5uMS39mEN6p4v03pH1ew/eIL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+au7Aul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+au7Aul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793A71F0089B;
	Sat,  3 Oct 2026 13:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791033676;
	bh=ec7b3OutVKPOVy/UUB7OgXJ1H/58+H1/d7IPRSyBLLI=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=d+au7Aul5EsJqvnDVxpepy7FAxeTs0pI54/tYEKUP9xdIteHansZT89tQJh88NxZ5
	 9BXkm7uPU/C6fccyr8ONgawvCQS6I37gs9M6OcRvtVJZBQ8OrXgd2J2SqaFa2vfP73
	 H0/GLPAR3dvIUbuanZFBBGHwHvK3JhGnCS5q+BrrHsK0Q2Y0Ert6Qm0mQLCBWJNlNf
	 zHu+ZjXSgjZD5x9b8hZnfTUJ4PcK+swf5FYBCgCT5OQZ62zcUgm1na4ARGSJrCG3HO
	 OjZveg+ebXmZqQTsae9scZaSUSebrYuUppIloNlvEWjhF2b89nYebSNX62SAHDHbSl
	 MwwAqZ84gilHw==
Content-Type: multipart/mixed; boundary="===============4739544272481822876=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <2724abaa8a55c8de46c9c1c9a849397252ae0d7d1585dbf9305c289e816b498e@mail.kernel.org>
In-Reply-To: <20261003124045.1289305-2-cui.tao@linux.dev>
References: <20261003124045.1289305-2-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v10 1/4] blk-iocost: add BPF struct_ops cost model support
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ameryhung@gmail.com,alexei.starovoitov@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sat,  3 Oct 2026 13:21:14 +0000 (UTC)

--===============4739544272481822876==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> blk-iocost: add BPF struct_ops cost model support

TL;DR: Documentation issue only: cgroup-v2.rst isn't updated for io.cost.model
accepting "model=bpf", and writing "model=linear" now switches a device off an
attached BPF model, which may surprise existing tools.

> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 2745bffcd5ee..509ae36f99ed 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c

[ ... ]

> @@ -3536,9 +3961,25 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
>  			continue;
>  		case COST_MODEL:
>  			match_strlcpy(buf, &args[0], sizeof(buf));
> -			if (strcmp(buf, "linear"))
> -				goto unlock;
> -			continue;
> +			if (!strcmp(buf, "linear")) {
> +				/* staged and committed below, so a parse
> +				 * error later in the same write leaves
> +				 * the model selection untouched
> +				 */
> +				new_model = NULL;
> +				model_write = true;
> +				continue;
> +			}
> +			if (!strcmp(buf, "bpf")) {
> +				new_model = rcu_dereference_protected(
> +						ioc->attached,
> +						lockdep_is_held(&ioc->lock));
> +				if (!new_model)
> +					goto unlock;
> +				model_write = true;
> +				continue;
> +			}
> +			goto unlock;
>  		}

Does this change to the io.cost.model interface need a matching update to
Documentation/admin-guide/cgroup-v2.rst?

ioc_cost_model_write() now accepts "model=bpf", and "model=linear" is no
longer only a value check.  It now clears ioc->model and moves the device
off an attached BPF model.  ioc_cost_model_prfill() can also print
"model=bpf".

The documentation still describes the key as:

  model		The cost model in use - "linear"

and says nothing about "bpf" or the new effect of writing "linear".

Existing tools that write lines like "MAJ:MIN ctrl=user model=linear
rbps=..." will now silently switch a device away from an attached BPF
model.  Could cgroup-v2.rst be updated to cover the new value and the
changed semantics?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/37124306614
--===============4739544272481822876==--
