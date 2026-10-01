Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E640282F1B;
	Thu,  1 Oct 2026 00:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790814062; cv=none; b=J5Ag5XBzLA887aWmZKVCtGwWsa1WudeeYS8RPguPge9JUyv/JhBZMPzfPhP1szlg4gv+Bid+D5Xt5ctkj2d7eIjnWPBKST4voXJBJpnNdYXfZ3tstRwoE7LlSEYMyhuFCZJMCCZBNB7JeVWlr7yk3Yt6YDVkp9Za7jxu4NTT/6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790814062; c=relaxed/simple;
	bh=zeHVgwVQCOpZGPbuV62NoIgPlJtExvO0see6x6+V+ec=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=mmF8kauLNSP877v143hYGcrMHJBGvvqYft2H5cL1fzWCFB8nq4w2jV3haU4NFjU2z7NOtPWfWeIX73V3s0PrMTF7sJDfIAmr10Oac9FynIRbPXOtV/y17/vkf3c/PgD3qf17M37/Liv7nLPO9fGAKUW/yx2eKKzvJuZMf/zqMpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1qlvmsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1qlvmsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5E41F000FF;
	Thu,  1 Oct 2026 00:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790814060;
	bh=MewAlD5aSkZUtyyg83a3AwFjqYwD/VRSwZs4SdrxEIc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=A1qlvmsRclnrJENovY2lSglSpAReArBZURRYsuf4IzM2ie8lBU4QaR9U2gTdTDk00
	 Py74PGm/smkybm+uisQp0IV8VAz+kho6nxbfxumWCTAwbNFVLge6nNt6TZIsueX8bN
	 VM6zN6NnSQLLaIVkTKO0jYiZiJQO8c2AA5bX3D9uqHeshq31NsR42dJC0ZQ7CDrw8B
	 MFFCvEsqLHONsYb2e71Vd+oh2SHTgJnOR9ygMTByMGMY+nUfTxHhB9PBg1bLVkuRYE
	 R8kfElHV8KJ4rQ6t+Xi5qMSut+ZpcfdEL7RI/tnZNl3N8WgRlw0N47ametf57apq3r
	 kbS0joADhj0Eg==
Date: Wed, 30 Sep 2026 14:20:59 -1000
Message-ID: <95edaf582303f1a9404c989f9f0e6501@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: josef@toxicopanda.com, axboe@kernel.dk, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, andrii@kernel.org, eddyz87@gmail.com,
	ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>, ameryhung@gmail.com,
	alexei.starovoitov@gmail.com
Subject: Re: [RFC PATCH v8 4/4] docs: cgroup-v2: document the iocost BPF cost
 model attachment
In-Reply-To: <20260930075154.189958-5-cui.tao@linux.dev>
References: <20260930075154.189958-1-cui.tao@linux.dev>
	<20260930075154.189958-5-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello, Tao.

The following is a Claude-generated review.

On Wed, 30 Sep 2026 15:51:54 +0800, Tao Cui wrote:
> +	When CONFIG_BLK_CGROUP_IOCOST_BPF is enabled, a BPF cost model
> +	can be attached to a device by loading an "iocost_model_ops"
> +	struct_ops with the whole disk's major:minor in its "dev" member
...
> +	switches back to the builtin model, and neither detaches the
> +	struct_ops; only detaching removes the model, after which
> +	"model=bpf" fails.  "ctrl" keeps describing the builtin

Attaching, not loading, binds the model. The test loads a second model
fine and only its attach fails. Device removal also removes the model,
and the user still has to tear down the struct_ops link afterwards. Can
you mention that too?

Thanks.

--
tejun
