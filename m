Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B798345561A;
	Fri,  4 Sep 2026 10:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518947; cv=none; b=dZDcC8PdL+vYhbdZ8MKmSpK+Ki39mD7iSKNN7XlNpZT3ShtRQMPG7J4iQNLZBWrtQvhm7RjnSIY/W6J/m13E2Hl9FIsmfhdzOc4/vdubNfrZ007VRne+vve/q3ZNf+jGm5dzOHpOwohbI8D0qsB0QiquCW8E2bU3ju92yBAOH7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518947; c=relaxed/simple;
	bh=2S3/1jTF9RJ2NObcRpD89k9eqJm1kLBuxbxmhKJB4aM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Ixr+K6j6jiNLJWI93uYwUmHsFTuRiuwWZXJrozbQrnV3+DSXtxEVMgxiNe4j+dgveRxRAhKwv0v0HDxFjmgISePk34+46J9Z5oB5P9KqbxSVi2sSt7HrPdj8i9Siyfkq0x2vIVCj0dCMTm2IgC8vwiQrmfCZ+Qc3JDDVqPb4OdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPS5W0hh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPS5W0hh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168291F00A3E;
	Fri,  4 Sep 2026 10:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518946;
	bh=P6j7tkt/1tMb+BxD83MOj2+xMJC9l03hjJiKyFN5ipA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=hPS5W0hhNqs/RkGAkjZ9OF/lbleE2T2L3OdMGqw1uRAE0hx3Nxv/xpqF87qTUXd6M
	 033GxzjEufSysYZtWbhsrguAKIOCQ87O+mBRU4e9AQKLpp3M0DxSoO1zdsYRyDxXcu
	 MlrNM64xjI0SHzGjHEtx+cm0wdlhLSuu9fwlQ7e24Qt6lZyi6gq4FzXFW3kBMqIXnc
	 F+7xJm+b6t95qIU+h5VOyqXoaidXiRVZXxKVUzi+pL9Wtst/mG+6HDsvV4EzKUNi6m
	 /nUQaYw68ft2N9YKXpNX97CvKgn/79GPg5MJxTg/gJdFBV6fvS8y/jb0eK9aIBCH21
	 v1KMEyaXq3pZA==
From: Christian Brauner <brauner@kernel.org>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Shaojie Sun <sunshaojie@kylinos.cn>
Cc: Jan Kara <jack@suse.cz>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260903064828.126643-1-sunshaojie@kylinos.cn>
References: <20260903064828.126643-1-sunshaojie@kylinos.cn>
Subject: Re: (subset) [PATCH v2 0/3] drop BUG_ON() NULL checks in namespace
 copy helpers
Message-Id: <20260904-gewirbelt-bankraub-bereden-53ffb98b9799@brauner>
Date: Fri, 04 Sep 2026 12:48:43 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1296; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2S3/1jTF9RJ2NObcRpD89k9eqJm1kLBuxbxmhKJB4aM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTNWiTnbf70fEHV6gUXF4d1/JYPdvdfo87N/kmbucxlZ
 sW99f5WHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPJlmZkWBoiL9gyOWb7uwyB
 LyvCzFQD3q7ImcVoff+7+JOZK5YEf2H4H7FY3/6V5sGMvR8XiP5UrPBTODF1xx3Db7pnH1a1Mu7
 P4AIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Thu, 03 Sep 2026 14:48:25 +0800, Shaojie Sun wrote:
> drop BUG_ON() NULL checks in namespace copy helpers
> 
> v2:
> - Reworked into a 3-patch series that simply drops the BUG_ON()s
>   instead of replacing them with WARN_ON_ONCE() + error return,
>   following the discussion with Tejun. Now also covers copy_utsname()
>   and copy_mnt_ns() so that all copy_*_ns() helpers behave
>   consistently.
> 
> [...]

Applied to the namespace-7.4.misc branch of the vfs/vfs.git tree.
Patches in the namespace-7.4.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: master

[2/3] uts: drop BUG_ON() in copy_utsname()
      https://git.kernel.org/vfs/vfs/c/d54cc3a5272c
[3/3] fs: namespace: drop BUG_ON() in copy_mnt_ns()
      https://git.kernel.org/vfs/vfs/c/4141e148e629

