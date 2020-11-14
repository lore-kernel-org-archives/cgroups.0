From: David Rientjes <rientjes@google.com>
Subject: Re: [RFC Patch 0/2] KVM: SVM: Cgroup support for SVM SEV ASIDs
Date: Fri, 13 Nov 2020 16:26:09 -0800 (PST)
Message-ID: <alpine.DEB.2.23.453.2011131615510.333518@chino.kir.corp.google.com>
References: <20200922004024.3699923-1-vipinsh@google.com> <20200922014836.GA26507@linux.intel.com> <20200922211404.GA4141897@google.com> <20200924192116.GC9649@linux.intel.com> <cb592c59-a50e-5901-71fe-19e43bc9e37e@amd.com> <20200925222220.GA977797@google.com>
 <20201002204810.GA3179405@google.com> <20201103020623.GJ21563@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Eyi3ibuvYWMCo7i6ODa9MSLY3tsErf7jEpym/+H+ah4=;
        b=bHZo0ee3XBP9p4M+ZN66+nahhWFE7yUfvbiG5bA6o1mruvmC3Yww3mynB3xOxEvtZM
         dXMICkYjdvO2ADU7o7Cgg6Ittbb0fNtX2JmKSb9Zews8kBA2YRq3+H3PMffKmJy8R98Z
         b9I43agtiQZjKyzPjHkpenN1Mc2Bf3LvlxVMk54MoRm5RnQYy/oAKsvpqbfWjMimZRib
         Ua2BZf3WMCDbmFyGy8BFT6X24fM1a7+f9f/v5F50CZGeyanXn+znzPjnizEY1N9Hh1sn
         cgBzOe2WIZiAC7+98J0+loMccJvGk4jxhzYg9JAw8HD0lURkU29EyqHZBaF2uf+/1P4O
         SlNg==
In-Reply-To: <20201103020623.GJ21563@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <sean.j.christopherson@intel.com>, Janosch Frank <frankja@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Vipin Sharma <vipinsh@google.com>, "Lendacky, Thomas" <thomas.lendacky@amd.com>, pbonzini@redhat.com, tj@kernel.org, lizefan@huawei.com, joro@8bytes.org, corbet@lwn.net, "Singh, Brijesh" <brijesh.singh@amd.com>, "Grimm, Jon" <jon.grimm@amd.com>, "Van Tassell, Eric" <eric.vantassell@amd.com>, gingell@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2 Nov 2020, Sean Christopherson wrote:

> On Fri, Oct 02, 2020 at 01:48:10PM -0700, Vipin Sharma wrote:
> > On Fri, Sep 25, 2020 at 03:22:20PM -0700, Vipin Sharma wrote:
> > > I agree with you that the abstract name is better than the concrete
> > > name, I also feel that we must provide HW extensions. Here is one
> > > approach:
> > > 
> > > Cgroup name: cpu_encryption, encryption_slots, or memcrypt (open to
> > > suggestions)
> > > 
> > > Control files: slots.{max, current, events}
> 
> I don't particularly like the "slots" name, mostly because it could be confused
> with KVM's memslots.  Maybe encryption_ids.ids.{max, current, events}?  I don't
> love those names either, but "encryption" and "IDs" are the two obvious
> commonalities betwee TDX's encryption key IDs and SEV's encryption address
> space IDs.
> 

Looping Janosch and Christian back into the thread.

I interpret this suggestion as
encryption.{sev,sev_es,keyids}.{max,current,events} for AMD and Intel 
offerings, which was my thought on this as well.

Certainly the kernel could provide a single interface for all of these and 
key value pairs depending on the underlying encryption technology but it 
seems to only introduce additional complexity in the kernel in string 
parsing that can otherwise be avoided.  I think we all agree that a single 
interface for all encryption keys or one-value-per-file could be done in 
the kernel and handled by any userspace agent that is configuring these 
values.

I think Vipin is adding a root level file that describes how many keys we 
have available on the platform for each technology.  So I think this comes 
down to, for example, a single encryption.max file vs 
encryption.{sev,sev_es,keyid}.max.  SEV and SEV-ES ASIDs are provisioned 
separately so we treat them as their own resource here.

So which is easier?

$ cat encryption.sev.max
10
$ echo -n 15 > encryption.sev.max

or

$ cat encryption.max
sev 10
sev_es 10
keyid 0
$ echo -n "sev 10" > encryption.max

I would argue the former is simplest (always preferring 
one-value-per-file) and avoids any string parsing or resource controller 
lookups that need to match on that string in the kernel.

The set of encryption.{sev,sev_es,keyid} files that exist would depend on
CONFIG_CGROUP_ENCRYPTION and whether CONFIG_AMD_MEM_ENCRYPT or 
CONFIG_INTEL_TDX is configured.  Both can be configured so we have all 
three files, but the root file will obviously indicate 0 keys available 
for one of them (can't run on AMD and Intel at the same time :).

So I'm inclined to suggest that the one-value-per-file format is the ideal 
way to go unless there are objections to it.
