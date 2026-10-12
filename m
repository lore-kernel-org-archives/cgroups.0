Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEB24C33CA;
	Mon, 12 Oct 2026 17:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791827515; cv=none; b=uM/IW4Vsk6RmJLf4q2v/V/HP8HXt8rCKGazowKK3E7a+g4ExF4vSkRCMVYmFkhTXuObzuU3wmQlPoPrOUwrBIGic1JyevnCh56YICzyl4AaQdtFUtTAgacqQiZeP7gxCQqVsaJL6F79+9yT88b1L0hyrhNY9ZjwTucVUe6JF6+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791827515; c=relaxed/simple;
	bh=qDINUBxZZPw1zhFnyXj5oTfCOVb0IJMJx4thMwKV8YA=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=WLdltILvYXvRbZ+MQf1HwlDwlMAty59p9b6LgoB8/T7KoZlg2yPlUzrjr71Kv+ybSb23i1k2wIKaBCgRVAv7IXY6GzDRv9jIizuRalVWjrgGv057bbR9fb1W6dmV292w/Dc3FsUljWoHLSfpA8Iw79NNIAkjaoQd5JqVam2W2R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYo3Ib9T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYo3Ib9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F5D1F0089B;
	Mon, 12 Oct 2026 17:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791827513;
	bh=kNahywYLBv8aIcm/NKKEaAKhrF/aTvhTm1jlesIR1Tw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oYo3Ib9T2TZSshkFrVUqEOLiXFfRi1YL/5Ep6sBc6dUG5N/yAlaONNYFmgvEBgrHc
	 b9gj1QMF/XT2BhOc8rgrHhkT2xYAb2qbmTW1urn3miOGHSekiPjh4ErT4cMJ0M/21i
	 9a/MJ3coYndW9WG5251ppIixuze1q+EOYOT5rSnr4G9VGICdyxxTbg+z3lo8BYW+Vs
	 EEGdBOaSVLLMudVkvldsDK3nm3hwVFj7QKz5ZiXF152X1DHBP1sEOZXa2Gl9mEU8N2
	 i6fzl2GUCx66cs+DXUYZo9F4c9PdUJTvzejtHoBFarjZMvq7xew3/QlWrXnYjxjlVX
	 Thln3g3+yC+Xg==
Date: Mon, 12 Oct 2026 07:51:52 -1000
Message-ID: <d9a3367a1852158f60cc2e89677fb12f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] BPF-based per-cgroup NUMA balancing mode selection
In-Reply-To: <20261012120438.52849-1-laoar.shao@gmail.com>
References: <20261012120438.52849-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

On Mon, Oct 12, 2026 at 08:04:35PM +0800, Yafang Shao wrote:
> This series adds a bpf_numab_ops struct_ops which attaches to a
> cgroup. The kernel consults the policies of the matching cgroup and of
> every ancestor and combines what they return.

The op doesn't compute anything. It returns a fixed mode per cgroup and
that's all the series uses it for. BPF is unnecessary here. This is a
prctl() feature, not a struct_ops one.

Thanks.

-- 
tejun
