From: Tejun Heo <tj@kernel.org>
Subject: Re: [Patch v3 0/2] cgroup: KVM: New Encryption IDs cgroup controller
Date: Wed, 16 Dec 2020 10:27:15 -0500
Message-ID: <X9onUwvKovJeHpKR@mtj.duckdns.org>
References: <20201209205413.3391139-1-vipinsh@google.com>
 <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
 <4f7b9c3f-200e-6127-1d94-91dd9c917921@de.ibm.com>
 <5f8d4cba-d3f-61c2-f97-fdb338fec9b8@google.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=prX3rWtyfPweOuw4gkFpK72BDK4qvRlCVupw3Ndw2Ac=;
        b=rezOy+6QPMcMTmHZilEXd5MahyR0XoYOFbeKSduB26x0hjzRboxW8uHxlpwAPUptzE
         zByvM8BVF7DqzhPTm1pLiRwkFncJRgXgk14fZ3Td5hXZ3ppHAYRVr4K2fmISA/yC3Tg0
         u9fOdp8eaoAayhcY31tEC3A76cRVIkZghlj1ifANhhBGZHwsbykoABxX4WbT8YwSrL4N
         0RMXDdI4XzOF/bcjpfJfe/QUTNbZNe1itunCwu7tIeOmzGjdiHCozLO5a2A3J41IRn5s
         DyyOmQz+GHzQRLN8jYIK0m3LPrDULTB5zJq6uaYm2JB/h+d76aj+Ew/g7hHFE1x/uYkT
         szFQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <5f8d4cba-d3f-61c2-f97-fdb338fec9b8@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, Vipin Sharma <vipinsh@google.com>, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 10, 2020 at 03:44:35PM -0800, David Rientjes wrote:
> Concern with a single misc controller would be that any subsystem that 
> wants to use it has to exactly fit this support: current, max, stat, 
> nothing more.  The moment a controller needs some additional support, and 
> its controller is already implemented in previous kernel versionv as a 
> part of "misc," we face a problem.

Yeah, that's a valid concern, but given the history, there doesn't seem to
be much need beyond that for these use cases and the limited need seems
inherent to the way the resources are defined and consumed. So yeah, it can
either way.

Thanks.

-- 
tejun
