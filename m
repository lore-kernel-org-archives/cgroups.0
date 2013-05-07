From: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [Suggestion] kernel/cgroup.c: about kfree after 'get_new_cssid'
Date: Tue, 07 May 2013 19:20:49 +0800
Message-ID: <5188E391.6040505@asianux.com>
References: <5188DB93.2080504@asianux.com> <5188DF27.4080000@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5188DF27.4080000-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013=E5=B9=B405=E6=9C=8807=E6=97=A5 19:01, Li Zefan wrote:
> On 2013/5/7 18:46, Chen Gang wrote:
>> Hello Maintainers:
>>
>> After call get_new_cssid(), I can not find the related free function
>> (it seems free_css_id() is for that, but not used).
>>
>> The memory location is:
>>   get_new_cssid() --> kzalloc() for 'struct css_id'
>>   get_new_cssid() --> idr_alloc() for 'ss->idr'
>>
>> One work flow:
>>   cgroup_load_subsys() --> cgroup_init_idr() --> get_new_cssid()
>>   when get_new_cssid() fails, it will:
>>   cgroup_load_subsys() --> cgroup_unload_subsys() --> idr_destroy(),
>>   and also:
>>   cgroup_load_subsys() --> cgroup_unload_subsys() --> ss->css_free()=
;
>>     ('css_free' may 'debug_css_free', or 'freezer_css_free' ...)
>>
>> It seems the work flow above is not 'kfree' 'struct css_id', is it t=
rue?
>>
>> BTW: I also guess, for cgroup_init_idr() in cgroup_init(), need chec=
k
>> the return value.
>>
>> Please help check.
>>
>=20
> It's the specific cgroup subsystem that calls free_css_id() in it's s=
ubsys->css_free()
> callback. See __mem_cgroup_free() for example.
>=20

OK, thank you for your confirmation.

> There's a bug in cgroup_unload_subsys() that idr_destroy() should be =
called after
> ss->css_free(). That said, given there's no modular cgroup subsystem =
using css_id,
> and the whole css_id thing will be eliminated in 3.11, why bother fix=
ing it.
>=20

I just find it by reading code (I also want to learn about kernel).

I guess, for some stable versions, may focus on it, they are the
different branches from the latest version.

So, is it suitable to send related patch for the bug ?

Thanks.

--=20
Chen Gang

Asianux Corporation
