Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648723BADB1;
	Wed, 16 Sep 2026 08:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789546952; cv=none; b=Gd4F9QXTlGb8FrLHWffrjtIxgLI49XJ37R8WqFjJelStq4udeP8HzG7f+qTs+EIi8O4lm/vngHdhe+CTilDtOZ9QY4qhLiAnVlQJWEr2J9BUldKgZXZpOPBLKNcnhh/P0utky7kl8/vTtQ+HGBRGOrGfV/qLmAyrldljhFE9C/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789546952; c=relaxed/simple;
	bh=/2DWkwAr4DbilIKZi5zshYXsB8JYRx9NpzZk7GA/7eY=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=e8+W0szN4AUKYcyUfiH/pE31GD3Ow/Ib/u74CNRDOS7Sr0iLz8Rrs6iJ4+3AahYg5JrUCagRia081kphFlc3HyamBaMOpeZstdSttBO2+A+X9DMF8Ndny6rU/FB7VcvY5yaYvaEjl7Zu696Yijs/d/P798Tt8hhUwrFdy15Guss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9kJ4uXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9kJ4uXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04841F000FF;
	Wed, 16 Sep 2026 08:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789546935;
	bh=ypMNq+uBTf3bV0CvKLttQpjmF2H7YeAIaADnmZI1vjM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Y9kJ4uXTO8jmgCrbabFZrGG+Cqu40q+3yBPBFjRCxeEkcAJ1SRZ/H89hbQe5z8w89
	 Fi9gMsrOIaWTkPHU6Z1O9nZjGEXyqJhLCxwViizvownKur6BfX/MrBOJG6DXFnWAOH
	 V5Dd5q4wz/bPTyZNGAQkocKkxZlk8034cB2zHzCbqVs6rCcVuv0u1J3fnY2JD/z/o+
	 SyvrY+p1ei9y3FZx5Ge+FpI8UkcZ8j+XJiUY7/6hvmBbkIu+fs9J4x8oxFoHjRCoHt
	 NWZhmCLG2N9BtlgxQExVcY/Nj3qeXi5ZkRzuZiQx+Bx+6u8i4mfb9U7IiXn0Lve3Xo
	 7wsXa5wYt3CjA==
Content-Type: multipart/mixed; boundary="===============0215795013638696076=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <a68ffeb7497f88f7798107f2d93c0ca707fbbb5f1a080f8f268eb5d13367159d@mail.kernel.org>
In-Reply-To: <20260916072302.1068871-6-cui.tao@linux.dev>
References: <20260916072302.1068871-6-cui.tao@linux.dev>
Subject: Re: [RFC PATCH v4 5/5] docs: cgroup-v2: document io.cost model=<name> binding
From: bot+bpf-ci@kernel.org
To: cui.tao@linux.dev,tj@kernel.org,josef@toxicopanda.com,axboe@kernel.dk,ameryhung@gmail.com
Cc: cgroups@vger.kernel.org,linux-block@vger.kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,andrii@kernel.org,ast@kernel.org,daniel@iogearbox.net,linux-kselftest@vger.kernel.org,cui.tao@linux.dev,cuitao@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 16 Sep 2026 08:22:14 +0000 (UTC)

--===============0215795013638696076==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 86a2a0099178e..5786d86eceeae 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst

[ ... ]

> @@ -2120,6 +2120,18 @@ IO Interface Files
>  	parameters are written to, "ctrl" become "user" and the
>  	automatic changes are disabled.
>
> +	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, "model" also accepts
> +	the name of a registered iocost_model_ops BPF struct_ops model:
> +	"model=<name>" binds the model to the device and the model fully
> +	replaces the builtin linear pricing, for every operation including
> +	flushes; "model=linear" (or "ctrl=auto/user") restores the builtin
> +	model.  Writing an unknown name fails with ENOENT and nothing is
> +	applied.  Unregistering a model removes its name so it can no
> +	longer be selected; devices already bound keep using it, and keep
> +	receiving cgroup lifecycle notifications, until switched back to
> +	the builtin model.  See
> +	include/linux/blk-iocost.h for the model interface.
> +

Does this section need to document what io.cost.model reads back with
a BPF model bound?

Looking at ioc_cost_model_prfill() in block/blk-iocost.c, when a BPF
model is bound, the file prints:

    seq_printf(sf, "%s ctrl=%s model=%s\n",
        dname, model ? "bpf" : ioc->user_cost_model ? "user" : "auto",
        model ? model->name : "linear");

So with a model bound, io.cost.model reads back "ctrl=bpf model=<name>".

The nested-key table nine lines above this paragraph lists the possible
values:

    =====           ================================
    ctrl            "auto" or "user"
    model           The cost model in use - "linear"
    =====           ================================

This table doesn't include "bpf" as a ctrl value or "<name>" as a model
value. The new paragraph also doesn't mention that "ctrl=bpf" is accepted
on write - ioc_cost_model_write() special-cases it so saved configurations
can be restored:

    } else if (!strcmp(buf, "bpf")) {
        /* readback value; keep the bound model */
        continue;
    }

Should the table be updated to include the "bpf" ctrl value and the
"<name>" model value, so the section documents what the kernel actually
prints?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35070283830
--===============0215795013638696076==--
