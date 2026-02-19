Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450492F5A06;
	Thu, 19 Feb 2026 22:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771539078; cv=none; b=PvcK9y9ID48cAZ9/TuWRhuH9ZaVPO5oBNWwMwqcZEp3S1TqFKtsQg8HjZyn/wWIuyeMd1wV2FXFxb5GmAElvPFQk4e0FDhxW8U2xSOxSO8XTxHMCTu04dI5hUS/APJU6xB1G3dm87LsoT0X7kB7fD1z1mFYoIeylQO8sTv1qboY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771539078; c=relaxed/simple;
	bh=wE6B5pfGJl7+M7vk6Rh46loycKwAEMc4Jo3tZxvBpq8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=E3dIuB8LBSpWwjPwVk1Wmu7E0uY5+IM51Bq1kUYnriwWtddsE/Q+zWywjsABpG/lZ86w9XUuJAZ0vWoPiuKY5QiMsmFEXoNGckxKKf5A7ojTk99w+Rfin9cfvAs9kBGbPHHPgJLrG3aYLpWx5oQcZU+VyeacZrQwY8wwVO2ZH44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qwegiPAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qwegiPAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE27AC4CEF7;
	Thu, 19 Feb 2026 22:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771539077;
	bh=wE6B5pfGJl7+M7vk6Rh46loycKwAEMc4Jo3tZxvBpq8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qwegiPAqBJDHYdki9GckTC9d7DjFqcn6bwJyeMrOWH6ucPzALpHv4kIGOQG3ON3tI
	 2V2vvyklZV3XS1uak1yyTOgaE76TnfdGvrzIX1/OL1MUtqLFAJyx4IlqiQwWaO6HE2
	 OGrVzVjW/+9xv1zJaH5hEhJfUj2KXqwpz5kOSGl0=
Date: Thu, 19 Feb 2026 14:11:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, mst@redhat.com, mhocko@suse.com, vbabka@suse.cz,
 apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com,
 cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com,
 gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, rppt@kernel.org, muchun.song@linux.dev,
 zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, surenb@google.com, virtualization@lists.linux.dev,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
Subject: Re: [PATCH v4] mm: move pgscan, pgsteal, pgrefill to node stats
Message-Id: <20260219141116.2cebbc75f4d79f06813d83a5@linux-foundation.org>
In-Reply-To: <20260219171124.19053-1-jp.kobryn@linux.dev>
References: <20260219171124.19053-1-jp.kobryn@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 19 Feb 2026 09:11:24 -0800 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:

> There are situations where reclaim kicks in on a system with free memory.
> One possible cause is a NUMA imbalance scenario where one or more nodes are
> under pressure. It would help if we could easily identify such nodes.
> 
> Move the pgscan, pgsteal, and pgrefill counters from vm_event_item to
> node_stat_item to provide per-node reclaim visibility. With these counters
> as node stats, the values are now displayed in the per-node section of
> /proc/zoneinfo, which allows for quick identification of the affected
> nodes.

This runs afoul of
https://lkml.kernel.org/r/20260123150108.43443-2-wujianyue000@gmail.com.
Please redo against mm.git's mm-new branch?
