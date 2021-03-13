From: Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Sat, 13 Mar 2021 08:57:01 -0800
Message-ID: <20210313085701.1fd16a39@jacob-builder>
References: <20210302081705.1990283-1-vipinsh@google.com>
        <20210302081705.1990283-3-vipinsh@google.com>
        <20210303185513.27e18fce@jacob-builder>
        <YEB8i6Chq4K/GGF6@google.com>
        <YECfhCJtHUL9cB2L@slm.duckdns.org>
        <20210312125821.22d9bfca@jacob-builder>
        <YEvZ4muXqiSScQ8i@google.com>
        <20210312145904.4071a9d6@jacob-builder>
        <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason

Hi Tejun,

On Sat, 13 Mar 2021 05:20:39 -0500, Tejun Heo <tj@kernel.org> wrote:

> On Fri, Mar 12, 2021 at 02:59:04PM -0800, Jacob Pan wrote:
> > Our primary goal is to limit the amount of IOASIDs that VMs can
> > allocate. If a VM is migrated to a different cgroup, I think we need to
> > charge/uncharge the destination/source cgroup in order enforce the
> > limit. I am not an expert here, any feedback would be appreciated.  
> 
> That simply isn't a supported usage model. None of other resources will
> get tracked if you do that.
Isn't PIDs controller doing the charge/uncharge? I was under the impression
that each resource can be independently charged/uncharged, why it affects
other resources? Sorry for the basic question.

I also didn't quite get the limitation on cgroup v2 migration, this is much
simpler than memcg. Could you give me some pointers?

BTW, since the IOASIDs are used to tag DMA and bound with guest process(mm)
for shared virtual addressing. fork() cannot be supported, so I guess clone
is not a solution here.

Thanks,

Jacob
