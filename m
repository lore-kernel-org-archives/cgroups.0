From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 00/20] Add Cgroup support for SGX EPC memory
Date: Fri, 07 Oct 2022 09:46:57 -0700
Message-ID: <228456112a91fb78a91fe217cd8e60ca2496aa6a.camel@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
         <YyyeSVSk/lWdo/W4@slm.duckdns.org>
         <4b8605533e5deade739249bfb341ab9c06d56a1e.camel@linux.intel.com>
         <YyyykUJQtYbPVctn@slm.duckdns.org>
         <7ff6d114-a6cc-e3c5-5edb-8ac0e527d8a9@intel.com>
         <Yy5KwnRTbFjmKE9X@slm.duckdns.org>
         <0f42e11434b264e555559cab626c1828a9eae09f.camel@linux.intel.com>
         <Y0BW/GkfXG99+41O@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665161220; x=1696697220;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Hz4ZOFub5d7WZ52Ly6J+98gkWjEVO9LcXzV3oygGfnc=;
  b=gNbe1Sug3sQ4i17rYJk8myvRRyn/bYA9pKvE3qeGarfj9ylj+xhITv9O
   wG7xtdX3u4Mc6waCNUvCkLU05KwTeA1GRG2styj13c1dgh5o7k0rgZ7W4
   W0ORFzPQXP43uKjjuA0VXQkEFzdLXrm55UIoruHt8KUPCz/SEGGAbXutv
   q54n3QXuFfF4emz2H+VzPAHdzMjSspg8Qwo0XJ35oN5f9Jyxxij71jKP4
   fhsMeDGo8XEHjPq79GDXpGLlloiW+cdvRHxLpqKM2y4p0cHj+2/z+H/D6
   svn5YVj8qq3tqf66Vml2fuRix2PuXVmNJ2bUWgUaHtzgNN3kQJ2C/qurr
   g==;
In-Reply-To: <Y0BW/GkfXG99+41O-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Fri, 2022-10-07 at 06:42 -1000, Tejun Heo wrote:
> Hello, Kristen.
>=20
> On Fri, Oct 07, 2022 at 09:39:40AM -0700, Kristen Carlson Accardi
> wrote:
> ...
> > With the misc controller, i haven't been able to find a way to
> > easily
> > react to a change in the max value. Am I missing something?
>=20
> There isn't currently but it should be possible to add per-key
> notifiers,
> right?
>=20
> Thanks.
>=20

OK - yes, I will include a modification to the misc controller for the
functionality I need in my patchset.

