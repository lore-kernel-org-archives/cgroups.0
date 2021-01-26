From: Tejun Heo <tj@kernel.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Tue, 26 Jan 2021 17:01:04 -0500
Message-ID: <YBCRIPcJyB2J85XS@slm.duckdns.org>
References: <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
 <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
 <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com>
 <YAopkDN85GtWAj3a@google.com>
 <1744f6c-551b-8de8-263e-5dac291b7ef@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MIH2UNLi2fhCMoMNiRx154+VpM0NIRieyzpHxs5Dshw=;
        b=DEjU2Vlz+c8s8l7i4VvNrOHrZX1BFA/CoCHLraoX/TGR7m7IOU/Tk+tMXGz2Ie8kVj
         NRrXxn6RiYvZpVsXxyW2ANxFvOjsPw4fYgILW+Q5wT0h4ekogKQAo1eKS1P77lgKI3nI
         1mkQ+1lcbvQhLF8LTabfIIo+NAgLtSI25NYjLc4f8IcvqpFBJSRSI43sJ5oVpm02n96D
         QVU/+8yE+q/cn9U/oK+XTtYMJXq+KdR1HO8fMUu0+7yHtjfPTvUZedtrUjvG7fCSneZs
         e9r9Ve3hIZgRPOpS/7mGJOTQ3Etujv//AbXyOlHj1gMJpEg1TnivcCjUgu+u+sloivxz
         wPuA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <1744f6c-551b-8de8-263e-5dac291b7ef@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Tom Lendacky <thomas.lendacky@amd.com>, Vipin Sharma <vipinsh@google.com>, "Singh, Brijesh" <brijesh.singh@amd.com>, "Grimm, Jon" <jon.grimm@amd.com>, "Van Tassell, Eric" <eric.vantassell@amd.com>, pbonzini@redhat.com, lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 26, 2021 at 12:49:14PM -0800, David Rientjes wrote:
> > SEV-SNP, another incremental enhancement (on SEV-ES), further strengthens the
> > argument for SEV and SEV-* coexistenence.  SEV-SNP and SEV-ES will share the
> > same ASID range, so the question is really, "do we expect to run SEV guests and
> > any flavor of SEV-* guests on the same platform".  And due to SEV-* not being
> > directly backward compatible with SEV, the answer will eventually be "yes", as
> > we'll want to keep running existing SEV guest while also spinning up new SEV-*
> > guests.
> > 
> 
> Agreed, cloud providers will most certainly want to run both SEV and SEV-* 
> guests on the same platform.

Am I correct in thinking that the reason why these IDs are limited is
because they need to be embedded into the page table entries? If so, we
aren't talking about that many IDs and having to divide the already small
pool into disjoint purposes doesn't seem like a particularly smart use of
those bits. It is what it is, I guess.

> I'm slightly concerned about extensibility if there is to be an 
> incremental enhancement atop SEV-* or TDX with yet another pool of 
> encryption ids.  (For example, when we only had hugepages, this name was 
> perfect; then we got 1GB pages which became "gigantic pages", so are 512GB 
> pages "enormous"? :)  I could argue (encryption_ids.basic.*,
> encryption_ids.enhanced.*) should map to 
> (encryption_ids.legacy.*, encryption_ids.*) but that's likely 
> bikeshedding.
> 
> Thomas: does encryption_ids.{basic,enhanced}.* make sense for ASID 
> partitioning?
> 
> Tejun: if this makes sense for legacy SEV and SEV-* per Thomas, and this 
> is now abstracted to be technology (vendor) neutral, does this make sense 
> to you?

The whole thing seems pretty immature to me and I agree with you that coming
up with an abstraction at this stage feels risky.

I'm leaning towards creating a misc controller to shove these things into:

* misc.max and misc.current: nested keyed files listing max and current
  usage for the cgroup.

* Have an API to activate or update a given resource with total resource
  count. I'd much prefer the resource list to be in the controller itself
  rather than being through some dynamic API just so that there is some
  review in what keys get added.

* Top level cgroup lists which resource is active and how many are
  available.

So, behavior-wise, not that different from the proposed code. Just made
generic into a misc controller. Would that work?

Thanks.

-- 
tejun
