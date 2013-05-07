From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH 2/3] memcg: check more strictly to avoid PAGE_ALIGN
 wrapped to 0
Date: Tue, 7 May 2013 23:41:09 +0800
Message-ID: <CAFj3OHVerf4L5JAHYqQuEykmV1fk1HB5hN86JBzpHSJU7=cAZQ@mail.gmail.com>
References: <1367768590-4403-1-git-send-email-handai.szj@taobao.com>
	<20130507140402.GC9497@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=sr0I13QS0wzC1hbMENFzfhik5bb2VYs5KnizT8K6lw8=;
        b=IW8i9K07jIwCkDPcmv5vpjSRsDfdHIUtCOo4OdqezGOOMQ5melbL7Bedmnbp4HeWY+
         6GIWcihX6xSrXOyyv0KZZ2Ak+m4Wf2hFDtK72blvJB4LhIpwCCg5uz45JR6iCRqfNH/f
         rGVET5XEnSB3Echj+S6yorJI/Wdw0FKm47tFxd1mfxuWoi42UWxA/eXLDViuRgw1+mjG
         ILzN9sn9ju5Jqd9FEYr5lKT49qdJRyhU+i7Ct3neK8ZPumhes9a//s3DTN7y++KPkBy4
         JyhHJr05QJnT3a2sa3FNKDSwGHKvsTON/Jkx/G4+wOXoUsv1SZB50iE0kUyyM/HOPXej
         ghLQ==
In-Reply-To: <20130507140402.GC9497@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, Andrew Morton <akpm@linux-foundation.org>, jeff.liu@oracle.com, Sha Zhengju <handai.szj@taobao.com>

On Tue, May 7, 2013 at 10:04 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Sun 05-05-13 23:43:10, Sha Zhengju wrote:
>> Since PAGE_ALIGN is aligning up(the next page boundary), this can
>> prevent input values wrapped to 0 and cause strange result to user.
>
> I guess you wanted to say that it can cause an overflow, right?
> "
> Since PAGE_ALIGN is aligning up (to the next page boundary), this can
> cause an overflow to 0 if >= ULLONG_MAX-4094 value is given in the
> buffer.
> "

Yes!

>>
>> This patch also rename the second arg of
>> res_counter_memparse_write_strategy() to 'resp' and add a local
>> variable 'res' to save the too often dereferences. Thanks Andrew
>> for pointing it out!
>
> Again, it would be nicer to have this cleanup in a separate patch.

Okay.

>
>> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
>> Reported-by: Li Wenpeng <xingke.lwp@taobao.com>
>
> Acked-by: Michal Hocko <mhocko@suse.cz>
>
> We have this bug since ever and nobody has noticed so nobody seems to
> use

Yeah, that's rarely occur, but we happened to run into it.
Thank you for the comments!

>
>> ---
>>  kernel/res_counter.c |   18 ++++++++++++------
>>  1 file changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/res_counter.c b/kernel/res_counter.c
>> index 3f0417f..be8ddda 100644
>> --- a/kernel/res_counter.c
>> +++ b/kernel/res_counter.c
>> @@ -178,23 +178,29 @@ u64 res_counter_read_u64(struct res_counter *counter, int member)
>>  #endif
>>
>>  int res_counter_memparse_write_strategy(const char *buf,
>> -                                     unsigned long long *res)
>> +                                     unsigned long long *resp)
>>  {
>>       char *end;
>> +     unsigned long long res;
>>
>>       /* return RES_COUNTER_MAX(unlimited) if "-1" is specified */
>>       if (*buf == '-') {
>> -             *res = simple_strtoull(buf + 1, &end, 10);
>> -             if (*res != 1 || *end != '\0')
>> +             res = simple_strtoull(buf + 1, &end, 10);
>> +             if (res != 1 || *end != '\0')
>>                       return -EINVAL;
>> -             *res = RES_COUNTER_MAX;
>> +             *resp = RES_COUNTER_MAX;
>>               return 0;
>>       }
>>
>> -     *res = memparse(buf, &end);
>> +     res = memparse(buf, &end);
>>       if (*end != '\0')
>>               return -EINVAL;
>>
>> -     *res = PAGE_ALIGN(*res);
>> +     if (PAGE_ALIGN(res) >= res)
>> +             res = PAGE_ALIGN(res);
>> +     else
>> +             res = RES_COUNTER_MAX; /* avoid PAGE_ALIGN wrapping to zero */
>> +
>> +     *resp = res;
>>       return 0;
>>  }
>> --
>> 1.7.9.5
>>
>
> --
> Michal Hocko
> SUSE Labs



--
Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
