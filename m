From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH] memcg: Check more strictly to avoid ULLONG overflow by PAGE_ALIGN
Date: Fri, 12 Apr 2013 18:38:45 +0800
Message-ID: <CAFj3OHXiFfXciYx3EXYZvvAUt7bf8YnF6spyoNt4aftfV4ZBXw@mail.gmail.com>
References: <1365748763-4350-1-git-send-email-handai.szj@taobao.com>
	<20130412171108.d3ef3e2d66e9c1bfcf69467c@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=toOovUoIUKuksDHGPgKgreCQ1jrXxzhoGIyX02yOq6E=;
        b=VL2CdKKXb4yDVFfH/0K/gSEJfhvulfh61Qj/LiZToZo1/eacKugNIs62LmDWg7glXc
         U14gzITVk6U/fv+weZzdixH+DJ6fIGKlJe3AXuHRpbG7ekD8ou7SO0QFrCMr81LzZX2U
         y3CIztrOHsTs+iielAlAGTavgZOk7VExM775eNVApmRHkjkIEN+zkHhDWzy8uk2QpuwS
         hUecj8G13QeeglbToalM2Ye+Wk6zW4cf6U6Y9UIuaZPs1OjVGEFV2RuczUGVgCf/O49m
         xr2I8dCLhrBQoJFfOToDQMTgLXGCcO5skIx7NwExAQpcajzWVJmPcUub7Xf+etREqmAW
         f3lg==
In-Reply-To: <20130412171108.d3ef3e2d66e9c1bfcf69467c@mxp.nes.nec.co.jp>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, jeff.liu@oracle.com, Sha Zhengju <handai.szj@taobao.com>

Hi,

On Fri, Apr 12, 2013 at 4:11 PM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> Hi,
>
> On Fri, 12 Apr 2013 14:39:23 +0800
> Sha Zhengju <handai.szj@gmail.com> wrote:
>
>> From: Sha Zhengju <handai.szj@taobao.com>
>>
>> While writing memory.limit_in_bytes, a confusing result may happen:
>>
>> $ mkdir /memcg/test
>> $ cat /memcg/test/memory.limit_in_bytes
>> 9223372036854775807
>> $ cat /memcg/test/memory.memsw.limit_in_bytes
>> 9223372036854775807
>> $ echo 18446744073709551614 > /memcg/test/memory.limit_in_bytes
>> $ cat /memcg/test/memory.limit_in_bytes
>> 0
>>
>> Strangely, the write successed and reset the limit to 0.
>> The patch corrects RESOURCE_MAX and fixes this kind of overflow.
>>
>>
>> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
>> Reported-by: Li Wenpeng < xingke.lwp@taobao.com>
>> Cc: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  include/linux/res_counter.h |    2 +-
>>  kernel/res_counter.c        |    8 +++++++-
>>  2 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
>> index c230994..c2f01fc 100644
>> --- a/include/linux/res_counter.h
>> +++ b/include/linux/res_counter.h
>> @@ -54,7 +54,7 @@ struct res_counter {
>>       struct res_counter *parent;
>>  };
>>
>> -#define RESOURCE_MAX (unsigned long long)LLONG_MAX
>> +#define RESOURCE_MAX (unsigned long long)ULLONG_MAX
>>
>
> I don't think it's a good idea to change a user-visible value.

I'm not sure why we set the max of ull to LLONG_MAX or there are other
considerations, but we indeed can write a larger limit into it.

>
>>  /**
>>   * Helpers to interact with userspace
>> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
>> index ff55247..6c35310 100644
>> --- a/kernel/res_counter.c
>> +++ b/kernel/res_counter.c
>> @@ -195,6 +195,12 @@ int res_counter_memparse_write_strategy(const char *buf,
>>       if (*end != '\0')
>>               return -EINVAL;
>>
>> -     *res = PAGE_ALIGN(*res);
>> +     /* Since PAGE_ALIGN is aligning up(the next page boundary),
>> +      * check the left space to avoid overflow to 0. */
>> +     if (RESOURCE_MAX - *res < PAGE_SIZE - 1)
>> +             *res = RESOURCE_MAX;
>> +     else
>> +             *res = PAGE_ALIGN(*res);
>> +
>
> Current interface seems strange because we can set a bigger value than
> the value which means "unlimited".
> So, how about some thing like:
>
>         if (*res > RESOURCE_MAX)
>                 return -EINVAL;
>         if (*res > PAGE_ALIGN(RESOURCE_MAX) - PAGE_SIZE)
>                 *res = RESOURCE_MAX;
>         else
>                 *res = PAGE_ALIGN(*res);
>

Actually, once a memcg is created even if the limits remain unchanged,
we still account the tasks' memory usages, but since the current
RESOURCE_MAX is already large enough(8589934591G...) we can consider
it as 'unlimited'.
So here if still using the current 'fake' MAX value and a little
hacking behavior above, we're just intended for making up for the
previous defect(keeping user-visible value unchanged)?

Except for those, I'm fine with both of the approaches. :)

>
>
>>       return 0;
>>  }
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



--
Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
