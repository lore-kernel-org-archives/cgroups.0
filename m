From: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: about CPU QoS in KVM
Date: Thu, 20 Apr 2017 16:00:50 +0200
Message-ID: <8a5470cd-0cb2-5019-c7d3-7c407e6a6005@redhat.com>
References: <33183CC9F5247A488A2544077AF19020DA237684@DGGEMA505-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=phQlsnG9P0TluTj7P1k5HiPpNbEFoDSgq6/5IZTcfnY=;
        b=lr0YYjOU0aGgXj0NcjzvSKINuqhghZJCbvH1SAG02SfuhG9+L47kFfdWkl6U0yAAsp
         DFwYwIkc3r3MGegw7CPqxKEfG2EqAoIZktm1gUzSfPRkwMx6/PDP5Uc6aTiL4iEMl5fH
         HgFfGhhEsUhL9uTTBPmOo7ybDUNDBfXQeNmN895hJiHSJfjylCl9dpLhRLj1MhxBzxOs
         8sFVDp2e5rhn5kMbt3YvPhVKOoOhw/AX4iglonCHV/nfGPU/sbqYU7MpgY31L5sydNLc
         t2ZMRbAfPcQ32qvObz4dIX1FJsWx5yjW5LwayF279z+y0pnOiO6vkw0TlhGBqdqj01Kb
         U42A==
In-Reply-To: <33183CC9F5247A488A2544077AF19020DA237684-CArPBO0LKVoFkbVBhwfq5wK1hpo4iccwjNknBlVQO8k@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Gonglei <arei.gonglei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Jason Wang (jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Huangweidong (C)" <weidong.huang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linqiangmin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Adding Rik.

Paolo

On 20/04/2017 15:32, Gonglei (Arei) wrote:
> Hi all,
> 
> Currently, KVM do the CPU resource reservation by the cgroup mechanism
> which can't do entire accurate separation because the capacity of the Linux
> scheduler. Take the public cloud as an example, some customers rent one vm
> with 8 CPUs paid by enough money, they want to get enough response
> speed on CPU scheduling. So we (the cloud platform providers ) reserve 1GHz
> CPU resources by cgroup for those VM's vcpu/pcpu. 
> 
> But the actual effects can't meet those requirements because the cgroup is
> limiting share usage of other processes in order to attach the reservation proportion,
> but the scheduler can't assure that. This mechanism is different with Xen,
> We can directly change the CPU weight on Xen hypervisor so that we can
> get entire accurate control on CPU resources based on accurate capacity (upper limit),
> share (weight) and reservation.
> 
> So my question is do we have a good method to do CPU reservation in KVM?
> 
> Thanks,
> -Gonglei
> 
> 
