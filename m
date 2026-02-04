Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26A03A1CEF;
	Wed,  4 Feb 2026 09:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770197315; cv=none; b=o3ZctFvSVTPi01L9L5pFYg5VL2IX/V9yqMZF0uPxV7RW9dxR3uXPwCRM6AEqCfyc/7xxBIrzPvYnm9yw4QUte7QR+xVqsNPOT7PilTmpmBY/XF1fPJ/W2B9tQrxoS/BZEP0rsoiRVQ3zGcF3qcufkCwj6bHI9eDUVztqRloTJJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770197315; c=relaxed/simple;
	bh=nXEQW0RD3tHANLDk1Vmj8TZU/wOk6Cxie+cPvOqsozU=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=NrZj/5Fw3UD1//2I6EkCliD2PjuTbZVVWGew6GnSYW7K15Ga6nNtmxVkYlEJtdscNjjlm4oiB0YOhyLDBhi3YoFmE+0CVNah3rp3A0NtVExZHa0+DVoMcO16NIt5/qwAceFDARBHnEL8B37lIh3QgLKxV9ApkdBQS3+qzIk9x0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hjvwfcjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hjvwfcjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5783DC4CEF7;
	Wed,  4 Feb 2026 09:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770197315;
	bh=nXEQW0RD3tHANLDk1Vmj8TZU/wOk6Cxie+cPvOqsozU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=HjvwfcjmVhIG76TDoBvmEmqdCRSO9SYrE7ujdWcl8T2Fu948Ns/o1vn2b3pXaPCIi
	 dee53azAEIroEXCTp5LwyChJEXamfrSxBWAxW7LkivT44ix3z9LxKngbveUSWozvwu
	 OnxqdeQ7esTgXviLu+0qnEdz8h+VbHb0GgGyhln/T4wugwj333JwlXoFykmGyOm3P1
	 f0cAJsTKdNglQfHGqPi4jsZIkKy8mqXw/sxzKaZrNvJt0/NOI6HHLqw3nr03gpklE2
	 0f9ebGS1YJmrKT7/VCAf19xpU6B+dVs73kUGQX+za0W7ETC/DvKEmwyhn/HorIw0dw
	 kRyO2LnWnGdNA==
Content-Type: multipart/mixed; boundary="===============3576808011636229974=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <958ccd923342ddd02e9122381d51319cb125ec51d601bb6fcad57531a2f5ef57@mail.kernel.org>
In-Reply-To: <031afcd7c16e97f1f3c0d4a8a526a9eee2ad23fd.1770194182.git.zhuhui@kylinos.cn>
References: <031afcd7c16e97f1f3c0d4a8a526a9eee2ad23fd.1770194182.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v6 11/12] selftests/bpf: Add test for memcg_bpf_ops hierarchies
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,eddyz87@gmail.com,song@kernel.org,yonghong.song@linux.dev,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,haoluo@google.com,jolsa@kernel.org,shuah@kernel.org,peterz@infradead.org,ojeda@kernel.org,nathan@kernel.org,kees@kernel.org,tj@kernel.org,jeffxu@chromium.org,mkoutny@suse.com,kernel@jfarr.cc,brauner@kernel.org,rdunlap@infradead.org,brgerst@gmail.com,masahiroy@kernel.org,davem@davemloft.net,kuba@kernel.org,hawk@kernel.org,inwardvessel@gmail.com,willemb@google.com,kerneljasonxing@gmail.com,paul.chaignon@gmail.com,a.s.protopopov@gmail.com,ameryhung@gmail.com,chenridong@huaweicloud.com,lance.yang@linux.dev,jiayuan.chen@linux.dev,linux-kernel@vger.kernel.org,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,netdev@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed,  4 Feb 2026 09:28:34 +0000 (UTC)

--===============3576808011636229974==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> index 8c787439f..378ee3b3b 100644
> --- a/tools/testing/selftests/bpf/prog_tests/memcg_ops.c
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_ops.c

[ ... ]

> +void test_memcg_ops_hierarchies(void)
> +{
> +	int ret, first = -1, second = -1, third = -1;
> +	struct memcg_ops *skel = NULL;

[ ... ]

> +cleanup:
> +	bpf_link__destroy(link1);
> +	bpf_link__destroy(link2);
> +	bpf_link__destroy(link3);
> +	memcg_ops__detach(skel);
> +	memcg_ops__destroy(skel);

Can this crash if skel is NULL? Unlike the other tests in this file
which guard these calls with if (skel), this cleanup path calls
memcg_ops__detach() unconditionally. If any of the earlier goto cleanup
paths are taken before memcg_ops__open_and_load() succeeds, skel remains
NULL.

The generated skeleton __detach() function does not have a NULL check:

    static inline void
    %1$s__detach(struct %1$s *obj)
    {
        bpf_object__detach_skeleton(obj->skeleton);
    }

This would dereference NULL when accessing obj->skeleton.

For comparison, test_memcg_ops_over_high(), test_memcg_ops_below_low_over_high(),
and test_memcg_ops_below_min_over_high() in the same file all use:

    if (skel) {
        memcg_ops__detach(skel);
        memcg_ops__destroy(skel);
    }

> +	close(first);
> +	close(second);
> +	close(third);
> +	cleanup_cgroup_environment();
> +}


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/21665371660

AI-authorship-score: low
AI-authorship-explanation: The code follows consistent patterns with other tests in the file and uses standard BPF selftest conventions, suggesting human authorship with good domain knowledge.
issues-found: 1
issue-severity-score: low
issue-severity-explanation: NULL pointer dereference crash in selftest cleanup path when cgroup setup fails, affecting test reliability but not production kernel code.

--===============3576808011636229974==--
