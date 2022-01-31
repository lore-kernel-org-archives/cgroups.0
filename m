From: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Subject: Re: [PATCH v2 1/3] lib/vsprintf: Avoid redundant work with 0 size
Date: Mon, 31 Jan 2022 12:02:29 +0100
Message-ID: <d44824d4-2dd1-a8ab-d3ee-ac67b749ca6f@rasmusvillemoes.dk>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-2-longman@redhat.com>
 <d99b3c4b-7b6e-529-6e4b-b91b65c92d81@google.com>
 <Yfe5Bb3U6Uil7Y6g@smile.fi.intel.com> <Yfe6SfG4CqzWSaMM@smile.fi.intel.com>
 <Yfe7Q5cx+MoaOev/@smile.fi.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=czeOm2pkfIYtlH8bieE/wFkWMyQace30JcDwxXQeWDY=;
        b=NAM+paj077GlbsSEbAhREf9Ku6Zelpm258xyJs/uNE2AuRvKnCy48gfwZAgwyslTFR
         m3FwDtohPmEJwRAkIVNJawuANbhmN7JaxgRofyQ/AdWTlQb60iLuWwhb63Vy8Kso+QP0
         7e2+p6p/6JWa/AfN5eIUs1nzVxb1IJYuYjzQA=
In-Reply-To: <Yfe7Q5cx+MoaOev/@smile.fi.intel.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 31/01/2022 11.34, Andy Shevchenko wrote:
> On Mon, Jan 31, 2022 at 12:30:33PM +0200, Andy Shevchenko wrote:
>> On Mon, Jan 31, 2022 at 12:25:09PM +0200, Andy Shevchenko wrote:
>>> On Sun, Jan 30, 2022 at 12:49:37PM -0800, David Rientjes wrote:
>>>> On Sat, 29 Jan 2022, Waiman Long wrote:
>>>>
>>>>> For *scnprintf(), vsnprintf() is always called even if the input size is
>>>>> 0. That is a waste of time, so just return 0 in this case.
>>>
>>> Why do you think it's not legit?
>>
>> I have to elaborate.
>>
>> For *nprintf() the size=0 is quite useful to have.
>> For *cnprintf() the size=0 makes less sense, but, if we read `man snprintf()`:
>>
>>   The  functions  snprintf() and vsnprintf() do not write more than size bytes
>>   (including the terminating null byte ('\0')). If the output was truncated due
>>   to this limit, then the return value is the  number of  characters (excluding
>>   the terminating null byte) which would have been written to the final string
>>   if enough space had been available. Thus, a return value of size or more
>>   means  that  the  output  was truncated.  (See also below under NOTES.)
>>
>>   If an output error is encountered, a negative value is returned.
>>
>> Note the last sentence there. You need to answer to it in the commit message
>> why your change is okay and it will show that you thought through all possible
>> scenarios.
> 
> Also it seems currently the kernel documentation is not aligned with the code
> 
>   "If @size is == 0 the function returns 0."
> 
> It should mention the (theoretical?) possibility of getting negative value,
> if vsnprintf() returns negative value.
> 

The kernel's vsnprintf _will never_ return a negative value. There is
way too much code which relies on that. It also has to work from any
context, so we'll never do any memory allocation or anything else that
could possibly force us to error out, and even if we encounter some
impossible situation, we do not return a negative value, but just stop
the output where we are.

So yes, micro-optimizing [v]scnprintf() is completely valid, but I've
never bothered to send the patch because the use case for scnprintf() is
primarily the

  ret += scnprintf(buf + ret, size - ret, ...);

pattern, with ret starting out at 0 and size being some non-zero number.
When given a non-zero size, scnprintf() is guaranteed to return
something _strictly less_ than that value; that invariant guarantees
that the size-ret expression never becomes 0. So if scnprintf() is
properly used, I can't think of any situation where size will be 0,
hence I see that patch as correct-but-mostly-pointless.

Rasmus
