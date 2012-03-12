From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Mon, 12 Mar 2012 16:00:20 -0700
Message-ID: <20120312230020.GL23255@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
 <20120312223113.GB18359@tango.0pointer.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gttawtPepvjk18aQRGqzH4ukcJfjb9+EHwgEP7qF1j0=;
        b=hDFog3sTyvpQwBmwnBb466C4YUPq0MfLGMeUn4lC4aDEuOSaKJW7NoKfIEWMEzgDLK
         /LHe4/cB8V2g96AA7CZ7DmnAf8yjoFW5CMLsb8l/mjyZ/9tB3W7SxGpt4rmwWWZvmXwv
         wKl5FX9Chsuu51T30J+flxyQedy/QdXSzv5wifAQr3l11GIQ0bNPZRYrYVw7/wCTpl02
         AAFwf/iv9F3+96bscfyOZ+2aW0Gb2rdzwKrP0gKTwpO3mmlTKeJ0M+EdJM+0rQdhxBFz
         v1wymNwmobfhE82a2xmv4hM3VoiplfCtz8FkmjjpSxHcSOnkrb3x6BqMZ2niCNflccSe
         bpKQ==
Content-Disposition: inline
In-Reply-To: <20120312223113.GB18359-kS5D54t9nk0aINubkmmoJbNAH6kLmebB@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hey, Lennart.

On Mon, Mar 12, 2012 at 11:31:14PM +0100, Lennart Poettering wrote:
> > On Mon, Mar 12, 2012 at 11:22:18PM +0100, Peter Zijlstra wrote:
> > > On Mon, 2012-03-12 at 15:10 -0700, Tejun Heo wrote:
> > > > 
> > > > * How to map controllers which aren't aware of full hierarchy is still
> > > >   an open question but I'm still standing by one active node on any
> > > >   root-to-leaf path w/ root group serving as the special rest group. 
> > > 
> > > What does this mean?
> > 
> > Let's say we have a tree like the following.
> > 
> >          root
> >       /   |   \
> >      G1  G2   G3
> >              /  \
> > 	   G31  G32
> > 
> > So, for cgroups which don't support full hierarchy, it'll be viewed as
> > either,
> > 
> >          root
> >       /   |   \
> >      G1  G2   G3
> > 
> > or
> > 
> >           root
> >       /   |   |  \
> >      G1  G2  G31 G32
> > 
> > With root being treated specially, probably as just being a equal
> > group as other groups, I'm not fully determined about that yet.
> 
> Note that at least systemd places all services by default beneath a
> single "super" group (/system/), hence the first suggestion would make
> little sense for us. The second suggestion would be fine however.

Ooh, both will be available to choose from.  I was trying to explain
that there can be configuration only at one layer for any task so that
it can be mapped to flat hierarchy.  Where to apply the config will be
selected by the user (or system tool).

Thanks.

-- 
tejun
