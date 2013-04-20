From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 05/10] cpuset: don't update tasks' cpumask and nodemask
 in an empty cpuset
Date: Sat, 20 Apr 2013 09:06:44 +0800
Message-ID: <5171EA24.3070001@huawei.com>
References: <517137A7.4020605@huawei.com> <51713819.8050708@huawei.com> <20130419183618.GC13811@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130419183618.GC13811-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On 2013/4/20 2:36, Tejun Heo wrote:
> Hello, Li.
> 
> On Fri, Apr 19, 2013 at 08:27:05PM +0800, Li Zefan wrote:
>> I think this was introduced unintentionally when cpuset hotplug was
>> made asynchronous. Fortunately it does no harm, as updating tasks'
>> cpumask will just return failure and there's a guarantee_online_mems()
>> when updating nodemask, and then the tasks will be moved to an ancestor
>> cpuset.
> 
> Yeah, which will update the masks to the proper values anyway, so it
> was intentionally written that way as it didn't really matter either
> way.  I suppose this helps future changes?  Maybe update the
> description a bit?
> 

I was trying to fix a bug: before moving tasks out of empty cpusets,
update_tasks_nodemask() is called, which calls do_migrate_pages(xx, from, to)
finally, from == node_to_be_offlined, to == empty_nodeamsk, so I guess
no pages will be migrated.

Then when those tasks are moving to an ancestor, do_migrate_pages(xx, from, to)
is called again, from == empty_nodemask, to == ancestor's nodemask,
so I guess again no pages will be migrated.

This bug exists even before your changes.
