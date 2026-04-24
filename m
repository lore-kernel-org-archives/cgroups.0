Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778FA3D3CEE;
	Fri, 24 Apr 2026 13:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037470; cv=none; b=bu8xiz/3UsoNUkqrDs53oX50NjMqPzYxlEmQWZPo2Y1+vReA9/5pHeOhEYLOhYvhQPyxBVUHt/ns/8W7OjQ1EnigraJzX5PvrJAHFLBGtWISzRcvMZX3vQ6iFwNd+k9I+ROCksjMm+VodaMkDzT/EYxDdha4wA6Dw4obWzcb9Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037470; c=relaxed/simple;
	bh=bp+ACcwezPuzPs1ltjFyz9x481JAiCF8UZHITo7dJiI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=MlRuBkLb18DJ/OREF5U9Q0jNCpns0CHA6gsDTS7JwsfHcfR6NbHDseFY0Ai/V2+19jD+OXIZV1bE2PFiB/NglmAKKom8q42IWh4oCUJ/QLGhXRTXSbXAhhfzQRTC1rkfSUM99RtwGNIHJZYsjd6u/6zAynlm766r4b9tXLJ+Pm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WLbnbmRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WLbnbmRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE7FC2BCB5;
	Fri, 24 Apr 2026 13:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777037470;
	bh=bp+ACcwezPuzPs1ltjFyz9x481JAiCF8UZHITo7dJiI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WLbnbmRIznNTjt5hg14jP0khfMtV0UhdvBTF3BjQLCjPyw1V2RKy7rNJx1LzsxhCo
	 PbV8vvqOPEUqo490ke59HqAgYalxRjTecEehhxaAMt02IoPnqubgiVQQ4n9z+TTO3F
	 plM3p077xPSYrmlvjag4jSowTE3I7OY6c7C2qYxM=
Date: Fri, 24 Apr 2026 06:31:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <li.wang@linux.dev>
Cc: tj@kernel.org, longman@redhat.com, roman.gushchin@linux.dev,
 hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev,
 nphamcs@gmail.com, chengming.zhou@linux.dev, mkoutny@suse.com,
 shuah@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/8] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-Id: <20260424063109.6fab94d833e82f87e4309006@linux-foundation.org>
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Apr 2026 12:00:51 +0800 Li Wang <li.wang@linux.dev> wrote:

> This patchset aims to fix various spurious failures and improve the overall
> robustness of the cgroup zswap selftests.

AI review:
	https://sashiko.dev/#/patchset/20260424040059.12940-1-li.wang@linux.dev
