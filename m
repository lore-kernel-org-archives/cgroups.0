From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/7] devcg: Added infrastructure for rdma device cgroup.
Date: Tue, 8 Sep 2015 12:32:46 +0530
Message-ID: <CAG53R5UOq30kz4nyS9M0ggULqXO1H7m3KqU=-pq+0PgkN5aCoA@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<1441658303-18081-4-git-send-email-pandit.parav@gmail.com>
	<55EE72B7.1060304@mellanox.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=ht8Kn1Rhcce2rmp54JH4m3DxF9P0ptXWEONCP2ObbaU=;
        b=Oo59SnaL+29Ed9wSazw/fCFDvsrJmi6dg9uX/1AnG0xvHbHMjHsbXZShR60QMbaVLf
         dKoCqDRBF2lVLuJqfQMo1ftIPIfqdAs0LcxICSuvoGQ2AcA54wb+Z8UNwl9Q6Om3Kxb1
         JQjFG50eEwrfNTsZpKp1sDRuysjqj2IVlRUaXbyWbhu0vr/ULTdD1IEiU17ctrBpwAVH
         abANdSrHxn8JYiDTt3ciMhe/zOttswViUoBQ7raibY0BnozSo97mixQewOfHyoKfcXcM
         +IeuJzoKH+m1DJxHCgxc4Lg9oyK9pfYAGECAS4dALyFYl8sQu/NiUyS6gxYXjP7x66cv
         8X1A==
In-Reply-To: <55EE72B7.1060304-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 8, 2015 at 11:01 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 07/09/2015 23:38, Parav Pandit wrote:
>> diff --git a/include/linux/device_cgroup.h b/include/linux/device_cgroup.h
>> index 8b64221..cdbdd60 100644
>> --- a/include/linux/device_cgroup.h
>> +++ b/include/linux/device_cgroup.h
>> @@ -1,6 +1,57 @@
>> +#ifndef _DEVICE_CGROUP
>> +#define _DEVICE_CGROUP
>> +
>>  #include <linux/fs.h>
>> +#include <linux/cgroup.h>
>> +#include <linux/device_rdma_cgroup.h>
>
> You cannot add this include line before adding the device_rdma_cgroup.h
> (added in patch 5). You should reorder the patches so that after each
> patch the kernel builds correctly.
>
o.k. got it. I will send V1 with this suggested changes.

> I also noticed in patch 2 you add device_rdma_cgroup.o to the Makefile
> before it was added to the kernel.
>
o.k.

> Regards,
> Haggai
