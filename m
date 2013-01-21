From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 6/6] memcg: avoid dangling reference count in creation
 failure.
Date: Mon, 21 Jan 2013 17:08:36 +0400
Message-ID: <50FD3DD4.5050309@parallels.com>
References: <1358766813-15095-1-git-send-email-glommer@parallels.com> <1358766813-15095-7-git-send-email-glommer@parallels.com> <20130121123057.GH7798@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130121123057.GH7798-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On 01/21/2013 04:30 PM, Michal Hocko wrote:
> On Mon 21-01-13 15:13:33, Glauber Costa wrote:
>> When use_hierarchy is enabled, we acquire an extra reference count
>> in our parent during cgroup creation. We don't release it, though,
>> if any failure exist in the creation process.
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>> Reported-by: Michal Hocko <mhocko@suse>
> 
> If you put this one to the head of the series we can backport it to
> stable which is preferred, although nobody have seen this as a problem.
> 
If I have to send again, I might. But I see no reason to do so otherwise.
