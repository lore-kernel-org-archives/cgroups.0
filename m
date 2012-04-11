From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] remove BUG() in possible but rare condition
Date: Wed, 11 Apr 2012 16:02:19 -0300
Message-ID: <4F85D53B.1070806@parallels.com>
References: <1334167824-19142-1-git-send-email-glommer@parallels.com> <20120411184845.GA24831@tiehlicka.suse.cz> <CA+55aFx1GMWGgh0sTAzvvVSzPQsQ_4NKeaNv1zpKrP4fg1dG+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFx1GMWGgh0sTAzvvVSzPQsQ_4NKeaNv1zpKrP4fg1dG+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 04/11/2012 03:57 PM, Linus Torvalds wrote:
> On Wed, Apr 11, 2012 at 11:48 AM, Michal Hocko<mhocko-AlSwsSmVLrQ@public.gmane.org>  wrote:
>>
>> I am not familiar with the code much but a trivial call chain walk up to
>> write_dev_supers (in btrfs) shows that we do not check for the return value
>> from __getblk so we would nullptr and there might be more.
>> I guess these need some treat before the BUG might be removed, right?
>
> Well, realistically, isn't BUG() as bad as a NULL pointer dereference?
>
> Do you care about the exact message on the screen when your machine dies?
Not particular, but I don't see why (I might be wrong) it would 
necessarily lead to a NULL pointer dereference.

At least in my test cases, after turning this to a WARN (to make sure it 
was still being hit), the machine could go on just fine.

I was running this in a container system, with restricted memory. After
killing the container - at least in my ext4 system - everything seemed 
as happy as ever.
