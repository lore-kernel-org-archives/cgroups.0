From: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Subject: Re: blkcg throttle settings page cache writes
Date: Tue, 27 Sep 2016 14:28:25 +0300
Message-ID: <57EA57D9.6000104@kyup.com>
References: <57D9098D.3020403@kyup.com>
 <20160916155736.GC26371@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160916155736.GC26371-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>



On 09/16/2016 06:57 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 14, 2016 at 11:25:49AM +0300, Nikolay Borisov wrote:
>> Hello,
>> So Tejun, my question is what is the problem for the blkcg information
>> to be transferred alongside the bio (which I believed to be happening
>> with the blkcg_association calls) so that even buffered writes are
>> throttled via the cgroup policies? Or are the numbers I'm seeing in
>> iostat actually the writes to the page-cache and not the underlying
>> block device?
> 
> You gotta use cgroup v2 for that.  Controlling buffered writes
> requires coordination between memory and io controllers which isn't
> possible with cgroup v1.

Thanks for the information Tejun, that makes sense. However, in my
testing I observed that when a throttle limit is set on IOPS it's not
being enforced for buffered writes, but when it's set on bps it is
actually working as expected. Is this expected or are there conflating
factors which I'm not taking into account and as such what I'm seeing -
iostat reports perfect utilisation of a particular device according to
the bps throttle limit.


> 
> Thanks.
> 
