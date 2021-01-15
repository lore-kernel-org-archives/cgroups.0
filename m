From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v4 2/2] cgroup: svm: Encryption IDs cgroup documentation.
Date: Fri, 15 Jan 2021 13:41:59 -0800
Message-ID: <YAIMJ9E8NneoAp8H@google.com>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-3-vipinsh@google.com>
 <YAICaoSyk2O2nU+P@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bgjnqtpec69vUmjqa2UifvxbYQW35/sgPsKU/7Bo9aI=;
        b=OggvUw0Hm9klzCb2gWzL1xpvM4h0B34ZYVQsxN3wC/zdRTLky1sIVS+aP+RMem0Lx+
         dhCHyUumtATf+63/HrQ39p6Plwn+OkdZ92Gyx3QGmotDVqQ0vYf+OMXeU1OQmZYDLp23
         G67G8V+nMMaSDcNKFXoJsHO5cGVnEx6jZqJiA8UQp+Rg3CH83hN9RC4c94IlDyEIP/st
         zg0JlRpy3X+IW2jLP5T+VNP8gpjIkw7faoZac0GCm/4Jn2YSbPTsHrfhyi9oLgSFjKtZ
         f/L89Eha2I7pIfgNg69nuV+z1VE8VInqryQK7DnoxnSVe+pgyAvVhEv/BLD+I5uOc5dA
         14Rg==
Content-Disposition: inline
In-Reply-To: <YAICaoSyk2O2nU+P@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 15, 2021 at 04:00:26PM -0500, Tejun Heo wrote:
> On Thu, Jan 07, 2021 at 05:28:46PM -0800, Vipin Sharma wrote:
> > Documentation for both cgroup versions, v1 and v2, of Encryption IDs
> > controller. This new controller is used to track and limit usage of
> > hardware memory encryption capabilities on the CPUs.
> > 
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > Reviewed-by: David Rientjes <rientjes@google.com>
> > Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> > ---
> >  .../admin-guide/cgroup-v1/encryption_ids.rst  | 108 ++++++++++++++++++
> >  Documentation/admin-guide/cgroup-v2.rst       |  78 ++++++++++++-
> 
> Given how trivial it is, I'm not gonna object to adding new v1 interface but
> maybe just point to v2 doc from v1?
> 

Sure, I will just add the path to v2 doc in v1.

> Thanks.
> 
> -- 
> tejun
