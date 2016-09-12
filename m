From: Guang Yang <guangyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: throttle IO to multiple devices in one group
Date: Mon, 12 Sep 2016 15:11:27 -0700
Message-ID: <CAKtk8hdg8FBmjfPbF9J0LxEv_DERb2R6vPueuH-o3hwcNHQxBA@mail.gmail.com>
References: <CAKtk8he8kEpbnnDL80LpigDZk-KyU6_o99D+k4iNWiUQ1AeOLQ@mail.gmail.com>
 <57D256C9.60901@kyup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=4gspRiuTkwZp53X9fN5bHRqOo1S+nEJBxHy4W7vMLb0=;
        b=gWGG2uL+wlP7/ggxidVo84sp+sR0fJifOt6A1tmqEIBB8viJZ/We1nl4x2thbm8T/s
         O38yldV4qvuIpIapiws+BqFNTirg2T3bjUOuHn69sL5cOgxRHdcPesT7nY0I8dluzhl2
         XcCM/Uwyfry4wEt2wn7spilZHvjpINAfY6I7bt4pnds9HAKlvCyUq5KmvgCc5VoUIzfY
         rtaFNZg/t12ADFNsEsPRgoIFXYZp6Ki6bjYdXO+ly1XBhjNuiyw6Y5jOkRwaeCKkodJ4
         AOldx08ROpYOc4T3O19yeW9SuYcUbT98m1GUNWp2XYU68ZbmrH4oQIGPB61WCQaQxO75
         Uh0A==
In-Reply-To: <57D256C9.60901-6AxghH7DbtA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks for the reply, Nikolay. It works for me with 2.6.32 kernel too.

Thanks,
Guang

On Thu, Sep 8, 2016 at 11:29 PM, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org> wrote:
>
>
> On 09/09/2016 02:32 AM, Guang Yang wrote:
>> Hello,
>> We are evaluating to use cgroups to isolate different applications on
>> Linux. One use case of our application is that it reads/writes to
>> multiple block devices and we would like throttle the IO for each
>> application to each devices via blkio.throttle.read_iops_device.
>> However, it looks like each group can only configure one device.
>>
>> Am I miss anything? Is there a way to support such semantic - limit
>> the number of reads to multiple devices within one group?
>>
>> Thanks very much.
>> --
>> To unsubscribe from this list: send the line "unsubscribe cgroups" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> [root@kernighan c11]# cat blkio.throttle.read_bps_device
> [root@kernighan c11]# echo "253:12 1600000" > blkio.throttle.read_bps_device
> [root@kernighan c11]# echo "253:13 1600000" >> blkio.throttle.read_bps_device
> [root@kernighan c11]# cat blkio.throttle.read_bps_device
> 253:13 1600000
> 253:12 1600000
>
>
> It works just fine (this is on 4.4 kernel though)
>
> Regards,
> Nikolay
