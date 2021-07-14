From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: enable accounting for pids in nested pid
 namespaces
Date: Wed, 14 Jul 2021 09:43:30 +0200
Message-ID: <20210714074330.eoug2b7hno3heoeb@wittgenstein>
References: <7b777e22-5b0d-7444-343d-92cbfae5f8b4@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7b777e22-5b0d-7444-343d-92cbfae5f8b4-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Thu, Apr 22, 2021 at 08:44:15AM +0300, Vasily Averin wrote:
> init_pid_ns.pid_cachep have enabled memcg accounting, though this
> setting was disabled for nested pid namespaces.
> 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---

Not sure I already acked this but looks good,
Acked-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
