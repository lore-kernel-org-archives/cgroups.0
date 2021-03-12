From: Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Fri, 12 Mar 2021 12:58:21 -0800
Message-ID: <20210312125821.22d9bfca@jacob-builder>
References: <20210302081705.1990283-1-vipinsh@google.com>
        <20210302081705.1990283-3-vipinsh@google.com>
        <20210303185513.27e18fce@jacob-builder>
        <YEB8i6Chq4K/GGF6@google.com>
        <YECfhCJtHUL9cB2L@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <YECfhCJtHUL9cB2L@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason

Hi Vipin & Tejun,

Sorry for the late reply, I sent from a different email address than I
intended. Please see my comments inline.


On Thu, 4 Mar 2021 03:51:16 -0500, Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Wed, Mar 03, 2021 at 10:22:03PM -0800, Vipin Sharma wrote:
> > > I am trying to see if IOASIDs cgroup can also fit in this misc
> > > controller as yet another resource type.
> > > https://lore.kernel.org/linux-iommu/20210303131726.7a8cb169@jacob-builder/T/#u
> > > However, unlike sev IOASIDs need to be migrated if the process is
> > > moved to another cgroup. i.e. charge the destination and uncharge the
> > > source.
> > > 
> > > Do you think this behavior can be achieved by differentiating resource
> > > types? i.e. add attach callbacks for certain types. Having a single
> > > misc interface seems cleaner than creating another controller.  
> > 
> > I think it makes sense to add support for migration for the resources
> > which need it. Resources like SEV, SEV-ES will not participate in
> > migration and won't stop can_attach() to succeed, other resources which
> > need migration will allow or stop based on their limits and capacity in
> > the destination.  
> 
Sounds good. Perhaps some capability/feature flags for each resource such
that different behavior can be accommodated?
Could you please include me in your future posting? I will rebase on yours.

> Please note that cgroup2 by and large don't really like or support charge
> migration or even migrations themselves. We tried that w/ memcg on cgroup1
> and it turned out horrible. The expected usage model as decribed in the
> doc is using migration to seed a cgroup (or even better, use the new
> clone call to start in the target cgroup) and then stay there until exit.
> All existing controllers assume this usage model and I'm likely to nack
> deviation unless there are some super strong justifications.
> 
Thank you so much for the pointers. Just to be clear, you meant
1. Use clone3 CLONE_INTO_CGROUP to put the child into a different cgroup.
2. Do not support migration of the parent (existing proc)

Thanks,

Jacob
