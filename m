From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 3/4] memcg: split part of memcg creation to css_online
Date: Tue, 4 Dec 2012 12:32:17 +0400
Message-ID: <50BDB511.5070107@parallels.com>
References: <1354282286-32278-1-git-send-email-glommer@parallels.com> <1354282286-32278-4-git-send-email-glommer@parallels.com> <20121203173205.GI17093@dhcp22.suse.cz> <50BDAEC1.8040805@parallels.com> <20121204081756.GA31319@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121204081756.GA31319-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 12/04/2012 12:17 PM, Michal Hocko wrote:
>> But it should be extremely easy to protect against this. It is just a
>> > matter of not returning online css in the iterator: then we'll never see
>> > them until they are online. This also sounds a lot more correct than
>> > returning allocated css.
> Yes but... Look at your other patch which relies on iterator when counting
> children to find out if there is any available.
>  
And what is the problem with it ?

As I said: if the iterator will not return css that are not online, we
should not have a problem.
