From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC] slub: show dead memcg caches in a separate file
Date: Tue, 8 May 2012 08:55:14 -0300
Message-ID: <4FA909A2.2010203@parallels.com>
References: <1336070841-1071-1-git-send-email-glommer@parallels.com> <CABCjUKDuiN6bq6rbPjE7futyUwTPKsSFWHXCJ-OFf30tgq5WZg@mail.gmail.com> <4FA89348.6070000@parallels.com> <CAOJsxLHFS+B64qfhCg-9LPbggPoyvkBSnA8nZPRoV15eeRpi_w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOJsxLHFS+B64qfhCg-9LPbggPoyvkBSnA8nZPRoV15eeRpi_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 05/08/2012 02:42 AM, Pekka Enberg wrote:
> On Tue, May 8, 2012 at 6:30 AM, Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  wrote:
>> But there is another aspect: those dead caches have one thing in common,
>> which is the fact that no new objects will ever be allocated on them. You
>> can't tune them, or do anything with them. I believe it is misleading to
>> include them in slabinfo.
>>
>> The fact that the caches change names - to append "dead" may also break
>> tools, if that is what you are concerned about.
>>
>> For all the above, I think a better semantics for slabinfo is to include the
>> active caches, and leave the dead ones somewhere else.
>
> Can these "dead caches" still hold on to physical memory? If so, they
> must appear in /proc/slabinfo.
Yes, if they didn't, I would show them nowhere, instead of in a separate 
file.

But okay, that's why I sent a separate RFC for that part.
I will revert this behavior.
