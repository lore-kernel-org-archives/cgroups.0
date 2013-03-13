From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] cgroup: a bunch of cleanups
Date: Wed, 13 Mar 2013 09:06:50 +0800
Message-ID: <513FD12A.1040105@huawei.com>
References: <513ED010.5060906@huawei.com> <20130312223839.GM25266@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130312223839.GM25266-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/3/13 6:38, Tejun Heo wrote:
> On Tue, Mar 12, 2013 at 02:49:52PM +0800, Li Zefan wrote:
>> Hi Tejun,
>>
>> If you're busy with other stuff, just take your time to go through those
>> patches.
>>
>> 0001-cgroup-remove-cgroup_is_descentant.patch
>> 0002-cgroup-remove-unused-variables-in-cgroup_destroy_loc.patch
>> 0003-cgroup-hold-cgroup_mutex-before-calling-css_offline.patch
>> 0004-cgroup-don-t-bother-to-resize-pid-array.patch
>> 0005-cgroup-remove-useless-code-in-cgroup_write_event_con.patch
>> 0006-cgroup-remove-unneeded-includes-from-cgroup.h.patch
>> 0007-cgroup-fix-an-almost-harmless-off-by-one-bug.patch
>> 0008-cgroup-consolidate-cgroup_attach_task-and-cgroup_att.patch
> 
> 0001-0007 applied to cgroup/for-3.10.  0008 looks fine but in the diff
> cgroup_attach_task_all() is removed completely and added back in
> slightly different form.

At first I thought cgroup_attach_task() was static, so I thought I had
to either move cgroup_attach_task_all() after cgroup_attach_task(),
or add a forward declaration of cgroup_attach_task() in order to pass
compile.

Then I found it was extern, but I forgot to revert this diff.

Will send a v2.

> If you wanna keep the functions ordered like
> you posted, please put a separate patch to move
> cgroup_attach_task_all() before the consolidation.
> 
