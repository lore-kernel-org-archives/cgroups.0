From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: cleanup the format of /proc/cgroups
Date: Mon, 22 Aug 2022 15:52:51 +0800
Message-ID: <YwM108KQCiD7Lp3n@feng-clx>
References: <20220821073446.92669-1-feng.tang@intel.com>
 <YwMwlMv/tK3sRXbB@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661154812; x=1692690812;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/cLs6QSxHIHeFFORrNEC0WPTviPNmoicENWCSKdqZ/A=;
  b=XYk0W5Ot+dORDE0aArxKlk39/8L9sl4Q9hZXWFModNbLFX14olycni9X
   T6Wpr6KqyfQfnkbs+YEdZkencoCkHthJI5iEea6DVUromRA0nX5oKQvXQ
   DDoFjB+sXWzCnO3uJFVWIQedXoof35TOG1ENO0qkGGt/6HxRuDU+bsfBQ
   mlZM7/4NSWW9j4gdr/ljH93RtCgdhyYx8QpusaNZbn+x1qDz1Svofwhz0
   3MJffB3hnsecs3ErPXZIc7Sj1og6dtVCuz3OhKF53aKbzVENJpdHoHlPz
   3Omh3wAvwusyAKdHV1jHXOaEtEMI7zs33mF8uV6ZIzjTUiIixuvHW3GAN
   A==;
Content-Disposition: inline
In-Reply-To: <YwMwlMv/tK3sRXbB-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Aug 21, 2022 at 09:30:28PM -1000, Tejun Heo wrote:
> Hello,
> 
> On Sun, Aug 21, 2022 at 03:34:46PM +0800, Feng Tang wrote:
> > Currrent /proc/cgroup output is like:
> > 
> >   #subsys_name	hierarchy	num_cgroups	enabled
> >   cpuset	6	1	1
> >   cpu	4	7	1
> >   cpuacct	4	7	1
> >   blkio	8	7	1
> >   memory	9	7	1
> >   ...
> > 
> > Add some indentation to make it more readable without any functional
> > change:
> 
> So, this has been suggested a couple times before and I fully agree that the
> file is really ugly. In the past, we didn't pull the trigger on it for two
> reasons - 1. It is user-visible functional change in that it can break
> really dumb parsers 2. the file is only useful for cgroup1 which has been in
> mostly maintenance mode for many years now. I don't feel that strongly
> either way but still kinda lean towards just leaving it as-is.
 
Ok, makes sense to me. Thanks for the explaination!

Thanks,
Feng


> Thanks.
> 
> -- 
> tejun
