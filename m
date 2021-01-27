From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Tue, 26 Jan 2021 17:11:59 -0800
Message-ID: <YBC937MFGEEiI63o@google.com>
References: <YAJsUyH2zspZxF2S@google.com>
 <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
 <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
 <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com>
 <YAopkDN85GtWAj3a@google.com>
 <1744f6c-551b-8de8-263e-5dac291b7ef@google.com>
 <YBCRIPcJyB2J85XS@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h4YmZOf34leeTQFI3eVZ6RKnokT375TaRDpu5h/uKr0=;
        b=C22G2NnLTkRdn/mttyEGOMoXxuTI2raLaGT4eCAOpNLzguJMhhMmlz0hxMQ5gA2Rj9
         qTOfsm8D9kYABK9iahC0LW6TJZGFYlNTBRFUajK7C0nvPhjSPfRyPxrSld7uQxz5yEPk
         8gOyD6zIHU7KjQD4jKwUI3I0eCeE4pQBotxDMRCpTJ3onB6SaWW6YcvXP1A3os4mkSh+
         ZWrMmw2P91GRl1Zfse3yYl0EuS7KKt7X4SpR8JphUOejt6zAT3zvjROsAJ8vux6lw3Tb
         YXzV6lDO0Zfg+oWDaGv5DDtrpWLiCpE/+MzqEQ1j9jOyYE+FHvZUTvAXPton0sk+fASu
         ZqXw==
Content-Disposition: inline
In-Reply-To: <YBCRIPcJyB2J85XS-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, "Singh, Brijesh" <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, "Grimm, Jon" <jon.grimm-5C7GfCeVMHo@public.gmane.org>, "Van Tassell, Eric" <eric.vantassell-5C7GfCeVMHo@public.gmane.org>, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 26, 2021 at 05:01:04PM -0500, Tejun Heo wrote:
> The whole thing seems pretty immature to me and I agree with you that coming
> up with an abstraction at this stage feels risky.
> 
> I'm leaning towards creating a misc controller to shove these things into:
> 
> * misc.max and misc.current: nested keyed files listing max and current
>   usage for the cgroup.
> 
> * Have an API to activate or update a given resource with total resource
>   count. I'd much prefer the resource list to be in the controller itself
>   rather than being through some dynamic API just so that there is some
>   review in what keys get added.
> 
> * Top level cgroup lists which resource is active and how many are
>   available.

Sounds good, we can have a single top level stat file

misc.stat
  Shows how many are supported on the host:
  $ cat misc.stat
  sev 500
  sev_es 10

If total value of some resource is 0 then it will be considered inactive and
won't show in misc.{stat, current, max}

We discussed earlier, instead of having "stat" file we should show
"current" and "capacity" files in the root but I think we can just have stat
at top showing total resources to keep it consistent with other cgroup
files.

Thanks
Vipin

