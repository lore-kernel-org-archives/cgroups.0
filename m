From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Sat, 13 Mar 2021 13:05:36 -0500
Message-ID: <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-3-vipinsh@google.com>
 <20210303185513.27e18fce@jacob-builder>
 <YEB8i6Chq4K/GGF6@google.com>
 <YECfhCJtHUL9cB2L@slm.duckdns.org>
 <20210312125821.22d9bfca@jacob-builder>
 <YEvZ4muXqiSScQ8i@google.com>
 <20210312145904.4071a9d6@jacob-builder>
 <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
 <20210313085701.1fd16a39@jacob-builder>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qmztczQ8nwlB2ZsLfNT+eUr55Vm8FQvEeckkwobT4Fo=;
        b=J7BNxH+9zAJSpZT49oEVvoljADKL0mcaBvvxC0C2vlCBSuitKhdzpCMx3KI7BfdLdR
         /OVlpcir79WWkWYHgudf7wc9wI4ikkGV/oj89W25FwqepTpfgBDOv3TxCNN1z0uOgJoF
         SY+FzlHUH+gZypRWujGQZPCo07NOekPMlT6BO8sJqBPNB+gWKZZKCGZuL/ixT0afD7hq
         OlHTJCfLA8dLtgYqCXf/rFP71y5lTue4Qkq7ePDIAbamQLwhl562yOeZmScANXRCkB69
         aY1f6sROr7S36dtchcv8kUNsxshmcp7+lC20LpV2jCcBoL7a980V+Pouv5fVkFtI4Qzb
         bDKQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210313085701.1fd16a39@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan@intel.com>
Cc: Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason

Hello,

On Sat, Mar 13, 2021 at 08:57:01AM -0800, Jacob Pan wrote:
> Isn't PIDs controller doing the charge/uncharge? I was under the impression
> that each resource can be independently charged/uncharged, why it affects
> other resources? Sorry for the basic question.

Yeah, PID is an exception as we needed the initial migration to seed new
cgroups and it gets really confusing with other ways to observe the
processes - e.g. if you follow the original way of creating a cgroup,
forking and then moving the seed process into the target cgroup, if we don't
migrate the pid charge together, the numbers wouldn't agree and the seeder
cgroup may end up running out of pids if there are any restrictions.

> I also didn't quite get the limitation on cgroup v2 migration, this is much
> simpler than memcg. Could you give me some pointers?

Migration itself doesn't have restrictions but all resources are distributed
on the same hierarchy, so the controllers are supposed to follow the same
conventions that can be implemented by all controllers.

> BTW, since the IOASIDs are used to tag DMA and bound with guest process(mm)
> for shared virtual addressing. fork() cannot be supported, so I guess clone
> is not a solution here.

Can you please elaborate what wouldn't work? The new spawning into a new
cgroup w/ clone doesn't really change the usage model. It's just a neater
way to seed a new cgroup. If you're saying that the overall usage model
doesn't fit the needs of IOASIDs, it likely shouldn't be a cgroup
controller.

Thanks.

-- 
tejun
