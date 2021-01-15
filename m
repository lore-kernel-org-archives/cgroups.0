From: Tejun Heo <tj@kernel.org>
Subject: Re: [Patch v4 2/2] cgroup: svm: Encryption IDs cgroup documentation.
Date: Fri, 15 Jan 2021 16:00:26 -0500
Message-ID: <YAICaoSyk2O2nU+P@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-3-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b4f3UhQcs3db0KRbKmi1fEJZcKX6X448F2Q0YUA3YCg=;
        b=mN2tL4d7EaI6xnuajdBvL5TsthjPSdFeFTAb8rFdHhUk9Uj/rgahmZB7MmEMctUuGZ
         Fg8a1b+24UXmaUpf4tBkbpJuOuI1bdlTm/fiGQ85bvihYW96JAT44+jsgpr5FBSLdyb3
         MX6S+KYcqkTqgTFXwdlADrWf/o41kcwBDUYN8qpTTmvQEJfBVpL+7ZjOgSo3czN0ktUS
         nNX9YVumcl5V2w3Wap4mtr0AsIR29/fDDHSRC+nMR/zMiewki7afBE9xg+pfDF6Cuvjy
         JGdYuBQekOeccVgdqtf1/QoItAgqShbR+EnnkPRzmEeYnr1+32kqMnrOxkLAAb95Qabi
         3G6g==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210108012846.4134815-3-vipinsh@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jan 07, 2021 at 05:28:46PM -0800, Vipin Sharma wrote:
> Documentation for both cgroup versions, v1 and v2, of Encryption IDs
> controller. This new controller is used to track and limit usage of
> hardware memory encryption capabilities on the CPUs.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Reviewed-by: David Rientjes <rientjes@google.com>
> Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  .../admin-guide/cgroup-v1/encryption_ids.rst  | 108 ++++++++++++++++++
>  Documentation/admin-guide/cgroup-v2.rst       |  78 ++++++++++++-

Given how trivial it is, I'm not gonna object to adding new v1 interface but
maybe just point to v2 doc from v1?

Thanks.

-- 
tejun
