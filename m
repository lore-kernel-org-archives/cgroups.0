Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD5737268D;
	Fri, 17 Jul 2026 17:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784309034; cv=none; b=eieXwmkEGCDnABa93H5ouV3g8CGW/cFZzMdhj+pwHgJaWHN1PVc4ryhMzvni5pP6WhYNipEnBQ2LiUvp90zmnAYlWYmew8koaHh9lW6ex39i2t+oajasSIb0kN+vu3MtyaJJWnS7NnDwRxpoo2TxK8IlCXHUm+xZE9Extm20R4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784309034; c=relaxed/simple;
	bh=BJxzorYgfYxIEUyfnkylQVq73e8/Yl47udHqLM0oTDw=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=S9h8i49BwuTAbcJ1JEZXxNZwtZWr9bUii3WK0TR1KgKVdzfbC486Tm4pPAzcmdjDGKOtbB32SlVmwf72sezbX58DHHFM0CDNfP7Qj4EZ/+MBZ+nQBJMmsTB6OH3ju6YgXH6dLz996DFJmgz16ifPJFpRsgYZ8hrVqbCyw72BXuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKRZhhXe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKRZhhXe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74471F000E9;
	Fri, 17 Jul 2026 17:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309033;
	bh=adWvQlxcRBHFH92aFVDpNPEaCwngEMZ1BrzTWd+ErjQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kKRZhhXe5q0AOhaejLLZ3dc+pGaijp9xX0KCY6QLC179EYegHyKGZ6vrdHsaskKtV
	 vSlLRKD2E6khAmFoFZVqzm3+Zsq4vYHFLdleQrTQkNBWMG+eUpaV7noSSAxpIFAgRb
	 qz+/h5bBtK5loC7n4jRw9mGAhaxYP0Pcaxav0gJ/IMZVu3/CdrkBzEg2NPA0/4w3U7
	 gPbX/IkB3eUY2s/1aycOL3JOAYgFw1YoERcMKCxrqfE05iTNK8vi8726QJoPYhaqzz
	 MUA/guQxEhIfxlS7subpSWkW5wbLW8zQRzONaJt1kFOA4221WW4vtUPlMB9c/+yex5
	 4U2gJScPkDAAg==
Date: Fri, 17 Jul 2026 07:23:52 -1000
Message-ID: <8b85b40f64ab9c949cd8a4358c1fc7b7@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutný <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Josef Bacik <josef@toxicpanda.com>,
 Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH v2 2/2] Docs/admin-guide/cgroup-v2: fix delay_nsec unit
 in io.latency doc
In-Reply-To: <20260717060225.2019764-3-cui.tao@linux.dev>
References: <20260717060225.2019764-1-cui.tao@linux.dev>
 <20260717060225.2019764-3-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied 2/2 to cgroup/for-7.3 with Michal's ack added.

Thanks.

-- 
tejun
