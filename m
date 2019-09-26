From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/3 for-5.4/block] iocost: better trace vrate changes
Date: Thu, 26 Sep 2019 09:12:38 +0200
Message-ID: <310739da-b606-6485-9979-9bc03a592265@kernel.dk>
References: <20190925230207.GI2233839@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u/+FmsO2fNzcsmYglT3xz6RDpSXgM0989c2PSz8Zvf4=;
        b=VFGoxo+2NsxxwxjafuC2PpLHAFStjdosoGEbFmrM8SZ3rrImY4Sqc1/3J0DL/nSiek
         cKXmLnyFis+D0MbKrVE0ATCMolB8ETO3TmYRdu83WYIqnQN2/9Kr879GEZ2XHDJJp0Np
         sfEk1iSsp2VIf4BX2N7yHGkfOznLAcThCZOePG9i/g9qzTRvaEjv8bR5rGYL86uzXlQx
         FVWTg05Jc+tDb3dA6Y661ABAFal9Jdn4j3GNAfXvyNBLm7YFtNgG3YtiZnpvk0ZpjpRu
         SfIdUGBrMNXSt8Y7+NgK6sl1kd11BTn6K3rme6akMMJnevDRjfsXmJnf+0J+hfgcnGmm
         f3BQ==
In-Reply-To: <20190925230207.GI2233839@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org

On 9/26/19 1:02 AM, Tejun Heo wrote:
> vrate_adj tracepoint traces vrate changes; however, it does so only
> when busy_level is non-zero.  busy_level turning to zero can sometimes
> be as interesting an event.  This patch also enables vrate_adj
> tracepoint on other vrate related events - busy_level changes and
> non-zero nr_lagging.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Hello, Jens.
> 
> I've encountered vrate regulation issues while testing on a hard disk
> machine.  These are three patches to improve vrate adj visibility and
> fix the issue.

Applied 1-3 for 5.4, thanks Tejun.

-- 
Jens Axboe

