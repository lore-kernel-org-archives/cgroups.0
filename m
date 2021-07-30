From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] cgroup: Fix typo in comments and documents
Date: Fri, 30 Jul 2021 13:16:46 -0600
Message-ID: <87im0ra9y9.fsf@meer.lwn.net>
References: <20210730051605.2626-1-caihuoqing@baidu.com>
 <87lf5nc0su.fsf@meer.lwn.net> <YQQUwX+/1N9utKEN@casper.infradead.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 00A512A0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1627672607; bh=YZc6mmNZCtOeBrjLGQq95v8TtG0AvIQbj6k4rdcz9zg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=qmn7LCq42csnsffDQi5ZEs3vj9qdZow+WW/D2/zM9ft36MrKc+uu3WSDWCOp1pk65
         uTR+PpaYMkp76pYJrDsBkBRRfnalc6hLzagHP4EByWUqIEGarFVmx0i8me+2+g9pBj
         VI9eEAVIL6q5f69dVukJDgUA8ccztyhjzI6xVrvYy8yGThpgnV0KyKSYIaNEtFGUSv
         R9csgOPitVaOAKMOhEkxUsDI3bq/ZaFinWeegdVjPf77MmmSX/q1MM+VT1DYnZyyQH
         9HGZm/yJsx7WP5dG3dJCYpNIT2AjoRCdLeEiKPFiIA6ILZWYByVUBaH5iObjbdmsha
         hdwc5xwHL1pgA==
In-Reply-To: <YQQUwX+/1N9utKEN@casper.infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Cai Huoqing <caihuoqing@baidu.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

Matthew Wilcox <willy@infradead.org> writes:

> On Fri, Jul 30, 2021 at 08:51:29AM -0600, Jonathan Corbet wrote:
>> Cai Huoqing <caihuoqing@baidu.com> writes:
>> 
>> > Fix typo: iff  ==> if
>> >
>> > Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
>> 
>> This is becoming an FAQ ...  "iff" in mathematical English means "if and
>> only if"; its usage in these documents is correct.
>
> ... and yet it's clearly not understood.  Similarly to the [start..end)
> convention (also the [start..end[ convention).  Should we deprecate
> use of it in kernel documentation, and if so, what should we replace it
> with?

I'm never quite sure what to do with these things...we want to be
inclusive, but we don't want to hobble the language we use beyond a
certain point.  We could ask people to spell out "if and only if", I
suppose, but that sounds like the kind of thing that leads to unpleasant
messages in my inbox.

Thanks,

jon
