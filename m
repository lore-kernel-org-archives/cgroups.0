From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: Check more strictly to avoid ULLONG overflow by PAGE_ALIGN
Date: Tue, 16 Apr 2013 15:29:25 +0800
Message-ID: <CAFj3OHX3XZf85F7161jp8KT30fCLFmpAYCx7J-PHx7cKOkTrQA@mail.gmail.com>
References: <1365748763-4350-1-git-send-email-handai.szj@taobao.com>
	<20130412171108.d3ef3e2d66e9c1bfcf69467c@mxp.nes.nec.co.jp>
	<20130415135805.c552511917b0dbe113388acb@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=gmkFWHKdfuf2L73oZuTaQiwp2vh0RTnEdu6RusSkK6A=;
        b=VjJp+/amAm03gM98pPiZYGG6PVx7pXerJRS792OUSF5IZbKJqIqbAw4BeVKjvJH++r
         te+E5r20kIoKYTZ/Z/6TVWVvHyeu6cVQxGpESw463yobh38F/yL4u/Ap6vBZOzAfOTI1
         hShp1nqUuTV9YaP/A/9cN/GVa++rR/LWleSiemouYNnNP+oW67iQJNv8l1uKbboHJEDD
         X49dD9AvtcbiKJAcIfEOy4AbZZenz9SdVvCSskD4/X8kvj1vvZBEbBioFqIucjj8nTmD
         NF+6sgCUT00vQaXrU9EIBj7+JEv0DWkgso46PNx7SyaGYwc1f1L3fXTISGQdv64iUgI9
         BjZg==
In-Reply-To: <20130415135805.c552511917b0dbe113388acb-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Tue, Apr 16, 2013 at 4:58 AM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Fri, 12 Apr 2013 17:11:08 +0900 Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org> wrote:
>
>> > --- a/include/linux/res_counter.h
>> > +++ b/include/linux/res_counter.h
>> > @@ -54,7 +54,7 @@ struct res_counter {
>> >     struct res_counter *parent;
>> >  };
>> >
>> > -#define RESOURCE_MAX (unsigned long long)LLONG_MAX
>> > +#define RESOURCE_MAX (unsigned long long)ULLONG_MAX
>> >
>>
>> I don't think it's a good idea to change a user-visible value.
>
> The old value was a mistake, surely.
>
> RESOURCE_MAX shouldn't be in this header file - that is far too general
> a name.  I suggest the definition be moved to res_counter.c.  And the
> (unsigned long long) cast is surely unneeded if we're to use
> ULLONG_MAX.
>
>> >  /**
>> >   * Helpers to interact with userspace
>> > diff --git a/kernel/res_counter.c b/kernel/res_counter.c
>> > index ff55247..6c35310 100644
>> > --- a/kernel/res_counter.c
>> > +++ b/kernel/res_counter.c
>> > @@ -195,6 +195,12 @@ int res_counter_memparse_write_strategy(const char *buf,
>> >     if (*end != '\0')
>> >             return -EINVAL;
>> >
>> > -   *res = PAGE_ALIGN(*res);
>> > +   /* Since PAGE_ALIGN is aligning up(the next page boundary),
>> > +    * check the left space to avoid overflow to 0. */
>> > +   if (RESOURCE_MAX - *res < PAGE_SIZE - 1)
>> > +           *res = RESOURCE_MAX;
>> > +   else
>> > +           *res = PAGE_ALIGN(*res);
>> > +
>>
>> Current interface seems strange because we can set a bigger value than
>> the value which means "unlimited".
>
> I'm not sure what you mean by this?
>
>> So, how about some thing like:
>>
>>       if (*res > RESOURCE_MAX)
>>               return -EINVAL;
>>       if (*res > PAGE_ALIGN(RESOURCE_MAX) - PAGE_SIZE)
>>               *res = RESOURCE_MAX;
>>       else
>>               *res = PAGE_ALIGN(*res);
>>
>
> The first thing I'd do to res_counter_memparse_write_strategy() is to
> rename its second arg to `resp' then add a local called `res'.  Because
> that function dereferences res far too often.
>
> Then,
>
> -       *res = PAGE_ALIGN(*res);
>         if (PAGE_ALIGN(res) >= res)
>                 res = PAGE_ALIGN(res);
>         else
>                 res = RESOURCE_MAX;     /* PAGE_ALIGN wrapped to zero */
>
>         *resp = res;
>         return 0;
>

Okay, this one is better.


Thanks,
Sha
