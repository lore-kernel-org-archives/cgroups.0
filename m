From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/1] mmzone: code cleanup for LRU stats.
Date: Mon, 18 Jan 2016 17:14:27 -0500
Message-ID: <20160118221427.GA8657@cmpxchg.org>
References: <1453101492-37125-1-git-send-email-maninder1.s@samsung.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453101492-37125-1-git-send-email-maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, baiyaowei-0p4V/sDNsUmm0O/7XYngnFaTQe2KTcn/@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ajeet.y-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, pankaj.m-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Vaneet Narang <v.narang-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

On Mon, Jan 18, 2016 at 12:48:12PM +0530, Maninder Singh wrote:
> Replacing hardcoded values with enum lru_stats for LRU stats.
> 
> Signed-off-by: Maninder Singh <maninder1.s-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Vaneet Narang <v.narang-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

I don't think the code is hard to understand, it always says 'anon' or
'file' or similar for every context where it's important to understand
what the magic array index means.

And this patch makes the lines too long and unwieldy.
