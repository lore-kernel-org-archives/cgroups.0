From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Date: Wed, 27 Jan 2021 09:10:53 -0500
Message-ID: <YBF0bb7gGkF01VCR@slm.duckdns.org>
References: <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
 <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
 <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com>
 <YAopkDN85GtWAj3a@google.com>
 <1744f6c-551b-8de8-263e-5dac291b7ef@google.com>
 <YBCRIPcJyB2J85XS@slm.duckdns.org>
 <YBC937MFGEEiI63o@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qR1ztsc0XnYzxWr2oOHJz7bbHSJoFk9Vyu/8scCawyE=;
        b=jJY9ENK+bqbfjVnSzWlZYt78e2AyQ93qnHJUAsPedn8NjOaifnpgzSqbPEFAAgDegm
         aVwn49VJjAb+XAg8nPBuvsacqBPpwmWLPQfOzCfdZ9aquybZ6GfsPMJpYK736rTeGfle
         EVSwSoDjQRYEB1CfMDDkQvZaF0iCMrL9aitm0aRi3JhYBbhSWVbLC+kXlkcubgpv8WrQ
         3ZnOYzC599R5uzlNpyf73COKLQ1ER6apTI9LmMlS9m+boODRHewKIXTiOZtoc7Z7OESH
         elr9ZJh3/xbXKiSoiZYURJzOR/zeq9jANT3nATxDJNm+8Q5EOCtS7lldhhmQT1uQuKW7
         SsbQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YBC937MFGEEiI63o-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, "Singh, Brijesh" <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, "Grimm, Jon" <jon.grimm-5C7GfCeVMHo@public.gmane.org>, "Van Tassell, Eric" <eric.vantassell-5C7GfCeVMHo@public.gmane.org>, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Jan 26, 2021 at 05:11:59PM -0800, Vipin Sharma wrote:
> Sounds good, we can have a single top level stat file
> 
> misc.stat
>   Shows how many are supported on the host:
>   $ cat misc.stat
>   sev 500
>   sev_es 10
> 
> If total value of some resource is 0 then it will be considered inactive and
> won't show in misc.{stat, current, max}
> 
> We discussed earlier, instead of having "stat" file we should show
> "current" and "capacity" files in the root but I think we can just have stat
> at top showing total resources to keep it consistent with other cgroup
> files.

Let's do misc.capacity and show only the entries which have their resources
initialized.

Thanks.

-- 
tejun
