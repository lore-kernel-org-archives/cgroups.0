From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v3 0/2] cgroup: KVM: New Encryption IDs cgroup controller
Date: Wed, 16 Dec 2020 12:02:37 -0800
Message-ID: <CAHVum0dS+QxWFSK+evxQtZDHkZZx9pr0m_jEDHc9ovd5jQcfaA@mail.gmail.com>
References: <20201209205413.3391139-1-vipinsh@google.com> <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
 <4f7b9c3f-200e-6127-1d94-91dd9c917921@de.ibm.com> <5f8d4cba-d3f-61c2-f97-fdb338fec9b8@google.com>
 <X9onUwvKovJeHpKR@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+T1M0djTrVYMWMJ7UcJwx0tkQ79zd8SuUMW71DQVsS0=;
        b=q+DyxhaxnPb/nH8qJzxHDRUDbs6pwrBVZw6PzpLeFo3wtldBNCEn4e64bSK0nhLF5X
         QvBT/wceHb8MK7Fm6YtVe7alN3zuwE0T3jaFFX9VRfhZKifVX3CDGzSjGXXVAJJpXSLk
         BYqUA0lzyEkYCfA/0WuODCJH5mOGW4V8P0cbCJlM2NdsPkwY5ZpUVEVBumz8vq3xmZQm
         PQyEwimqMI9kswHp6aDK7UXpsBu5joatambFWqpECUHqscsjIaEKpGZiYFMen0Kf3XVW
         Q8YKf8+FVjWvyXB/rJ0RfDFFi19z72HtGBVwOT5yFzE5kLAsEpDIgG2ZzYj5KaG1wkfA
         IjGQ==
In-Reply-To: <X9onUwvKovJeHpKR-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Brijesh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Jon <jon.grimm-5C7GfCeVMHo@public.gmane.org>, Eric <eric.vantassell-5C7GfCeVMHo@public.gmane.org>, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Janosch Frank <frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Matt Gingell <gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dionna Glaze <dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 9, 2020 at 12:59 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> * I don't have an overall objection. In terms of behavior, the only thing
>   which stood out was input rejection depending on the current usage. The
>   preferred way of handling that is rejecting future allocations rather than
>   failing configuration as that makes it impossible e.g. to lower limit and
>   drain existing usages from outside the container.

Thanks. In next version of the patch I will remove rejection of max value
based on current usage.

On Wed, Dec 16, 2020 at 7:27 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Dec 10, 2020 at 03:44:35PM -0800, David Rientjes wrote:
> > Concern with a single misc controller would be that any subsystem that
> > wants to use it has to exactly fit this support: current, max, stat,
> > nothing more.  The moment a controller needs some additional support, and
> > its controller is already implemented in previous kernel versionv as a
> > part of "misc," we face a problem.
>
> Yeah, that's a valid concern, but given the history, there doesn't seem to
> be much need beyond that for these use cases and the limited need seems
> inherent to the way the resources are defined and consumed. So yeah, it can
> either way.

I think a misc controller should be able support other "Resource Distribution
Models" mentioned in the cgroup v2 documentation besides limits. There might be
use cases in future which want to use weight, protection or allocation models.
If that happens it will be more difficult to support these different resources.
This will also mean the same hierarchy might get charged differently by the
same controller.

I like the idea of having a separate controller to keep the code simple and
easier for maintenance.

If you decide to have a separate misc controller please let me know what will
be the overall expectations and I can change my patch to reflect that,
otherwise I can send out a new patch with just removal of max input rejection.

My understanding with a "misc" controller is it will be something like
- cgroup v2
  cgroup/misc.encryption_ids.{sev, tdx, seid}.{stat, max, current}

- cgroup v1
  cgroup/misc/misc.encryption_ids.{sev, tdx, seid}.{stat, max, current}

Thanks
Vipin
