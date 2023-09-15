From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 00/18] Add Cgroup support for SGX EPC memory
Date: Fri, 15 Sep 2023 08:26:11 -1000
Message-ID: <ZQShw25UBVvVvjQo@mtj.duckdns.org>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694802373; x=1695407173; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dlV13QwwEAoXGdo9jbQW+sodfxxDlcgtLnB5aE/tibY=;
        b=Zni0BN3MU3FgBGvb9E3SP8UfiOMf9LsjEgP83dBOE2MUiHd2kF91631DgiECWi9G3G
         9j6cwAMJAHFkZk9fACn0OTo1n3YhpW92uT/YtOP7G3in8xwKlQFifT8GJq/1UKAnuW44
         EJ8Mzthsm7LMHKHyT4SE5SBsyAQ09tHZtJnphTRBih9LHn+ouJ2JQGhgXAqEMpDogceR
         buXRPYOU/W5w8XvAmKV+8ISs6AkNedKfAXGpwdvvJXphQ+qHWd/dmz9GOyV1//ODiYP9
         kAe6dgEwd9UJysMP/sbShYe3oxKT7j1yHa2xprFX/UFP6/mJ0ExbR+0E8IaK/06YAv0a
         N7Fg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230913040635.28815-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Tue, Sep 12, 2023 at 09:06:17PM -0700, Haitao Huang wrote:
> SGX EPC memory allocations are separate from normal RAM allocations, and
> are managed solely by the SGX subsystem. The existing cgroup memory
> controller cannot be used to limit or account for SGX EPC memory, which is
> a desirable feature in some environments, e.g., support for pod level
> control in a Kubernates cluster on a VM or baremetal host [1,2].
> 
> This patchset implements the support for sgx_epc memory within the misc
> cgroup controller. The user can use the misc cgroup controller to set and
> enforce a max limit on total EPC usage per cgroup. The implementation
> reports current usage and events of reaching the limit per cgroup as well
> as the total system capacity.

Minor nit aside, it looks fine from cgroup side.

Thanks.

-- 
tejun
