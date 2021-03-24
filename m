From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Date: Wed, 24 Mar 2021 15:09:53 -0700
Message-ID: <YFu4sdhT7KexlyES@google.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <20210304231946.2766648-2-vipinsh@google.com>
 <20210319142801.7dcce403@jacob-builder>
 <YFjn7wv/iMO4Isgz@google.com>
 <20210324091701.63c9ce8e@jacob-builder>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B8cQEyenOi6P1dFAPnRKGJMuEeOhjBSY7qxP2TEHV/o=;
        b=lj6TKx0RstOX0gCi1HsZbR1+i32sFs4YgJqVKDqJMqNl9P/JoBwbO2aTapvdiuP0d5
         DUBzUDV4+r6jkyN2lpepyEX/HLGAKoApLDB3/ZFZ7jrzOOBwRnGPJi32vqtxploDw8q1
         2xhcRg8iqo4Uoje6GvexvUjTkiOfFCXWqIfDCogdi6ZVYcl3Rv+mv39+uPPb1UJQ0bAq
         kPBthg+XX84Uy842vs62HsYZxS37Bz66dcdBGKhNLGpXt+qaGBIV9rPIPwlqOLM5a7s5
         d2YGvho3F6mV31G/8IGY/TAGgIePMext3VqLwc+P0J3CSrRxDdUt2MZENf3sS5fMS1iY
         xCaw==
Content-Disposition: inline
In-Reply-To: <20210324091701.63c9ce8e@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan@intel.com>
Cc: tj@kernel.org, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>

On Wed, Mar 24, 2021 at 09:17:01AM -0700, Jacob Pan wrote:
> I didn't mean the users of misc_cgroup will use css directly. I meant if I
> want to use misc cgruop in ioasid.c, I have to do the following to avoid
> undefined css:
> #include <linux/cgroup.h>
> #include <linux/misc_cgroup.h>
> 
> So it might be simpler if you do #include <linux/cgroup.h> inside
> misc_cgroup.h. Then in ioasid.c, I only need to do
> #include <linux/misc_cgroup.h>.

Sorry, I misunderstood the comment first time. I agree with you, I will
add cgroup header file in the misc_cgroup.h after  #ifdef
CONFIG_CGROUP_MISC statement.

Thanks
Vipin
