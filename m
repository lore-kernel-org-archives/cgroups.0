From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Mon, 15 Mar 2021 18:19:35 -0400
Message-ID: <YE/ddx5+ToNsgUF0@slm.duckdns.org>
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
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3mc7yshphWRfddErbP6ANAyJjIp9vav1KVv/MqnV+08=;
        b=k4pm+oGHyW/0Hrhbuc7q0+8SgSfdHGYYhPiguGQUh3briuu3jw/5TCyzMGYg8w060V
         MryXnAFafYTZSEg8Y+OqxpfH8TPufBlnRmse3CpAcUakPqZ4TqGz08U1Dp6IHGvZo6dO
         XzvFYARQvIi9vwCArHIBTKB7h0shngcktmS2v27/iOr9YVJOqXHOVsRyLEZeZV/XAEBz
         wTWFgYDv6KA49YfmbS8Kz1BvuHErK/RNw44PjG4hs4LhLyftup1EIv+0wxbGVYDzlIxn
         sKPxsUOx+ytNRtofdhTLCw/ZiSovafjqT75OP8vBE51uc2DsudjKzAuXR9mAJe0PxXw2
         7Y0g==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210315151155.383a7e6e@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan@intel.com>
Cc: Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason

Hello,

On Mon, Mar 15, 2021 at 03:11:55PM -0700, Jacob Pan wrote:
> > Migration itself doesn't have restrictions but all resources are
> > distributed on the same hierarchy, so the controllers are supposed to
> > follow the same conventions that can be implemented by all controllers.
> > 
> Got it, I guess that is the behavior required by the unified hierarchy.
> Cgroup v1 would be ok? But I am guessing we are not extending on v1?

A new cgroup1 only controller is unlikely to be accpeted.

> The IOASIDs are programmed into devices to generate DMA requests tagged
> with them. The IOMMU has a per device IOASID table with each entry has two
> pointers:
>  - the PGD of the guest process.
>  - the PGD of the host process
> 
> The result of this 2 stage/nested translation is that we can share virtual
> address (SVA) between guest process and DMA. The host process needs to
> allocate multiple IOASIDs since one IOASID is needed for each guest process
> who wants SVA.
> 
> The DMA binding among device-IOMMU-process is setup via a series of user
> APIs (e.g. via VFIO).
> 
> If a process calls fork(), the children does not inherit the IOASIDs and
> their bindings. Children who wish to use SVA has to call those APIs to
> establish the binding for themselves.
> 
> Therefore, if a host process allocates 10 IOASIDs then does a
> fork()/clone(), it cannot charge 10 IOASIDs in the new cgroup. i.e. the 10
> IOASIDs stays with the process wherever it goes.
> 
> I feel this fit in the domain model, true?

I still don't get where migration is coming into the picture. Who's
migrating where?

Thanks.

-- 
tejun
