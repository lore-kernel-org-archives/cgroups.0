From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH memcg v3] net: set proper memcg for net_init hooks
 allocations
Date: Tue, 26 Apr 2022 08:58:07 +0300
Message-ID: <a153e5da-b22a-2ea5-f0ef-a46337711400@openvz.org>
References: <20220424144627.GB13403@xsang-OptiPlex-9020>
 <c2f0139a-62e2-5985-34e9-d42faac81960@openvz.org> <YmdeCqi6wmgiSiWh@carbon>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZBYAGN8Bb7OvFzAe7F9Y2LfgGtxk1nTfvTdOaaOXGBo=;
        b=Jq6JdD8VzFEq18+o276NScliYwVuNJf4Rn3tazrd5OBUECXdtwysjbVzisP42H7Zfg
         AzLF13iBPuGB4G8laKbcZXc+vG2Nd6M+Fk6lwgFd3A2z8Y97UPbC0O5FCrHPpHCQfkNj
         LsXD2YsfDHX3vGdtEbPWrIaeng7NCC/JLJLjHxphWsPsxrCBycx7sWesbCjiyTLJkQcU
         FFpPWUdRKmtffIo1OD6Dfll3JGIziSw1stDsXiz0KhtuGy3kd9vpS4CwqwZguWcs3uEG
         CaYqiqwcLSyiA8L314rfaauhH780shmI3tTGilQpxB+MADc1Eq9p/n3OpAQrudz4xvnl
         +1Kg==
Content-Language: en-US
In-Reply-To: <YmdeCqi6wmgiSiWh@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 4/26/22 05:50, Roman Gushchin wrote:
> On Mon, Apr 25, 2022 at 01:56:02PM +0300, Vasily Averin wrote:
>> +
>> +static inline struct mem_cgroup *get_net_memcg(void *p)
>> +{
>> +	struct mem_cgroup *memcg;
>> +
>> +	memcg = get_mem_cgroup_from_kmem(p);
>> +
>> +	if (!memcg)
>> +		memcg = root_mem_cgroup;
>> +
>> +	return memcg;
>> +}
> 
> I'm not a fan of this helper: it has nothing to do with the networking,
> actually it's a wrapper of get_mem_cgroup_from_kmem() replacing NULL
> with root_mem_cgroup.
> 
> Overall the handling of root_mem_cgroup is very messy, I don't blame
> this patch. But I wonder if it's better to simple move this code
> to the call site without introducing a new function?

Unfortunately root_mem_cgroup is defined under CONFIG_MEMCG,
so we cannot use it outside without ifdefs.

> Alternatively, you can introduce something like:
> struct mem_cgroup *mem_cgroup_or_root(struct mem_cgroup *memcg)
> {
> 	return memcg ? memcg : root_mem_cgroup;
> }

Thank you for the hint, this looks much better.
	Vasily Averin
