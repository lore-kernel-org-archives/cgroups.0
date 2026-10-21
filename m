Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578612;
	b=HlHvzByG8OSR7PEnz8mkpV7apCCVqsKxCZRoII5+dElPICtILvlafvJwMJugdHGCi6gA
	 +IE/mNpT7gO/bGq1sEeENh7rcxGypEOPfjyN4S1+XQXRT5QPmuxAo4O1db0dw9GEB7tM+
	 ygg1BTyKNKdmqns4wcdJuAtvDWEntyLByX/j9bjp9rXmPKrKaTNaUPsngSxa3m4QSBBXQ
	 hTWmWUSl9ZBZh48/S/lqnMy4CjRmEvRfg8hlTmDp/M/1y6B5PfPsmVwHRfavJFlUAF4+e
	 FWCKodj5o/mOM6cdAfotqdF2Mcs5bjY0ql03a25hKSRhjemVREOu7SBE862rgRwu5oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578612;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=W8edK1Xi3fKqCs4MYZhDfH0qfLfRnuuhcmFNKoFIYOo=;
	b=sQeXEscfhuD5t9R6ok5TdJyqpq3b1yc5L8NddVjbxGHghm46wHMUlrxwH9Vm83jeRLOl
	 /DxsflN0vzy4cePSFU+L5syKLh1vUZxnkwgtEGvNrvCV6bEwBddZ74OJqzc2b19y7VEvR
	 vmz4ZdlXi68DArLyNB75zBJ9GV1yrw3V9eWQ8sqzD3zRjDt12B0YSiz0RwvFpsn6iclBR
	 f58867loXMpI5ZZPmxj4TsMGsNxBg4qvyGD8MfcsrjxqYKVgIr+A6vhueyNkfiHxF+UjQ
	 O6G+NdpcgldjF7jpsgXU9mI4snj1aEGiwZ80tzvyi+/sQILlFE5fS2TErCSGnRDrKqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=npuiu8Zb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69EF606A31B;
	Wed, 21 Oct 2026 10:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=npuiu8Zb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4551F000C9;
	Wed, 21 Oct 2026 10:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792578611;
	bh=W8edK1Xi3fKqCs4MYZhDfH0qfLfRnuuhcmFNKoFIYOo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=npuiu8ZbeBCUB/eaT8kTlOj1JSGVuD1Q5Ur9utmedIlIQT3szI/SXajQtD3/uHyT3
	 DJd+HVY81WggR4V3GJFqpqyOuY4XR1jRNpoeWBzl0HyWGHrSvvXjYPyzuGZRAqXkAJ
	 uyHKANHt9lEYXkUvWnaCzLsl9VKnFSf0Y2VRfaQR7vodyWcURKZal7WsfZVZypDndN
	 X8aHo+JfJLy8wibOUWQDtrCERvZSYWQeWvFcu72V7ZBK3SJbDOlDiRk9YLCHiWo7Oe
	 2OFSLIAJ03m82FVRDQReWcb/QCYt5JLQ0SIUUp/bImQKUx1s6Dr0t7YPZCh/fg0uSp
	 A4xGFCSnCmRcg==
From: Christian Brauner <brauner@kernel.org>
To: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
 Liz Fong-Jones <lizf@honeycomb.io>
Cc: "Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 ian@honeycomb.io
In-Reply-To: <20261017040710.1174009-1-lizf@honeycomb.io>
References: <20261017040710.1174009-1-lizf@honeycomb.io>
Subject: Re: [PATCH v2] writeback: keep cleanup_offline_cgwb()'s scan out
 of syncs
Message-Id: <20261021-vagabunden-nullrunde-torpedieren-3b864a09e824@brauner>
Date: Wed, 21 Oct 2026 12:30:04 +0200
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=894; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xGvdJTJPwUrQmbSvbQg+cAG6DSz9S/AsFgM5IJB+gjs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTdmKJXxrVq1n6OYnX2mKsvpjDdFwwLLlq35NWC6AOJT
 fveMypqdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk+VuG/6Gb37zOnN0mWL/0
 XJGR0PKmnT9nKlsv8klYFPGfSbkl1omRYVlMl4rpxYMB/NtDU3k+87kY7hf0Et33J03/t+25Q4u
 dmAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Sat, 17 Oct 2026 04:07:11 +0000, Liz Fong-Jones wrote:
> writeback: keep cleanup_offline_cgwb()'s scan out of syncs

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] writeback: keep cleanup_offline_cgwb()'s scan out of syncs
      https://git.kernel.org/vfs/vfs/c/056b35228fad

