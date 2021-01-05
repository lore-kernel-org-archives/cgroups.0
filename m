From: Tejun Heo <tj@kernel.org>
Subject: Re: [Patch v3 0/2] cgroup: KVM: New Encryption IDs cgroup controller
Date: Tue, 5 Jan 2021 10:36:40 -0500
Message-ID: <X/SHiFHRsQM43VgC@mtj.duckdns.org>
References: <20201209205413.3391139-1-vipinsh@google.com>
 <X9E6eZaIFDhzrqWO@mtj.duckdns.org>
 <4f7b9c3f-200e-6127-1d94-91dd9c917921@de.ibm.com>
 <5f8d4cba-d3f-61c2-f97-fdb338fec9b8@google.com>
 <X9onUwvKovJeHpKR@mtj.duckdns.org>
 <CAHVum0dS+QxWFSK+evxQtZDHkZZx9pr0m_jEDHc9ovd5jQcfaA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OkXL1EFyZinDOQMdya4rZdvw/dJev0p82LTHbe0DFao=;
        b=KJ6P2nu2S3iBxkYTpfSqP+V+xlOKYWA3Y5MKfCdWSvI20X4BmnSw0FBdKZ2tiysa/u
         OHtFo4qwvv/ETi6a+9k8DHlc0dOgavjgIi4Dmsuxzw3DQm22Mryu88ADMBb7+VjglpwI
         Q2wQ2S7LVuAtL6vQcxNqa/Tjj/PGjwWasP5OTH8FaWQuaeAtL+4sK9cvDCN1/+dpHSu8
         ZE0RhTN9bEQ7ImcQS0qmZjyWUUbY5L5H0x2xkBlXMHzUJ2oXExF+xTHINcglxBablW0w
         QYqq2IEmch/yoe5fAfdRu5Ejp6jDeedkfgWQQ3zJBUssG70masoUfUcmR1VV9/uXuLKg
         piuw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAHVum0dS+QxWFSK+evxQtZDHkZZx9pr0m_jEDHc9ovd5jQcfaA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: David Rientjes <rientjes@google.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Tom Lendacky <thomas.lendacky@amd.com>, Brijesh <brijesh.singh@amd.com>, Jon <jon.grimm@amd.com>, Eric <eric.vantassell@amd.com>, pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>, lizefan@huawei.com, hannes@cmpxchg.org, Janosch Frank <frankja@linux.ibm.com>, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, Jim Mattson <jmattson@google.com>, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, Matt Gingell <gingell@google.com>, Dionna Glaze <dionnaglaze@google.com>, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Happy new year!

On Wed, Dec 16, 2020 at 12:02:37PM -0800, Vipin Sharma wrote:
> I like the idea of having a separate controller to keep the code simple and
> easier for maintenance.

Yeah, the more I think about it, keeping it separate seems like the right
thing to do. What bothers me primarily is that the internal logic is
identical between the RDMA controller and this one. If you wanna try
factoring them out into library, great. If not, I don't think it should
block merging this controller. We can get to refactoring later.

Thanks.

-- 
tejun
