Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB72B29C35A;
	Wed, 22 Jul 2026 00:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784679235; cv=none; b=tKij1KWyDZl6FVgST4ZKrzCK17CDGNVdcV1WqzLyG3ZZSRWaCks5EWof/dWvCT27OlW8APOpqlXPbU3DM7CVtg7Z+difQyElPG7Ae5wHuuTuL1rzjkZ3+jlP+E3qLkBSO3lVCG9u3AegOXdkP2I6jf3dgFDgsTt6lhuY2XKsGfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784679235; c=relaxed/simple;
	bh=ZrpUHrE5e+W0FdqZLnSjY0xC2pCcZzrfX39HefQVfbA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=sjeCBNyxu0KNFJ+oJcsWKrC52PjpZ003QbhdslfbtPx7xBOrQGrhunhKFR0nOekVqE05fHdLT9d84r/UmBUHsq1dA58Ygb3gIOytXjP5LkeEhMUkOzVc42nfFGWPHtTlfgYkk2Bm7G9FWnkakgJum/OI5YtmcJk6InqdUKG+Fqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nJPZ26zo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nJPZ26zo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9CB1F000E9;
	Wed, 22 Jul 2026 00:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784679232;
	bh=V+aY/Lsw2VDgBYyUllYNgRGhKE2XyNDmp9Ld83OgmxE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nJPZ26zoK7PeHw+emQhxgCgwLn8YyeMkqi0Fd4RjQd5+al8q4OAvP9ctMVjqJe71s
	 GXL9PO9z2mVWG0Uu2MmY07PnEZYg6BjBNgiLvcCure2j6YIlulDZFkgrI9SS+PwYlX
	 5QVyAYDb2uhDygxWGjir4LpcpLmowxGRf3bDpgms=
Date: Tue, 21 Jul 2026 17:13:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hongfu Li
 <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memcg: check kzalloc_node() return in memcg1_init()
Message-Id: <20260721171351.ec213c13afab38b89c14f849@linux-foundation.org>
In-Reply-To: <20260721100916.76822-1-hongfu.li@linux.dev>
References: <20260721100916.76822-1-hongfu.li@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 21 Jul 2026 18:09:16 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Add NULL check for per-node kzalloc_node() allocations in memcg1_init().
> 
> Skip the NUMA node when allocation fails. All users of
> soft_limit_tree.rb_tree_per_node[] safely handle NULL entries, only losing
> soft-limit tracking for that node.
> 
> ...
>
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -2566,6 +2566,8 @@ static int __init memcg1_init(void)
>  		struct mem_cgroup_tree_per_node *rtpn;
>  
>  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> +		if (!rtpn)
> +			continue;
>  
>  		rtpn->rb_root = RB_ROOT;
>  		rtpn->rb_rightmost = NULL;

Thanks.  We assume that mamory allocations cannot fail within __init
code.  Because if they do, the kernel has some ghastly problem and it
cannot possibly run.

