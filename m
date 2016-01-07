From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv1 6/6] rdmacg: Added documentation for rdma controller.
Date: Fri, 8 Jan 2016 01:13:29 +0530
Message-ID: <CAG53R5WstJ_=9AP-d5JdcHyUu1f8iO0CSfRsL7U-60enhW=q9Q@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<1452020286-9508-7-git-send-email-pandit.parav@gmail.com>
	<20160105215309.GG5995@mtj.duckdns.org>
	<CAG53R5WD18VK3sVuVnPR7yjEBqRjHAoUkCpZKzSd9-PYZrx-YA@mail.gmail.com>
	<20160106225714.GI3660@htj.duckdns.org>
	<CAG53R5XKpP6YAe8buRrgG=m4_dQK5MjkWtcA7CN-74AJ1SUUyQ@mail.gmail.com>
	<20160107154218.GF29797@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=1s4wfkXhlMjRHJtD7iHpGrVpkKAwySw+fos9ghsJU1U=;
        b=HIvl7tSZP4pfNE9vxeNk+ojPpts8BqJFm1UpFCP8vtvUImdzNx+CRw6YHLEEYH0tF2
         k8pyo/itHIQ6+383RfX0auhJHRL+vsafdePZPKw+zriAumCgtg4roxhXtImNhFqNt13z
         H/KO6/8Ze7Qc/y4EbtrCH9379OIFAy0IRFZ0CpeQOqOssqf57ehsC/40FI/kdDP6O4WR
         UTGcJLWHZvl9d0+TWtv34rEMAaekD4kCx400QBzk3/FyVKV0eKxqZAWknCbEdqzFjC8B
         NVCP0pjJdbTbPgVxe4D4A2d0SV548FGfMr3JEdxIs+LuylY/oEuhQJk2PZpdNcfNzCtI
         T9lg==
In-Reply-To: <20160107154218.GF29797-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jan 7, 2016 at 9:12 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Thu, Jan 07, 2016 at 05:22:40AM +0530, Parav Pandit wrote:
>> I can remove "resource" key word. If just that if something other than
>> resource comes up to limit to in future, it will be hard to define at
>> that time.
>
> Please remove.  The word doesn't mean anything in this context.
>
ok. I will remove.

>> > Also can't the .max file list
>> > the available resources?  Why does it need a separtae list file?
>> >
>> max file does lists them only after limits are configured for that
>> device. Thats when rpool (array of max and usage counts) is allocated.
>>
>> If user wants to know what all knobs are available, than list file
>> exposes them on per device basis without actually mentioning actual
>> limit or without allocating rpool arrays.
> ...
>> list file looks like below for two device entries.
>> mlx4_0 ah qp mr pd srq flow
>> ocrdma0 ah qp mr pd
>>
>> max file looks like below.
>> mlx4_0 ah=100 qp=40 mr=10 pd=90 srq=10 flow=10
>
> Just always show the settings for all devices in the max file like the
> following?
>
>   mlx4_0 ah=max qp=max mr=max pd=max srq=max flow=max
>   ocrdma0 ah=max qp=max mr=max pd=max

Should be possible. I will make the change.

>
> Thanks.
>
> --
> tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
