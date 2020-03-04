From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: Memory reclaim protection and cgroup nesting (desktop use)
Date: Wed, 4 Mar 2020 10:02:31 -0700
Message-ID: <20200304100231.2213a982@lwn.net>
References: <d4826b9e568f1ab7df19f94c409df11956a8e262.camel@sipsolutions.net>
        <20200304163044.GF189690@mtj.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200304163044.GF189690-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed, 4 Mar 2020 11:30:44 -0500
Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> > (In a realistic scenario I expect to have swap and then reserving maybe
> > a few hundred MiB; DAMON might help with finding good values.)  
> 
> What's DAMON?

	https://lwn.net/Articles/812707/

jon
