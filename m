Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5474779B3
	for <cgroups@vger.kernel.org>; Wed,  6 May 2026 14:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778078788; cv=none; b=tw3EcGVg1o0rJXaB1AKlQRACM0hgTVTAxEKEqA7i5VnhypeRal3wn5J14YcWzpv+QVGQUaahDAHYuAIkNwshhNNss6PA1rSewiB1hpoiQB+QbnOA01FOWqrw3sPC7OlFn/yiDN731PPl6PIw7X0nyMgNq1ML8MsM6cRn9H6eroM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778078788; c=relaxed/simple;
	bh=FhRqdYrHyU3h6y1BoEgh7cPXGcT5005JLxeV37oLfJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DZ87CpEDHBw2MJwNTlXa53eqYiMYcI7QQx/OKIHwgdmvtaazKpdYEemja79gZL8ocRs3RzD5ieJi0mEhErNGK3nzm9nba+JK8zxhqWIxciPW89hqt+vwyg8vy+/9bUtfvI1lxtebmivgN3gXP4gV36DE0YaDqXj13bwOUYufqTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VNnFQ8SF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VNnFQ8SF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5154EC2BCFB
	for <cgroups@vger.kernel.org>; Wed,  6 May 2026 14:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778078788;
	bh=FhRqdYrHyU3h6y1BoEgh7cPXGcT5005JLxeV37oLfJU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VNnFQ8SF2RKFgvFfbQMoFmw0ZHA1pLUTJkO1RKmHx92RZOxiobguj0YDco8BiF+9E
	 jTe4W7G5UQZ5N2mZOzkVllMqF+uZZRdVjf7wJ5mrMP7LrZfkZZcvOOH3AhEtR7cTHZ
	 nsmM5BDgABNPn7a/3Q07SZhA1/nRHu73qIGDvdfLDHtd+6QJgsaeR8jC0S7Sxktzgd
	 ApRL+H0TF5NLa5Q9Nj3OGhneG30WXgEhMaFhcdah86a2qqtjVWetGFAq/9f+w9KuGA
	 CcY1US604TuZmhWQfr8/Hhvff/psTGzVtRiHZCMsF12+8AcGYSnz2QOLM7LUPjrUQb
	 QhtPHxHtI9XPg==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-651b4d09141so1247195d50.1
        for <cgroups@vger.kernel.org>; Wed, 06 May 2026 07:46:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9wFE+cPLuHvtUpsppS4vwuhz87xDOc12KHEAuNhYMD2uK4Br8+pBpTrCCWG6VJ9uBNB8KxAwqD@vger.kernel.org
X-Gm-Message-State: AOJu0YzboWPbJwaGG4aPo8NCKk0mkgl+YDmIv6sDEj9jBs0FZntni+Pt
	TJJG1n0lq/eliG+munAG01qVCWM845ZEt/Z3ty9DfjHIPr35FaF+eG2G11gSfotEWCgxeQzSA6+
	iejl/WULtDhxDU02+8JJf+Ygp//0NY0khoMwKYGp9cQ==
X-Received: by 2002:a05:690e:13c4:b0:65c:71ae:cb0f with SMTP id
 956f58d0204a3-65c7a4130d0mr2891480d50.22.1778078787418; Wed, 06 May 2026
 07:46:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com> <20260421-swap-table-p4-v3-3-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-3-2f23759a76bc@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 6 May 2026 16:46:15 +0200
X-Gmail-Original-Message-ID: <CACePvbXf-xUbOqBFh0kjLxj-dq2K0XwvnH-ToX2fUVwiYLgFZw@mail.gmail.com>
X-Gm-Features: AVHnY4L1sm0VDd9qmvk3L0ISgntS0820Z1TRtzcsAJF_-RRUUvvfkseUIvU6Nns
Message-ID: <CACePvbXf-xUbOqBFh0kjLxj-dq2K0XwvnH-ToX2fUVwiYLgFZw@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] mm/huge_memory: move THP gfp limit helper into header
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 21, 2026 at 8:16=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Shmem has some special requirements for THP GFP and has to limit it in
> certain zones or provide a more lenient fallback.
>
> We'll use this helper for generic swap THP allocation, which needs to
> support shmem. For a typical GFP_HIGHUSER_MOVABLE swap-in, this helper
> is basically a no-op. But it's necessary for certain shmem users, mostly
> drivers.
>
> No feature change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>


Acked-by: Chris Li <chrisl@kernel.org>

Chris
