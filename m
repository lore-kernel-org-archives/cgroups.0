Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE6C3A783C;
	Wed,  4 Feb 2026 09:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770197319; cv=none; b=Vi3z7s7IAIE64ObkBq6wntHvFt013pcRYVe6GkC//A56JZzAGDgZEuAajafoneXNEwjBYVFHxlR8iGJrn1Bv/jW+5VJasnskf3CkMV2Gvh7+GAWcAl6aC7nJGqXwbOGL2/O0ov7o6BShUu2LLHZeONajPU8OS4WYGlB4sa2BJM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770197319; c=relaxed/simple;
	bh=hGv/7w//6+bCcJo2PoukH/3G/bRcielsG9LBWTo4Xxs=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=PRBbUhIHxcwKiz9GaKs+HdQW2H97qnqMV0l42E1mypyodPjEy+eFVoDDtNyVyX19vVgeUTu723Rg+AVVeNZ4wrKU8Ji2knW8JAoGeM9k9z3fc1ntXPjsiNPUcEDZV2z93tBqzTMVxFongT4ItbBLUUVM7U030CcLk9c07D1e5nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EzqnLDSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzqnLDSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D89DC19422;
	Wed,  4 Feb 2026 09:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770197319;
	bh=hGv/7w//6+bCcJo2PoukH/3G/bRcielsG9LBWTo4Xxs=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=EzqnLDScBdg66jVR9qskXzcwt+V6OKIQknHhwE1F13tcaR/J7Wax2gr1CLNouXDeY
	 Sb6Y2Wd9CC6L47/enfwulnvn7vJ76DSUUYDcfYNqojAtqDNRH3F6M+R52DfTrfp6Hi
	 j8lA2Kx2TMmNSnO0NjHOR4kKSpo3zpPTRmUyxbmDkrO6bDRW71CLRtc/mNYr2qFoGv
	 CMHweO7NFbe5TwniqrilV/mIjfwivrGitu9jS6L27Z5DaBDVqmHzd9ZCvz5NXw5F8O
	 2Jhm/egfVtUizGxtKFz66Uk0g2szjonCTRUALOn2xE4gSA1WVM53b8r5C5LoLcHegX
	 7uIDb5+/PYduQ==
Content-Type: multipart/mixed; boundary="===============2395984818963869282=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <0044b4c0aa82681725d87d242bc1ce63f5ee3cdd330f0262b042a334688f03e5@mail.kernel.org>
In-Reply-To: <ba2cd1640447097cece1560dd7183bc3db39c57a.1770194182.git.zhuhui@kylinos.cn>
References: <ba2cd1640447097cece1560dd7183bc3db39c57a.1770194182.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v6 07/12] libbpf: Support passing user-defined flags for struct_ops
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,eddyz87@gmail.com,song@kernel.org,yonghong.song@linux.dev,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,haoluo@google.com,jolsa@kernel.org,shuah@kernel.org,peterz@infradead.org,ojeda@kernel.org,nathan@kernel.org,kees@kernel.org,tj@kernel.org,jeffxu@chromium.org,mkoutny@suse.com,kernel@jfarr.cc,brauner@kernel.org,rdunlap@infradead.org,brgerst@gmail.com,masahiroy@kernel.org,davem@davemloft.net,kuba@kernel.org,hawk@kernel.org,inwardvessel@gmail.com,willemb@google.com,kerneljasonxing@gmail.com,paul.chaignon@gmail.com,a.s.protopopov@gmail.com,ameryhung@gmail.com,chenridong@huaweicloud.com,lance.yang@linux.dev,jiayuan.chen@linux.dev,linux-kernel@vger.kernel.org,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,netdev@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed,  4 Feb 2026 09:28:38 +0000 (UTC)

--===============2395984818963869282==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> The `bpf_struct_ops_opts` struct is extended with a `flags` member,
> which is then passed to the `bpf_link_create` syscall within
> `bpf_map__attach_struct_ops_opts`.

The commit message states the struct is "extended with a `flags` member", but
the flags field already exists in bpf_struct_ops_opts. It was added in commit
a09c73b18 ("libbpf: introduce bpf_map__attach_struct_ops_opts()"):

    struct bpf_struct_ops_opts {
        size_t sz;
        __u32 flags;
        __u32 relative_fd;
        __u64 expected_revision;
        size_t :0;
    };

This patch adds code to USE the existing flags field, not extend the struct.
Would a message like "Pass the existing flags field from bpf_struct_ops_opts
to bpf_link_create" be more accurate?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21665371660

AI-authorship-score: medium
AI-authorship-explanation: The commit message contains a factual inaccuracy about extending the struct when the field already existed, which could indicate AI-generated text that didn't fully analyze the prior commit in the series.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: The only issue is an inaccurate commit message that claims to extend a struct with a field that already exists; this is a documentation issue, not a code bug.

--===============2395984818963869282==--
