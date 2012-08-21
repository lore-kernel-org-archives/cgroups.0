From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 11/11] protect architectures where THREAD_SIZE >=
 PAGE_SIZE against fork bombs
Date: Tue, 21 Aug 2012 12:57:04 +0200
Message-ID: <20120821105704.GF19797@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-12-git-send-email-glommer@parallels.com>
 <20120821093513.GD19797@dhcp22.suse.cz>
 <5033579D.5000203@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5033579D.5000203-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue 21-08-12 13:40:45, Glauber Costa wrote:
> On 08/21/2012 01:35 PM, Michal Hocko wrote:
[...]
> > I am asking because this should trigger memcg-oom
> > but that one will usually pick up something else than the fork bomb
> > which would have a small memory footprint. But that needs to be handled
> > on the oom level obviously.
> > 
> Sure, but keep in mind that the main protection is against tasks *not*
> in this memcg.

Yes and that's is good step forward. I just wanted to mention that we
still have the problem inside the subhierarchy. The changelog was not
specific enough.
-- 
Michal Hocko
SUSE Labs
