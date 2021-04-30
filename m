From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 4/5] tests/cgroup: move cg_wait_for(),
 cg_prepare_for_wait()
Date: Thu, 29 Apr 2021 20:45:44 -0700
Message-ID: <YIt9aOSG0RIFwv4+@carbon.dhcp.thefacebook.com>
References: <20210429120113.2238065-1-brauner@kernel.org>
 <20210429120113.2238065-4-brauner@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=yk7naFH/uiPWW4wIDzT3ehFQAMCmIto+rApOVpqNXo8=;
 b=bG4SFiknerBZnBlLjgQbTmMR9VGbZpflexiNtm6PKm99Aih897w0N54LyZAdJxST1tnT
 kdE7LW7AiK1+vOgQvNjlFlTLG1sF2JviKnf9nGnZAvnDYKHI69H9/SIR6UpJSTUz4MCR
 WOizl8DJGwDkD/j2KomQWhd1tafaBdC75V0= 
Content-Disposition: inline
In-Reply-To: <20210429120113.2238065-4-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Thu, Apr 29, 2021 at 02:01:12PM +0200, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> as they will be used by the tests for cgroup killing.
> 
> Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
