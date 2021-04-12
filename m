From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next] cgroup/cpuset: fix typos in comments
Date: Mon, 12 Apr 2021 17:21:12 -0400
Message-ID: <YHS5yPsuQxPbzNdT@slm.duckdns.org>
References: <20210408080346.166046-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MBWhgeDndp0aZntn+ODLCePsN2Avwf3xdPZInGzyS+0=;
        b=sH8Fchkq/AinteIuXtQiJD7yfb56iqLXEJgwpccdCaz/VKUDWKkOYg8QlTGqlDYVY1
         AGE8n70N/Nimrb3WC47tDMr7bO3VVaEC2MX7L3NmA9G9FsgyuBDIyvDF45nnFEprQSMj
         Or8o6NabQPDxsHDAOGyHXuKGBlI2mkIH9ipZbJSq2NlIcky98cfAso1knges3C2LnOxC
         tFMcjXdvLSuoBnPfjhfz0k5QauvhEB5qivFSeiNcFTybxSdb6PmQV6eICgUhwnK36Mu+
         1qAl6pW8cUYFFIiBze7ZHlSSvmINlqmxODdfqRv3aj7YZh37X5NNaokZQp2H2hjx+2SW
         C4eg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210408080346.166046-1-lujialin4@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lu Jialin <lujialin4@huawei.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Wang Weiyang <wangweiyang2@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Apr 08, 2021 at 04:03:46PM +0800, Lu Jialin wrote:
> Change hierachy to hierarchy and unrechable to unreachable,
> no functionality changed.
> 
> Signed-off-by: Lu Jialin <lujialin4@huawei.com>

Applied to cgroup/for-5.13.

Thanks.

-- 
tejun
