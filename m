From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v3 0/2] cgroup: KVM: New Encryption IDs cgroup controller
Date: Wed, 6 Jan 2021 10:45:14 -0800
Message-ID: <X/YFOvLp/mEk5z9W@google.com>
References: <20201209205413.3391139-1-vipinsh@google.com>
 <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
 <4f7b9c3f-200e-6127-1d94-91dd9c917921@de.ibm.com>
 <5f8d4cba-d3f-61c2-f97-fdb338fec9b8@google.com>
 <X9onUwvKovJeHpKR@mtj.duckdns.org>
 <CAHVum0dS+QxWFSK+evxQtZDHkZZx9pr0m_jEDHc9ovd5jQcfaA@mail.gmail.com>
 <X/SHiFHRsQM43VgC@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ho+xRsAlnZPA9XwreJh6lam3mNeyMrjUZb8gp0Pijj4=;
        b=pp1lm1jkJ+G032pTcswwk6Ab4cZJqTQ98WbtBympCzpKmXncEcv6qCTKzdSbVOifHF
         uO+nl+4aB9LlmW27p+QnG2+/nu8cKCtE16/9E02D0atV5oYdFrwqTeb1hcvmgQQjdytE
         BP1rIL3zXJL23b5bAWRaM36ihs/hLE+PLKsZFbf/TciuW23P2ye6vkAHfsnLnFQiw8op
         SaTOOnQnWIsFOuYSjlppUh85Nmnt1nhpBQbFhMgLCW6419x2Pc3B2b/hRpknb8qcl2/J
         v0XFc/9O3QoVmWuvbjNFMHTi5AJ8M6U2jnYB8YoB90TeBavfL516zS3wbFWGmGUCg3im
         GPtg==
Content-Disposition: inline
In-Reply-To: <X/SHiFHRsQM43VgC@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Tom Lendacky <thomas.lendacky@amd.com>, Brijesh <brijesh.singh@amd.com>, Jon <jon.grimm@amd.com>, Eric <eric.vantassell@amd.com>, pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>, lizefan@huawei.com, hannes@cmpxchg.org, Janosch Frank <frankja@linux.ibm.com>, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, Jim Mattson <jmattson@google.com>, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, Matt Gingell <gingell@google.com>, Dionna Glaze <dionnaglaze@google.com>, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jan 05, 2021 at 10:36:40AM -0500, Tejun Heo wrote:
> Happy new year!
> 
> On Wed, Dec 16, 2020 at 12:02:37PM -0800, Vipin Sharma wrote:
> > I like the idea of having a separate controller to keep the code simple and
> > easier for maintenance.
> 
> Yeah, the more I think about it, keeping it separate seems like the right
> thing to do. What bothers me primarily is that the internal logic is
> identical between the RDMA controller and this one. If you wanna try
> factoring them out into library, great. If not, I don't think it should
> block merging this controller. We can get to refactoring later.
> 

Happy new year!
Sounds great, I will send out a new patch which will not reject the new
max limit based on the current usage. It will not include refactoring
out common code between RDMA and Encryption ID controller. We can pursue
that later.

Thanks
Vipin
