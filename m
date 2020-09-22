From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC Patch 1/2] KVM: SVM: Create SEV cgroup controller.
Date: Mon, 21 Sep 2020 18:04:04 -0700
Message-ID: <94c3407d-07ca-8eaf-4073-4a5e2a3fb7b8@infradead.org>
References: <20200922004024.3699923-1-vipinsh@google.com>
 <20200922004024.3699923-2-vipinsh@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=m8E8Vf5qksBX37a4kASi4E/iaS+WWUnkAWa42nHAhjg=; b=qiS7ovRSDJLAlLlHxV8YScSA/D
        ADYpxv41falafRgnGRUfs95YRpjVnTMh/me+7fWgiWuwphbH+xkqtQATwDX+1AsL130ahDXvu1aTG
        QBZvocvQjkSgnt78eqsOiHoP6SyNIs5ckBxnzEsIPBuvIiLDOFan4mIFq3VH0rUSGRBR/W8ZAsmlE
        XgFb4CMnINWDpFB1CagNZ+fqhivG8Bdwwyf6ttEKg5z1+98W37Se7NAYxxo93bw21hrxn9ny43Bmw
        dhMtbytyrQuWEec9D2pvXQTRNcM5WaLpBQB6O3kpKWgdOPq9XzKTd4ztQJ/stzoa4eekv5tAl3t3+
        AxamSgRw==;
In-Reply-To: <20200922004024.3699923-2-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dionna Glaze <dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Erdem Aktas <erdemaktas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hi,

On 9/21/20 5:40 PM, Vipin Sharma wrote:
> diff --git a/init/Kconfig b/init/Kconfig
> index d6a0b31b13dc..1a57c362b803 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1101,6 +1101,20 @@ config CGROUP_BPF
>  	  BPF_CGROUP_INET_INGRESS will be executed on the ingress path of
>  	  inet sockets.
>  
> +config CGROUP_SEV
> +	bool "SEV ASID controller"
> +	depends on KVM_AMD_SEV
> +	default n
> +	help
> +	  Provides a controller for AMD SEV ASIDs. This controller limits and
> +	  shows the total usage of SEV ASIDs used in encrypted VMs on AMD
> +	  processors. Whenever a new encrypted VM is created using SEV on an
> +	  AMD processor, this controller will check the current limit in the
> +	  cgroup to which the task belongs and will deny the SEV ASID if the
> +	  cgroup has already reached its limit.
> +
> +	  Say N if unsure.

Something here (either in the bool prompt string or the help text) should
let a reader know w.t.h. SEV means.

Without having to look in other places...

thanks.
-- 
~Randy

