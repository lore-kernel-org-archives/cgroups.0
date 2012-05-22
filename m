From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] slab+slob: dup name string
Date: Tue, 22 May 2012 19:27:21 +0400
Message-ID: <4FBBB059.1060903@parallels.com>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1205220857380.17600-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 05/22/2012 05:58 PM, Christoph Lameter wrote:
> On Tue, 22 May 2012, Glauber Costa wrote:
>
>> [ v2: Also dup string for early caches, requested by David Rientjes ]
>
> kstrdups that early could cause additional issues. Its better to leave
> things as they were.
>

For me is really all the same. But note that before those kstrdups, we 
do a bunch of kmallocs as well already. (ex:

/* 4) Replace the bootstrap head arrays */
{
	struct array_cache *ptr;

	ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);

Which other point of issues do you see besides the memory allocation 
done by strdup?

I agree with your comment that we shouldn't worry about those caches, 
because only init code uses it.

Weather or not David's concern of wanting to delete those caches some 
day is valid, I'll leave up to you guys to decide
