From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH nf-next v3] netfilter: xtables: lightweight process control
 group matching
Date: Sat, 28 Dec 2013 17:54:20 +0800
Message-ID: <52BE9FCC.6020708@huawei.com>
References: <cover.1387815795.git.dborkman@redhat.com> <7d845623366ba0d435d5c82bf318455871929e90.1387815795.git.dborkman@redhat.com> <52BCF04B.3070908@huawei.com> <52BD34D1.1040708@redhat.com> <52BE2A79.6040504@huawei.com> <52BE8936.6000001@redhat.com> <52BE8F50.4080005@redhat.com> <52BE97DC.5090807@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52BE97DC.5090807-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>> Thinking about this further a bit, with this separation into net/core/, you
>> would need another Kconfig, where people choose between built-in or
>> module (or none).
> 
> Just disable module support for net_cgroup_classid. I never like the cgroup
> feature that allows modular subsystems. It will be just about 100 lines of
> code, so we gain little by making it modular. Futhermore with this change,
> we can simplify include/linux/cls_cgroup.h
> 
> Moreoever cls_cgroup is the only modular cgroup subsystem, so I may even remove
> this feature from cgroup core after the change to cls_cgroup.
> 
>> With built-in you would disallow people to load/unload the
>> cgroup part during runtime. With the module, you would introduce a module
>> dependency _for each_, even if you only want to use net_cls, which sort of
>> is not what we want from a simple "cleanup".
>>

Even if it's a module, I don't think there's any dependency here, as
the only interface that cls_cgroup and netfilter_cgroup need is
task_cls_classid(), which is an inline function and doesn't involve any
EXPORT symbol.

Therefore it works even if CONFIG_CLS_CGROUP doesn't depend of
CONFIG_NET_CGROUP_CLASSID.
