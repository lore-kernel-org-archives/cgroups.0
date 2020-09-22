From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Date: Mon, 21 Sep 2020 18:48:38 -0700
Message-ID: <20200922014836.GA26507@linux.intel.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200922004024.3699923-1-vipinsh@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: thomas.lendacky@amd.com, pbonzini@redhat.com, tj@kernel.org, lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com, rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Sep 21, 2020 at 05:40:22PM -0700, Vipin Sharma wrote:
> Hello,
> 
> This patch series adds a new SEV controller for tracking and limiting
> the usage of SEV ASIDs on the AMD SVM platform.
> 
> SEV ASIDs are used in creating encrypted VM and lightweight sandboxes
> but this resource is in very limited quantity on a host.
> 
> This limited quantity creates issues like SEV ASID starvation and
> unoptimized scheduling in the cloud infrastructure.
> 
> SEV controller provides SEV ASID tracking and resource control
> mechanisms.

This should be genericized to not be SEV specific.  TDX has a similar
scarcity issue in the form of key IDs, which IIUC are analogous to SEV ASIDs
(gave myself a quick crash course on SEV ASIDs).  Functionally, I doubt it
would change anything, I think it'd just be a bunch of renaming.  The hardest
part would probably be figuring out a name :-).

Another idea would be to go even more generic and implement a KVM cgroup
that accounts the number of VMs of a particular type, e.g. legacy, SEV,
SEV-ES?, and TDX.  That has potential future problems though as it falls
apart if hardware every supports 1:MANY VMs:KEYS, or if there is a need to
account keys outside of KVM, e.g. if MKTME for non-KVM cases ever sees the
light of day.
