From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 1/5] cgroups: Refactor children cgroups in memcg tests
Date: Sat, 23 Apr 2022 04:30:37 -0700
Message-ID: <20220423113037.gnfysktiuzmfnpmp@dev0025.ash9.facebook.com>
References: <20220422155728.3055914-1-void@manifault.com>
 <20220422155728.3055914-2-void@manifault.com>
 <YmM0b+3thMZaXVDb@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YmM0b+3thMZaXVDb@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Apr 22, 2022 at 04:04:15PM -0700, Roman Gushchin wrote:
>

Thanks for the reviews on this patchset, Roman. FYI I think Andrew already
merged these patches to the -mm tree. I'll send out a follow-on patch that
fixes everything you pointed out, both here and on the other patches in the
set.

> On Fri, Apr 22, 2022 at 08:57:25AM -0700, David Vernet wrote:
> > In test_memcg_min() and test_memcg_low(), there is an array of four sibling
> > cgroups. All but one of these sibling groups does a 50MB allocation, and
> > the group that does no allocation is the third of four in the array.  This
> > is not a problem per se, but makes it a bit tricky to do some assertions in
> > test_memcg_low(), as we want to make assertions on the siblings based on
> > whether or not they performed allocations. Having a static index before
> > which all groups have performed an allocation makes this cleaner.
> > 
> > This patch therefore reorders the sibling groups so that the group that
> > performs no allocations is the last in the array.
> 
> It makes the comment explaining the test just above the test_memcg_min()
> function obsolete. Please, fix it too.

Thanks for catching that. I'll fix the comment both in test_memcg_min() and
test_memcg_low() when I send out that follow-on patch.
