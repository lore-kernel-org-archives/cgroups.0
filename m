From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] memcg: debugging facility to access dangling memcgs.
Date: Tue, 4 Dec 2012 11:40:42 +0400
Message-ID: <50BDA8FA.4060404@parallels.com>
References: <1354541048-12597-1-git-send-email-glommer@parallels.com> <20121203154420.661f8e28.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121203154420.661f8e28.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 12/04/2012 03:44 AM, Andrew Morton wrote:
> On Mon,  3 Dec 2012 17:24:08 +0400
> Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> 
>> If memcg is tracking anything other than plain user memory (swap, tcp
>> buf mem, or slab memory), it is possible - and normal - that a reference
>> will be held by the group after it is dead. Still, for developers, it
>> would be extremely useful to be able to query about those states during
>> debugging.
>>
>> This patch provides a debugging facility in the root memcg, so we can
>> inspect which memcgs still have pending objects, and what is the cause
>> of this state.
> 
> As this is a developer-only thing, I suggest that we should avoid
> burdening mainline with it.  How about we maintain this in -mm (and
> hence in -next and mhocko's memcg tree) until we no longer see a need
> for it?
> 
I am absolutely fine with that.
