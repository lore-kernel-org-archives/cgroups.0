Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794385701;
	b=2CXc+DlWK6edoAgkWmxp3DGtAy+IU4mc81c8EaGziUXLlLdJSeXHDAxUJYct0gyblPTn
	 YamwpYF4HeKR7zYhMEGbIxnCJpQUvtmvsU3VlKlwJH399x/5j5NuG0+vGJFclNmv6NWJ1
	 DCCgBp7sLN/G4/x/19MWCIlSxlV81ZcPuNhxQJdMLgAd8ZGnRcyZWtF8TlgEi1U6k7SCq
	 Tc9TjYzFhV6bwxUsYsNsJb+boAwAR8ZUjsVyXH2z56UL1AGPAzpDnEm48wrdGmuRR5KQB
	 d/vST9MmWzrzQuNdmFsAAtPUPrWSuY6FhUA7UPavSFqhTqJBK+uQWLOmz/aRgFVSrBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794385701;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=gcIKN4jsIQlyGqAhuZyA/IGoRoSGh5xeSKn5q/FW1ss=;
	b=5LS0QQ+RY1QTPLK84F3e2DK+PEk41byqsgN1B+gWrWicezsssv5L1Pvba8RTLaE/X+cV
	 FtL/GxljaJDymqqQvlFbhJvpdbopHukz4OOqTlnhMLyiT8PQcYDRgvDfpkm+p5QShpLX5
	 yAyzDIvXFQv3g4tsRoNF55n4ymbqRh5cl+Et7wnMPV9m+fD5dR1UHPND9xkYa7HQuHk7T
	 DTGNfj//0VS060pyMg9o9tH12MQiGNB6XMbiXbnj02f5a33aacg8uAUWcVVxKdDP7Wsib
	 hm0hV8FbWSsxFDczgi0DBdcgDzSc5X7imRsrf5xMvaYKhRo9DUYosSkykZxClijvElA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DOKn+x4R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D085960A2619;
	Wed, 11 Nov 2026 08:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DOKn+x4R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DDF1F00A05;
	Wed, 11 Nov 2026 08:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794385701;
	bh=gcIKN4jsIQlyGqAhuZyA/IGoRoSGh5xeSKn5q/FW1ss=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=DOKn+x4R0Lt241rvPfHbxLwI3TJZ73SkJeFKg3QHd4Sjlu+UXEvaHs3kOxAQVdmXd
	 7EMaFty5yM9ipJC6s+Bu6ihn0z/25MASyoU2hRvYOK0+gIjvnKpfxtKywyZ99nsAzt
	 XPQ5HqOgYzS78Tjln5IBCxiL3rqcTYZCCJW+hc5rjO5GDhjxYjW0TeGTSpuKaqqdg7
	 08b9g6UCwVtayD1B//JXQbRGH/HmvqPHEqWQhbxCeA4ZRm+09K6P98PCo2SkQJhP+e
	 ybREy979hEcgrIiSX0v5mwUZ49sbflsjOYXT0DEGoBcq6j/7zIKTput0MA99eNuaPD
	 SWmPOxL9NpQtw==
Content-Type: multipart/mixed; boundary="===============0887953150388126547=="
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <804b992eb8d1be9849d102cff1b87303b024cde4b09e16c4a18842a53f2196da@mail.kernel.org>
In-Reply-To: <3977ed2471c6fdc19c672b2dcd13c70f997b9eff.1794303670.git.sieberf@amazon.com>
References: <3977ed2471c6fdc19c672b2dcd13c70f997b9eff.1794303670.git.sieberf@amazon.com>
Subject: Re: [PATCH v2 4/4] sched_ext: charge BPF scheduler tasks to cpu.max bandwidth
From: bot+bpf-ci@kernel.org
To: sieberf@amazon.com,mingo@redhat.com,peterz@infradead.org,juri.lelli@redhat.com,vincent.guittot@linaro.org,tj@kernel.org
Cc: bsegall@google.com,dietmar.eggemann@arm.com,rostedt@goodmis.org,mgorman@suse.de,vschneid@redhat.com,kprateek.nayak@amd.com,hannes@cmpxchg.org,mkoutny@suse.com,void@manifault.com,arighi@nvidia.com,changwoo@igalia.com,skhan@linuxfoundation.org,corbet@lwn.net,rdunlap@infradead.org,cgroups@vger.kernel.org,sched-ext@lists.linux.dev,linux-doc@vger.kernel.org,linux-kselftest@vger.kernel.org,bpf@vger.kernel.org,linux-kernel@vger.kernel.org,nh-open-source@amazon.com,hborghor@amazon.de,fmubeen@amazon.de,dwmw@amazon.co.uk,karataev@amazon.com,sieberf@amazon.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 11 Nov 2026 08:28:19 +0000 (UTC)

--===============0887953150388126547==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> sched_ext: charge BPF scheduler tasks to cpu.max bandwidth

TL;DR: Nit only, in the selftest: join_path(), cgroup_id() and
controller_enabled() in cgroup_runtime.c duplicate helpers in
cgroup_nr_cpus.c; consider moving them into shared util.c/util.h.

> diff --git a/tools/testing/selftests/sched_ext/cgroup_runtime.c b/tools/testing/selftests/sched_ext/cgroup_runtime.c
> new file mode 100644
> --- /dev/null
> +++ b/tools/testing/selftests/sched_ext/cgroup_runtime.c

[ ... ]

> +static int join_path(char *dst, size_t dst_size, const char *parent, const char *name)
> +{
> +	int ret;
> +
> +	ret = snprintf(dst, dst_size, "%s/%s", parent, name);
> +	if (ret < 0 || (size_t)ret >= dst_size)
> +		return -ENAMETOOLONG;
> +	return 0;
> +}

[ ... ]

this isn't a bug, but join_path(), cgroup_id() and controller_enabled() look
identical to the static helpers of the same names in cgroup_nr_cpus.c.

Could they move into the shared util.c/util.h so both cgroup tests use one
copy?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/42982707042
--===============0887953150388126547==--
