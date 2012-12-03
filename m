From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] device_cgroup: make may_access() stronger
Date: Mon, 3 Dec 2012 14:01:04 -0500
Message-ID: <20121203190104.GC32112@redhat.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.817704289@napanee.usersys.redhat.com>
 <20121203174414.GI19802@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121203174414.GI19802-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Dec 03, 2012 at 09:44:14AM -0800, Tejun Heo wrote:
> I kinda dislike this.  This isn't a performanc critical path where we
> must try our best to shave off a few condition checks.  There's no
> reason to encode the test like this.  Please just spell the conditions
> out in code rather than trying to build a magic series of equality
> tests which somehow ends up spewing out the correct results.

sure, will do. but this is not "magic", that's just logic simplification.

-- 
Aristeu
