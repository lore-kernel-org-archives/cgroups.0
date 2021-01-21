From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Thu, 21 Jan 2021 10:55:13 -0500
Message-ID: <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
References: <20210108012846.4134815-1-vipinsh@google.com>
 <20210108012846.4134815-2-vipinsh@google.com>
 <YAICLR8PBXxAcOMz@mtj.duckdns.org>
 <YAIUwGUPDmYfUm/a@google.com>
 <YAJg5MB/Qn5dRqmu@mtj.duckdns.org>
 <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RgFdesqiZMPXxw2+lHkC+nOIxN2Hdy7A8pPSFD9aimI=;
        b=vNyp82p47jqoLdij4TrB0pGsaHQMJ9ZtfFxJ3k/gjlPax2v0NfLp+MONyCPUjLEDR/
         o8W7yrQU1d2o+rmTbByYaJrI/Gy8Et+KryvlEKvcjQIXeyZkBaufFhQW5LmnQhssI7aJ
         /17MlJnHVYhq9JZUG8p83rGj4gC0Lx3T9zF0l7vm73Az1z8Rw9kbsB7O5nehtIZ8ywCr
         l1EDbfGpQMaVGAlbZb39lFnaj3JKXxQf8zvITV7EFxPFOo1D0gbTbF1EER+qpHjLGh1n
         5knJr4nJ6JQA1pDUbogmPleaktdT4HIREjqfogvE5YqYMUwLyxi0MO8ffxMxzJt92OG7
         p0FQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <be699d89-1bd8-25ae-fc6f-1e356b768c75-5C7GfCeVMHo@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Jan 21, 2021 at 08:55:07AM -0600, Tom Lendacky wrote:
> The hardware will allow any SEV capable ASID to be run as SEV-ES, however,
> the SEV firmware will not allow the activation of an SEV-ES VM to be
> assigned to an ASID greater than or equal to the SEV minimum ASID value. The
> reason for the latter is to prevent an !SEV-ES ASID starting out as an
> SEV-ES guest and then disabling the SEV-ES VMCB bit that is used by VMRUN.
> This would result in the downgrading of the security of the VM without the
> VM realizing it.
> 
> As a result, you have a range of ASIDs that can only run SEV-ES VMs and a
> range of ASIDs that can only run SEV VMs.

I see. That makes sense. What's the downside of SEV-ES compared to SEV w/o
ES? Are there noticeable performance / feature penalties or is the split
mostly for backward compatibility?

Thanks.

-- 
tejun
