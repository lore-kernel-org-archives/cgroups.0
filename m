From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 4/6] add a new scheduler hook for context switch
Date: Wed, 30 May 2012 16:08:24 +0400
Message-ID: <4FC60DB8.70405@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>  <1338371317-5980-5-git-send-email-glommer@parallels.com>  <1338376851.26856.260.camel@twins> <1338378051.26856.267.camel@twins>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338378051.26856.267.camel@twins>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On 05/30/2012 03:40 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-30 at 13:20 +0200, Peter Zijlstra wrote:
>>
>> $ perf stat -e cycles --repeat 100 perf bench sched messaging -p -g 100
>>
>>      48,826,146,710 cycles  #    2.470 GHz  ( +-  0.17% )
>>         2.149005270 seconds time elapsed    ( +-  0.12% )
>
> A repeat count of 250 dropped it down to:
>
>          2.144582157 seconds time elapsed    ( +-  0.08% )
>
> Also, if you're poking at the context switch path, something like:
>
> $ taskset 1 perf stat -e cycles --repeat 10 perf bench sched pipe -l 100000
>
> gives a good number and is usually more stable than hackbench.
thanks for the pointers
