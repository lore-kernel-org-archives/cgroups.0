Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555C74E1C7A;
	Mon, 21 Sep 2026 17:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790011396; cv=none; b=ox7Z66M/o7zJD4YQgYAmy9F8v8657YD+nKyhoF7QaoZCuZkRBX5JSCwyKgow5gA2A+cuic/gAkNmdQlELidt9fFgrLHgyKFtaVKfcpx62pSNTnL6+wiUltF3USBx0P14fnCjT8ljP+GZMtIRZ297KKEmIBRVh2V2w7ZaDv+tGks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790011396; c=relaxed/simple;
	bh=GE7Pp15ua9+0nIRr+aqmuiFCFX0bRcA8pWHoIoDyI4U=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=hjb/Jh4S/qOHcsf9HeUydpIK1BibyHnTNWCOZxhzGWPZOo7j4ni8+dPp0oj8VAwBTDdTGxf2b2JySrDIWpvPMjylojFLw9yv6ZZbNWcsNDnjdQu5rvDKpe5TT9PoF7+VLVfW8HVEf53NjQv3uWl36ppslGKSY1nfyjDD8VNh4Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/rO7cOo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/rO7cOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43911F000FF;
	Mon, 21 Sep 2026 17:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790011395;
	bh=cvBCBEwzvo5dM+hFdnUoFjkzjksM6/2gzXaPJcwymaE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=O/rO7cOoNfns1nqprM7eB3yzatErXJhxLDasS+Y7EV97Hnh3LW5H6iqUczgIf9DCp
	 oLLW+gJLOCn8uNa+e48UprFMd9JUxGR+2nLRzVCiWeHkSEO0rHxlrELiYkfl5jAN8I
	 5eP+uQG1xnHLCXQxGWQxA2d+gD1OUJ/WlqnKOopnSvcQqcHUtnqdbKonampLx0kTum
	 tfK8OcBG7+Nmg8Xd4qCSHtDeBJ+WmVav2yXYCW3ZbpE/HRjFrRm91N1R4Xyb5+TlNO
	 L3ZyMFixCQSeh//HoVEWA+NfQ9TryDjWpLMQ0ibW0fYqkidrBSVCgOaqtWl54quno3
	 bx3kF7lJYY2gQ==
Date: Mon, 21 Sep 2026 07:23:13 -1000
Message-ID: <150a0e69f95d9271881d840ad309f944@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
	shuah@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, li.wang@linux.dev,
	lihongfu@kylinos.cn, shakeel.butt@linux.dev, tj@kernel.org
Subject: Re: [PATCH 0/2] selftests/cgroup: fix truncated reads of
 /proc/self/mounts
In-Reply-To: <20260921131556.444661-1-sunshaojie@kylinos.cn>
References: <20260921131556.444661-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Mon, Sep 21, 2026 at 09:15:54PM +0800, Shaojie Sun wrote:
> Shaojie Sun (2):
>   selftests/cgroup: read the entire file in read_text()
>   selftests/cgroup: don't crash on a truncated mount entry in
>     cg_find_root()

Applied 1-2 to cgroup/for-7.4.

Thanks.

--
tejun
