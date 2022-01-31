From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] lib/vsprintf: Avoid redundant work with 0 size
Date: Mon, 31 Jan 2022 12:34:43 +0200
Message-ID: <Yfe7Q5cx+MoaOev/@smile.fi.intel.com>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-2-longman@redhat.com>
 <d99b3c4b-7b6e-529-6e4b-b91b65c92d81@google.com>
 <Yfe5Bb3U6Uil7Y6g@smile.fi.intel.com>
 <Yfe6SfG4CqzWSaMM@smile.fi.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643625352; x=1675161352;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YWtKq8OcN++bgZXQOD7vrGgwPikzV7AzgE9vpzi2/ms=;
  b=aGJGWLkuz93qzF0+O4SpjoeqDtCRqmNGt2OylFOJ5Jg2mFBt66wpXvp1
   uR+Q+YKK614Pm+W27Y4rnJn2tvX/lVRWt3KxTyUC6dfvhVcCeTdGWsId5
   u3b102124K1ij9JBNMpffk/KZJhDAA+bTRmYdxiuxBi6h93hpsajE0al5
   yZLc9/AWZ4vI5yAJblynCfDPQKpMb0GxgYFAnGBbij2GMEpbRrSq9NrEg
   WVS198gDDp1qe+1A5PEAXG9RwP4IRzFCnaU6y5kLhYq9hhRzrq6hBbJ31
   aJHWDPEQBWhu1WwfaLqXvy6rvOXCvsv/XgDz9OOR3NgI+vOsUKQDCH/oP
   Q==;
Content-Disposition: inline
In-Reply-To: <Yfe6SfG4CqzWSaMM-XvqNBM/wLWRrdx17CPfAsdBPR1lH4CV8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rafael Aquini <aquini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Jan 31, 2022 at 12:30:33PM +0200, Andy Shevchenko wrote:
> On Mon, Jan 31, 2022 at 12:25:09PM +0200, Andy Shevchenko wrote:
> > On Sun, Jan 30, 2022 at 12:49:37PM -0800, David Rientjes wrote:
> > > On Sat, 29 Jan 2022, Waiman Long wrote:
> > > 
> > > > For *scnprintf(), vsnprintf() is always called even if the input size is
> > > > 0. That is a waste of time, so just return 0 in this case.
> > 
> > Why do you think it's not legit?
> 
> I have to elaborate.
> 
> For *nprintf() the size=0 is quite useful to have.
> For *cnprintf() the size=0 makes less sense, but, if we read `man snprintf()`:
> 
>   The  functions  snprintf() and vsnprintf() do not write more than size bytes
>   (including the terminating null byte ('\0')). If the output was truncated due
>   to this limit, then the return value is the  number of  characters (excluding
>   the terminating null byte) which would have been written to the final string
>   if enough space had been available. Thus, a return value of size or more
>   means  that  the  output  was truncated.  (See also below under NOTES.)
> 
>   If an output error is encountered, a negative value is returned.
> 
> Note the last sentence there. You need to answer to it in the commit message
> why your change is okay and it will show that you thought through all possible
> scenarios.

Also it seems currently the kernel documentation is not aligned with the code

  "If @size is == 0 the function returns 0."

It should mention the (theoretical?) possibility of getting negative value,
if vsnprintf() returns negative value.

-- 
With Best Regards,
Andy Shevchenko


