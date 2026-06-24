Received: from va-2-49.ptr.blmpb.com (va-2-49.ptr.blmpb.com [209.127.231.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84B38A726
	for <cgroups@vger.kernel.org>; Wed, 24 Jun 2026 06:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284298; cv=none; b=RK2XQ938IM4W9deEEZXrAB6d78il9oO1sdJt1DiCwpCGWPaJcYIDstw0iEFw71+lS6FauNuJk4lcXhHMajbWhqbEIXmKtGUalrOyU6MwsrZW9eng/JQ6Yg758mjNutA0YRIVfJ8QDN/1GnD+2bIerlTTDBBTXQhQy2vzsvO9IsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284298; c=relaxed/simple;
	bh=rJseISap9xBx1TIEdDPlKtfLclHaCWHTrvJEL4F1BII=;
	h=To:Cc:References:Subject:In-Reply-To:Date:Message-Id:Mime-Version:
	 From:Content-Type; b=ehOz8i8DfNX+k0t4AiTkJdGt1ELqgm63PLW/eWZVSmnceR8aEIk7Ug+TNfaVipla2N4yQcpHm1jBwu/U/G408UfAgoirbwd6gxKLloONdhuO6whY5OlyIn+t9k/isy35BcujrRByCUfqa53htv8YbvewmcN2AO5XnIPmJmfwkVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=ko+peYdW; arc=none smtp.client-ip=209.127.231.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="ko+peYdW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1782284286;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=FMKsX1oqr9cJS0GXtzM8Ok+fkwH2kagCOdyTihBZHlM=;
 b=ko+peYdWhkBC6Z2+M+DAnl+DHsw7wlKUYcGNSanD0QdqHL8kOGNHfy5JdHfFOLwBitSHLK
 EK6pLRNFI2Ud7COX476laUs/Yn9twDwM6BzwU5ay+45/RPsZvLd2zVcfwbj3e8/Oh8o6Qh
 51b1/iIv5qImhJBjy9SAtaeR3IiSjddbeFzYvyuiv9VOVVgPqb8e0c6pncmMnr8S7IziS1
 bRaHq/Eeyn+vdDxSEw1TIBPEMAo4KrGVeqjBoeJepRYhI8QA0h9N/pIA84fxdaAnw/4KBM
 RdiUXkYUQnjnDCgCUCNCg2y4JhTuJcX8KFuo5Ck1jX6/L9Z0UVAbsh/6OJ/rQw==
To: "Yu Kuai" <yukuai@kernel.org>, <nilay@linux.ibm.com>, 
	<tom.leiming@gmail.com>, <bvanassche@acm.org>, <tj@kernel.org>, 
	<josef@toxicpanda.com>, <axboe@kernel.dk>
Cc: <akpm@linux-foundation.org>, <chrisl@kernel.org>, <kasong@tencent.com>, 
	<shikemeng@huaweicloud.com>, <nphamcs@gmail.com>, <bhe@redhat.com>, 
	<baohua@kernel.org>, <youngjun.park@lge.com>, <cgroups@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH 0/8] blk-cgroup: remove queue_lock nesting from blkcg paths
X-Lms-Return-Path: <lba+26a3b7ffd+6e4f90+vger.kernel.org+yukuai@fygo.io>
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
Date: Wed, 24 Jun 2026 14:57:59 +0800
Message-Id: <1c739fcc-5132-4cb2-bf34-cec94de26509@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Wed, 24 Jun 2026 06:58:04 +0000
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8

Friendly ping ...

This set can still be applied cleanly for block-7.2 branch.

=E5=9C=A8 2026/6/8 11:42, Yu Kuai =E5=86=99=E9=81=93:
> From: Yu Kuai <yukuai@fygo.io>
>
> Hi,
>
> This series is the follow-up blk-cgroup locking cleanup on top of the
> earlier blkg-list protection fixes, and prepares blk-cgroup to stop using
> q->queue_lock as the global blkg lifetime/iteration lock.
>
> The current queue_lock based protection is hard to maintain because
> queue_lock is used from hardirq and softirq completion paths, while some
> blkcg cgroup file paths also need to iterate blkgs, print policy data, or
> create blkgs from RCU-protected contexts.  This series first tightens the
> blkcg-side lifetime rules:
>
> - blkcg_print_stat() iterates blkgs under blkcg->lock with IRQs disabled.
> - policy data freeing is delayed past an RCU grace period.
> - blkcg_print_blkgs(), blkg lookup/create, bio association, page-IO
>    association, blkg destruction, and BFQ initialization stop nesting
>    queue_lock under RCU or blkcg->lock.
>
> Using blkcg->lock and RCU for blkcg-owned lists/data keeps the lock order
> local to blk-cgroup and avoids extending queue_lock into cgroup file
> iteration paths.  It also makes the subsequent conversion to q->blkcg_mut=
ex
> possible without carrying forward queue_lock's interrupt-context
> constraints.
>
> Yu Kuai (8):
>    blk-cgroup: protect iterating blkgs with blkcg->lock in
>      blkcg_print_stat()
>    blk-cgroup: delay freeing policy data after rcu grace period
>    blk-cgroup: don't nest queue_lock under rcu in blkcg_print_blkgs()
>    blk-cgroup: don't nest queue_lock under rcu in blkg_lookup_create()
>    blk-cgroup: don't nest queue_lock under rcu in bio_associate_blkg()
>    blk-cgroup: don't nest queue_lock under blkcg->lock in
>      blkcg_destroy_blkgs()
>    mm/page_io: don't nest queue_lock under rcu in
>      bio_associate_blkg_from_page()
>    block, bfq: don't grab queue_lock to initialize bfq
>
>   block/bfq-cgroup.c        |  17 ++++-
>   block/bfq-iosched.c       |   5 --
>   block/blk-cgroup-rwstat.c |  15 ++--
>   block/blk-cgroup.c        | 151 ++++++++++++++++++++++----------------
>   block/blk-cgroup.h        |   8 +-
>   block/blk-iocost.c        |  22 ++++--
>   block/blk-iolatency.c     |  10 ++-
>   block/blk-throttle.c      |  13 +++-
>   mm/page_io.c              |   7 +-
>   9 files changed, 158 insertions(+), 90 deletions(-)
>
>
> base-commit: b23df513de562739af61fa61ba80ef5e8059a636

--=20
Thanks,
Kuai
