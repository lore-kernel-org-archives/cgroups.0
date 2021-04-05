From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v4 0/3] cgroup: New misc cgroup controller
Date: Sun, 4 Apr 2021 17:29:59 -0700
Message-ID: <CAHVum0fhWSOFRS-t7cF=zCRf_SUoMN5UOYBChWSpmhJVcuMbsg@mail.gmail.com>
References: <20210330044206.2864329-1-vipinsh@google.com> <YGn42SKCPg2HWtQc@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4djxblumYsM0MYjaTI3gAeclQoo4tMzFZGJUydviNoY=;
        b=k9XPOH16pkp6wIhN6fUXTfgtf00C1nX1vfWzkAoJCwZhTPryGhPETEbWtKNuql8dcT
         J66HvvN+nGIGX/hWkB2rtYjC7ogWFD4Rd4IZkQ0bS/rYf5HmIGTyE/ZylI39cDqXlZLQ
         DrwfgJgtrdAYa4RnReHlFBjkf09I61p5QCpFtdcJBiTqN5do0FBlf/GNBAM4Sa4K9fTt
         O0Sc6EJP96oqfCYeJaor+ktU4xDDekqEt6oEKns8rGYAeQWl4AQoPK1E7sIISi8w1r2q
         CU1BS4YW9udqw0T/oEayc0e8nZsTv0pujP4QcRjuay7oCDxyx5293bIck4CW+rAYTTaJ
         a32w==
In-Reply-To: <YGn42SKCPg2HWtQc@mtj.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Jacob Pan <jacob.jun.pan@intel.com>, Randy Dunlap <rdunlap@infradead.org>, Tom Lendacky <thomas.lendacky@amd.com>, Brijesh <brijesh.singh@amd.com>, Jon <jon.grimm@amd.com>, Eric <eric.vantassell@amd.com>, pbonzini@redhat.com, hannes@cmpxchg.org, Janosch Frank <frankja@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, corbet@lwn.net, Sean Christopherson <seanjc@google.com>, vkuznets@redhat.com, wanpengli@tencent.com, Jim Mattson <jmattson@google.com>, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, Matt Gingell <gingell@google.com>, David Rientjes <rientjes@google.com>, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.

On Sun, Apr 4, 2021 at 10:35 AM Tejun Heo <tj@kernel.org> wrote:
>
> Applied to cgroup/for-5.13. If there are further issues, let's address them
> incrementally.
>
> Thanks.
>
> --
> tejun

Thanks Tejun for accepting and guiding through each version of this
patch series.
