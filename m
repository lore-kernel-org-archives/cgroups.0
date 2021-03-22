From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Date: Mon, 22 Mar 2021 11:54:39 -0700
Message-ID: <YFjn7wv/iMO4Isgz@google.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <20210304231946.2766648-2-vipinsh@google.com>
 <20210319142801.7dcce403@jacob-builder>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C6WJKx3BOi9nQkez3SccHyBDAf1k0LVTRQZfDBrkHyI=;
        b=lROe8A3BfIgu0wSAyymzCG+OaZGPSPRf5WXAPgf1RNZNuQsv1wIBTvrqjTNJ6QyEit
         1/eYhLK8nbGq6zxinywzSNB3h8wFI2C3jZ7B5EiXgEJFO73NIkC4GGEx1dqJAOkESryI
         +SRQJXSay1vDinJGHbEAUUAJsLZaj883q4Brd8XZUDiXZy32QWHo01+AZg4iVEGmpc4B
         24ABF0G6KnhskHx9KcXUiVMV1gidde0sEpcHr+O561YGKG5BPu4P3VV0HKS+kdZmlSoa
         +LEpvlocNgqW7VLmLaJ1KJEa/Juv8Ply6k8SRx9p9WL3+98g1fPb60V+TYi+sIAPdA0G
         QOew==
Content-Disposition: inline
In-Reply-To: <20210319142801.7dcce403@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan@intel.com>
Cc: tj@kernel.org, mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>

On Fri, Mar 19, 2021 at 02:28:01PM -0700, Jacob Pan wrote:
> On Thu,  4 Mar 2021 15:19:45 -0800, Vipin Sharma <vipinsh@google.com> wrote:
> > +#ifndef _MISC_CGROUP_H_
> > +#define _MISC_CGROUP_H_
> > +
> nit: should you do #include <linux/cgroup.h>?
> Otherwise, css may be undefined.

User of this controller will use get_curernt_misc_cg() API which returns
a pointer. Ideally the user should use this pointer and they shouldn't have
any need to access "css" in their code. They also don't need to create a
object of 'struct misc_cg{}', because that won't be correct misc cgroup
object. They should just declare a pointer like we are doing here in
'struct kvm_sev_info {}'.

If they do need to use "css" then they can include cgroup header in their
code.

Let me know if I am overlooking something here.

Thanks
Vipin Sharma
