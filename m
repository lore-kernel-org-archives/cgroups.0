From: Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Wed, 3 Mar 2021 18:55:13 -0800
Message-ID: <20210303185513.27e18fce@jacob-builder>
References: <20210302081705.1990283-1-vipinsh@google.com>
        <20210302081705.1990283-3-vipinsh@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20210302081705.1990283-3-vipinsh@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vipin Sharma <vipinsh@google.com>
Cc: tj@kernel.org, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, jacob.jun.pan@intel.com, "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Alex Williamson <alex.williamson@redhat.com>, J

Hi Vipin,

On Tue,  2 Mar 2021 00:17:05 -0800, Vipin Sharma <vipinsh@google.com> wrote:

> +Migration and Ownership
> +~~~~~~~~~~~~~~~~~~~~~~~
> +
> +A miscellaneous scalar resource is charged to the cgroup in which it is
> used +first, and stays charged to that cgroup until that resource is
> freed. Migrating +a process to a different cgroup does not move the
> charge to the destination +cgroup where the process has moved.
> +
I am trying to see if IOASIDs cgroup can also fit in this misc controller
as yet another resource type.
https://lore.kernel.org/linux-iommu/20210303131726.7a8cb169@jacob-builder/T/#u
However, unlike sev IOASIDs need to be migrated if the process is moved to
another cgroup. i.e. charge the destination and uncharge the source.

Do you think this behavior can be achieved by differentiating resource
types? i.e. add attach callbacks for certain types. Having a single misc
interface seems cleaner than creating another controller.

Thanks,

Jacob
