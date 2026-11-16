Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833002;
	b=o3CbigomtiPb4qO4DnSt3EVfaUPDVr8zO4+dxrVWlCT2EmkucTlfHSAxxgNVwIr0TGzF
	 qJO8XPlCV/NAR+jF9jATRodjkeLwQzmrQ2OMjS305tQWuLO0FgO9DlIZGnzI2rcU2teXw
	 MPHjjzmhWFIvF1EXUdACn8RuwKzqaFnGi7/fgHagceVgPfPtxgwxlc8Dpu6U/nxUUXA5A
	 3qblG+Cmea4oSxXcTcdufD6Ryl2UEK2kHFDIoueNDw3SMi7rMLtoWBsnBX/Q/tc03wEua
	 fqfwzkYDYRnaAkJ265i4HBxS3sinVaIx1Fql5HLgD7Y/bJS7TyTuW7QwguBUS6YjahQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833002;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=CUoPl1l8usOofd78Ed60am7yd2LiyfDr+gb/uSMrxrQ=;
	b=sOI2i9Q9MxAVQprv+EeJYyIrzXf3HY2J1N85Gylh6o3qkFYOFnAWmt0N+pbgcgVJnALk
	 EX971KwHNwsvptgHrGkXvc4ZK5j1aA4qIVCYcum0csO70YeGbIRnBhH/PFAvg+dIjAl9n
	 SH2APJAmCYLEhpyW4kliOB9GQg3ruVxWZJuv3iNccnTuJiW82TEfaxry57/yVDaJMf/Rh
	 nMEEkwFPEcWwSfIZkBOE6JkhKDLG07LkiPkCloRY5pHuSMYXSOPKdRBoGFqU5eXT5A6QU
	 z/rKBl+jqfyzK/ffxGqbUxQLBb6TKX6qvTELlIxJwg5VJ+3nCZeTzGL14Ij4h4+8k9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=I1s9A41H;
	arc=none smtp.remote-ip=95.215.58.44
Received: from mta1.migadu.com (out-44.mta1.migadu.com [95.215.58.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D7F606A31C
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 12:43:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14D7F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=I1s9A41H
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=aV0qlpDNLooNPnrXY/O+0ggSMhmcS5vAI4Fpci/O2HM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794832998; v=1; x=1795437798;
 b=I1s9A41HT3FiYpPUzewZNWQf8vkqhHIR5ARVQKbAS7SluRlbI2ihtVhd5lhnKrQhcJUMCIoY
 eNwzEYRSRu+xLaJ5egcR9w3ULxO87tojrrLTl/r9R3iJElHDuTAqzvuuvVWpgRcAaxAzfBIIPQp
 KiXCd1WtAFdxn6UXLCj7xSVU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fca2d1d817ea616d;
	Mon, 16 Nov 2026 12:43:18 +0000
X-Mizu-Trace-ID: fca2d1d817ea616d
X-Migadu-Flow: FLOW_OUT
Message-ID: <d0128189-f454-42bf-972b-90f6a8536b83@linux.dev>
Date: Mon, 16 Nov 2026 20:43:08 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, tj@kernel.org, josef@toxicpanda.com,
 bvanassche@acm.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-ioprio: check capabilities before promoting a cgroup
 to RT
To: Hungyu Lin <dennylin0707@gmail.com>, axboe@kernel.dk
References: <20261116090529.69650-1-dennylin0707@gmail.com>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261116090529.69650-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/16 17:05, Hungyu Lin 写道:
> ioprio_set() and the per-request I/O priority of aio and io_uring only
> hand out IOPRIO_CLASS_RT to tasks that have CAP_SYS_ADMIN or
> CAP_SYS_NICE. The io.prio.class cgroup attribute has no such check.
> Writing "promote-to-rt", or its alias "none-to-rt", to it changes the
> requests of the cgroup to the RT class.
> 
> The attribute exists in every cgroup that has the io controller enabled
> and it is not hierarchical. A user that got a cgroup delegated owns the
> files of the child cgroups it creates there, so it can create a child
> cgroup, move into it and write "promote-to-rt" to its io.prio.class.
> Its requests are then issued with IOPRIO_CLASS_RT although ioprio_set()
> fails with -EPERM for the same task, and mq-deadline dispatches them
> before the best-effort requests of everybody else.
> 
> The delegation model in Documentation/admin-guide/cgroup-v2.rst expects
> the settings of all resource controllers to be hierarchical, so that a
> delegatee can only distribute further what it received from its parent.
> This attribute lets it raise the priority class of its own requests
> instead.
> 
> Require CAP_SYS_ADMIN or CAP_SYS_NICE for the two policies that raise
> the priority class, like ioprio_check_cap() does. The other policies are
> left alone.
> 
> Fixes: 556910e39249 ("block: Introduce the ioprio rq-qos policy")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Reviewed-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  block/blk-ioprio.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
> index 8fa8bca35062..ea32db727b16 100644
> --- a/block/blk-ioprio.c
> +++ b/block/blk-ioprio.c
> @@ -14,6 +14,7 @@
>  
>  #include <linux/blk-mq.h>
>  #include <linux/blk_types.h>
> +#include <linux/capability.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include "blk-cgroup.h"
> @@ -91,6 +92,9 @@ static ssize_t ioprio_set_prio_policy(struct kernfs_open_file *of, char *buf,
>  	ret = sysfs_match_string(policy_name, buf);
>  	if (ret < 0)
>  		return ret;
> +	if ((ret == POLICY_PROMOTE_TO_RT || ret == POLICY_NONE_TO_RT) &&
> +	    !capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
> +		return -EPERM;
>  	blkcg->prio_policy = ret;
>  	return nbytes;
>  }

