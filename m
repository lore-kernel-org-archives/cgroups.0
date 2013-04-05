From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC][PATCH 5/7] cgroup: make sure parent won't be destroyed
 before its children
Date: Fri, 5 Apr 2013 12:10:02 +0400
Message-ID: <515E86DA.1090907@parallels.com>
References: <515BF233.6070308@huawei.com> <515BF2A4.1070703@huawei.com> <20130404113750.GH29911@dhcp22.suse.cz> <20130404133706.GA9425@htj.dyndns.org> <20130404152028.GK29911@dhcp22.suse.cz> <20130404152213.GL9425@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130404152213.GL9425-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 04/04/2013 07:22 PM, Tejun Heo wrote:
> On Thu, Apr 04, 2013 at 05:20:28PM +0200, Michal Hocko wrote:
>>> But what harm does an additional reference do?
>>
>> No harm at all. I just wanted to be sure that this is not yet another
>> "for memcg" hack. So if this is useful for other controllers then I have
>> no objections of course.
> 
> I think it makes sense in general, so let's do it in cgroup core.  I
> suppose it'd be easier for this to be routed together with other memcg
> changes?
> 
> Thanks.
> 
You guys seems already settled, but FWIW I agree with Tejun here. It
makes sense from a design point of view for a cgroup to pin its parent.
cgroup core it is.
