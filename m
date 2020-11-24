From: Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Date: Tue, 24 Nov 2020 23:18:14 +0000
Message-ID: <20201124231814.GA258638@google.com>
References: <alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com>
 <20201124191629.GB235281@google.com>
 <20201124194904.GA45519@google.com>
 <alpine.DEB.2.23.453.2011241215400.3594395@chino.kir.corp.google.com>
 <20201124210817.GA65542@google.com>
 <20201124212725.GB246319@google.com>
 <20201124222149.GB65542@google.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nI2CFR08TVYrjA8L8FQ1rV8lfflai02Hbg1xnZq/aLQ=;
        b=TGRVwUyghmV6Y++qNyCuEHFIj5NexKfSDa8Ug82+bRV8Joh6DX6CqSVUA03kE0YCN+
         gvN84VG47WYkm1TCbdSwWX/5h/yvPdMsu+3yoMZr73gr3ZKSL08rfkcDz7EsrjbNZpyR
         vf57CM0AT0VBe/iic5U5QHi54nMEOKwuV/fACKDHwJvyLn4ojz+y/1M5BbK8swJU5pWh
         6DDaApE5mDNGuOrRjmQu5ifVPVUVKs7nJZrdbnYE6HOqarY+Rmd2joTtKV9Nz1SKk/Tn
         smL/NTLkBKtLAIdPQHFAudhhPAWJMQaklsNfKoCEud1Oz93ynweZXZhJxmYT61o5KkBT
         GskQ==
Content-Disposition: inline
In-Reply-To: <20201124222149.GB65542@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: David Rientjes <rientjes@google.com>, Janosch Frank <frankja@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Thomas <thomas.lendacky@amd.com>, pbonzini@redhat.com, tj@kernel.org, lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net, Brijesh <brijesh.singh@amd.com>, Jon <jon.grimm@amd.com>, Eric <eric.vantassell@amd.com>, gingell@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 24, 2020, Vipin Sharma wrote:
> On Tue, Nov 24, 2020 at 09:27:25PM +0000, Sean Christopherson wrote:
> > Is a root level stat file needed?  Can't the infrastructure do .max - .current
> > on the root cgroup to calculate the number of available ids in the system?
> 
> For an efficient scheduling of workloads in the cloud infrastructure, a
> scheduler needs to know the total capacity supported and the current
> usage of the host to get the overall picture. There are some issues with
> .max -.current approach:
> 
> 1. Cgroup v2 convention is to not put resource control files in the
>    root. This will mean we need to sum (.max -.current) in all of the
>    immediate children of the root.

Ah, that's annoying.  Now that you mention it, I do vaguely recall this behavior.
 
> 2. .max can have any limit unless we add a check to not allow a user to
>    set any value more than the supported one. 

Duh, didn't think that one through.

Thanks!
