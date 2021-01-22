From: Sean Christopherson <seanjc@google.com>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Thu, 21 Jan 2021 17:25:36 -0800
Message-ID: <YAopkDN85GtWAj3a@google.com>
References: <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
 <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
 <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gzcpU9W1/SZCeREWQKtCyU+h3ZnueYB6wsd7p8fQjUk=;
        b=Ivg8s/ngCczJmDVLobjxa7s3o/QJ81lhVeiVs+r5I/EbmSTuoLcuzVzUEEim+zxauz
         jW26PvAyV7m5WxC3OBo2G+OpV8nlBVlzuj+n495o9Fb7N0nH2Q/Axwg562mccRnVtwag
         Zggzp+J/2P9RvXz8oXaQQS9aB/U1BQG1Kb3Wm/jWj4G5TKZZCi8K74Mfjeq6Qf1z7ee0
         6k2e9QzVsAMLZLDg/w8kHSPKmClR83FXKMGZuUyiY+1X465rrUKAPpXQzRSuJcNbJn/w
         FYXkJv2yLZYGKcnaZxekgSWbeT0Wp81bb/snOGx8tnAnv5sREa+vwu89V6iHG6igejfK
         j7kw==
Content-Disposition: inline
In-Reply-To: <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Tejun Heo <tj@kernel.org>, Vipin Sharma <vipinsh@google.com>, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jan 21, 2021, Tom Lendacky wrote:
> On 1/21/21 9:55 AM, Tejun Heo wrote:
> > Hello,
> > 
> > On Thu, Jan 21, 2021 at 08:55:07AM -0600, Tom Lendacky wrote:
> > > The hardware will allow any SEV capable ASID to be run as SEV-ES, however,
> > > the SEV firmware will not allow the activation of an SEV-ES VM to be
> > > assigned to an ASID greater than or equal to the SEV minimum ASID value. The
> > > reason for the latter is to prevent an !SEV-ES ASID starting out as an
> > > SEV-ES guest and then disabling the SEV-ES VMCB bit that is used by VMRUN.
> > > This would result in the downgrading of the security of the VM without the
> > > VM realizing it.
> > > 
> > > As a result, you have a range of ASIDs that can only run SEV-ES VMs and a
> > > range of ASIDs that can only run SEV VMs.
> > 
> > I see. That makes sense. What's the downside of SEV-ES compared to SEV w/o
> > ES? Are there noticeable performance / feature penalties or is the split
> > mostly for backward compatibility?
> 
> SEV-ES is an incremental enhancement of SEV where the register state of the
> guest is protected/encrypted. As with a lot of performance questions, the
> answer is ...it depends. 

True, but the expected dual-usage is more about backwards compatibility than
anything else.  Running an SEV-ES VM requires a heavily enlightened guest vBIOS
and kernel, which means that a VM that was created as an SEV guest cannot easily
be converted to an SEV-ES guest, and it would require cooperation from the guest
(if it's even feasible?).

SEV-SNP, another incremental enhancement (on SEV-ES), further strengthens the
argument for SEV and SEV-* coexistenence.  SEV-SNP and SEV-ES will share the
same ASID range, so the question is really, "do we expect to run SEV guests and
any flavor of SEV-* guests on the same platform".  And due to SEV-* not being
directly backward compatible with SEV, the answer will eventually be "yes", as
we'll want to keep running existing SEV guest while also spinning up new SEV-*
guests.

That being said, it's certainly possible to abstract the different key types
between AMD and Intel (assuming s390 won't use the cgroup due to it's plethora
of keys).  TDX private keys are equivalent to SEV-ES ASIDs, and MKTME keys (if
the kernel ever gains a user) could be thrown into the same bucket as SEV IDs,
albeit with some minor mental gymnastics.

E.g. this mapping isn't horrendous:

  encrpytion_ids.basic.*       == SEV   == MKTME
  encrpytion_ids.enhanced.*    == SEV-* == TDX

The names will likely be a bit vague, but I don't think they'll be so far off
that it'd be impossible for someone with SEV/TDX knowledge to glean their intent.
And realistically, if anyone gets to the point where they care about controlling
SEV or TDX IDs, they've already plowed through hundreds of pages of dense
documentation; having to read a few lines of cgroup docs to understand basic vs.
enhanced probably won't faze them at all.
