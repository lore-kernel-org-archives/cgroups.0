From: =?utf-8?B?0JTQvNC40YLRgNC40Lkg0K/QutGD0L3QuNC9?= 
        <zeil-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH iproute2-next v2 1/3] ss: introduce cgroup2 cache and helper functions
Date: Wed, 13 May 2020 10:27:42 +0300
Message-ID: <25511589354341@mail.yandex-team.ru>
References: <20200509165202.17959-1-zeil@yandex-team.ru> <42814b4f-dc95-d246-47a4-2b8c46dd607e@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1589354863; bh=fqTiNo7qgWHswfMQuWMsYkNbunOtZFsc+gVHEJqehuM=;
        h=Subject:In-Reply-To:Cc:Date:References:To:From:Message-Id;
        b=JWdpHWOZZIaiOXsS0PqNcPWXouB+6R7VLJw+CpzqnlvlBpv1KCr0rctlRYuF4Gur9
         0J5KL+MM0M5lDsGGVlQvj7ve3qxTh+bvHOrwiukVzOi+3uhOnbkIlQnNVpl3gjP2fV
         o6JLQjeikub1PL99IcjMO4mpe/rkBLlvdv5gyCQM=
In-Reply-To: <42814b4f-dc95-d246-47a4-2b8c46dd607e-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



13.05.2020, 05:03, "David Ahern" <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On 5/9/20 10:52 AM, Dmitry Yakunin wrote:
>>  This patch prepares infrastructure for matching sockets by cgroups.
>>  Two helper functions are added for transformation between cgroup v2 ID
>>  and pathname. Cgroup v2 cache is implemented as hash table indexed by ID.
>>  This cache is needed for faster lookups of socket cgroup.
>>
>>  v2:
>>    - style fixes (David Ahern)
>
> you missed my other comment about this set. Running this new command on
> a kernel without support should give the user a better error message
> than a string of Invalid arguments:
>
> $ uname -r
> 5.3.0-51-generic
>
> $ ss -a cgroup /sys/fs/cgroup/unified
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument
> RTNETLINK answers: Invalid argument

No, i didn't miss your comment. This patchset was extended with the third patch which includes bytecode filter checking.
