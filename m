From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 1 Sep 2016 10:25:40 +0300
Message-ID: <9b6a346d-af4c-1e5f-0144-f68fb8e46c27@mellanox.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <1472632647-1525-2-git-send-email-pandit.parav@gmail.com>
 <61101e8b-5776-c0bc-b3ea-d8b984eebabf@mellanox.com>
 <20160831211618.GA12660@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=gPotF1sfnj9+GvKexujffksiWwfMs2g6RJ1GLDkSe3E=;
 b=IQUa8rlllon3ZxozjSYYsVm/fKV6LEMCK4kWII1/+O9h15esadaGu+ZpH2ZQOrnI/F5rsPjifJkIlOHJzgyEV6dVbQTxJNzUJvDRcaW8PqRiMkFHu7EekjRIxhY8gPDh3Whr9Tjla11Ho76NkkxhnUwARgUVsXAg0mZwS+PxnX0=
In-Reply-To: <20160831211618.GA12660-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 01/09/2016 00:16, Tejun Heo wrote:
> Hello,
>
> On Wed, Aug 31, 2016 at 06:07:30PM +0300, Matan Barak wrote:
>> Currently, there are some discussions regarding the RDMA ABI. The current
>> proposed approach (after a lot of discussions in the OFVWG) is to have
>> driver dependent object types rather than the fixed set of IB object types
>> we have today.
>> AFAIK, some vendors might want to use the RDMA subsystem for a different
>> fabrics which has a different set of objects.
>> You could see RFCs for such concepts both from Mellanox and Intel on the
>> linux-rdma mailing list.
>>
>> Saying that, maybe we need to make the resource types a bit more flexible
>> and dynamic.
>
> That'd be back to square one and Christoph was dead against it too,
> so...
>

Well, if I recall, the reason doing so last time was in order to allow 
flexible updating of ib_core independently, which is obviously not a 
good reason (to say the least).

Since the new ABI will probably define new object types (all recent 
proposals go this way), the current approach could lead to either trying 
to map new objects to existing cgroup resource types, which could lead 
to some weird non 1:1 mapping, or having a split definitions - such that 
each driver will declare its objects both in the cgroups mechanism and 
in its driver dispatch table.
Even worse than that, drivers could simply ignore the cgroups support 
while implementing their own resource types and get a very broken 
containers support.


> Thanks.
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
