Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E8048425F;
	Tue,  8 Sep 2026 21:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788901419; cv=none; b=nCpF6+C2MyoewyIOnLQdOvd1QL9PuKCRoTwbpOgn4Cjp33+6mQmF6tRWJrlSuQ0d009ZWNOrFmnVAfUE53sTqv2FLJqiC5hKvd+yPpg7ZYBKHMz4jeRr/ojBEyvm/T8uKXTQSqH3mvltYwtpjVjiNMHS2PqrKVEzISzhsFNJgZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788901419; c=relaxed/simple;
	bh=QyRcy8PKKKOcnVMp4JHDk9cLkVqsLKQuYo42KhyqG3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s54Sts7vFjvoBRoY80/7g2pQgQRBsLkfKEcEzzPo5WO7Hfs84LMSsIjfizRP15ObK9gDmSAP0yajhO80WUyOf5B/wDE8MN/yyX18bNYtqEN/m0IXb70esy7J+uodPh3rL5xvx63xlAvlItz82y4LWIvAax2t588RohDVx1d65PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/peEe43; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/peEe43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E6A1F00A3A;
	Tue,  8 Sep 2026 21:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788901418;
	bh=Lxp0BuicDym9G7SjZTIygT3r1xSyIvuHAAEpU2Cqv0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/peEe43ZlG2MvBjaqVwvXwT14/Ne39b1LqZytdlLqTrtNKVyj2TfW8xTN+2syS3n
	 4GwZYl/eQOgSSK/qWpMueMNtZ1vHTzyRwCT2whJtOZGcHaN6Rtot7SOtAaIh8kwjE9
	 38+6OixiPx6Bl8lZPhel9K1f4Bri+PoER/QvJqED+G/mvAVSbSnRBHWdjjK9BFjPeW
	 HzJBIhcOYPDEUGCig/v2zoGgcPTHsDBp6oQBphwoLqvfB62jTFmwPUFylGYUJ7GrsV
	 Mxb6CxwRRPdQj14Ni+qvwKzOmN2gUFgtOn3nBoeoabxN1p0K0grivnwWtUFoIgHUOX
	 IDGeg9XAT4eUw==
From: Tejun Heo <tj@kernel.org>
To: Tao Cui <cui.tao@linux.dev>
Cc: tj@kernel.org, josef@toxicopanda.com, axboe@kernel.dk,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, andrii@kernel.org,
 ast@kernel.org, daniel@iogearbox.net, linux-kselftest@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 6/8] selftests/bpf: add iocost cost model test
Date: Tue, 08 Sep 2026 10:31:11 -1000
Message-ID: <178889947168.2.11103866380052520121@kernel.org>
In-Reply-To: <20260908100143.47598-7-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
 <20260908100143.47598-7-cui.tao@linux.dev>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello, Tao.

On Tue, 08 Sep 2026 18:01:41 +0800, Tao Cui wrote:

> +		TH_LOG("open %s: %s", path, strerror(errno));

TH_LOG is not available through test_progs.h. A syntax check of the posted
runner fails here. Please use the test_progs logging facilities.

> +#include "iocost_model.skel.h"

The selftest kernel config also needs CONFIG_BLK_CGROUP_IOCOST and
CONFIG_BLK_CGROUP_IOCOST_BPF so vmlinux.h contains iocost_model_ops. The
runtime skip cannot avoid that build dependency.

> +			err = fprintf(fp, "%s", buf) <= 0;
> +			fclose(fp);

fprintf() can succeed while the buffered write is rejected at fclose(),
whose result is ignored. Check the actual write result and expected errno.
Please also check the flush and restoration errors in switch_to_bpf().

Thanks.

-- 
tejun
