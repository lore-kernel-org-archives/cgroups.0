From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: throttle IO to multiple devices in one group
Date: Fri, 9 Sep 2016 09:29:29 +0300
Message-ID: <57D256C9.60901@kyup.com>
References: <CAKtk8he8kEpbnnDL80LpigDZk-KyU6_o99D+k4iNWiUQ1AeOLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKtk8he8kEpbnnDL80LpigDZk-KyU6_o99D+k4iNWiUQ1AeOLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Guang Yang <guangyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 09/09/2016 02:32 AM, Guang Yang wrote:
> Hello,
> We are evaluating to use cgroups to isolate different applications on
> Linux. One use case of our application is that it reads/writes to
> multiple block devices and we would like throttle the IO for each
> application to each devices via blkio.throttle.read_iops_device.
> However, it looks like each group can only configure one device.
> 
> Am I miss anything? Is there a way to support such semantic - limit
> the number of reads to multiple devices within one group?
> 
> Thanks very much.
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


[root@kernighan c11]# cat blkio.throttle.read_bps_device 
[root@kernighan c11]# echo "253:12 1600000" > blkio.throttle.read_bps_device
[root@kernighan c11]# echo "253:13 1600000" >> blkio.throttle.read_bps_device
[root@kernighan c11]# cat blkio.throttle.read_bps_device
253:13 1600000
253:12 1600000


It works just fine (this is on 4.4 kernel though)

Regards, 
Nikolay 
