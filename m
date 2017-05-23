From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Race between cgroup core and the cpuset controller
Date: Tue, 23 May 2017 17:32:01 -0400
Message-ID: <b7cb070c-c6df-9bf7-fd88-a1b07da28dd0@oracle.com>
References: <327ca1f5-7957-fbb9-9e5f-9ba149d40ba2@oracle.com>
 <20170523200645.GG13222@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523200645.GG13222-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi Tejun,

On 05/23/2017 04:06 PM, Tejun Heo wrote:
> Can you please see whether the following patch fixes the issue?
> Thanks.
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index f6501f4f6040..9e29dba49d6c 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -176,9 +176,10 @@ typedef enum {
>   } cpuset_flagbits_t;
>   
>   /* convenient tests for these bits */
> -static inline bool is_cpuset_online(const struct cpuset *cs)
> +static inline bool is_cpuset_online(struct cpuset *cs)
>   {
> -	return test_bit(CS_ONLINE, &cs->flags);
> +	return test_bit(CS_ONLINE, &cs->flags) &&
> +		!percpu_ref_is_dying(&cs->css.refcnt);
>   }
>   
>   static inline int is_cpu_exclusive(const struct cpuset *cs)

That does the trick, thanks.

Please let me know if there's anything else I can do to help.

Daniel
