From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv11 3/3] rdmacg: Added documentation for rdmacg
Date: Wed, 24 Aug 2016 17:18:24 -0400
Message-ID: <20160824211824.GW8185@htj.duckdns.org>
References: <1471869231-15576-1-git-send-email-pandit.parav@gmail.com>
 <1471869231-15576-4-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z+XGvDXiwOvyTGQDECOEcF8j2sH0VPvNBJJbegvr7MU=;
        b=GRFPGvcny8y1hVedyQ5aI4AUsvuRRQ1s6P9PwK1t7b1jR6d9ourJOrCz/kxVvUWuat
         8gNymNdP5deuSNKcSIwin+G3SBzK7WGKwtfMae1m/z1vp2gBDgEPR9thhzf9EQpjrg0l
         nB9XLBQdmyp5dIH39/q6HR0PlKHZnocSVrcEriD2h/WdYBnUxU7NS5u0duBnXoe35dP2
         pLIL+qEJpnCIJdWZVTwnEEoSJkdKdpYjbROv14ISkXgCXWAjN16nKm/B1LanxbNN1cOV
         PA2uRu14hkDTvG0ALlcHsvdocASGQZDqvkKQ8SgccRekEAsBgbxvzsDD6696PRD4quNv
         Ts3A==
Content-Disposition: inline
In-Reply-To: <1471869231-15576-4-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 22, 2016 at 06:03:51PM +0530, Parav Pandit wrote:
> +  rdma.max
> +	A readwrite file that exists for all the cgroups except root that

Can you please add that it's a nested-keyed file?

...
> +  rdma.current
> +	A read-only file that describes current resource usage.

Ditto.

Thanks.

-- 
tejun
