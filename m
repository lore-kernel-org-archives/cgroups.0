From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] cgroup: Fix typo in comments and documents
Date: Fri, 30 Jul 2021 16:03:29 +0100
Message-ID: <YQQUwX+/1N9utKEN@casper.infradead.org>
References: <20210730051605.2626-1-caihuoqing@baidu.com>
 <87lf5nc0su.fsf@meer.lwn.net>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mO/QfKKgdDva3A+HR1SvHcs/ooBUVUFlVYCzjnwt1Jc=; b=fiUI1Q6YBT7hv+CJGJ8nRMKHbs
        CbuMpTc3Jbe0ChvLzPGC6jlL9yVJMSZ6/Tq2vrwx0DwHtx6//o1G2fjJAQe7cnbNjE6reNlCy9tbV
        47ewXWmRbAUHFy4sMY85I8dpiAgxYDumsiSiWBlvPMDUr/XYhEK5RsFNFskxZk0TThicJvpC9bUAl
        eLyj7a+jdr9KPYQoxRBXGWkTPhYoAHPFVnIyiMH28p7TcZ+vCEBnlD02Sbt+WL2luH0oAlEC4pjW9
        UoBBtqzhsx6QTEB2eGXT3l5kUo2u/Yyrrqb3VzdZcNI3ZfYPyXeSdRsgaegVYUIOPsIWBzzw8axPe
        NOkyjVPA==;
Content-Disposition: inline
In-Reply-To: <87lf5nc0su.fsf@meer.lwn.net>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>
Cc: Cai Huoqing <caihuoqing@baidu.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Fri, Jul 30, 2021 at 08:51:29AM -0600, Jonathan Corbet wrote:
> Cai Huoqing <caihuoqing@baidu.com> writes:
> 
> > Fix typo: iff  ==> if
> >
> > Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> This is becoming an FAQ ...  "iff" in mathematical English means "if and
> only if"; its usage in these documents is correct.

... and yet it's clearly not understood.  Similarly to the [start..end)
convention (also the [start..end[ convention).  Should we deprecate
use of it in kernel documentation, and if so, what should we replace it
with?
