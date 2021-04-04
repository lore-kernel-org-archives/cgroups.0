From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/3] cgroup: New misc cgroup controller
Date: Sun, 4 Apr 2021 13:35:21 -0400
Message-ID: <YGn42SKCPg2HWtQc@mtj.duckdns.org>
References: <20210330044206.2864329-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=33J8OtutelowSioLnJ+BV370Ve8/xBpuUEz5H46uwPQ=;
        b=DpC5OcjNicGSE5IHLbNl9o0O/n6y7SZQIRP1OF7pZYWEW8TYxgpEXUHI0e7ZPfxSEm
         A+O7GebbfT58u7Lpmiv6sBL3Yk+EujsWCCzrB3aDx97xfLrwLc7CEIA8SeXMDdCVwmsY
         BPqIQTgWEwBURoGagdqHuCG92UlwBGsrjntu1SWK8cLpRmxtUAgouhJt3WpC0vh9OdW9
         /I9txAgZWSB1mY1LSilQo4XMQDZA+0riwckuXe5LjY1cgRMODU/Q+/YhfbHA3JSSUHSn
         Ns1fZL7rLbr7viGLe8jOTv5XiK3tpOFOFQJ5gwIh9kukMUGZbtQgthNUDTrY1AdaBS8H
         2Dkg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210330044206.2864329-1-vipinsh@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: mkoutny@suse.com, jacob.jun.pan@intel.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Applied to cgroup/for-5.13. If there are further issues, let's address them
incrementally.

Thanks.

-- 
tejun
