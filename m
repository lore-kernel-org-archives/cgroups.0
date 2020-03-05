From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Memory reclaim protection and cgroup nesting (desktop use)
Date: Thu, 5 Mar 2020 10:39:48 -0500
Message-ID: <20200305153948.GB6939@mtj.thefacebook.com>
References: <d4826b9e568f1ab7df19f94c409df11956a8e262.camel@sipsolutions.net>
 <20200304163044.GF189690@mtj.thefacebook.com>
 <4d3e00457bba40b25f3ac4fd376ba7306ffc4e68.camel@sipsolutions.net>
 <20200305145554.GA5897@mtj.thefacebook.com>
 <7ce3aa9cf6f7501ce2ce6057a03a40cd5e126efd.camel@sipsolutions.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PHq9PaeVGtyudk0wOTWZY80KOkaKDj/XvNUNHTcU/hU=;
        b=st265gUVi6yGmxIN+nyLlX9bI0TZYas/Sz1TACzRXEO0WsuHyBBHN+VJCFf49CjWOK
         O/Kqo75c9VQGL/OBHP+jKGyGvguT1v4JDGpgwSqbi8BlLcePzstMqZu3B7ljA0i0m1zn
         Pn9/sKYplZJfqEPkySASJ2XYQCboTZZSQIgqYReLFiukIgvov+qJnOdVPb52daw8SipC
         ZKlqq0Xs0QXTo/Q79Lijg7YZCvpe9D/p1yf1i+oTH0TeNV3ju4wZSgYs15DjwMm4QIdB
         GJwSOhKCZ08ksO0b2LR2UOP0tHQN+hmJwB0KKr9R8E1XQykMTfuObZfEeVhcEQ9KRscb
         zAVQ==
Content-Disposition: inline
In-Reply-To: <7ce3aa9cf6f7501ce2ce6057a03a40cd5e126efd.camel-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Benjamin.

On Thu, Mar 05, 2020 at 04:27:19PM +0100, Benjamin Berg wrote:
> > Changing memory limits dynamically can lead to pretty abrupt system
> > behaviors depending on how big the swing is but memory.low and io/cpu
> > weights should behave fine.
> 
> Right, we'll need some daemon to handle this, so we could even smooth
> out any change over a period of time. But it seems like that will not
> be needed. I don't expect we'll want to change anything beyond
> memory.low and io/cpu weights.

Yeah, you don't need to baby memory.low and io/cpu weights at all.

> > Sounds great. In our experience, what would help quite a lot is using
> > per-application cgroups more (e.g. containing each application as user
> > services) so that one misbehaving command can't overwhelm the session
> > and eventually when oomd has to kick in, it can identify and kill only
> > the culprit application rather than the whole session.
> 
> We are already trying to do this in GNOME. :)

Awesome.

> Right now GNOME is only moving processes into cgroups after launching
> them though (i.e. transient systemd scopes).

Even just that would be plenty helpful.

> But, the goal here is to improve it further and launch all
> applications directly using systemd (i.e. as systemd services). systemd
> itself is going to define some standards to facilitate everything. And
> we'll probably also need to update some XDG standards.
> 
> So, there are some plans already, but many details have not been solved
> yet. But at least KDE and GNOME people are looking into integrating
> well with systemd.

Sounds great. Please let us know if there's anything we can help with.

Thanks.

-- 
tejun
