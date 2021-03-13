From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Sat, 13 Mar 2021 05:20:39 -0500
Message-ID: <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-3-vipinsh@google.com>
 <20210303185513.27e18fce@jacob-builder>
 <YEB8i6Chq4K/GGF6@google.com>
 <YECfhCJtHUL9cB2L@slm.duckdns.org>
 <20210312125821.22d9bfca@jacob-builder>
 <YEvZ4muXqiSScQ8i@google.com>
 <20210312145904.4071a9d6@jacob-builder>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UpX1Lg+mq54WtiAhrwBDWXYDPmqQUSFtcUwtNY+v8RQ=;
        b=FS0YqOTWPrsR8T8rB+TOtNMqfIpKjZbMujx1QpqRgZjz+StMzp0ESXTxK/LGZVIOsP
         9J/ID9iq3J8fZXg6Zvd+AZeFr0D4YkkTPs8aOslYrPBSny6+99XB8x6oEohV8QVCe77t
         cUb0BW4BeNSoNY+qqwndaQGB63Hxq/SUFNI/zOzGmYw9u8iUbebYf6K0V012N05CS6MU
         HkIJs4hs3gGUSxMlZ1Fh6L2Gc3+begGLpY1xDxOeF1bLTazwfYrTo9ed3PR2AFrzSZHL
         aUwrIpg9owREHwMHERhVCTJp9HrkZ26YA1xMQIDqfyU3uRlaMJYeB8puRxRmsdcEjhCI
         OInA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210312145904.4071a9d6@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan@intel.com>
Cc: Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason

On Fri, Mar 12, 2021 at 02:59:04PM -0800, Jacob Pan wrote:
> Our primary goal is to limit the amount of IOASIDs that VMs can allocate.
> If a VM is migrated to a different cgroup, I think we need to
> charge/uncharge the destination/source cgroup in order enforce the limit. I
> am not an expert here, any feedback would be appreciated.

That simply isn't a supported usage model. None of other resources will get
tracked if you do that.

Thanks.

-- 
tejun
