From: Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Fri, 12 Mar 2021 14:59:04 -0800
Message-ID: <20210312145904.4071a9d6@jacob-builder>
References: <20210302081705.1990283-1-vipinsh@google.com>
        <20210302081705.1990283-3-vipinsh@google.com>
        <20210303185513.27e18fce@jacob-builder>
        <YEB8i6Chq4K/GGF6@google.com>
        <YECfhCJtHUL9cB2L@slm.duckdns.org>
        <20210312125821.22d9bfca@jacob-builder>
        <YEvZ4muXqiSScQ8i@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <YEvZ4muXqiSScQ8i@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vipin Sharma <vipinsh@google.com>
Cc: Tejun Heo <tj@kernel.org>, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@n>

Hi Vipin,

On Fri, 12 Mar 2021 13:15:14 -0800, Vipin Sharma <vipinsh@google.com> wrote:

> On Fri, Mar 12, 2021 at 12:58:21PM -0800, Jacob Pan wrote:
> > Hi Vipin & Tejun,
> > 
> > Sorry for the late reply, I sent from a different email address than I
> > intended. Please see my comments inline.
> > 
> > 
> > On Thu, 4 Mar 2021 03:51:16 -0500, Tejun Heo <tj@kernel.org> wrote:
> >   
> > > Hello,
> > > 
> > > On Wed, Mar 03, 2021 at 10:22:03PM -0800, Vipin Sharma wrote:  
> > > > > I am trying to see if IOASIDs cgroup can also fit in this misc
> > > > > controller as yet another resource type.
> > > > > https://lore.kernel.org/linux-iommu/20210303131726.7a8cb169@jacob-builder/T/#u
> > > > > However, unlike sev IOASIDs need to be migrated if the process is
> > > > > moved to another cgroup. i.e. charge the destination and uncharge
> > > > > the source.
> > > > > 
> > > > > Do you think this behavior can be achieved by differentiating
> > > > > resource types? i.e. add attach callbacks for certain types.
> > > > > Having a single misc interface seems cleaner than creating
> > > > > another controller.    
> > > > 
> > > > I think it makes sense to add support for migration for the
> > > > resources which need it. Resources like SEV, SEV-ES will not
> > > > participate in migration and won't stop can_attach() to succeed,
> > > > other resources which need migration will allow or stop based on
> > > > their limits and capacity in the destination.    
> > >   
> > Sounds good. Perhaps some capability/feature flags for each resource
> > such that different behavior can be accommodated?
> > Could you please include me in your future posting? I will rebase on
> > yours.  
> 
> Hi Jacob
> 
> Based on Tejun's response, I will not add charge migration support in
> misc controller.
> 
Sounds good. I need some confirmation on whether migration is a must have
for VMs allocated IOASIDs.
Our primary goal is to limit the amount of IOASIDs that VMs can allocate.
If a VM is migrated to a different cgroup, I think we need to
charge/uncharge the destination/source cgroup in order enforce the limit. I
am not an expert here, any feedback would be appreciated.

> I can definitly add you in my future posting, if you still wanna use it
> without charge migration support.
> 
Yes, please. I got your v3 already, so just future patches.

> Thanks
> Vipin


Thanks,

Jacob
