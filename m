From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 04/18] slab: don't preemptively remove element from
 list in cache destroy
Date: Wed, 24 Oct 2012 09:54:05 +0300
Message-ID: <CAOJsxLFxQuC9mRb=ZMoqdxS6fyLHCg1LxyfF9wAR1hiOL5i93g@mail.gmail.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com>
	<1350656442-1523-5-git-send-email-glommer@parallels.com>
	<0000013a7a84cb28-334eab12-33c4-4a92-bd9c-e5ad938f83d0-000000@email.amazonses.com>
	<5085068E.5080304@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=UVFnln0c2ERbYtp5pdPFnmryEIt2e7X1VPPe7Ze8FmQ=;
        b=XSH1CozhaltTbqHCZALFVORCQp1WByEoQh7OBv1YNb8MBGsoIaiL0jA0RwlByM5w/W
         iGDAlrQNGY5maaK0/A5JZU+I13JL9T6hOrG7LWxZlSykxfiVKJfX8CRquxSEPnr516UO
         EYwI5CQ/mzyrFbePKbq3y+e6FfUfIqK7pfOh3ScSbX0ZKZf4a811U+XvfzNGYg4ur939
         hyjPiv/M/7orC52otGzYKVA7fDAYveyd0Wn2oJ9NqlVQ9POPTvI92s0DH8Tb9PU68/l5
         5sWqWOd8DEA9gdRJ1p3KXR+pG6mro66H2iQqcVimntrG6Hc8XD7vgVdn+ADzwCGKrTLR
         1uZg==
In-Reply-To: <5085068E.5080304-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Oct 22, 2012 at 11:40 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> On 10/19/2012 11:34 PM, Christoph Lameter wrote:
>> On Fri, 19 Oct 2012, Glauber Costa wrote:
>>
>>> I, however, see no reason why we need to do so, since we are now locked
>>> during the whole deletion (which wasn't necessarily true before).  I
>>> propose a simplification in which we delete it only when there is no
>>> more going back, so we don't need to add it again.
>>
>> Ok lets hope that holding the lock does not cause issues.
>>
>> Acked-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>>
> BTW: One of the good things about this set, is that we are naturally
> exercising cache destruction a lot more than we did before. So if there
> is any problem, either with this or anything related to cache
> destruction, it should at least show up a lot more frequently. So far,
> this does not seem to cause any problems.

We no longer hold the mutex the whole time after. See commit 210ed9d
("mm, slab: release slab_mutex earlier in kmem_cache_destroy()") for
details.
