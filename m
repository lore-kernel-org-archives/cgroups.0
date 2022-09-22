From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 00/20] Add Cgroup support for SGX EPC memory
Date: Thu, 22 Sep 2022 14:03:52 -0700
Message-ID: <7ff6d114-a6cc-e3c5-5edb-8ac0e527d8a9@intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <YyyeSVSk/lWdo/W4@slm.duckdns.org>
 <4b8605533e5deade739249bfb341ab9c06d56a1e.camel@linux.intel.com>
 <YyyykUJQtYbPVctn@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663880637; x=1695416637;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5J/gUw0ozggdiEjT67Hv+Q1CO877q7WnX+QC9z+OreE=;
  b=cGQ3FhvmCEU1br1E/02+iXJWgWqgjpHiM7usoLkViCJf2toyn5wGQ0lM
   cB9bf8ZoQ3RbJYV1V4uTEpxLaL3kpdnGs75jXqD7J4sLS0Fb3RbYcluu4
   eUShQ4xROSserw5YPRhlCH04kULGlB1z81+3p9dzsFomQCYGs8eCn9Py+
   bS/ehEOKPfGP+h5MX8wXsAC+kccGePgmXeU9Hs+ySTR4Zys3J86fR8Cuc
   9qFmqDtGEwZU/3ylxF/bm6QjM8ZroTdK1n6C4GkUByo+dl6eZIZIhOuvE
   Yr15QatCUwEz7NBDpxOdEcTlqxRpIgtnRxUpBv0Ef39lulSw0wLBrQlT4
   A==;
Content-Language: en-US
In-Reply-To: <YyyykUJQtYbPVctn-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On 9/22/22 12:08, Tejun Heo wrote:
> Can you please give more concrete examples? I'd love to hear how the SGX EPC
> memory is typically used in what amounts and what's the performance
> implications when they get reclaimed and so on. ie. Please describe a
> realistic usage scenario of contention with sufficient details on how the
> system is set up, what the applications are using the SGX EPC memory for and
> how much, how the contention on memory affects the users and so on.

One wrinkle is that the apps that use SGX EPC memory are *normal* apps.
 There are frameworks that some folks are very excited about that allow
you to run mostly unmodified app stacks inside SGX.  For example:

	https://github.com/gramineproject/graphene

In fact, Gramine users are the troublesome ones for overcommit.  Most
explicitly-written SGX applications are quite austere in their SGX
memory use; they're probably never going to see overcommit.  These
Gramine-wrapped apps are (relative) pigs.  They've been the ones finding
bugs in the existing SGX overcommit code.

So, where does all the SGX memory go?  It's the usual suspects:
memcached and redis. ;)
