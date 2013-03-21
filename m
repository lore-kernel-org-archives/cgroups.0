From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.10] cgroup: make cgroup_mutex outer to
	threadgroup_lock
Date: Thu, 21 Mar 2013 17:17:27 +0100
Message-ID: <20130321161727.GA21760@redhat.com>
References: <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org> <513A9A67.60909@huawei.com> <20130309032936.GT14556@mtj.dyndns.org> <513AE918.7020704@huawei.com> <20130319220246.GR3042@htj.dyndns.org> <514909A0.4030808@huawei.com> <20130320150351.GW3042@htj.dyndns.org> <20130320183523.GA29365@redhat.com> <CAOS58YPxGXt+iq1GZ4hryqm1Z_p+r7eRRC7ruUDDd=LQrWtAxg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOS58YPxGXt+iq1GZ4hryqm1Z_p+r7eRRC7ruUDDd=LQrWtAxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 03/20, Tejun Heo wrote:
>
> On Wed, Mar 20, 2013 at 11:35 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > then we need "do not abuse ->cred_guard_mutex in threadgroup_lock()"
> > acked by you and Li. Please let me know if I should resend it.
>
> Yeah, we want that one regardless of this one. Please feel free to add
> my Acked-by (if I hadn't acked already, that is).

Yeah, you have already acked it, thanks

> How should your
> patch be routed? Through -mm?

Well, this is the only method I know ;) So I am resending it to Andrew
with your acks apllied.

Oleg.
