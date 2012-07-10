From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
Date: Tue, 10 Jul 2012 10:11:05 +0800
Message-ID: <4FFB8F39.9030209@huawei.com>
References: <4FEEA5CB.8070809@huawei.com> <20120703170317.GB555@google.com> <20120703225218.GF555@google.com> <4FF3E063.5010604@huawei.com> <20120708063536.GB19021@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120708063536.GB19021-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On 2012/7/8 14:35, Tejun Heo wrote:

> Hello, Li.
> 
> On Wed, Jul 04, 2012 at 02:19:15PM +0800, Li Zefan wrote:
>>> I think we're horridly broken for
>>> root cgroup tho - and it has been broken for very long time.  I think
>>> it's mostly hidden because most (all?) controllers short-circuit root
>>> cgroup.  Eh, well....
>>>
>>
>> Could you elaborate a bit on what's broken for root cgroup?
> 
> If someone holds css ref of a root cgroup, AFAICS nothing is
> preventing the cgroup hierarchy from being unmounted and root cgroup
> destroyed.
> 


Right, but that should be safe. The css objects of the root cgroup are
allocated at boot, and won't be destroyed at umount.

Furthermore when a cgroup hierarchy is going to be unmounted, those css's
will be made to point to a cgroup named dummytop in rebind_subsystems(),
and there's a syncronize_rcu() in the end of the function, so accessing
css->cgroup is always safe.

In this case, dummytop->dentry is NULL, and that's safe too, because
cgroup_path() is aware of this case.
