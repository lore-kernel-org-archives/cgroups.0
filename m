From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -next v2 1/9] blk-iocost: cleanup ioc_qos_write() and
 ioc_cost_model_write()
Date: Wed, 30 Nov 2022 07:54:59 -0800
Message-ID: <Y4d801NjwwT0voKA@infradead.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-2-linan122@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=33yVl81nf/HYwbFyHP95flgen3w7k+7heZeCstu2Zt8=; b=1JXfUuCkqNVgQ9pH2hx3JGBJa1
        xGiCfys6fwNZUG6n/MUJVc83nSq085NlVLhdf5uUF8wSWS83HRjoBdnjR0f8pvmWEUMzJUlUUralz
        /Mq8A3ixnlv5DbHvj5ESqNZ5E+8/IzFurjAWffK8dQvzlxR1D5Equrh3itxNAd7ePbNiJNcS/qeu7
        HrSLXwHiOPcz+jb94A+bycyePIavkHCJqRnL7hJ1cSCtaMa5Q3P+aGyIiCh+MDagen1YVKdR6rJOq
        LMbCRWF2ZTNYYERjWEv3O6lP7ZDehAGMls52ZBXAbtV2CB3eJHC1zpFG1duRiOh+RRuOE4bhcxg/O
        Fva1+w3w==;
Content-Disposition: inline
In-Reply-To: <20221130132156.2836184-2-linan122@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Nan <linan122@huawei.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

> +	ret = nbytes;

ret is an int which bytes is a size_t.  So we at least need a ssize_t
instead for ret, and even that assumes nbytes never overflows a ssize_t.
