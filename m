From: Aristeu Rozanski <aris-moeOTchvdi7YtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/4] device_cgroup: replace internally whitelist with
 exception list
Date: Mon, 30 Jul 2012 10:51:37 -0400
Message-ID: <20120730145137.GA13180@jake.ruivo.org>
References: <20120724220333.966415895@muttley.lan.cathedral>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120724220333.966415895-+5JutNtNrJPwzbzh4h2Q61C45dnP8DBc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, Jul 24, 2012 at 06:03:33PM -0400, Aristeu Rozanski wrote:
> The original model of device_cgroup is having a whitelist where all the
> allowed devices are listed. The problem with this approach is that is
> impossible to have the case of allowing everything but few devices.
> 
> The reason for that lies in the way the whitelist is handled internally:
> since there's only a whitelist, the "all devices" entry would have to be
> removed and replaced by the entire list of possible devices but the ones
> that are being denied.  Since dev_t is 32 bits long, representing the allowed
> devices as a bitfield is not memory efficient.
> 
> This patch replaces the "whitelist" by a "exceptions" list and the default
> policy is kept as "deny_all" variable in dev_cgroup structure.

Any comments on these patches?

-- 
Aristeu
