From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 4/4] get rid of populate for memcg
Date: Wed, 21 Mar 2012 20:30:07 +0400
Message-ID: <4F6A020F.5030904@parallels.com>
References: <1332262256-13407-1-git-send-email-glommer@parallels.com> <1332262256-13407-5-git-send-email-glommer@parallels.com> <20120320183149.GB20832@google.com> <4F6984F3.2010009@parallels.com> <20120321160610.GA4246@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120321160610.GA4246-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 03/21/2012 08:06 PM, Tejun Heo wrote:
> I don't quite get why a protocol module would be loaded but not
> reigstered.  Do we actually have cases like that?  I know it's
> mechanically possible but don't think there's any actual use case or
> existing code which does that, so no need to worry about them.
>

Probably I'm just over worrying here. If your macro can handle 
unregistering well, I think I should be fine using them.
