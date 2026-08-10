Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAF4440A33;
	Mon, 10 Aug 2026 19:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390553; cv=none; b=aUWoirJLlDFuwJ9ctqHtiVjliz8LZLz2mnEwgw76RNzcOYSiqACALsP0NDaetWRQq6UQ5u6YbpxiUEbhe/lotDPkR5RnoUnrrhB38Nj4w4P3F5V9IbcfhjITNYcaBJbWjxYGULry5DdIY9Gi0wlDHZjtQWB4X6dWI1bo9CAAn9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390553; c=relaxed/simple;
	bh=RUcLM6clF6BbBh181lMBRzMP5HLUp5UhSvnW3zloBl4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=RvcRruurvUWsGPZFi0cyW8hP3wVWHPU7hoVNXRf60vIB6yz/MWlsLqAyciKNiEMdtICT6TKv3MX5ZFUpO7kcC9AWFYI7eJc5mPHVMeRLJ591MWWboJIIhMAsuSLQWSeOlCiFOAmGkxz2AdGTOX6lF661yb6SOfVJjQadc+8kGms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d0JMBqVQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0JMBqVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982521F000E9;
	Mon, 10 Aug 2026 19:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786390551;
	bh=RUcLM6clF6BbBh181lMBRzMP5HLUp5UhSvnW3zloBl4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d0JMBqVQq1TQs3gmGkPD0zmsp9WIupbTm76ilHUaOOjaW0ohQcBR25T1U4qkzzP3g
	 ngQ1OCfI+Sj8rKfvkNJwtDKc5/sjt4fOkDtO2eIKK8lR1x5Twlhp3w4vRb+ZnhI2FH
	 CsPOeFWTmlVUGZbDoK4I9htaDpgjNO38RU1L5QqVZRsfTEjd9bsZQkuQOLdwCsQ2st
	 bWHlGRDlLrMlj5nf+mITBNmdr3jmhWVmoVJv5xWgIF9L/RD0mwfoVqBTzpb3FNh9vG
	 gKFQ+A7AsvF6inNre0BxFvhc5l22Bu7z3qmFtF6EcbHfMM7ZRK5V5mBoLNbt78y6HF
	 czL5Gq2oV4rKg==
Date: Mon, 10 Aug 2026 09:35:50 -1000
Message-ID: <11d2ce0cafd19dda67513986d8b5fd48@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: longman@redhat.com, ridong.chen@linux.dev, cgroups@vger.kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, linux-kernel@vger.kernel.org,
 zhangguopeng@kylinos.cn
Subject: Re: [PATCH] cgroup/cpuset: Use WRITE_ONCE() for shared prs_err
 updates
In-Reply-To: <20260810095559.77345-1-guopeng.zhang@linux.dev>
References: <20260810095559.77345-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Mon, Aug 10, 2026 at 05:55:59PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>
> cpuset_partition_show() reads cs->prs_err without cpuset_mutex using
> READ_ONCE(). The field is documented as not lock protected, but several
> updates to live cpusets still use plain stores.
>
> Convert the remaining prs_err stores on live cpusets to WRITE_ONCE().

Applied to cgroup/for-7.3.

Thanks.

--
tejun
