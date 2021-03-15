From: Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Mon, 15 Mar 2021 16:40:12 -0700
Message-ID: <20210315164012.4adeabe8@jacob-builder>
References: <20210303185513.27e18fce@jacob-builder>
        <YEB8i6Chq4K/GGF6@google.com>
        <YECfhCJtHUL9cB2L@slm.duckdns.org>
        <20210312125821.22d9bfca@jacob-builder>
        <YEvZ4muXqiSScQ8i@google.com>
        <20210312145904.4071a9d6@jacob-builder>
        <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
        <20210313085701.1fd16a39@jacob-builder>
        <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
        <20210315151155.383a7e6e@jacob-builder>
        <YE/ddx5+ToNsgUF0@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <YE/ddx5+ToNsgUF0@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason

Hi Tejun,

On Mon, 15 Mar 2021 18:19:35 -0400, Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Mon, Mar 15, 2021 at 03:11:55PM -0700, Jacob Pan wrote:
> > > Migration itself doesn't have restrictions but all resources are
> > > distributed on the same hierarchy, so the controllers are supposed to
> > > follow the same conventions that can be implemented by all
> > > controllers. 
> > Got it, I guess that is the behavior required by the unified hierarchy.
> > Cgroup v1 would be ok? But I am guessing we are not extending on v1?  
> 
> A new cgroup1 only controller is unlikely to be accpeted.
> 
> > The IOASIDs are programmed into devices to generate DMA requests tagged
> > with them. The IOMMU has a per device IOASID table with each entry has
> > two pointers:
> >  - the PGD of the guest process.
> >  - the PGD of the host process
> > 
> > The result of this 2 stage/nested translation is that we can share
> > virtual address (SVA) between guest process and DMA. The host process
> > needs to allocate multiple IOASIDs since one IOASID is needed for each
> > guest process who wants SVA.
> > 
> > The DMA binding among device-IOMMU-process is setup via a series of user
> > APIs (e.g. via VFIO).
> > 
> > If a process calls fork(), the children does not inherit the IOASIDs and
> > their bindings. Children who wish to use SVA has to call those APIs to
> > establish the binding for themselves.
> > 
> > Therefore, if a host process allocates 10 IOASIDs then does a
> > fork()/clone(), it cannot charge 10 IOASIDs in the new cgroup. i.e. the
> > 10 IOASIDs stays with the process wherever it goes.
> > 
> > I feel this fit in the domain model, true?  
> 
> I still don't get where migration is coming into the picture. Who's
> migrating where?
> 
Sorry, perhaps I can explain by an example.

There are two cgroups: cg_A and cg_B with limit set to 20 for both. Process1
is in cg_A. The initial state is:
cg_A/ioasid.current=0, cg_A/ioasid.max=20
cg_B/ioasid.current=0, cg_B/ioasid.max=20

Now, consider the following steps:

1. Process1 allocated 10 IOASIDs,
cg_A/ioasid.current=10,
cg_B/ioasid.current=0

2. then we want to move/migrate Process1 to cg_B. so we need uncharge 10 of
cg_A, charge 10 of cg_B

3. After the migration, I expect
cg_A/ioasid.current=0,
cg_B/ioasid.current=10

We don't enforce the limit during this organizational change since we can't
force free IOASIDs. But any new allocations will be subject to the limit
set in ioasid.max.

> Thanks.
> 


Thanks,

Jacob
