From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/6] cgroup, memcg: implement css->id and convert css_from_id()
 to use it
Date: Sun, 4 May 2014 14:02:23 +0800
Message-ID: <5365D7EF.7050802@huawei.com>
References: <1398373333-1521-1-git-send-email-tj@kernel.org> <1398373333-1521-7-git-send-email-tj@kernel.org> <535DCBFC.4000404@huawei.com> <20140501154630.GG31611@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140501154630.GG31611-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

(Just came back from a short vacation)

On 2014/5/1 23:46, Tejun Heo wrote:
> On Mon, Apr 28, 2014 at 11:33:16AM +0800, Li Zefan wrote:
>> On 2014/4/25 5:02, Tejun Heo wrote:
>>> Until now, cgroup->id has been used to identify all the associated
>>> csses and css_from_id() takes cgroup ID and returns the matching css
>>> by looking up the cgroup and then dereferencing the css associated
>>> with it; however, now that the lifetimes of cgroup and css are
>>> separate, this is incorrect and breaks on the unified hierarchy when a
>>> controller is disabled and enabled back again before the previous
>>> instance is released.
>>>
>>> This patch adds css->id which is a subsystem-unique ID and converts
>>> css_from_id() to look up by the new css->id instead.  memcg is the
>>> only user of css_from_id() and also converted to use css->id instead.
>>>
>>
>> netprio_cgroup also needs to be updated.
> 
> Why?  Wouldn't it be more natural to tie that to the associated
> cgroup's ID rather than the specific css instance.  It's different for
> memcg as it involves css refcnts but netprio_cgroup, AFAICS, only uses
> it for cgroup identification anyway.
> 

You're right. I thought it won't work correctly in unified hierarchy
where controllers can be disabled/enabled.
