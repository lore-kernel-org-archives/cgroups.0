From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v3 0/2] cgroup: New misc cgroup controller
Date: Fri, 12 Mar 2021 09:49:26 -0800
Message-ID: <YEupplaAWU1i0G6B@google.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <YETLqGIw1GekWdYK@slm.duckdns.org>
 <YEpoS90X19Z2QOro@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=csMPZAYxCBTEQbPB3Xmop3XmbNBt5+uYFADY2kRb6qA=;
        b=o9KG5np4GiSzQMqkEaxSRIqmTD15b/mJFR0bihIPG/1y69mD7nFyMiABc8fYtXdqOk
         GFpEv76l31p8dmd//oe7ARKidD3Cb0XkZaJduHtnrKMONTq935ng9PTueZ4JHI7R1IAI
         l5f2a42VDoEXXfyBPIZ3RxzHdfYzyXJSs5giZu/ivRvMJelLVtiHSNvV20sMuLjQTWYJ
         iLNLdo3EbAApFxiSxmQSqJljwgZ6BYuoQAOInEE/vhT86GYPfiRQLgYNuTp6f7v4O/ZP
         n2/Cf3MmFDF1tubVD7LXT2U0k2QQXJCKgW6bh2shK8GwEMNLfm4BUR1rZN6/SxNuT0ix
         ZnLg==
Content-Disposition: inline
In-Reply-To: <YEpoS90X19Z2QOro@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 11, 2021 at 07:58:19PM +0100, Michal Koutn=FD wrote:
> I admit, I didn't follow the past dicussions completely, however,
> (Vipin) could it be in the cover letter/commit messages shortly
> summarized why cgroups and a controller were chosen to implement
> restrictions of these resources, what were the alternatives any why were
> they rejected?

I will add some more information in the cover letter of the next version.

Basically, SEV will mostly be used by cloud providers for providing
confidential VMs. Since they are limited we need a good way to schedule
these jobs in cloud infrastructure. To achieve this we either come up
with some ioctl for "/dev/sev" to know about its usage, availability,
etc. This requires existing scheduling mechanism in the cloud to have an
extension for this interaction. Now same thing needs to be done for TDX.
IBM SEID doesn't have scarcity of this resource but they are also
interested in tracking and limiting the usage. Each one coming up with
their own interaction is a duplicate effort when they all need similar
thing. One can say that abstraction should be at KVM level but these
resources can be used outside VM as well.

Most of the cloud infrastructure use cgroups for knowing the host state,
track the resources usage, enforce limits on them, etc. They use this
info to optimize work allocation in the fleet and make sure no rogue job
consumes more than it needs and starves other. Adding these resources
to cgroup is a natural choice with least friction. Cgroup itself says it
is a mechanism to distribute system resources along the hierarchy in a
controlled mechanism and configurable manner. Most of the resources in
cgroups are abstracted enough but their are still resources which are
not abstract but have limited availability or have specific use cases.

>=20
> In the previous discussion, I saw the reasoning for the list of the
> resources to be hardwired in the controller itself in order to get some
> scrutiny of possible changes. That makes sense to me. But with that, is
> it necessary to commit to the new controller API via EXPORT_SYMBOL? (I
> don't mean this as a licensing question but what the external API should
> be (if any).)

As per my understanding this is the only for way for loadable modules
(kvm-amd in this case) to access Kernel APIs. Let me know if there is a
better way to do it.

>=20
> Besides the generic remarks above, I'd still suggest some slight
> implementation changes, posted inline to the patch.

I will work on them.

I appreciate you guys taking out time and helping me out with this patch
series.

Thanks
Vipin
