From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 1/2] cgroup: sev: Add misc cgroup controller
Date: Thu, 4 Mar 2021 03:53:11 -0500
Message-ID: <YECf9yxMMAztYEH4@slm.duckdns.org>
References: <20210302081705.1990283-1-vipinsh@google.com>
 <20210302081705.1990283-2-vipinsh@google.com>
 <YD+ubbB4Tz0ZlVvp@slm.duckdns.org>
 <YEB6ULUgbf+s8ydd@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7yRX9wnbaqglQOqo35jp40oCDrn05rlNxnwnL03DlpE=;
        b=KZp4VpCLyjq4r7v+f3wf3DEJwmNX69ZdxRoq/N35GcQfqmjHiarec+NRj7KIldoeDn
         pZbEMbqOFxiQNvPhJdL/up4J+DHXdVPtN8l6ev1aGrjKVWrHdVUiyQ3Ne3+oN+ssrls6
         LxnEGJ3S+kkZGcOyVXuepIbNqb1RPDtwc1GiQwhln41uDV1zNmeLCoGVCz1Zou/rv8Km
         3zoPGw9sfJxB/GP+6HeJLHc7ZL8k/473wsXPli2Df4HTj+afRv1U+MNTSquDZmTG4vZZ
         1GO0fzGBFPwvgzS1jPRN+1sMTk1UKbe7A2bA5z1ZcNiHFJUYu/I4XRGD4g+xai+Z2UfJ
         P1BA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YEB6ULUgbf+s8ydd@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 03, 2021 at 10:12:32PM -0800, Vipin Sharma wrote:
> Right now there is no API for the caller to know total usage, unless they
> keep their own tally, I was thinking it will be useful to add one more API
> 
> unsigned long misc_cg_res_total_usage(enum misc_res_type type)
> 
> It will return root_cg usage for "type" resource.
> Will it be fine?

Yeah, that sounds fine.

Thanks.

-- 
tejun
