Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3496C3EBF31;
	Thu, 12 Feb 2026 08:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770886235; cv=none; b=W2qzc7R4+mI9VIqwKqSdf8NoDmR+iKbl0qY3Z/IdmGpwPc7Szh5SwLe71+EExQRLnHa6f5NPFMD0lBnWJhk8k3H862FKWBh0Hhz4hXTZ/IzqpDZPidRrfES9IN3wKPKSMCaqKPsO3KJYHix5Cl+hgRAfen/mkJpRVlyt9DBEagQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770886235; c=relaxed/simple;
	bh=tFZNX6x5kQa3R5bh2C+SIIXI/4UmBn0oMjHEk4eUOEs=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=lXvFF0BX3yajI4TOFW+4MRSiIspqdWrkcm80dG/+hbMKdsTWSZ3kWl6WCF8xzVFyyLzYIe4YBOt2/cjfzVGIteN83sJp/xfSeP4iFURPGOTlHdGhwgIyL/oQ4HcESrddNFsllYoSWkv5uNyMieaB0mWDvpJ+60PSXqm3x6PzkKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNDmJQoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNDmJQoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 379E7C4CEF7;
	Thu, 12 Feb 2026 08:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770886234;
	bh=tFZNX6x5kQa3R5bh2C+SIIXI/4UmBn0oMjHEk4eUOEs=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=XNDmJQoV2PMqhuDh97GJvfMGlGBF7Q4ElssERNNNLKV2ldSnj4QlGhLAA9YAvptAG
	 4sTNQ55sWaWq9ec3QQPI+mvBLBCPKrLZ1WrcV8AuLDz3F7ojRZPae8DDf4HXxKBnrd
	 /KB9ua7da3oyfyjNSG7JGNdiWChdRIK0EYJ1yFoNBUYjK4Ts/BkMzFhFWZl1Loyl4r
	 EtvR6WUW/0tR63+S4ugd29vq+hmqVkrJzI0H/Z/Ion2miO6+CgocvMp7vrzl/EVhAQ
	 llK68uWfw68MNc4uXAJtGuyS5EmJ83OabHpPpA6SNX3xHXosfD+nnKagX/WuXvUELv
	 f3UNhYxZ1Zq9A==
Content-Type: multipart/mixed; boundary="===============4217100397236680912=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <0d926bdc5b5e030fafc82de73c3f3e5412c051fc6763f77da9ea6aa316bd8f13@mail.kernel.org>
In-Reply-To: <042df9438d9e78bcd66f1fa0e7043b9ea8cda96c.1770883926.git.zhuhui@kylinos.cn>
References: <042df9438d9e78bcd66f1fa0e7043b9ea8cda96c.1770883926.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: Check bpf_mem_cgroup_page_state return value
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,eddyz87@gmail.com,song@kernel.org,yonghong.song@linux.dev,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,haoluo@google.com,jolsa@kernel.org,shuah@kernel.org,zhuhui@kylinos.cn,inwardvessel@gmail.com,cgroups@vger.kernel.org,linux-mm@kvack.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 12 Feb 2026 08:50:34 +0000 (UTC)

--===============4217100397236680912==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> --- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c

[ ... ]

> @@ -170,6 +180,8 @@ static void test_pgfault(struct bpf_link *link, struct memcg_query *memcg_query)
>  	if (!ASSERT_OK(read_stats(link), "read stats"))
>  		goto cleanup;
>
> +	ASSERT_NEQ(memcg_query->pgfault, (unsigned long)-1,
> +		  "bpf_mem_cgroup_page_state PGFAULT");
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^

The assertion message references bpf_mem_cgroup_page_state(), but the BPF
program actually uses bpf_mem_cgroup_vm_events() to retrieve the pgfault
value:

tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c:
    memcg_query.pgfault = bpf_mem_cgroup_vm_events(memcg, PGFAULT);

Should the message be "bpf_mem_cgroup_vm_events PGFAULT" instead?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21939182103

AI-authorship-score: low
AI-authorship-explanation: The commit message uses first-person narrative describing a real back-porting scenario, and the code changes are simple repetitive assertions typical of human-written test improvements.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: Minor documentation issue where an assertion message references the wrong BPF function name; does not affect test correctness or system behavior.

--===============4217100397236680912==--
