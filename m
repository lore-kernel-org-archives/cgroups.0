From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/15] blk-cgroup: remove __bio_blkcg
Date: Thu, 21 Apr 2022 11:21:01 -1000
Message-ID: <YmHKvY658MbXQKzj@slm.duckdns.org>
References: <20220420042723.1010598-1-hch@lst.de>
 <20220420042723.1010598-2-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IinI33pSr8d3WhExYC7mTfj7eLtY6joSBsl3ibPhoGg=;
        b=DCakvaO85AHCPkXp1OMlJGDTQgPZHI6loyZStX1R06qX3I8dlTt8gy4VOUJ/X1QRo5
         kj/GasYXiUQfIkp1NFVNFCx3EL3XjoHbJHjAjvCnBsRgeJ3Te1ZQUT9RVkXXzc7oahvi
         T6ldgq9In5sBxJlTibzusLYfg9f5Js72idQqPI712gT/X61EPmDWdmuVgGOUlHfmH1OX
         tBUqSwrtLOnSkSIQGg4T8kZ3yKXcCJ8WxP32RePAeqhVPOXJM7Q6YRCzd0e5qp12hlNK
         9agkcAvEgTQ9aWn+ojFuWjNXu6sbKRHPBgOdfl8Ef9piSRNhYS6a7t0rtNXuhCfVGL0w
         b0FA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220420042723.1010598-2-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Paolo Valente <paolo.valente@linaro.org>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-nvme@lists.infradead.org, linux-mm@kvack.org

On Wed, Apr 20, 2022 at 06:27:09AM +0200, Christoph Hellwig wrote:
> Remove the unused and deprecated __bio_blkcg helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
