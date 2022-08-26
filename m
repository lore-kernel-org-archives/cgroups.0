From: "lujialin (A)" <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 0/2] Introduce cgroup.top interface
Date: Fri, 26 Aug 2022 17:50:55 +0800
Message-ID: <e6deb22b-506d-d4f6-1a75-58dda4b58bcc@huawei.com>
References: <20220826011503.103894-1-lujialin4@huawei.com>
 <Ywg7NcHtfjDKjwXR@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Ywg7NcHtfjDKjwXR-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Ok, I got it, thanks

=D4=DA 2022/8/26 11:17, Tejun Heo =D0=B4=B5=C0:
> Hello,
>
> On Fri, Aug 26, 2022 at 09:15:01AM +0800, Lu Jialin wrote:
>> Cgroup is used to organize and manage resource available processes.
>> Currently there are no handy tool for gathering reousrce usage
>> information for each and every child cgroups, makes it hard to detect
>> resource outage and debug resource issues.
>>
>> To overcome this, we present the cgroup.top interface. Just like the
>> top command, user is able to easily gather resource usage information
>> , allowing user to detect and respond to resource outage in child
>> cgroups
> I don't think this is something we want build into the kernel. Maybe what
> you want is something similar to below?
>
>    https://github.com/facebookincubator/below
>
> Thanks.
>
