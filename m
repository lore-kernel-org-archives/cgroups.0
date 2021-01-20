From: Tejun Heo <tj@kernel.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Wed, 20 Jan 2021 11:40:18 -0500
Message-ID: <YAhc8khTUc2AFDcd@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6cgRNQyvwqoOzrnPDmHwEwehw3UJ3BnFoyNANdWEhcs=;
        b=A+DQWxSy/SvL7lr93IkBN+cn6fxDJbsm0KZN1mKcBCanmMbc1jJXX9aKLE3r+hSIL/
         APH3ovJ5ozPOv+XO96yoJBgwXxehA98sdUl1WND+h+93MkW4HhuS+BCOP3BcFccOtTOi
         hBRghF0tAkk2KRD4qcoYp1iOjqg+UJw9yvgxqduUrpfkyj6mJJefjSgTjF6glRkXTwYD
         K5KITRPviTggIspBtJKBa3q4XMfF5VXdchZ5RNmN/ahWqdW9cVGU1x06fSAp4UPbQeAa
         CQ+0bQiCnO6mZpYpaIbr6+EynJhVJAMeeaA/rdL5RgFqTjqnkUxcbrtw3WJ+6oVXgiGK
         SEYA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YAfYL7V6E4/P83Mg@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, seanjc@google.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 19, 2021 at 11:13:51PM -0800, Vipin Sharma wrote:
> > Can you please elaborate? I skimmed through the amd manual and it seemed to
> > say that SEV-ES ASIDs are superset of SEV but !SEV-ES ASIDs. What's the use
> > case for mixing those two?
> 
> For example, customers can be given options for which kind of protection they
> want to choose for their workloads based on factors like data protection
> requirement, cost, speed, etc.

So, I'm looking for is a bit more in-depth analysis than that. ie. What's
the downside of SEV && !SEV-ES and is the disticntion something inherently
useful?

> In terms of features SEV-ES is superset of SEV but that doesn't mean SEV
> ASIDs are superset of SEV ASIDs. SEV ASIDs cannot be used for SEV-ES VMs
> and similarly SEV-ES ASIDs cannot be used for SEV VMs. Once a system is
> booted, based on the BIOS settings each type will have their own
> capacity and that number cannot be changed until the next boot and BIOS
> changes.

Here's an excerpt from the AMD's system programming manual, section 15.35.2:

  On some systems, there is a limitation on which ASID values can be used on
  SEV guests that are run with SEV-ES disabled. While SEV-ES may be enabled
  on any valid SEV ASID (as defined by CPUID Fn8000_001F[ECX]), there are
  restrictions on which ASIDs may be used for SEV guests with SEV- ES
  disabled. CPUID Fn8000_001F[EDX] indicates the minimum ASID value that
  must be used for an SEV-enabled, SEV-ES-disabled guest. For example, if
  CPUID Fn8000_001F[EDX] returns the value 5, then any VMs which use ASIDs
  1-4 and which enable SEV must also enable SEV-ES.

> We are not mixing the two types of ASIDs, they are separate and used
> separately.

Maybe in practice, the key management on the BIOS side is implemented in a
more restricted way but at least the processor manual says differently.

> > I'm very reluctant to ack vendor specific interfaces for a few reasons but
> > most importantly because they usually indicate abstraction and/or the
> > underlying feature not being sufficiently developed and they tend to become
> > baggages after a while. So, here are my suggestions:
> 
> My first patch was only for SEV, but soon we got comments that this can
> be abstracted and used by TDX and SEID for their use cases.
> 
> I see this patch as providing an abstraction for simple accounting of
> resources used for creating secure execution contexts. Here, secure
> execution is achieved through different means. SEID, TDX, and SEV
> provide security using different features and capabilities. I am not
> sure if we will reach a point where all three and other vendors will use
> the same approach and technology for this purpose.
> 
> Instead of each one coming up with their own resource tracking for their
> features, this patch is providing a common framework and cgroup for
> tracking these resources.

What's implemented is a shared place where similar things can be thrown in
bu from user's perspective the underlying hardware feature isn't really
abstracted. It's just exposing whatever hardware knobs there are. If you
look at any other cgroup controllers, nothing is exposing this level of
hardware dependent details and I'd really like to keep it that way.

So, what I'm asking for is more in-depth analysis of the landscape and
inherent differences among different vendor implementations to see whether
there can be better approaches or we should just wait and see.

> > * If there can be a shared abstraction which hopefully makes intuitive
> >   sense, that'd be ideal. It doesn't have to be one knob but it shouldn't be
> >   something arbitrary to specific vendors.
> 
> I think we should see these as features provided on a host. Tasks can
> be executed securely on a host with the guarantees provided by the
> specific feature (SEV, SEV-ES, TDX, SEID) used by the task.
> 
> I don't think each H/W vendor can agree to a common set of security
> guarantees and approach.

Do TDX and SEID have multiple key types tho?

> > * If we aren't there yet and vendor-specific interface is a must, attach
> >   that part to an interface which is already vendor-aware.
> Sorry, I don't understand this approach. Can you please give more
> details about it?

Attaching the interface to kvm side, most likely, instead of exposing the
feature through cgroup.

Thanks.

-- 
tejun
