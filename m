From: weiping zhang <zwp10758-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] blk-throttle: export io_serviced_recursive, io_service_bytes_recursive
Date: Thu, 18 Jan 2018 23:41:06 +0800
Message-ID: <CAA70yB6WJcNQqfF7SiT19qJ_sBY-DDDn5kzNmW24SSBgyTLEsw@mail.gmail.com>
References: <20171211145621.GA2115@localhost.didichuxing.com> <20171211151705.GG2421075@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=JHS0L2BGNpvM/S6ROUojlSnN0tsMtHofEn2SuhmcGHg=;
        b=KqTMEze133mPw4lKbUkmckl7AEXA9DwYYSub9LcFEhz97FYNz3jEufEfLbSoAViLk9
         a1p57nxFkiICQKxiCkT9xLW7eL0O0UJTBie0Mq038eQW+ajlnp1sk1CwmQ2CZIYtBmxz
         LUS4Pd5flN2IBmzbHfGwhM85qaozFkfbEetmh3X/S/zAZTy+l23Nr+KVfkDGYwNWnr/T
         EHjgF35tThEydOJ4zvsBTy+1yo7wkMDsXLYMq6tvkswf4D5jtFIuGAHMWJPy6GdNk3aV
         PS1+Om/jB+tT3EA9QNDVWUaj2PC26PX+drUeuGP/6/kvW21m7k30PXADh0+Igp38EBCR
         8XOw==
In-Reply-To: <20171211151705.GG2421075-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2017-12-11 23:17 GMT+08:00 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> On Mon, Dec 11, 2017 at 10:56:25PM +0800, weiping zhang wrote:
>> export these two interface for cgroup-v1.
>>
>> Signed-off-by: weiping zhang <zhangweiping-j11cvHKnkmPwvR0lvYjcXw@public.gmane.org>
>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>

Hi Jens,

Have you got time to check this patch ?

Thanks

> Thanks.
>
> --
> tejun
