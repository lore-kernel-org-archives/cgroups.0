From: Hongchen Zhang <zhanghongchen-cXZgJK919ebM1kAEIRd3EQ@public.gmane.org>
Subject: Re: [PATCH] cgroup: wait for css offline when rmdir
Date: Tue, 31 May 2022 11:49:53 +0800
Message-ID: <fbb820c5-dbcb-0f00-c365-d3c57ca27edf@loongson.cn>
References: <1653619158-27607-1-git-send-email-zhanghongchen@loongson.cn>
 <YpCQZ5RRnxwh7fmK@slm.duckdns.org>
 <e74e03f1-cb54-b158-a085-2965fd088d1d@loongson.cn>
 <YpVo4XiIDu68w40Z@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YpVo4XiIDu68w40Z-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2022/5/31 上午9:01, Tejun Heo wrote:
> Hello,
> 
> On Mon, May 30, 2022 at 09:53:51AM +0800, Hongchen Zhang wrote:
>>    When I test the LTP's memcg_test_3 testcase at 8 Node server,I get the
>> -ENOMEM error,which caused by no avaliable idr found in mem_cgroup_idr.
>> the reason is the use of idr in mem_cgroup_idr is too fast than the free.In
>> the specific case,the idr is used and freed cyclically,so when we rmdir one
>> cgroup dir, we can synchronize the idr free through wating for the memcg css
>> offlined,and then we can use it the next cycle.
> 
> This is a micro benchmark specific problem and it doesn't make sense to
> change the overall behavior for this as the suggested change is neither
> desirable or logical. Maybe you can just incur the delay only after idr
> allocation fails and then retry?
> 
> Thanks.
> 
Hi Tejun,

Yes, the problem would disappear when add some reasonable delay. But I 
think if we can increase the MEM_CGROUP_ID_MAX to INT_MAX.Thus the 
-ENOMEM error would be never occured,even if the system is out of memory.

Thanks.

