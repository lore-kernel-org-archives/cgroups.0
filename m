From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH RESEND 0/4] device_cgroup: replace internally whitelist
 with exception list
Date: Thu, 16 Aug 2012 13:08:44 -0700
Message-ID: <20120816130844.6f26530d.akpm@linux-foundation.org>
References: <20120809190414.773462171@muttley.lan.cathedral>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120809190414.773462171-+5JutNtNrJPwzbzh4h2Q61C45dnP8DBc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: aris-moeOTchvdi7YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, 09 Aug 2012 15:04:14 -0400
aris-moeOTchvdi7YtjvyW6yDsg@public.gmane.org wrote:

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

The patches look reasonable to me.  I suggest you resend them after
kernel summit and cc a few additional people: Serge Hallyn, Pavel
Emelyanov and James Morris.
