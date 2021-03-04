From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Wed, 3 Mar 2021 22:22:03 -0800
Message-ID: <YEB8i6Chq4K/GGF6@google.com>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-3-vipinsh@google.com>
 <20210303185513.27e18fce@jacob-builder>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wa5muaXHut4hfwXTsUBvUfthAuhKwhmv9/hS3aAHRxQ=;
        b=Ei8dVn1tS3L8d+KCjI+VuCzSj+Cfa7yV0HFL1DM94rBiWSDms9SHkHwivMYn04bjmx
         OY7XuGQpzmXg0EUzXpFAvpzAbXLTJKYqOnctbovAHMT8rOH5KdM45V87GeUhl5QmBmOf
         9SsmlkYM/nbtIcpXpwLUik8NdP/SeznAYt/+RCuNSN4C49b2N8+qrYgTtMsFHLPlCq3i
         oFaz4h5lYyjePLRasP1ShTXGMxKB4OpTzRm53eQV4pK89hTc9zr8XIMmx5W/jGKNj+L3
         M9VgZ1z/fQqUt6B/WABIinlH+Kr151hgBCYsKRas0sZSUw/S+UXNv+4IxVwtGr+bxBZB
         7OiA==
Content-Disposition: inline
In-Reply-To: <20210303185513.27e18fce@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan@intel.com>
Cc: tj@kernel.org, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>

On Wed, Mar 03, 2021 at 06:55:13PM -0800, Jacob Pan wrote:
> Hi Vipin,
> 
> On Tue,  2 Mar 2021 00:17:05 -0800, Vipin Sharma <vipinsh@google.com> wrote:
> 
> > +Migration and Ownership
> > +~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +A miscellaneous scalar resource is charged to the cgroup in which it is
> > used +first, and stays charged to that cgroup until that resource is
> > freed. Migrating +a process to a different cgroup does not move the
> > charge to the destination +cgroup where the process has moved.
> > +
> I am trying to see if IOASIDs cgroup can also fit in this misc controller
> as yet another resource type.
> https://lore.kernel.org/linux-iommu/20210303131726.7a8cb169@jacob-builder/T/#u
> However, unlike sev IOASIDs need to be migrated if the process is moved to
> another cgroup. i.e. charge the destination and uncharge the source.
> 
> Do you think this behavior can be achieved by differentiating resource
> types? i.e. add attach callbacks for certain types. Having a single misc
> interface seems cleaner than creating another controller.

I think it makes sense to add support for migration for the resources
which need it. Resources like SEV, SEV-ES will not participate in
migration and won't stop can_attach() to succeed, other resources which
need migration will allow or stop based on their limits and capacity in
the destination.
