From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 8/9] devcg: refactor dev_exception_clean()
Date: Thu, 31 Jan 2013 10:13:32 -0500
Message-ID: <20130131151331.GM17632@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.253395279@napanee.usersys.redhat.com>
 <20130130204730.GF8507@mail.hallyn.com>
 <20130130204917.GL17632@redhat.com>
 <CAOS58YOHkK9xTBPFAXKksrwP7ZxQc_WuGOp39D94Z1pBsFHfjw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOS58YOHkK9xTBPFAXKksrwP7ZxQc_WuGOp39D94Z1pBsFHfjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Wed, Jan 30, 2013 at 12:50:38PM -0800, Tejun Heo wrote:
> On Wed, Jan 30, 2013 at 12:49 PM, Aristeu Rozanski > that's not
> intentional. thanks for catching this
> >
> > Tejun, you want me to resubmit the whole series or just the next patch
> > (where I was supposed to move that chunk)?
> 
> If it doesn't affect the next patch, just posting an updated version
> of this patch should be enough, I think. Which tree are these patches
> planned to go through?

the fix should actually happen on the next patch, not this one. and it
seems I'll have to refresh it anyway (just had a glance on Serge's
emails).

-- 
Aristeu
