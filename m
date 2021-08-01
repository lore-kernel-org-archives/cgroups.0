From: Hu Haowen <src.res@email.cn>
Subject: Re: [PATCH] cgroup: Fix typo in comments and documents
Date: Sun, 1 Aug 2021 11:39:07 +0800
Message-ID: <4f44c9b2-15ae-1ed9-0c0a-f0cef648c416@email.cn>
References: <20210730051605.2626-1-caihuoqing@baidu.com>
 <87lf5nc0su.fsf@meer.lwn.net> <YQQUwX+/1N9utKEN@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cn;
        s=dkim; h=To:From:Date; bh=HPiF0gjTXrWW3nXeBh9k7on9SjUI9wWXMvbjR
        vl/P0s=; b=HvX+utebY+tIz7tKyXgj3yYl7sEtTDCcHjUifi7grxwiQ82gm2oC8
        GbC5V5ewEsdND8UzhtTE3OPJQnCKAQgQAxiGzjwouegOOVEoXZ4SrfrNxqBTUGeV
        DGG5zpVhqjyzZ22BA1uAunVMc2EWDnUVjBiOXEYMjz4wCzYLm0Uc+I=
In-Reply-To: <YQQUwX+/1N9utKEN@casper.infradead.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Matthew Wilcox <willy@infradead.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Cai Huoqing <caihuoqing@baidu.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org


=D4=DA 2021/7/30 =CF=C2=CE=E711:03, Matthew Wilcox =D0=B4=B5=C0:
> On Fri, Jul 30, 2021 at 08:51:29AM -0600, Jonathan Corbet wrote:
>> Cai Huoqing <caihuoqing@baidu.com> writes:
>>
>>> Fix typo: iff  =3D=3D> if
>>>
>>> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
>> This is becoming an FAQ ...  "iff" in mathematical English means "if and
>> only if"; its usage in these documents is correct.
> ... and yet it's clearly not understood.  Similarly to the [start..end)
> convention (also the [start..end[ convention).  Should we deprecate
> use of it in kernel documentation, and if so, what should we replace it
> with?

What about establishing a documentation section which gives clear
definitions to each words whose meaning isn't easy to understand for
common people, such as this situation? In this case readers are able to
get rid of their questions on their own, instead of asking maintainers
for any explanation.

Regards,
Hu Haowen

