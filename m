From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Thu, 4 Mar 2021 03:51:16 -0500
Message-ID: <YECfhCJtHUL9cB2L@slm.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-3-vipinsh@google.com>
 <20210303185513.27e18fce@jacob-builder>
 <YEB8i6Chq4K/GGF6@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I4gktfqxylGB3DlwpHUJlo46LXTYxo6+TuJCmtDgwqg=;
        b=WYjdeOOvSLFpvDoGjRRqZlAOwzlmZdzsKW62eY2+C+MatfU5IHlRHugMRRHognkKJa
         7I/NGS3uGqF63bl8cu+Sd8jPUj2wa8lNZWhg6s7FdnFPLRsxr7AK4HzzeD65KBmPz6wN
         VQcjeJJbBgX5qiMV1/Cq6/FQCVXVPWIa+tMGhn9gGdfcb2+PL56qDI1QfMLy9cayAD8R
         QXnYX4JEzS6BN9ANqF2JSjPoHHX1U+rqiF5qO+KIN6ax+4qAeRnkp97wMpAOHuQIRs5o
         Kj46nYkNjqGS+ndlohRvyB8MUQ4HYU2dQPbGtA8rAwwGGcZ43FjhtD3OMnmovFe3Uaft
         0aqA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YEB8i6Chq4K/GGF6-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jacob Pan <jacob.jun.pan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mkoutny-IBi9RG/b67k@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jaso

Hello,

On Wed, Mar 03, 2021 at 10:22:03PM -0800, Vipin Sharma wrote:
> > I am trying to see if IOASIDs cgroup can also fit in this misc controller
> > as yet another resource type.
> > https://lore.kernel.org/linux-iommu/20210303131726.7a8cb169@jacob-builder/T/#u
> > However, unlike sev IOASIDs need to be migrated if the process is moved to
> > another cgroup. i.e. charge the destination and uncharge the source.
> > 
> > Do you think this behavior can be achieved by differentiating resource
> > types? i.e. add attach callbacks for certain types. Having a single misc
> > interface seems cleaner than creating another controller.
> 
> I think it makes sense to add support for migration for the resources
> which need it. Resources like SEV, SEV-ES will not participate in
> migration and won't stop can_attach() to succeed, other resources which
> need migration will allow or stop based on their limits and capacity in
> the destination.

Please note that cgroup2 by and large don't really like or support charge
migration or even migrations themselves. We tried that w/ memcg on cgroup1
and it turned out horrible. The expected usage model as decribed in the doc
is using migration to seed a cgroup (or even better, use the new clone call
to start in the target cgroup) and then stay there until exit. All existing
controllers assume this usage model and I'm likely to nack deviation unless
there are some super strong justifications.

Thanks.

-- 
tejun
