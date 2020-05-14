From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH iproute2-next v2 1/3] ss: introduce cgroup2 cache and
 helper functions
Date: Wed, 13 May 2020 21:28:28 -0600
Message-ID: <c3221491-18e9-4de5-961c-38b9ac184601@gmail.com>
References: <20200509165202.17959-1-zeil@yandex-team.ru>
 <42814b4f-dc95-d246-47a4-2b8c46dd607e@gmail.com>
 <25511589354341@mail.yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U6W+r5c8ovMrF0z73K8Er6Wd4+8Nosbg+auclRIfIos=;
        b=o0iNI2Olf2IOyuGxWubB+iFpYCVvBJbk4a6mDyVyQmhznbHtTH653YfWBbT65GTw18
         YvSBTpDqauQMUKykr2/Z0WNtDU2P7Ivt6bFbGWUOkEYG8GZwfWQxPpJ457IAqETG/3eI
         D6P/Vx9vXApI7gVLteSZope7ihAYv3ybdp+pmWck7xkTT7vpmh78Wve2pTw3FOltsSiX
         N2cuJNZe9+mihoUr3Vgkn1sImHCjmKHbcpAnh5MJn4D203HHx93kDVPqvth6MjccU8vI
         wdYi0eOr2Vv13eEwB3kHyYWeTWXwQ8hDSSOrUSmG8b9pfE+fR8p2sN0pXsazK0QVjOuG
         Du3g==
In-Reply-To: <25511589354341-ksC8LV8Y0H5cXLcuY5BXMCjHesifYMBh@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?B?0JTQvNC40YLRgNC40Lkg0K/QutGD0L3QuNC9?= <zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 5/13/20 1:27 AM, Дмитрий Якунин wrote:
> 
> 
> 13.05.2020, 05:03, "David Ahern" <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> On 5/9/20 10:52 AM, Dmitry Yakunin wrote:
>>>  This patch prepares infrastructure for matching sockets by cgroups.
>>>  Two helper functions are added for transformation between cgroup v2 ID
>>>  and pathname. Cgroup v2 cache is implemented as hash table indexed by ID.
>>>  This cache is needed for faster lookups of socket cgroup.
>>>
>>>  v2:
>>>    - style fixes (David Ahern)
>>
>> you missed my other comment about this set. Running this new command on
>> a kernel without support should give the user a better error message
>> than a string of Invalid arguments:
>>
>> $ uname -r
>> 5.3.0-51-generic
>>
>> $ ss -a cgroup /sys/fs/cgroup/unified
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
> 
> No, i didn't miss your comment. This patchset was extended with the third patch which includes bytecode filter checking.
> 

ok. missed that. applied to iproute2-next.

in the future, please provide a cover letter
