From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] memcg: correct RESOURCE_MAX to ULLONG_MAX and rename
 it to a better one
Date: Tue, 7 May 2013 23:10:31 +0800
Message-ID: <CAFj3OHVVPLQnOKFFdV6pu7mP=8W6mKUusvaBU8aspRZeUNBaOw@mail.gmail.com>
References: <1367768477-4360-1-git-send-email-handai.szj@taobao.com>
	<20130507134004.GB9497@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=4YjDB20FssuLerVbPPsTWBp+hAdUbSKgVTCwoIOm08k=;
        b=sdEgrTAkgELePoPxWu/o0Khm1b+fuwG8qAKkOB2kluj1W/OH5Fjc1gqAY6QWvGPBli
         G9hYE/rx0XXzXa+rz2dr8frqoGhE73qcwd17OxIBbfrzfSkxd2kqxM7VObM8A9vAjRFr
         wXQBU+dE/RCNyF/c+f7qo85Pe4JfOB5ATTdgH+L6Os6ttwo4reQoB7u7kbS+GJ6kXRMt
         YXt4ZLq8Q6x1Os7Xr9unwkYMl6SprgVzhjWYzeQM2EjLcboMBDDd3IN+gXhu/UYtdh6g
         c6U3I6TvRvcCjsTaHH5WDATerFBbnflnGgMRoa6UkWF4qbYU3jxrsQn2vsYVdwyBRnDg
         zfMw==
In-Reply-To: <20130507134004.GB9497-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Hi Michal,

On Tue, May 7, 2013 at 9:40 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Sun 05-05-13 23:41:17, Sha Zhengju wrote:
>> Current RESOURCE_MAX(unlimited) is ULONG_MAX, but we can set a bigger value
>
> You have a typo here. The current limit is LLONG_MAX
>
>> than it which is strange. This patch fix it to UULONG_MAX.
>
> and the new one is ULLONG_MAX

Oops... It was most thoughtless of me.

>
>> Notice that this change will affect user output of default *.limit_in_bytes:
>> before change:
>> $ cat /memcg/memory.limit_in_bytes
>> 9223372036854775807
>>
>> after change:
>> $ cat /memcg/memory.limit_in_bytes
>> 18446744073709551615
>>
>> But it doesn't alter the API in term of input - we can still use
>> "echo -1 > *.limit_in_bytes" to reset the numbers to "unlimited".
>>
>> Thanks the suggestions from Andrew and Daisuke Nishimura!
>>
>> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>
> For the default change
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Thanks!

>
>> ---
>>  include/linux/res_counter.h |    2 +-
>>  kernel/res_counter.c        |    8 ++++----
>>  mm/memcontrol.c             |    4 ++--
>>  net/ipv4/tcp_memcontrol.c   |   10 +++++-----
>>  4 files changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
>> index c230994..d7e9056 100644
>> --- a/include/linux/res_counter.h
>> +++ b/include/linux/res_counter.h
>> @@ -54,7 +54,7 @@ struct res_counter {
>>       struct res_counter *parent;
>>  };
>>
>> -#define RESOURCE_MAX (unsigned long long)LLONG_MAX
>> +#define RES_COUNTER_MAX ULLONG_MAX
>
> I do not think the renaming is worth bothering but if you feel it is a
> better match then just do it in a separate patch, please.

I've received comments from Andrew that he suggested we had better
rename it since it is too general. (Sorry, it's my fault that I didn't
mention the change log from V1, I will take care next time. The
previous discussion is here:
http://www.spinics.net/lists/cgroups/msg06788.html). I think we might
as well do it and I'll separate it in next turn.

--
Thanks,
Sha
