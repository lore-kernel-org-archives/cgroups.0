From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
Date: Wed, 27 Feb 2013 17:46:59 +0400
Message-ID: <512E0E53.9010908@parallels.com>
References: <1361550000-14173-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.02.1302221034380.7600@gentwo.org> <alpine.DEB.2.02.1302221057430.7600@gentwo.org> <0000013d02d9ee83-9b41b446-ee42-4498-863e-33b3175c007c-000000@email.amazonses.com> <5127A607.3040603@parallels.com> <0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000@email.amazonses.com> <CAOJsxLFzrw0pCzUG7Ru4dB9=aPoNKHiJ_y3bopiFvBhzV9A5Zg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOJsxLFzrw0pCzUG7Ru4dB9=aPoNKHiJ_y3bopiFvBhzV9A5Zg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 02/27/2013 11:47 AM, Pekka Enberg wrote:
> On Fri, Feb 22, 2013 at 7:23 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
>> On Fri, 22 Feb 2013, Glauber Costa wrote:
>>
>>> On 02/22/2013 09:01 PM, Christoph Lameter wrote:
>>>> Argh. This one was the final version:
>>>>
>>>> https://patchwork.kernel.org/patch/2009521/
>>>>
>>>
>>> It seems it would work. It is all the same to me.
>>> Which one do you prefer?
>>
>> Flushing seems to be simpler and less code.
> 
> Well, I completely lost track of what to apply... Can someone please
> send me the final version that everybody agrees on with proper ACKs
> and other attributions?
> 
You can apply this one as-is with Christoph's ACK.
