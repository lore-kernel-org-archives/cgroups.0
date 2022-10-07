From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 00/20] Add Cgroup support for SGX EPC memory
Date: Fri, 07 Oct 2022 09:39:40 -0700
Message-ID: <0f42e11434b264e555559cab626c1828a9eae09f.camel@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
         <YyyeSVSk/lWdo/W4@slm.duckdns.org>
         <4b8605533e5deade739249bfb341ab9c06d56a1e.camel@linux.intel.com>
         <YyyykUJQtYbPVctn@slm.duckdns.org>
         <7ff6d114-a6cc-e3c5-5edb-8ac0e527d8a9@intel.com>
         <Yy5KwnRTbFjmKE9X@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665160801; x=1696696801;
  h=message-id:subject:from:to:cc:in-reply-to:references:
   content-transfer-encoding:mime-version:date;
  bh=9Nj9pblwvx5r7sXSpQ1XOTFiHv2HjukhpuHauwYQ3cI=;
  b=KDNtvTXtg4kosGKpubx3/KNE6IlK8oIdAGxIR+igo9iHXm7u+AxG25wN
   3rK3YCmtozvNHkWP/eOmbZeTAYndh8ZSQxjHog4i+tgMEsfy+4Lwjcp+n
   mOZW7AvTt1qva1YC6nkPpe4gUYi6Hhzb4eUwl/+fqBxStPUPpZcuwFVct
   +QaS6tjQixZ0fUAq6g6I36URSWLa2LAAtKbhE7hCWsifO/zE1gcfdLEcz
   oU9FsppMCTd70mjYZpJ1A1sabQvupvR3pivsqu00YxgA8qJRbatLgjaRk
   V7LEme1AfLPaQqPf6JNKtTATKdDL7NposjlKYyYy4SmdWSCye0gnV0hEJ
   A==;
In-Reply-To: <Yy5KwnRTbFjmKE9X-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Fri, 2022-09-23 at 14:09 -1000, Tejun Heo wrote:
<snip>

>=20
> Given that, how about this? We can easily add the functionality of
> .max
> through the misc controller. Add a new key there, trycharge when
> allocating
> new memory, if fails, try reclaim and then fail allocation if reclaim
> fails
> hard enough. I belive that should give at least a reasonable place to
> start
> especially given that memcg only had limits with similar semantics
> for quite
> a while at the beginning.
>=20

Hi Tejun,
I'm playing with the misc controller to see if I can make it do what I
need to do, and I had a question for you. Is there a way to easily get
notified when there are writes to the "max" file? For example, in my
full controller implementation, if a max value is written, the current
epc usage for that cgroup is immediately examined. If that usage is
over the new value of max, then the reclaimer will reclaim from that
particular cgroup to get it under the max. If it is not possible to
reclaim enough to get it under the max, enclaves will be killed so that
all the epc pages can be released and then get under the max value.
With the misc controller, i haven't been able to find a way to easily
react to a change in the max value. Am I missing something?

Thanks,
Kristen

