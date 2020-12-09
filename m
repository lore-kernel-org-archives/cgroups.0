From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v3 0/2] cgroup: KVM: New Encryption IDs cgroup controller
Date: Wed, 9 Dec 2020 15:58:33 -0500
Message-ID: <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
References: <20201209205413.3391139-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hLr4IoNk4mXvkDggJZgGkE0Lh0R6y+fsYHaJEGIfuuc=;
        b=gphtz3zP8o+6zS3N+NSHv4/V28d6PSJir32f2MrZa2gKRKJDXP6TvwxbeBOq3deiDV
         LlTp1Xc1fAAHw05jQqUsRiHBgY+ruguxqVbvb5cIlP3sy2WcS9YLU0Q5r6+dgB/iJTKB
         vXdpg4K3iNVlSaW+QLGwC6orshyfnLvJ2mg0jYpB8AYnV66ox0Dd0Tv1asOBtczplSjD
         YDAeLZ7WJooce78KC5lMONcwo6GD3XoXqxfLF58l8ufOJZp/UuMkKulOibk9ILEZpfhj
         AkwSNALY3spqQNHSCUdoyrkmftK/32r7rM91m9khiDAb+5KieKcWlZ8xJIKJ13BZCNCP
         oSGg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20201209205413.3391139-1-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

Rough take after skimming:

* I don't have an overall objection. In terms of behavior, the only thing
  which stood out was input rejection depending on the current usage. The
  preferred way of handling that is rejecting future allocations rather than
  failing configuration as that makes it impossible e.g. to lower limit and
  drain existing usages from outside the container.

* However, the boilerplate to usefulness ratio doesn't look too good and I
  wonder whether what we should do is adding a generic "misc" controller
  which can host this sort of static hierarchical counting. I'll think more
  on it.

Thanks.

-- 
tejun
