From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: initialize rqos before accessing it
Date: Sun, 26 Feb 2023 13:18:12 -0700
Message-ID: <167744269225.13527.9868779562423182386.b4-ty@kernel.dk>
References: <20230224160714.172884-1-leitao@debian.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TycbyvH4hoRUp82zuYMHneygBALggpe+yy/y2XkSW+k=;
        b=y7EMRhNnxrODvQIIQapGaXGGVUFVhimKVzRv3nzmTFNHrmZ/lCtDOdtAjhWEZWsGhO
         T9Mtom41ApCTh3kgxshWwaBncqlr1K3XGOkKuRZPVdsvWg1mM7zS80ZSGXtrJ22QLHnV
         i6vLBHuw0kX5aQJHrmCGwX/E3hJ/C/Rdjp/sKyIGM+P/vo+PYVyw945FDDnrpEf97VzV
         XzvySTN/wr3T4mwbcMHh83umRapfM3vikuVKPg2yr0jFvrVe6qbp82tE3u5aTRB8nL+i
         FwjpEvpZaIQa0iZBzNvutcgexlftNlVzbLaTr7Mi97JEFtW2CWLY3hsOGSNxnxpQ4J+a
         127g==
In-Reply-To: <20230224160714.172884-1-leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Breno Leitao <leitao-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: aherrmann-l3A5Bk7waGM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, leit-b10kYP2dOMg@public.gmane.org


On Fri, 24 Feb 2023 08:07:14 -0800, Breno Leitao wrote:
> Current kernel (d2980d8d826554fa6981d621e569a453787472f8) crashes
> when blk_iocost_init for `nvme1` disk.
> 
> 	BUG: kernel NULL pointer dereference, address: 0000000000000050
> 	#PF: supervisor read access in kernel mode
> 	#PF: error_code(0x0000) - not-present page
> 
> [...]

Applied, thanks!

[1/1] blk-iocost: initialize rqos before accessing it
      commit: efbb51a0aae5fcecda266ac254146e36fff41e16

Best regards,
-- 
Jens Axboe



