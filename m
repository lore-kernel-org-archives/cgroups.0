From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC Patch 1/2] KVM: SVM: Create SEV cgroup controller.
Date: Tue, 03 Nov 2020 14:43:57 -0800
Message-ID: <7ed06917207b4348cc6b680ccd093e0eb204d2ec.camel@HansenPartnership.com>
References: <20200922004024.3699923-1-vipinsh@google.com>
         <20200922004024.3699923-2-vipinsh@google.com>
         <94c3407d-07ca-8eaf-4073-4a5e2a3fb7b8@infradead.org>
         <20200922012227.GA26483@linux.intel.com>
         <c0ee04a93a8d679f5e9ee7eea6467b32bb7063d6.camel@HansenPartnership.com>
         <20201103181007.GB28367@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604443439;
        bh=jBpk6Z334081TAbA3EzUJdc4T6st/PnuXaUfjPTVc08=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=u7V3w979b4gsRp1iPjuXeauDjIyEBPeEP2YCp2eijHJkFw8ja3mDQShpKFonUphOI
         XNSstro+N/f8i95ggyC5/1MbS5c4ZUNb9sb4YYjNo6EDwJgmCkj1PtdIcS8KmGzGBW
         dEDwrJmhlJBDSt5c60+Fel3ym5PnYw0c6JX8RUDk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1604443439;
        bh=jBpk6Z334081TAbA3EzUJdc4T6st/PnuXaUfjPTVc08=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=u7V3w979b4gsRp1iPjuXeauDjIyEBPeEP2YCp2eijHJkFw8ja3mDQShpKFonUphOI
         XNSstro+N/f8i95ggyC5/1MbS5c4ZUNb9sb4YYjNo6EDwJgmCkj1PtdIcS8KmGzGBW
         dEDwrJmhlJBDSt5c60+Fel3ym5PnYw0c6JX8RUDk=
In-Reply-To: <20201103181007.GB28367@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Vipin Sharma <vipinsh@google.com>, thomas.lendacky@amd.com, pbonzini@redhat.com, tj@kernel.org, lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, gingell@google.com, rientjes@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Dionna Glaze <dionnaglaze@google.com>, Erdem Aktas <erdemaktas@google.com>

On Tue, 2020-11-03 at 10:10 -0800, Sean Christopherson wrote:
> On Tue, Nov 03, 2020 at 08:39:12AM -0800, James Bottomley wrote:
> > On Mon, 2020-09-21 at 18:22 -0700, Sean Christopherson wrote:
> > > ASIDs too.  I'd also love to see more info in the docs and/or
> > > cover letter to explain why ASID management on SEV requires a
> > > cgroup.  I know what an ASID is, and have a decent idea of how
> > > KVM manages ASIDs for legacy VMs, but I know nothing about why
> > > ASIDs are limited for SEV and not legacy VMs.
> > 
> > Well, also, why would we only have a cgroup for ASIDs but not
> > MSIDs?
> 
> Assuming MSID==PCID in Intel terminology, which may be a bad
> assumption, the answer is that rationing PCIDs is a fools errand, at
> least on Intel CPUs.

Yes, sorry, I should probably have confessed that I'm most used to
parisc SIDs, which are additional 32 bit qualifiers the CPU explicitly
adds to every virtual address.  The perform exactly the same function,
though except they're a bit more explicit (and we have more bits).  On
PA every virtual address is actually a GVA consisting of 32 bit of SID
and 64 bits of VA and we use this 96 byte address for virtual indexing
and things.  And parisc doesn't have virtualization acceleration so we
only have one type of SID.

Thanks for the rest of the elaboration.

James


