From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Tue, 26 Jan 2021 12:49:14 -0800 (PST)
Message-ID: <1744f6c-551b-8de8-263e-5dac291b7ef@google.com>
References: <YAICLR8PBXxAcOMz@mtj.duckdns.org> <YAIUwGUPDmYfUm/a@google.com> <YAJg5MB/Qn5dRqmu@mtj.duckdns.org> <YAJsUyH2zspZxF2S@google.com> <YAb//EYCkZ7wnl6D@mtj.duckdns.org> <YAfYL7V6E4/P83Mg@google.com> <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com> <YAmj4Q2J9htW2Fe8@mtj.duckdns.org> <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com> <YAopkDN85GtWAj3a@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=JT5edQcn2lC/ohAJBe7VJY+gZeoJrzYd010rHqJGKDE=;
        b=Sl3WiOu4tIDOkkgv6i4aMIADj6Mw5A+pPOV31fbYQXGVQgOWouYMM9sniqU/pYH0k7
         2bREpiqbqKcRGqldVB4KKeo0Crk7SCoIXJWfguKvvlG8NCnvIuoyx5dlIZKLjioqq8dd
         UOkv/2z8yKxiOcEI6Qx+6Jjygo437bYF0l+IWzWFxzmvNrQi2oKLFiTj9uHv18Vo+8LS
         SXfRYG5Bu3tI76sinpnZrXtxRnYYxLP7ukt94RAtwQabXFW7v37K9A3D3MX8L4iu30Gc
         BV5CZUT7tAIm/dQbcvnszeOQCpOd+2emTElIqjZRG/A8fPqerkeY6wXr7UKHybt0vmC8
         +gmg==
In-Reply-To: <YAopkDN85GtWAj3a-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Singh, Brijesh" <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, "Grimm, Jon" <jon.grimm-5C7GfCeVMHo@public.gmane.org>, "Van Tassell, Eric" <eric.vantassell-5C7GfCeVMHo@public.gmane.org>, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 21 Jan 2021, Sean Christopherson wrote:

> True, but the expected dual-usage is more about backwards compatibility than
> anything else.  Running an SEV-ES VM requires a heavily enlightened guest vBIOS
> and kernel, which means that a VM that was created as an SEV guest cannot easily
> be converted to an SEV-ES guest, and it would require cooperation from the guest
> (if it's even feasible?).
> 
> SEV-SNP, another incremental enhancement (on SEV-ES), further strengthens the
> argument for SEV and SEV-* coexistenence.  SEV-SNP and SEV-ES will share the
> same ASID range, so the question is really, "do we expect to run SEV guests and
> any flavor of SEV-* guests on the same platform".  And due to SEV-* not being
> directly backward compatible with SEV, the answer will eventually be "yes", as
> we'll want to keep running existing SEV guest while also spinning up new SEV-*
> guests.
> 

Agreed, cloud providers will most certainly want to run both SEV and SEV-* 
guests on the same platform.

> That being said, it's certainly possible to abstract the different key types
> between AMD and Intel (assuming s390 won't use the cgroup due to it's plethora
> of keys).  TDX private keys are equivalent to SEV-ES ASIDs, and MKTME keys (if
> the kernel ever gains a user) could be thrown into the same bucket as SEV IDs,
> albeit with some minor mental gymnastics.
> 
> E.g. this mapping isn't horrendous:
> 
>   encrpytion_ids.basic.*       == SEV   == MKTME
>   encrpytion_ids.enhanced.*    == SEV-* == TDX
> 
> The names will likely be a bit vague, but I don't think they'll be so far off
> that it'd be impossible for someone with SEV/TDX knowledge to glean their intent.
> And realistically, if anyone gets to the point where they care about controlling
> SEV or TDX IDs, they've already plowed through hundreds of pages of dense
> documentation; having to read a few lines of cgroup docs to understand basic vs.
> enhanced probably won't faze them at all.
> 

The abstraction makes sense for both AMD and Intel offerings today.  It 
makes me wonder if we want a read-only 
encryption_ids.{basic,enhanced}.type file to describe the underlying 
technology ("SEV-ES/SEV-SNP", "TDX", etc).  Since the technology is 
discoverable by other means and we are assuming one encryption type per 
pool of encryption ids, we likely don't need this.

I'm slightly concerned about extensibility if there is to be an 
incremental enhancement atop SEV-* or TDX with yet another pool of 
encryption ids.  (For example, when we only had hugepages, this name was 
perfect; then we got 1GB pages which became "gigantic pages", so are 512GB 
pages "enormous"? :)  I could argue (encryption_ids.basic.*,
encryption_ids.enhanced.*) should map to 
(encryption_ids.legacy.*, encryption_ids.*) but that's likely 
bikeshedding.

Thomas: does encryption_ids.{basic,enhanced}.* make sense for ASID 
partitioning?

Tejun: if this makes sense for legacy SEV and SEV-* per Thomas, and this 
is now abstracted to be technology (vendor) neutral, does this make sense 
to you?
