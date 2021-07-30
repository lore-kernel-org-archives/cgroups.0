From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] cgroup: Fix typo in comments and documents
Date: Fri, 30 Jul 2021 08:51:29 -0600
Message-ID: <87lf5nc0su.fsf@meer.lwn.net>
References: <20210730051605.2626-1-caihuoqing@baidu.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net B5CB62A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1627656689; bh=11tsRvWqxa857A4Loa4QydFr4xgnp3s3Ast3UUgdn+0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=VN8pSMY/6VyMSZP1meyUIrBqFBjrUbbgFVmCyesRBGTMpmETD1yXzrEc52grBRSo2
         U8COBlGrfOWLxmyOrz6F5tLHVEpUttpiv0BxARkODmWFSv9i01tPrWBlfH+8Q2O4TG
         IfkUiD6JU5YPYz+arEeDZ9Ue+qpM1PgHkW4r8Ak0TcfuKodWmXo7ZWVLUCDDLOWNO0
         jn5SRoj3sNcrSIgksC8ujEslevYMqBCvZuWGrokVAT3SC04SBxVh5SCBx7cvaAB4Ti
         B7S3mKpTvxemKZTAWusUBz4mLFzsvcncVyyw0+beAzNhvgD6syn1Qmu1q2qRR4HmJz
         4STtbzjHAmJhg==
In-Reply-To: <20210730051605.2626-1-caihuoqing@baidu.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cai Huoqing <caihuoqing@baidu.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Cai Huoqing <caihuoqing@baidu.com>

Cai Huoqing <caihuoqing@baidu.com> writes:

> Fix typo: iff  ==> if
>
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

This is becoming an FAQ ...  "iff" in mathematical English means "if and
only if"; its usage in these documents is correct.

Thanks,

jon
