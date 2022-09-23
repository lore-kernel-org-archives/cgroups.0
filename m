From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 00/20] Add Cgroup support for SGX EPC memory
Date: Fri, 23 Sep 2022 15:24:07 +0300
Message-ID: <Yy2lZx6u1dhFO34i@kernel.org>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663935852;
        bh=NM85qGkf1dVSLgcWZ9WS9hx6Yj3D92+rESK6H5VWGoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fuaO3gNn+VXn3Yxl+8JP0QCWQcdXn7r1h4B7zsIOiDer1BG7984BmGJSQPsTNW//R
         GtLPE9JShxRKCh/76id4IH1oGvbzS29V6Li1mS1kMqQRWnca/YdeTsoIWTGyHKu+AN
         GiRN/KA6ODjUVnLVP4TpFY5oG8GXYbEglfAR9Z9GmhYTXRZsn/3ntZSNXGKJorA2Pc
         gvnOG1u2zFwFltY670KLvDLgtP00wo2FMXCkFcQLWlGKhSht3jqDtYcT22ZV+nKbVX
         Ca23UEV0RhF78QZFWlJ3TjvSyDpg6drYseCHe6veVdWDFILxEHRbEqKb3GTDLwpDGH
         F+XHrJxuitqmg==
Content-Disposition: inline
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Sep 22, 2022 at 10:10:37AM -0700, Kristen Carlson Accardi wrote:
> Add a new cgroup controller to regulate the distribution of SGX EPC memory,
> which is a subset of system RAM that is used to provide SGX-enabled
> applications with protected memory, and is otherwise inaccessible.
> 
> SGX EPC memory allocations are separate from normal RAM allocations,
> and is managed solely by the SGX subsystem. The existing cgroup memory
> controller cannot be used to limit or account for SGX EPC memory.
> 
> This patchset implements the sgx_epc cgroup controller, which will provide
> support for stats, events, and the following interface files:
> 
> sgx_epc.current
> 	A read-only value which represents the total amount of EPC
> 	memory currently being used on by the cgroup and its descendents.
> 
> sgx_epc.low
> 	A read-write value which is used to set best-effort protection
> 	of EPC usage. If the EPC usage of a cgroup drops below this value,
> 	then the cgroup's EPC memory will not be reclaimed if possible.
> 
> sgx_epc.high
> 	A read-write value which is used to set a best-effort limit
> 	on the amount of EPC usage a cgroup has. If a cgroup's usage
> 	goes past the high value, the EPC memory of that cgroup will
> 	get reclaimed back under the high limit.
> 
> sgx_epc.max
> 	A read-write value which is used to set a hard limit for
> 	cgroup EPC usage. If a cgroup's EPC usage reaches this limit,
> 	allocations are blocked until EPC memory can be reclaimed from
> 	the cgroup.

It would be worth of mentioning for clarity that shmem is accounted from
memcg.

BR, Jarkko
