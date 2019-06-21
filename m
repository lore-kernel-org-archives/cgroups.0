From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/5] BT scheduling class
Date: Fri, 21 Jun 2019 15:03:16 +0200
Message-ID: <20190621130316.GK3436@hirez.programming.kicks-ass.net>
References: <1561103157-11246-1-git-send-email-xiaoggchen@tencent.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8voMoB854F0d0ERXQAC40rhDRb6mL2IHOiaUQ+KH42o=; b=z8rASQxg05EpGWK8+LWzS8UKu
        R2t5YFty57rg3tJ+9o5GBkwAFsW238Ziar0WfMCtcJq1L/DAcVT1w/tbaJA4s64uIwHAkmnFyISd4
        4ANrU0r4enmtDhKjihUH0dSv4PnuZ4uUBgt0i5fxsojbqLFtJLRJZk23qdNTYXHIxV16wNZ4pDumI
        /sjfSFSbKJDdeOKwJ3Jnna5pw+NrsuUl4w0QdqE31uGhi36L8x9HNb/RZ2nLEob7bPa3O0kvNi5kb
        qce7MpVKClVlejw/WlIYqVDd8POiUFWKg6VCUmo1w6J3NbQsMuTKB3wsmCpKosmPAI9zG9BJ2bFMr
Content-Disposition: inline
In-Reply-To: <1561103157-11246-1-git-send-email-xiaoggchen@tencent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xiaoggchen@tencent.com
Cc: jasperwang@tencent.com, heddchen@tencent.com, mingo@redhat.com, linux-kernel@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, viresh.kumar@linaro.org

On Fri, Jun 21, 2019 at 03:45:52PM +0800, xiaoggchen@tencent.com wrote:

> First only server application exists in the system and the success
> rate is 99.998% and the average cpu use is only 25%.

Have you guys looked at this series:

  https://lkml.kernel.org/r/cover.1556182964.git.viresh.kumar@linaro.org


