From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 00/10] memcg kmem limitation - slab.
Date: Tue, 31 Jul 2012 20:39:30 +0400
Message-ID: <50180A42.2050806@parallels.com>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <20120731163027.GE17078@somewhere.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120731163027.GE17078-oHC15RC7JGTpAmv0O++HtFaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 07/31/2012 08:30 PM, Frederic Weisbecker wrote:
> On Wed, Jul 25, 2012 at 06:38:11PM +0400, Glauber Costa wrote:
>> Hi,
>>
>> This is the slab part of the kmem limitation mechanism in its last form.  I
>> would like to have comments on it to see if we can agree in its form. I
>> consider it mature, since it doesn't change much in essence over the last
>> forms. However, I would still prefer to defer merging it and merge the
>> stack-only patchset first (even if inside the same merge window). That patchset
>> contains most of the infrastructure needed here, and merging them separately
>> would not only reduce the complexity for reviewers, but allow us a chance to
>> have independent testing on them both. I would also likely benefit from some
>> extra testing, to make sure the recent changes didn't introduce anything bad.
> 
> What is the status of the stack-only limitation patchset BTW? Does anybody oppose
> to its merging?
> 
> Thanks.
> 
Andrew said he would like to see the slab patches in a relatively mature
state first.

I do believe they are in such a state. There are bugs, that I am working
on - but I don't see anything that would change them significantly at
this point.

If Andrew is happy with what he saw in this thread, I could post those
again.
