From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 1/4] kernfs: kvmalloc xattr value instead of kmalloc
Date: Mon, 09 Mar 2020 12:58:49 -0700
Message-ID: <84ef5548ee27e7150d0b7a5702ce50536cea975a.camel@perches.com>
References: <C16IH7NEXW4J.440OGTNY7CWX@dlxu-fedora-R90QNFJV>
         <6bbfc8b8c9c206d80de43a64bfe4b8083cc2c02f.camel@perches.com>
         <20200309195104.GA77841@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200309195104.GA77841-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Daniel Xu <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, 2020-03-09 at 15:51 -0400, Tejun Heo wrote:
> On Mon, Mar 09, 2020 at 12:41:05PM -0700, Joe Perches wrote:
> > If the need is to allocate from a single block of memory,
> > perhaps you need a submemory allocator like gen_pool.
> > (gennalloc.h)
> > 
> > Dunno.  Maybe i just don't quite understand your need.
> 
> vmalloc is the right thing to do here. vmalloc space isn't a scarce
> resource on any 64bit machines. On 32bits, which basically are tiny
> machines at this point, these allocations are both size and quantity
> limited by other factors (e.g. each cgroup consumes way more memory).

This feels like driving spikes into a living thing
more than into a
corpse.

I've still got more than a few 32-bit devices around.


