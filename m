Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1E038E8C6;
	Mon,  3 Aug 2026 16:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785775671; cv=none; b=aKvqK9Wpg0LH37OJl4upz1WSbE1CcDuyhOtBLFM2SpC+K2SckfvYFE3GyaAQSUe8c56Qo4T77oc6WeVc/m4ff6xCiCdnJrRL5GAYdMU4d/7EAbnLKisNKVZLbe3GSw0zi8CtayVRdxvrCEMXlcW9zcylW8ZmQuk+75KnRhR2geA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785775671; c=relaxed/simple;
	bh=46/keLQycuUBwhOiN6E0URHyJdOXrJloEMnEHp/bxLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SCTjakytiDCAvrQjUuVD9BbiSlkXJr6a30/oGeanXM02dEzf1BG6eydRN71dtqdgKU7ahQuu9adTbcj12zxSjAqvo02M9Th5qS/ScRW3ROEtDbSR4xCF43/xA17cWHYKi0/vru7U3UjWddRYYxOJCpTrjtyjpeFDeGMfC7aIHVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1x95HTb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1x95HTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4270C1F000E9;
	Mon,  3 Aug 2026 16:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785775669;
	bh=+ZQ2UCWqjxlvkvfla+wyCS9muUAOr+226CxgJwVqdxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n1x95HTbIbQfvgfoT1QC1fLdq4GT637KWeXnEsloAwpDERBmCG0K+jvUzb82VV76/
	 fjL5arfBbxhOwTJvp8JmedhCR1Vi0F+K1KslusdYwncH9SiudZs8edmuvR2P63ACaf
	 iKq0fafHvVwjGf8VnVJ1Yptpqheab7Pf9Ig0ge0XoQAsj6HO0FYvW9l3cIV9QD+dhy
	 Qw5c+8OHMijUrkogSfHBerb3nFemetnmmP/wY0P0QN+2EqZtE4yJmgHMleesPT9c1L
	 yOI/qgQ1JNdxJhNPVgiqDd0dtwAXWOpeeHPXwKc+L4PxhhF+tzWeG2N38MhemBozNu
	 o1Uds5kgfOVVg==
Date: Mon, 3 Aug 2026 06:47:48 -1000
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: axboe@kernel.dk, josef@toxicpanda.com, yukuai@fygo.io,
	cgroups@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH v2] block/blk-cgroup-rwstat: use data_race() for online
 test
Message-ID: <anDGNLFidOuxqy12@slm.duckdns.org>
References: <20260803133400.137906-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803133400.137906-1-cui.tao@linux.dev>

On Mon, Aug 03, 2026 at 09:34:00PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> blkg_rwstat_recursive_sum() reads pos_blkg->online without the queue
> lock that its doc comment requires, since blkcg_print_blkgs() stopped
> holding it in 56cc24f59c14.  Concurrent blkg_create/destroy flips
> ->online, tripping KCSAN.  The race is harmless (RCU-protected, stale
> online only causes minor stat noise).  Use data_race() to annotate
> the intentional lockless read.
> 
> Also update the stale doc comment that still requires the queue lock.
> 
> Reviewed-by: Yu Kuai <yukuai@fygo.io>
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
