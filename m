From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 00/11] new cgroup controller for gpu/drm subsystem
Date: Tue, 24 Mar 2020 14:46:33 -0400
Message-ID: <20200324184633.GH162390@mtj.duckdns.org>
References: <20200226190152.16131-1-Kenny.Ho@amd.com>
 <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AGxmNy0595sT346CYB2mgtexQzuM2HSrDde9cVbZJuU=;
        b=M3QHtiDCjMkqKxWvyPl5FUJxxKx7+N4EaFCnKutVLtNtajUcahJKaZa0ow/Iz8n8vF
         +cTaGUSAx07luD6LuXpFlfEyxpVpWMxDTX6hfLOgkEyqWH71CUYPYpwYunw3m6+byoEx
         cqbsc7zfXkij/jLcSsAEnxMTyFJjLdeavZ1Vu5ZDBOCL+eZt1qHzjhNGrsKYVzKVUObo
         38MQ0gVgqyJ+wkY2WkU09z+gDjseha8Lgmr3Dty97if7NGwSTgddMDnEHu1RZkix40Ar
         GrX/0NCKWzRn+Dyf06srWhJwYIjlEymtoDhdE1UJmOXKCEqW3hgArIGXUehAAFjZC8Tk
         Mw+w==
Content-Disposition: inline
In-Reply-To: <CAOWid-eyMGZfOyfEQikwCmPnKxx6MnTm17pBvPeNpgKWi0xN-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Kuehling, Felix" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "Greathouse, Joseph" <joseph.greathouse-5C7GfCeVMHo@public.gmane.org>, jsparks-WVYJKLFxKCc@public.gmane.org

On Tue, Mar 17, 2020 at 12:03:20PM -0400, Kenny Ho wrote:
> What's your thoughts on this latest series?

My overall impression is that the feedbacks aren't being incorporated throughly
/ sufficiently.

Thanks.

-- 
tejun
