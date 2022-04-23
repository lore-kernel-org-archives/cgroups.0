From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 1/5] cgroups: Refactor children cgroups in memcg tests
Date: Sat, 23 Apr 2022 08:33:21 -0700
Message-ID: <20220423153321.cts6qhlybkghoe2o@dev0025.ash9.facebook.com>
References: <20220423113037.gnfysktiuzmfnpmp@dev0025.ash9.facebook.com>
 <EEC47283-0467-4C97-AAB2-73F17A97CE15@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <EEC47283-0467-4C97-AAB2-73F17A97CE15-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sat, Apr 23, 2022 at 08:19:12AM -0700, Roman Gushchin wrote:
> 
> > On Apr 23, 2022, at 4:30 AM, David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org> wrote:
> > 
> > ﻿On Fri, Apr 22, 2022 at 04:04:15PM -0700, Roman Gushchin wrote:
> >> 
> > 
> > Thanks for the reviews on this patchset, Roman. FYI I think Andrew already
> > merged these patches to the -mm tree. I'll send out a follow-on patch that
> > fixes everything you pointed out, both here and on the other patches in the
> > set.
> 
> The mm tree isn’t a git tree, but a collection of the text patches, managed by Andrew. So you can send a new version and Andrew can update it in place. It’s happening all the time: mostly for adding reviewed-by/acked-by tags etc, but for code updates as well.
> It’s not uncommon for some patchset to mature while being in the mm tree, this allows to include them into linux-next and give some more testing, but without doing many reverts/fixups (Andrew is often squashing fixups into the original patch too). So long story short, you can just send a new version, especially because all changes all minor.

Ah, that makes sense. Thanks for explaining that. I'll send out a v2 of the
patches shortly, then!
