From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 2/4] Add a __GFP_SLABMEMCG flag
Date: Sat, 9 Jun 2012 12:19:44 +0400
Message-ID: <4FD30720.6040908@parallels.com>
References: <1339148601-20096-1-git-send-email-glommer@parallels.com> <1339148601-20096-3-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206081430380.4213@router.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1206081430380.4213-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbeck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 06/08/2012 11:31 PM, Christoph Lameter wrote:
> Please make this conditional on CONFIG_MEMCG or so. The bit can be useful
> in particular on 32 bit architectures.
Looking at how __GFP_NOTRACK works - which is also ifdef'd, the bit it 
uses is skipped if that is not defined, which I believe is a sane thing 
to do.

Given that, I don't see the point of conditionally defining the memcg 
bit, It basically means that the only way we can reuse the bit saved is 
by making a future feature fundamentally incompatible with memcg.

