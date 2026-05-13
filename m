Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B87399CF5
	for <cgroups@vger.kernel.org>; Wed, 13 May 2026 20:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778704070; cv=none; b=Adf3nP1F4h4N+u52kHoMqDtX22oE3c6Ht1VWCUCIf04OUrNwrZ8QFSAqtBIZqJjU5GSEK8jdh29ufWQJh5eJVUydOREJ3wse4uGXvChXMfa1c4ZNBa25ba9PmplMuxHDz7tswYEDHpG6ePrFjaeqyUnBzqqL1wsZefoh49vvS4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778704070; c=relaxed/simple;
	bh=qml4WAJKRZDVRX/sLvD4hDBx+iIWzg9Thdnj8lVCfYw=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=sjXi72H6efVB65vjM8vIlp/76QvURct8c9kI4GTGiCfla3Nph/jArlrdh5BbU+G3rv5uiYJUEajtazjlxRtn57EYF+PYy1IMPSc7O922kNheZ9tvE+G+qtyLyu1Kb8R5Pb474i6bB7GmQcWxAs+Ksy2EPIdlAJCo1t3Rbq1qDdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KeawrKH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KeawrKH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BA3C19425;
	Wed, 13 May 2026 20:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778704069;
	bh=qml4WAJKRZDVRX/sLvD4hDBx+iIWzg9Thdnj8lVCfYw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KeawrKH8MVIec0IwQo/f+PtgNh1qikmgsL6OLd22GI2WGsCzDnNiC+HppKPAj2GEY
	 vuUNV0VYsJvV3GvFFmoPu6JMj6/kpKVk8QcwuFN813TgfJzsBFk8P+VG0QdWFDgttY
	 g1kZWhGCczDqj7VZjyRuVeBFaDXdIMP7ZZNH30foyTNgFh/WHgIK/FNizS6D74SFtg
	 7a7ynRGYup3dma7m3uKOofsV9WJJ0yjJToNa7cSex+g7Vo5fJeKDQgBOk2s6GpOPwX
	 MFWZhAd6CmpT490p34voIekv66hlCG+omqPF8sJ5gujW1lfNh4KvfTnO4XnLQHnBlo
	 SD8cpyj7CGt8w==
Date: Wed, 13 May 2026 10:27:49 -1000
Message-ID: <f30b301f9a7dee1fc458f1c7964f731a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cuitao@kylinos.cn>
Cc: hannes@cmpxchg.org,
	mkoutny@suse.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 0/4] cgroup/rdma: add rdma.peak and rdma.events[.local]
In-Reply-To: <20260513104956.373216-1-cuitao@kylinos.cn>
References: <20260513104956.373216-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

v1 points are fully addressed.  A few more on v2:

* In rdmacg_resource_set_max(), the new "rpool has peak/events" check
  uses `goto dev_err` to skip free_cg_rpool_locked().  It works
  because ret is still 0 at that point, but dev_err is the error
  label and this isn't an error path.  Restructure so the free is
  guarded by an if, or rename the label.

* By the end of patch 3, the rpool-keep predicate is five lines
  duplicated in uncharge_cg_locked() and rdmacg_resource_set_max().
  Worth extracting into a rpool_has_persistent_state() helper — a
  sixth counter later then changes one site, not two.

* Switching rdmacg_event_locked() from get_ to find_ avoids the
  spurious-rpool problem I raised in v1, but it also means
  ancestors of over_cg without a prior rpool for this device
  silently drop the hierarchical event.  Now that the rpool-keep
  check covers event counters, get_ + keep-alive would give full
  hierarchical coverage without the issue from v1 (rpools getting
  freed on the next uncharge).  The struct is small and rpool
  presence isn't user-observable.  Worth reconsidering — or, if you
  keep find_, note the caveat in the rdma.events documentation.

* Patch 3 also extends rdma.events with hierarchical alloc_fail
  but the commit message only describes rdma.events.local.  Mention
  the rdma.events change.

* In rdmacg_events_show() / rdmacg_events_local_show(), the
  `(s64)READ_ONCE(u64) ... %lld` pattern can drop the cast and use
  %llu.

Thanks.

--
tejun
