From: Xiu Jianfeng <xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next] cgroup: Remove out-of-date comment in
 cgroup_migrate()
Date: Wed, 24 May 2023 14:57:05 +0800
Message-ID: <c56473be-facb-e0ea-246c-bdd5bf74c7cd@huaweicloud.com>
References: <20230523111456.146053-1-xiujianfeng@huaweicloud.com>
 <ZG0PYH7a9Mw50bEl@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <ZG0PYH7a9Mw50bEl-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2023/5/24 3:09, Tejun Heo wrote:
> On Tue, May 23, 2023 at 07:14:56PM +0800, Xiu Jianfeng wrote:
>> From: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Commit 674b745e22b3 ("cgroup: remove rcu_read_lock()/rcu_read_unlock()
>> in critical section of spin_lock_irq()") has removed the rcu_read_lock,
>> which makes the comment out-of-date, so remove it.
>>
>> Signed-off-by: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> So, that removed rcu_read_lock() because it's implied by the irq disable but
> the comment content is still useful in describing what's preventing
> use-after-free. Can you please update the comment accordingly instead?

sure, I would send a v2.

> 
> Thanks.
> 

