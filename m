From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v10 4/4] cgroups: implement the PIDs subsystem
Date: Thu, 14 May 2015 03:44:24 +1000
Message-ID: <CAOviyaimfHD=Jg1+FEwyapwO=zdaL0bvq8YDA1Cnq90YbfGENQ@mail.gmail.com>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
	<1429446154-10660-5-git-send-email-cyphar@cyphar.com>
	<20150422162954.GF10738@htj.duckdns.org>
	<CAOviyagHJhxD8E+CeEdy399ARPaNyyiSJSJjByK=5ALN5jxbJw@mail.gmail.com>
	<20150424153657.GC24029@htj.duckdns.org>
	<CAOviyah9yyXJG0eUeizpb5ZnzNUAKfxXGkXJw-5sNw7sQOAEuA@mail.gmail.com>
	<20150513172906.GY11388@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150513172906.GY11388@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

>> Would you be okay with this?
>>
>>     if (limit < 0 || limit >= PIDS_MAX)
>>
>> I'd prefer if we used PIDS_MAX as the maximum input value as well as
>> being the internal representation of the maximum, rather than
>> switching to something like INT_MAX.
>
> Yeah, that sounds okay to me but I forgot why we went for INT_MAX in
> the first place.  Do you remember why we tried INT_MAX at all?
>
> Thanks.
>
> --
> tejun

I think it's because we didn't want to expose PIDS_MAX to userspace.
But we're not *really* exposing it, we're just enforcing the input
limit for "max".

--
Aleksa Sarai (cyphar)
www.cyphar.com
