From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Date: Mon, 15 Mar 2021 19:54:36 -0400
Message-ID: <YE/zvLkL1vM8/Cdm@slm.duckdns.org>
References: <YECfhCJtHUL9cB2L@slm.duckdns.org>
 <20210312125821.22d9bfca@jacob-builder>
 <YEvZ4muXqiSScQ8i@google.com>
 <20210312145904.4071a9d6@jacob-builder>
 <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
 <20210313085701.1fd16a39@jacob-builder>
 <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
 <20210315151155.383a7e6e@jacob-builder>
 <YE/ddx5+ToNsgUF0@slm.duckdns.org>
 <20210315164012.4adeabe8@jacob-builder>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=US0hVPQ8vE/ff4q4EMV/WahbUbFBxAIlNGyDC8TZKKo=;
        b=anlpAKgv1icjbUA4PcLTmi9IUjIbI/zzazbcKLMIKSnLma+f+zvtMa/z+TNJ1Fb4/U
         w4LKNq8Sxa+Jd4ADL3B6JaCsM2rY4qXj3HeZD4506hVAgMner9pcoO2Vd9OZCjXqeQ2Q
         C/KJ3q0LAJ2t2P4R0lPsrUK1AC8Cgrxvl02ibVFSP88VrAhtb7nDKS5uiJI/tNu+Uv/M
         HvEa87XZIybFq27EArSte01J4H7GrL53gn48U5jGfSOP/O0z/vgpwwPp2ftthhXWAsVY
         //QJ71p/BWJs/LrqaW7yb0VkIlGKZxprXpB0uMM1gym5oJ/Pjk4XP/jxxyLzDqwn2AFp
         k4vg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210315164012.4adeabe8@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan@intel.com>
Cc: Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Jason

Hello,

On Mon, Mar 15, 2021 at 04:40:12PM -0700, Jacob Pan wrote:
> 2. then we want to move/migrate Process1 to cg_B. so we need uncharge 10 of
> cg_A, charge 10 of cg_B

So, what I don't get is why this migration is necessary. This isn't
supported as a usage pattern and no one, at least in terms of wide-spread
usage, does this. Why is this a requirement for your use case?

Thanks.

-- 
tejun
