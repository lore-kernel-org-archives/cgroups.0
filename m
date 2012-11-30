From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 1/4] cgroup: warn about broken hierarchies only after
 css_online
Date: Fri, 30 Nov 2012 19:13:54 +0400
Message-ID: <50B8CD32.4080807@parallels.com>
References: <1354282286-32278-1-git-send-email-glommer@parallels.com> <1354282286-32278-2-git-send-email-glommer@parallels.com> <20121130151158.GB3873@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121130151158.GB3873-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

On 11/30/2012 07:11 PM, Tejun Heo wrote:
> On Fri, Nov 30, 2012 at 05:31:23PM +0400, Glauber Costa wrote:
>> If everything goes right, it shouldn't really matter if we are spitting
>> this warning after css_alloc or css_online. If we fail between then,
>> there are some ill cases where we would previously see the message and
>> now we won't (like if the files fail to be created).
>>
>> I believe it really shouldn't matter: this message is intended in spirit
>> to be shown when creation succeeds, but with insane settings.
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> 
> Applied to cgroup/for-3.8.  Thanks!
> 

We just need to be careful because when we merge it with morton's, more
bits will need converting.
