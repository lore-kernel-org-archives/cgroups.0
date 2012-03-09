From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] memcg: Free spare array to avoid memory leak
Date: Fri, 9 Mar 2012 12:36:33 +0900
Message-ID: <20120309123633.1faa4056.kamezawa.hiroyu@jp.fujitsu.com>
References: <1331036004-7550-1-git-send-email-handai.szj@taobao.com>
	<20120307230819.GA10238@shutemov.name>
	<4F581554.6020801@gmail.com>
	<20120308103510.GA12897@shutemov.name>
	<4F588DF5.60300@gmail.com>
	<20120309102431.5a8a1c3d.kamezawa.hiroyu@jp.fujitsu.com>
	<4F5977E6.5040205@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F5977E6.5040205-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Fri, 09 Mar 2012 11:24:22 +0800
Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On 03/09/2012 09:24 AM, KAMEZAWA Hiroyuki wrote:
> > On Thu, 08 Mar 2012 18:46:13 +0800
> > Sha Zhengju<handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
> >
> >> On 03/08/2012 06:35 PM, Kirill A. Shutemov wrote:
> >>> On Thu, Mar 08, 2012 at 10:11:32AM +0800, Sha Zhengju wrote:
> >>>> On 03/08/2012 07:08 AM, Kirill A. Shutemov wrote:
> >>>>> On Tue, Mar 06, 2012 at 08:13:24PM +0800, Sha Zhengju wrote:
> >>>>>> From: Sha Zhengju<handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> >>>>>>
> >>>>>> When the last event is unregistered, there is no need to keep the spare
> >>>>>> array anymore. So free it to avoid memory leak.
> >>>>> It's not a leak. It will be freed on next event register.
> >>>> Yeah, I noticed that. But what if it is just the last one and no more
> >>>> event registering ?
> >>> See my question below. ;)
> >>>
> >>>>> Yeah, we don't have to keep spare if primary is empty. But is it worth to
> >>>>> make code more complicated to save few bytes of memory?
> >>>>>
> >> If we unregister the last event and *don't* register a new event anymore,
> >> the primary is freed but the spare is still kept which has no chance to
> >> free.
> >>
> >> IMHO, it's obvious not a problem of saving bytes but *memory leak*.
> >>
> > IMHO, it's cached. It will be freed when a memcg is destroyed.
> 
> I didn't see that behavior.  Could you point it out ? :-)
> 

I'm sorry I misundersttood the behavior.
I'll read your patch again.


Thanks,
-Kame
