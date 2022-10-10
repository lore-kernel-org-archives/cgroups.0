From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] blk-cgroup: Fix typo in comment
Date: Mon, 10 Oct 2022 10:29:36 -1000
Message-ID: <Y0SAsFcIgLvkPpPi@slm.duckdns.org>
References: <20221010023859.11896-1-shikemeng@huawei.com>
 <20221010023859.11896-5-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qJvdR5sFA7841TfkHWBXVf+L88za68VvtqLkISWSSSU=;
        b=mzi+/WBX/eFPhWGRK9wk25LbdDWrPtoko+QoLbYq0hvYx6m4vETmFUGiPPn3VsV0gA
         i+6WjDzaxoqyRXmWtvngaiuaryYkBi+wK7hwrLWOAH9u1CdCLDXYFeA0iZTQpNeKhY78
         txA6yTR3Po4vsfLRmHO7bUvUB1VB4pNCFef8LirwRR7MmCj8cL64TBK32FD+5V1y5eit
         /ZbkipPrix/XLAUNcNSqLNygx2pwxjox3ZbUIUapUf9darLgWGmBgSe6EaoUlGzs79gg
         T/o8f+CuAjAQoZZsN7jFqFh8VWcmYy9Z0J6GYR1w+ChMabKGOHmxt0j3x+9LyNMxX1EP
         3Jew==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221010023859.11896-5-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng@huawei.com>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 10, 2022 at 10:38:59AM +0800, Kemeng Shi wrote:
> Replace assocating with associating.
> Replace assocaited with associated.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
