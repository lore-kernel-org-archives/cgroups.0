From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/3] cgroup: New misc cgroup controller
Date: Thu, 23 Sep 2021 06:01:09 -1000
Message-ID: <YUykxX/oWh2kvOvQ@slm.duckdns.org>
References: <20210330044206.2864329-1-vipinsh@google.com>
 <f1955267-c009-4dea-970e-9145c7cd6dbc@rockwork.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BuDobJ3AWzl5ylAONqdPHFWh3sYqdQh+QEZjN3iZoYo=;
        b=Jn0EWN1cnKTmalUnGyaSabNAfg09UM7LGJlb9FMlmH2wC2ofN3uhW56smzjlK3UcO0
         E8PWTuQxY/T5n3CEXhkX29IWE9iP2/ATbaWgnOIwpS0ClnYMUCSfFbi7xZ1v5SzopW2I
         ikT6vQd6aEn6ghx6Yc0fhvcMfGtgd7pvTzHPwVzMJmFMv84TiAGSKxOFQnKXcwOzztRQ
         ft1Xce3oxJdSY5hqxuTdT+xJO7P+R/SZ8vhSPpPvuN/xusYQwRani0+kYdM08WgnAMWN
         Zo5dKXPafK9ww9lVNbrmImutp49COvua7RGz+cKMJPx0111B9mn2fIijtMjX8ooF14EG
         Uo6w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <f1955267-c009-4dea-970e-9145c7cd6dbc@rockwork.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xingyou Chen <rockrush@rockwork.org>
Cc: Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com, jacob.jun.pan@intel.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, brian.welty@intel.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Sep 23, 2021 at 11:38:49PM +0800, Xingyou Chen wrote:
> > Misc controller is a generic controller which can be used by these
> > kinds of resources.
> 
> Will we make this dynamic? Let resources be registered via something
> like misc_cg_res_{register,unregister}, at compile time or runtime,
> instead of hard coded into misc_res_name/misc_res_capacity etc.
> 
> There are needs as noted in drmcg session earlier this year. We may
> make misc cgroup stable, and let device drivers to register their
> own resources.

Not too likely given that the need for one-off resources for a specific
driver seems to indicate lack of proper abstraction and control mechanism
more than anything else. Even for cases where there are genuine needs for
per-hardware knobs, I think it's prudent to enforce a review cycle which
involves people who aren't directly working on the specific driver.

Thanks.

-- 
tejun
