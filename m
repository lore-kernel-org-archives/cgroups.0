From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 6/6] memcg: avoid dangling reference count in creation
 failure.
Date: Mon, 21 Jan 2013 14:19:21 +0100
Message-ID: <20130121131921.GK7798@dhcp22.suse.cz>
References: <1358766813-15095-1-git-send-email-glommer@parallels.com>
 <1358766813-15095-7-git-send-email-glommer@parallels.com>
 <20130121123057.GH7798@dhcp22.suse.cz>
 <50FD3DD4.5050309@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50FD3DD4.5050309-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On Mon 21-01-13 17:08:36, Glauber Costa wrote:
> On 01/21/2013 04:30 PM, Michal Hocko wrote:
> > On Mon 21-01-13 15:13:33, Glauber Costa wrote:
> >> When use_hierarchy is enabled, we acquire an extra reference count
> >> in our parent during cgroup creation. We don't release it, though,
> >> if any failure exist in the creation process.
> >>
> >> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> >> Reported-by: Michal Hocko <mhocko@suse>
> > 
> > If you put this one to the head of the series we can backport it to
> > stable which is preferred, although nobody have seen this as a problem.
> > 
> If I have to send again, I might. But I see no reason to do so otherwise.

The question is whether this is worth backporting to stable. If yes then
it makes to move it up the series. Keep it here otherwise. I think the
failure is quite improbable and nobody complained so far. On the other
hand this is an obvious bug fix so it should qualify for stable.

I would wait for others for what they think and do the shuffling after
all other patches are settled. I would rather be safe and push the fix
pro-actively.

Thanks
-- 
Michal Hocko
SUSE Labs
