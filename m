From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Mon, 15 Mar 2021 22:22:12 -0400
Message-ID: <YFAWVJrM86FB17Lk@slm.duckdns.org>
References: <YEvZ4muXqiSScQ8i@google.com>
 <20210312145904.4071a9d6@jacob-builder>
 <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
 <20210313085701.1fd16a39@jacob-builder>
 <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
 <20210315151155.383a7e6e@jacob-builder>
 <YE/ddx5+ToNsgUF0@slm.duckdns.org>
 <20210315164012.4adeabe8@jacob-builder>
 <YE/zvLkL1vM8/Cdm@slm.duckdns.org>
 <20210315183030.5b15aea3@jacob-builder>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x9e1xfobrgux5JmgRy+7168jAO2JUpIpvIQcF6MG83w=;
        b=fjEXsStwnXKCurOKkJhtQkcTA24r1rdYzLOmvw1xvyNUJvtm0b9kg5enio6VXPGHUE
         NeMqy3J9wiHHmkHoTqZlg8I7iJ8StIPtyYL8JawjzLLmbqjI+hrWHfILqO0RxLbwrXLC
         jDWFObZ/zoE4IRnM9FQRyorroXQVsjphNLWMaDMpPHCRxgovQgs4vjPMMOm2o45NtdX/
         nDbk2QOo3c4OaemxRdSTaFDuqla+i33mWKdJznmikwFBiysdhSnwmgzniAXpM9JXIQla
         5KZ3WFUnLvoxEVwfPbWYKAVhnwTfUrDOtfhCPtfNSeuue6NnIU8ZUyDPx7cSZeSy2Yys
         QoHw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210315183030.5b15aea3@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan@intel.com>
Cc: Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason

On Mon, Mar 15, 2021 at 06:30:30PM -0700, Jacob Pan wrote:
> I don't know if this is required. I thought utilities such as cgclassify
> need to be supported.
> " cgclassify - move running task(s) to given cgroups "
> If no such use case, I am fine with dropping the migration support. Just
> enforce limit on allocations.

Yeah, that's what all other controllers do. Please read the in-tree cgroup2
doc.

Thanks.

-- 
tejun
