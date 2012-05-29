From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 05/28] memcg: Reclaim when more than one page needed.
Date: Tue, 29 May 2012 19:45:42 +0400
Message-ID: <4FC4EF26.30609@parallels.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290917230.4666@router.home> <alpine.DEB.2.00.1205290919130.4666@router.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1205290919130.4666-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 05/29/2012 06:20 PM, Christoph Lameter wrote:
> On Tue, 29 May 2012, Christoph Lameter wrote:
>
>>>   	* unlikely to succeed so close to the limit, and we fall back
>>>   	 * to regular pages anyway in case of failure.
>>>   	 */
>>> -	if (nr_pages == 1&&  ret)
>>> +	if (nr_pages<= (PAGE_SIZE<<  PAGE_ALLOC_COSTLY_ORDER)&&  ret) {
>
> Should this not be
>
> 	 nr_pages<= 1<<  PAGE_ALLOC_COSTLY_ORDER

I myself believe you are right.

Not sure if Suleiman had anything in mind that we're not seeing when he 
wrote this code?
